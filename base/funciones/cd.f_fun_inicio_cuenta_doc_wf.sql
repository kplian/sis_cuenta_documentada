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
    v_limite_fondos				integer;
    v_contador					integer;
    v_rendicion					record;
    v_rendicion_det				record;
    v_cd_comprometer_presupuesto		varchar;
    v_total_documentos		numeric;
   
	
    
BEGIN

	  v_nombre_funcion = 'cd.f_fun_inicio_cuenta_doc_wf';
      v_cd_comprometer_presupuesto = pxp.f_get_variable_global('cd_comprometer_presupuesto');
      
      select 
        c.id_cuenta_doc,
        tcd.codigo_plantilla_cbte,
        tcd.sw_solicitud,
        c.estado,
        c.id_cuenta_doc_fk,
        tcd.nombre,
        c.importe,
        c.id_estado_wf,
        c.id_funcionario,
        c.id_tipo_cuenta_doc,
        c.id_cuenta_doc_fk
        
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
      
      
      
      IF p_estado_anterior = 'borrador' and v_reg_cuenta_doc.sw_solicitud = 'si' THEN
          
              v_limite_fondos = pxp.f_get_variable_global('cd_limite_fondos')::integer;
             
              -- validar que no sobre pase el limite de solicitudes abiertas
              select  count(c.id_cuenta_doc) into v_contador
              from cd.tcuenta_doc c
              inner join cd.ttipo_cuenta_doc tc on tc.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc  
              where c.estado_reg = 'activo' 
                   and tc.sw_solicitud = 'si'  
                   and c.estado != 'finalizado'
                   and c.id_funcionario =  v_reg_cuenta_doc.id_funcionario;
              
              
                   
              
              --si esta en el limite de solicitudes
              IF v_contador >= v_limite_fondos THEN
                     
                    -- ver si tiene autorizacion para pasar
                    select b.id_bloqueo_cd,
                           b.estado
                    into v_registros
                    from cd.tbloqueo_cd b
                    where b.estado_reg = 'activo' and
                          b.id_tipo_cuenta_doc =
                            v_reg_cuenta_doc.id_tipo_cuenta_doc and
                          b.id_funcionario = v_reg_cuenta_doc.id_funcionario;
                          
                   
                     
                    IF v_registros.estado = 'bloqueado' THEN
                       raise exception  'El funcionario llego al limite de solicitudes de fondo en avance abiertas (Puede solicitar un desbloqueo en tesoreria, maximos permitido % )', v_limite_fondos;
                    ELSIF v_registros.estado = 'autorizado' THEN
                       --inactiva bloqueo
                       update cd.tbloqueo_cd
                       set estado_reg = 'inactivo'
                       where id_bloqueo_cd = v_registros.id_bloqueo_cd;
                    
                    END IF;                                    
                            
              END IF;  
              
       END IF;
       
      
       --raise exception 'ssss %',p_estado_anterior;
       
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
         
     END IF;
      
       -- si es uan rendicion y esta saliendo del estado borrador, comprometemos presupeusto
     IF p_estado_anterior = 'borrador' and v_reg_cuenta_doc.sw_solicitud = 'no' THEN       
            -- verificar presupuesto            
            IF not cd.f_gestionar_presupuesto_cd(v_reg_cuenta_doc.id_cuenta_doc, p_id_usuario, 'verificar')  THEN                 
                   raise exception 'Error al verificar el presupuesto';                 
            END IF;
            
            IF v_cd_comprometer_presupuesto = 'si'  THEN       
                -- comprometer presupuesto
                IF not cd.f_gestionar_presupuesto_cd(v_reg_cuenta_doc.id_cuenta_doc, p_id_usuario, 'comprometer')  THEN                 
                       raise exception 'Error al comprometer el presupuesto';                 
                END IF;
            END IF;
     END IF;
     
      -- calcular el importe de la rendicion sumando documentos, y depositos
      -- para las rendiciones
      IF  v_reg_cuenta_doc.sw_solicitud = 'no' THEN
                  
            select 
               COALESCE(sum(COALESCE(dcv.importe_pago_liquido,0)),0)::numeric 
            into
              v_total_documentos                
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and rd.id_cuenta_doc_rendicion = v_reg_cuenta_doc.id_cuenta_doc;
                        
           select  
             COALESCE(sum(COALESCE(lb.importe_deposito,0)),0)::numeric 
           into
             v_importe_depositos
           from tes.tts_libro_bancos lb
           inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc'
           where c.estado_reg = 'activo' and c.id_cuenta_doc =  v_reg_cuenta_doc.id_cuenta_doc;
                        
                    
           update  cd.tcuenta_doc   p set 
              importe =  v_total_documentos +   v_importe_depositos       
           where id_proceso_wf = p_id_proceso_wf;
                 
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
                                                     p_id_estado_wf,                                                     
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