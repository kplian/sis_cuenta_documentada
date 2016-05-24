--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_fun_inicio_cuenta_doc_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_id_depto_lb integer = NULL::integer,
  p_id_cuenta_bancaria integer = NULL::integer,
  p_id_depto_conta integer = NULL::integer,
  p_estado_anterior varchar = 'no'::character varying,
  p_id_cuenta_bancaria_mov integer = NULL::integer
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    funcion que actualiza los estados despues del registro de estado en cuenta ddocumentada
*  Fecha:   16/05/2016
*
*/

DECLARE

	v_nombre_funcion   			text;
    v_resp    					varchar;
    v_mensaje 					varchar;    
    v_registros 				record;
    v_regitros_pp				record;
    v_monto_ejecutar_mo			numeric;
    v_id_uo						integer;
    v_id_usuario_excepcion		integer;
    v_resp_doc 					boolean;
    v_id_usuario_firma			integer;
    v_id_moneda_base			integer;
    v_fecha						date; 
    v_importe_aprobado_total	numeric;
    v_importe_total				numeric;
    v_sincronizar				varchar;
    v_nombre_conexion			varchar;
    v_id_int_comprobante 		integer;
    v_codigo_plantilla_cbte		varchar;
    v_reg_cuenta_doc			record;
    v_importe_documentos		numeric;
    v_importe_depositos			numeric;
   
	
    
BEGIN

	  v_nombre_funcion = 'cd.f_fun_inicio_cuenta_doc_wf';
      
      select 
        c.id_cuenta_doc,
        tcd.codigo_plantilla_cbte,
        tcd.sw_solicitud,
        c.estado,
        c.id_cuenta_doc_fk,
        tcd.nombre,
        c.importe
      into
         v_reg_cuenta_doc
      from cd.tcuenta_doc c
      inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
      where c.id_proceso_wf = p_id_proceso_wf;
      
      
      -- actualiza estado en la solicitud
      update cd.tcuenta_doc   set 
         id_estado_wf =  p_id_estado_wf,
         estado = p_codigo_estado,
         id_usuario_mod=p_id_usuario,
         id_usuario_ai = p_id_usuario_ai,
         usuario_ai = p_usuario_ai,
         fecha_mod=now()                     
      where id_proceso_wf = p_id_proceso_wf;
      
      
       -- si es tesoreria actuliza libro de bancos y cuenta bancaria (solo para la solicitud de fondos)
      IF p_estado_anterior = 'vbtesoreria' and v_reg_cuenta_doc.sw_solicitud = 'si' THEN
      
        update cd.tcuenta_doc   set 
            id_depto_lb =  p_id_depto_lb,
            id_cuenta_bancaria = p_id_cuenta_bancaria,
            id_depto_conta = p_id_depto_conta,
            id_cuenta_bancaria_mov = p_id_cuenta_bancaria_mov
         where id_proceso_wf = p_id_proceso_wf;
      
      END IF;
      
     
      
      
      --para las rendiciones se verifica que el total de depositos y facturas cuadre  con la rendicion
      IF  v_reg_cuenta_doc.sw_solicitud = 'no' THEN
      
           IF  v_reg_cuenta_doc.id_cuenta_doc_fk is null THEN
              raise exception 'El registro de cuanta doc no es una rendición, verifique el tipo de cuenta documentada %',v_reg_cuenta_doc.nombre;
            END IF;
         
            --suma todas las facturas registradas  para la rendicion 
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
               rd.id_cuenta_doc_rendicion = v_reg_cuenta_doc.id_cuenta_doc;  --registro de rendicion
               
            -- sumar el total de depositos registrados par la retencion
            
            select
              sum(lb.importe_deposito)
            into
               v_importe_depositos
            from tes.tts_libro_bancos lb
            inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc' 
            where c.id_cuenta_doc = v_reg_cuenta_doc.id_cuenta_doc  --registro de rendicion
                  and lb.estado_reg = 'activo' 
                  and lb.estado != 'anulado';
            
            
            --verifico importe rendido
            IF  COALESCE(v_importe_documentos,0) +  COALESCE(v_importe_depositos,0) != v_reg_cuenta_doc.importe  THEN
               raise exception 'El total a rendir (factuas + depositos) no igual con el monto indicado,   (% + %) <> %', COALESCE(v_importe_documentos,0) ,  COALESCE(v_importe_depositos,0)  ,  v_reg_cuenta_doc.importe;
            END IF;
        
      END IF;
      
      
     -- si ele stado es pendiente genera el comprobante
     IF p_codigo_estado = 'pendiente' THEN
     
                v_sincronizar = pxp.f_get_variable_global('sincronizar');
                --  generacion de comprobante
                IF (v_sincronizar = 'true') THEN  
                  select * into v_nombre_conexion from migra.f_crear_conexion();     
                END IF;
                
                
               v_id_int_comprobante =   conta.f_gen_comprobante ( 
                                                     v_reg_cuenta_doc.id_cuenta_doc, 
                                                     v_reg_cuenta_doc.codigo_plantilla_cbte ,
                                                     p_id_usuario,
                                                     p_id_usuario_ai, 
                                                     p_usuario_ai, 
                                                     v_nombre_conexion);
            
          
                 
                
                update  cd.tcuenta_doc   p set 
                    id_int_comprobante = v_id_int_comprobante          
                where id_proceso_wf = p_id_proceso_wf;          
                    	
                IF (v_sincronizar = 'true') THEN  
                  select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
                END IF;
     
     END IF;
   
   
   

RETURN   TRUE;



EXCEPTION
					
	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
			raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;