--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_gestionar_cbte_cd_prevalidacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*

Autor: RAC KPLIAN
Fecha:   05 abril de 2016
Descripcion  Esta funcion revierte el presupeusto comprometido en las facturas rendidas

*/


DECLARE

	 v_nombre_funcion   				text;
	 v_resp							varchar;
     v_registros 					record;
     v_id_estado_actual  			integer;
     va_id_tipo_estado 				integer[];
     va_codigo_estado 				varchar[];
     va_disparador    				varchar[];
     va_regla        				varchar[]; 
     va_prioridad     				integer[];    
     v_tipo_sol   					varchar;    
     v_nro_cuota 					numeric;    
     v_id_proceso_wf 				integer;
     v_id_estado_wf 				integer;
     v_codigo_estado 				varchar;
     v_id_plan_pago 				integer;
     v_verficacion  				boolean;
     v_verficacion2 				varchar[];     
     v_id_tipo_estado  				integer;
     v_codigo_proceso_llave_wf   	varchar;
     v_cd_comprometer_presupuesto	varchar;
    
BEGIN

        v_nombre_funcion = 'tes.f_gestionar_cbte_cd_prevalidacion';
        v_cd_comprometer_presupuesto = pxp.f_get_variable_global('cd_comprometer_presupuesto');
        
        IF v_cd_comprometer_presupuesto = 'si' THEN
     
              --   1) con el id_comprobante identificar la cuenta documentada de rendicion
             
                select 
                   pc.id_cuenta_doc
                into
                   v_registros
                from  cd.tcuenta_doc pc
                where  pc.id_int_comprobante = p_id_int_comprobante; 
              
               --  2) Validar que tenga un proceso de caja
              
               IF  v_registros.id_cuenta_doc is NULL  THEN
                  raise exception 'El comprobante no esta relacionado con ningun proceso de caja';
               END IF;
          
                
              -- revertir el presupuesto de las facturas rendidas
                             
              IF not cd.f_gestionar_presupuesto_cd(
                                    v_registros.id_cuenta_doc, -- id_proceso_caja 
                                    p_id_usuario, 
                                    'revertir',
                                    p_conexion)  THEN
                     
                     raise exception 'Error al revertir presupuesto';
                                   
              END IF;
       
      END IF;  
      
  
RETURN  TRUE;



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