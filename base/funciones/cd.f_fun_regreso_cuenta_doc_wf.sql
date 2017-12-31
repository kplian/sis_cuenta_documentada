CREATE OR REPLACE FUNCTION cd.f_fun_regreso_cuenta_doc_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    funcion que actualiza los estados despues del registro de un retroceso en la cuenta documentada
*  Fecha:   16/05/2016
*
*/

DECLARE

  v_nombre_funcion      text;
    v_resp            varchar;
    v_mensaje         varchar;
    v_reg_cuenta_doc    record;
    v_cd_comprometer_presupuesto    varchar;
   
  
    
BEGIN

  v_nombre_funcion = 'cd.f_fun_regreso_cuenta_doc_wf';
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
        c.id_tipo_cuenta_doc
        
      into
         v_reg_cuenta_doc
      from cd.tcuenta_doc c
      inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
      where c.id_proceso_wf = p_id_proceso_wf;
    

    -- actualiza estado en la solicitud
    update cd.tcuenta_doc  c set 
         id_estado_wf =  p_id_estado_wf,
         estado = p_codigo_estado,
         id_usuario_mod=p_id_usuario,
         fecha_mod=now(),
         id_usuario_ai = p_id_usuario_ai,
         usuario_ai = p_usuario_ai
    where id_proceso_wf = p_id_proceso_wf;
    
    -- si estado al que regresa es borrador, revertimos presupeusto 
--raise exception 'sssssss 11: %',v_reg_cuenta_doc.id_cuenta_doc;        
    IF p_codigo_estado = 'borrador'  and v_reg_cuenta_doc.sw_solicitud = 'no'  and v_cd_comprometer_presupuesto = 'si' THEN    
        -- revertir  presupuesto
        IF not cd.f_gestionar_presupuesto_cd(v_reg_cuenta_doc.id_cuenta_doc, p_id_usuario, 'revertir')  THEN                 
               raise exception 'Error al revertir el presupuesto';                 
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