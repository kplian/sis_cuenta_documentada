CREATE OR REPLACE FUNCTION cd.f_fun_inicio_pago_simple_caja_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_id_depto_lb integer = NULL::integer,
  p_id_cuenta_bancaria integer = NULL::integer,
  p_estado_anterior varchar = 'no'::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       cd.f_fun_inicio_pago_simple_caja_wf
                
 DESCRIPCION:   Actualiza los estados despues del registro de estado en pagos simples por caja
 AUTOR:         RCM
 FECHA:         17/01/2018
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/
DECLARE

    v_nombre_funcion                text;
    v_resp                          varchar;     
    v_mensaje                       varchar;    
    v_registros                     record;
    v_rec                           record;
    v_monto_ejecutar_mo             numeric;
    v_id_uo                         integer;
    v_id_usuario_excepcion          integer;
    v_resp_doc                      boolean;
    v_sincronizar                   varchar;
    v_nombre_conexion               varchar;
    v_id_int_comprobante            integer;
    v_id_solicitud_efectivo         integer;
    
BEGIN
    
    --Identificación del nombre de la función
    v_nombre_funcion = 'cd.f_fun_inicio_pago_simple_caja_wf';

    ----------------------------------------------
    --Obtención de datos del pago simple
    ----------------------------------------------
    select 
    c.id_pago_simple,
    c.estado,
    c.id_estado_wf,
    c.id_funcionario,
    tc.codigo as codigo_tipo_pago_simple,
    tc.id_caja,
    tc.obs,
    tc.importe,
    tc.id_funcionario,
    tc.fecha,
    pro.dec_proveedor
    into v_rec
    from cd.tpago_simple c
    inner join cd.ttipo_pago_simple tc
    on tc.id_tipo_pago_simple = c.id_tipo_pago_simple
    inner join param.v_proveedor pro
    on pro.id_proveedor = c.id_proveedor
    where c.id_proceso_wf = p_id_proceso_wf;
      
    --Actualización del estado de la solicitud
    update cd.tpago_simple set 
    id_estado_wf    = p_id_estado_wf,
    estado          = p_codigo_estado,
    id_usuario_mod  = p_id_usuario,
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai,
    fecha_mod       = now()                     
    where id_proceso_wf = p_id_proceso_wf;

    ------------------------------------
    -- LÓGICA DE VALIDACIÓN POR ESTADOS
    ------------------------------------
    if p_estado_anterior = 'borrador' then

        --Verifica que tenga facturas/recibos registrados cuando sea primero devengado y luego pago
        if not exists(select 1 from cd.tpago_simple_det
                    where id_pago_simple = v_rec.id_pago_simple) then
            raise exception 'Debe agregar al menos un documento (facturas, recibos, etc.) para generar la Solicitud de Efectivo en Cajas.';
        end if;

    end if;

    ------------------------------------
    -- Generación de comprobante diario
    ------------------------------------
    --Si el estado es pendiente genera el comprobante
    if p_codigo_estado = 'pendiente' then

        --Creación de solicitud de efectivo
        select
        v_rec.id_caja as id_caja,
        v_rec.importe as monto,
        v_rec.id_funcionario as id_funcionario,
        'solicitud' as tipo_solicitud,
        v_rec.fecha as fecha,
        ('Pago a Proveedor '||v_rec.desc_proveedor||', por concepto de: '|| v_rec.obs)::varchar as motivo,
        null::integer as id_solicitud_efectivo_fk
        into v_registros;

        --Generacion de la solicitud de efectivo
        v_resp = tes.f_inserta_solicitud_efectivo(0,p_id_usuario,hstore(v_registros),v_rec.id_pago_simple);
        v_id_solicitud_efectivo = pxp.f_obtiene_clave_valor(v_resp,'id_solicitud_efectivo','','','valor')::integer;

        --Creacion de la rendicion de la solicitud de efectivo
        insert into tes.tsolicitud_rendicion_det (
          id_usuario_reg,
          fecha_reg,
          estado_reg,
          id_documento_respaldo,
          id_solicitud_efectivo,
          monto
        )
        select
        1,now(),'activo',psd.id_doc_compra_venta,v_id_solicitud_efectivo,dcv.importe_doc
        from cd.tpago_simple_det psd
        inner join conta.tdoc_compra_venta dcv
        on dcv.id_doc_compra_venta = psd.id_doc_compra_venta
        where psd.id_pago_simple = v_rec.id_pago_simple;

        --Actualiza la tabla e id origen en doc compra venta
        update conta.tdoc_compra_venta set
        tabla_origen = 'tes.tsolicitud_rendicion_det',
        id_origen = v_id_solicitud_efectivo
        from cd.tpago_simple_det psd
        inner join conta.tdoc_compra_venta dcv
        on dcv.id_doc_compra_venta = psd.id_doc_compra_venta
        where psd.id_pago_simple = v_rec.id_pago_simple
        and conta.tdoc_compra_venta.id_doc_compra_venta = psd.id_doc_compra_venta;

        --Actualización del Id del comprobante en la cuenta documentada
        update cd.tpago_simple set 
        id_solicitud_efectivo = v_id_solicitud_efectivo
        where id_pago_simple = v_rec.id_pago_simple;

    end if;
    
 
    --Respuesta
    return true;

EXCEPTION
                    
    WHEN OTHERS THEN

        v_resp = '';
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