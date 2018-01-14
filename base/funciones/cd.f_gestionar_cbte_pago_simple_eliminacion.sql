--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_gestionar_cbte_pago_simple_eliminacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*
Autor: RAC KPLIANF
Fecha:   28 marzo de 2016
Descripcion  Esta funcion retrocede el estado de los planes de pago cuando los comprobantes son eliminados

  

*/


DECLARE
  
    v_nombre_funcion        text;
    v_resp                  varchar;
    v_registros             record;
    v_id_estado_actual      integer;
    va_id_tipo_estado       integer[];
    va_codigo_estado        varchar[];
    va_disparador           varchar[];
    va_regla                varchar[]; 
    va_prioridad            integer[];
    v_tipo_sol              varchar;
    v_nro_cuota             numeric;
    v_id_proceso_wf         integer;
    v_id_estado_wf          integer;
    v_id_plan_pago          integer;
    v_verficacion           boolean;
    v_verficacion2          varchar[];
    v_id_tipo_estado        integer;
    v_id_funcionario        integer;
    v_id_usuario_reg        integer;
    v_id_depto              integer;
    v_codigo_estado         varchar;
    v_id_estado_wf_ant      integer;
    v_rec_cbte_trans        record;
    v_reg_cbte              record;
    v_estado                varchar;
    
BEGIN

    v_nombre_funcion = 'cd.f_gestionar_cbte_pago_simple_eliminacion';

    -- 1) Con el id_int_comprobante identificar el pago simple
    select 
    cc.id_pago_simple,
    cc.id_estado_wf,
    cc.id_proceso_wf,
    cc.estado,
    cc.id_int_comprobante,
    tps.codigo as codigo_tipo_pago_simple
    into
    v_registros
    from cd.tpago_simple cc
    inner join cd.ttipo_pago_simple tps on  tps.id_tipo_pago_simple = cc.id_tipo_pago_simple
    where cc.id_int_comprobante = p_id_int_comprobante; 

    --2) Validar que exista el pago simple
    IF  v_registros.id_pago_simple is NULL THEN     

        select 
        cc.id_pago_simple,
        cc.id_estado_wf,
        cc.id_proceso_wf,
        cc.estado,
        cc.id_int_comprobante_pago as id_int_comprobante,
        tps.codigo as codigo_tipo_pago_simple
        into
        v_registros
        from cd.tpago_simple cc
        inner join cd.ttipo_pago_simple tps on  tps.id_tipo_pago_simple = cc.id_tipo_pago_simple
        where cc.id_int_comprobante_pago = p_id_int_comprobante; 

        IF  v_registros.id_pago_simple is NULL  THEN
            raise exception 'El comprobante no esta relacionado a ningun pago';
        END IF;

    END IF;

    --Obtencion datos del comprobante
    select
    ic.estado_reg
    INTO
    v_reg_cbte
    from conta.tint_comprobante ic
    where ic.id_int_comprobante = v_registros.id_int_comprobante;
     
    IF v_reg_cbte.estado_reg = 'validado' THEN
       raise exception 'No puede eliminar comprobantes validados';
    END IF;
     
    if v_registros.codigo_tipo_pago_simple <> 'PAG_DEV' then
    
        --Recupera estado anterior segun Log del WF
        SELECT  
        ps_id_tipo_estado,
        ps_id_funcionario,
        ps_id_usuario_reg,
        ps_id_depto,
        ps_codigo_estado,
        ps_id_estado_wf_ant
        into
        v_id_tipo_estado,
        v_id_funcionario,
        v_id_usuario_reg,
        v_id_depto,
        v_codigo_estado,
        v_id_estado_wf_ant 
        FROM wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf);
    
    else
    
        v_id_tipo_estado = 667;
        SELECT  
        ps_id_funcionario,
        ps_id_usuario_reg,
        ps_id_depto,
        ps_codigo_estado,
        ps_id_estado_wf_ant
        into
        v_id_funcionario,
        v_id_usuario_reg,
        v_id_depto,
        v_codigo_estado,
        v_id_estado_wf_ant 
        FROM wf.f_obtener_estado_segun_log_wf(v_registros.id_estado_wf,v_id_tipo_estado);
    
    end if;
    

    select 
    ew.id_proceso_wf 
    into 
    v_id_proceso_wf
    from wf.testado_wf ew
    where ew.id_estado_wf= v_id_estado_wf_ant;

    --Registra nuevo estado
    v_id_estado_actual = wf.f_registra_estado_wf(
            v_id_tipo_estado, 
            v_id_funcionario, 
            v_registros.id_estado_wf, 
            v_id_proceso_wf, 
            p_id_usuario,
            p_id_usuario_ai,
            p_usuario_ai,
            v_id_depto,
            'Eliminación de comprobante de pago simple:'|| COALESCE(v_registros.id_int_comprobante::varchar,'NaN'));

    if v_codigo_estado = 'pendiente' then
        -- si el estado es pendiente conservamos el ID del cbte ...
        -- actualiza estado del proceso de caja
        update cd.tpago_simple pc set 
        id_estado_wf = v_id_estado_actual,
        estado = v_codigo_estado,
        id_usuario_mod = p_id_usuario,
        fecha_mod = now(),
        id_usuario_ai = p_id_usuario_ai,
        usuario_ai = p_usuario_ai
        where pc.id_pago_simple = v_registros.id_pago_simple;

    elsif v_codigo_estado = 'vbtesoreria' then

        --Actualiza estado en la solicitud, quita la relacion del comprobante de pago
        update cd.tpago_simple pc set 
        id_estado_wf =  v_id_estado_actual,
        estado = v_codigo_estado,
        id_usuario_mod=p_id_usuario,
        fecha_mod=now(),
        id_int_comprobante_pago = NULL,
        id_usuario_ai = p_id_usuario_ai,
        usuario_ai = p_usuario_ai
        where pc.id_pago_simple = v_registros.id_pago_simple;

    else
        --Actualiza estado en la solicitud,quita la relacion del comprobante de diario
        update cd.tpago_simple pc set 
        id_estado_wf =  v_id_estado_actual,
        estado = v_codigo_estado,
        id_usuario_mod=p_id_usuario,
        fecha_mod=now(),
        id_int_comprobante = NULL,
        id_usuario_ai = p_id_usuario_ai,
        usuario_ai = p_usuario_ai
        where pc.id_pago_simple = v_registros.id_pago_simple;

    end if;   

    --Quita la relacion de las facturas con el comprobante
    update conta.tdoc_compra_venta set
    id_int_comprobante = null,
    fecha_mod = now(),
    id_usuario_reg = p_id_usuario
    from cd.tpago_simple_det psd
    where psd.id_pago_simple = v_registros.id_pago_simple
    and psd.id_doc_compra_venta = conta.tdoc_compra_venta.id_doc_compra_venta;

    return true;

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