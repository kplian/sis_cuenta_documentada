CREATE OR REPLACE FUNCTION cd.f_cambiar_estado_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_id_estado_wf integer,
  p_id_depto integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       cd.f_cambiar_estado_wf
                
 DESCRIPCION:   Función que actualiza los estados en cuenta documentada
 AUTOR:         RCM
 FECHA:         29/03/2018
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/
DECLARE
  
    v_id_estado_actual              integer;
    v_id_tipo_estado                integer;
    v_id_funcionario                integer;
    v_id_depto                      integer;

BEGIN

    --Obtiene el id del tipo de estado del estado solicitado (p_codigo_estado)
    select te.id_tipo_estado
    into v_id_tipo_estado
    from wf.tproceso_wf pw 
    inner join wf.ttipo_proceso tp
    on pw.id_tipo_proceso = tp.id_tipo_proceso
    inner join wf.ttipo_estado te 
    on te.id_tipo_proceso = tp.id_tipo_proceso 
    and te.codigo = p_codigo_estado
    where pw.id_proceso_wf = p_id_proceso_wf;
    
    --Obtiene el funcionario del estado anterior
    select id_funcionario, id_depto
    into v_id_funcionario, v_id_depto
    from wf.testado_wf where id_estado_wf = p_id_estado_wf;
    
                   
    if v_id_tipo_estado is null then
      raise exception 'El estado % no está parametrizado en el workflow de Cuenta Documentada',p_codigo_estado;  
    end if;
                    
    v_id_estado_actual = wf.f_registra_estado_wf(v_id_tipo_estado, 
                                                 v_id_funcionario, 
                                                 p_id_estado_wf, 
                                                 p_id_proceso_wf,
                                                 p_id_usuario,
                                                 p_id_usuario_ai,
                                                 p_id_usuario_ai::varchar,
                                                 v_id_depto,
                                                 'Cambio de estado en cuenta documentada');
                    
    update cd.tcuenta_doc set 
    id_estado_wf =  v_id_estado_actual,
    estado = p_codigo_estado,
    id_usuario_mod = p_id_usuario,
    fecha_mod = now(),
    id_usuario_ai = p_id_usuario_ai
    where id_proceso_wf = p_id_proceso_wf;
    
    return 'hecho';

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;