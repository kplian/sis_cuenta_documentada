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
  p_estado_anterior varchar = 'no'::character varying
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
   
	
    
BEGIN

	  v_nombre_funcion = 'cd.f_fun_inicio_cuenta_doc_wf';
    
     
      -- actualiza estado en la solicitud
      update cd.tcuenta_doc   set 
         id_estado_wf =  p_id_estado_wf,
         estado = p_codigo_estado,
         id_usuario_mod=p_id_usuario,
         id_usuario_ai = p_id_usuario_ai,
         usuario_ai = p_usuario_ai,
         fecha_mod=now()                     
      where id_proceso_wf = p_id_proceso_wf;
      
      
       -- si es tesoreria actuliza libro de bancos y cuenta bancaria
      IF p_estado_anterior = 'vbtesoreria' THEN
         update cd.tcuenta_doc   set 
            id_depto_lb =  p_id_depto_lb,
            id_cuenta_bancaria = p_id_cuenta_bancaria,
            id_depto_conta = p_id_depto_conta
         where id_proceso_wf = p_id_proceso_wf;
      END IF;
     

     -- si ele stado es pendiente genera el comprobante
     IF p_codigo_estado = 'pendiente' THEN
     
                 select 
                     c.id_cuenta_doc,
                     tc.codigo_plantilla_cbte
                   into
                     v_reg_cuenta_doc
                 from cd.tcuenta_doc  c
                 inner join cd.ttipo_cuenta_doc tc on tc.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
                 where id_proceso_wf = p_id_proceso_wf;
     
                
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