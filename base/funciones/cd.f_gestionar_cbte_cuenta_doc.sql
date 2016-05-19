--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_gestionar_cbte_cuenta_doc (
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
Fecha:   17  abril  de 2016
Descripcion  Esta funcion gestiona los cbtes de cuenta_documentada cuando son validados

               

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
	 --gonzalo
     v_id_finalidad					integer;
     v_respuesta_libro_bancos 		varchar;
     v_registros_tpc				record;
     v_codigo_tpc  					varchar;
     v_id_proceso_caja				integer;
     v_id_int_comprobante			integer;
     v_sw_disparo 					boolean;
     v_hstore_registros 			hstore;
     v_tmp_tipo						varchar;
     v_id_solicitud_efectivo		integer;
     v_saldo_caja					numeric;
     v_monto						numeric;
     v_registros_cv					record;
    
BEGIN

	v_nombre_funcion = 'cd.f_gestionar_cbte_cuenta_doc';
 
   -- 1) con el id_comprobante identificar el plan de pago
   
      select 
            pc.id_cuenta_doc,
            pc.id_estado_wf,
            pc.id_proceso_wf,
            pc.tipo_pago,
            pc.estado,
            pc.id_cuenta_doc_fk,
          
            pc.id_cuenta_bancaria ,
            pc.fecha,
            pc.importe,
            pc.id_depto_conta,
            tpc.codigo_plantilla_cbte,
            dpc.prioridad as prioridad_conta,
            dpl.prioridad as prioridad_libro,
            c.temporal,
            c.fecha as fecha_cbte,
            tpc.codigo as codigo_tcd,
            tpc.codigo_wf,
            ew.id_funcionario,
            ew.id_depto,
            pc.id_depto_conta,
            pc.id_gestion,
            pc.nro_tramite,
            pc.motivo,
            pc.fecha,
            pc.id_gestion
      into
            v_registros
      
      from  cd.tcuenta_doc pc
      
      inner join cd.ttipo_cuenta_doc tpc on tpc.id_tipo_cuenta_doc = pc.id_tipo_cuenta_doc and tpc.estado_reg = 'activo'
      inner join conta.tint_comprobante  c on c.id_int_comprobante = pc.id_int_comprobante 
	  inner join wf.testado_wf ew on ew.id_estado_wf = pc.id_estado_wf
      left join param.tdepto dpc on dpc.id_depto = pc.id_depto_conta
	  left join param.tdepto dpl on dpl.id_depto = pc.id_depto_lb
      
      where  pc.id_int_comprobante = p_id_int_comprobante; 
    
    
      --2) Validar que tenga un proceso de caja
    
     IF  v_registros.id_cuenta_doc is NULL  THEN
        raise exception 'El comprobante no esta relacionado con ninguna cuenta documentada';
     END IF;
    
     
    
    --------------------------------------------------------
    ---  cambiar el estado del proceso de caja         -----
    --------------------------------------------------------
        
        
          -- obtiene el siguiente estado del flujo 
               SELECT 
                   *
                into
                  va_id_tipo_estado,
                  va_codigo_estado,
                  va_disparador,
                  va_regla,
                  va_prioridad
              
              FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');
              
              
              
              IF va_codigo_estado[2] is not null THEN              
                 raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
              END IF;
              
              IF va_codigo_estado[1] is  null THEN
                 raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
              END IF;
              
              -- estado siguiente
              v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                             v_registros.id_funcionario, 
                                                             v_registros.id_estado_wf, 
                                                             v_registros.id_proceso_wf,
                                                             p_id_usuario,
                                                             p_id_usuario_ai, -- id_usuario_ai
                                                             p_usuario_ai, -- usuario_ai
                                                             v_registros.id_depto_conta,
                                                             'Comprobante validado');
              -- actualiza estado del proceso
            
              update cd.tcuenta_doc pc  set 
                           id_estado_wf =  v_id_estado_actual,
                           estado = va_codigo_estado[1],
                           id_usuario_mod=p_id_usuario,
                           fecha_mod=now(),
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai
            where pc.id_cuenta_doc  = v_registros.id_cuenta_doc; 
    
 
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