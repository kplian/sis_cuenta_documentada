CREATE OR REPLACE FUNCTION cd.f_fun_inicio_pago_simple_wf (
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
 FUNCION:       cd.f_fun_inicio_pago_simple_wf
                
 DESCRIPCION:   Actualiza los estados despues del registro de estado en pagos simples
 AUTOR:         RCM
 FECHA:         05/01/2018
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
    
BEGIN
    
    --Identificación del nombre de la función
    v_nombre_funcion = 'cd.f_fun_inicio_pago_simple_wf';

    ----------------------------------------------
    --Obtención de datos de la cuenta documentada
    ----------------------------------------------
    select 
    c.id_pago_simple,
    c.estado,
    c.id_estado_wf,
    c.id_funcionario,
    tc.codigo as codigo_tipo_pago_simple,
    tc.plantilla_cbte,
    tc.plantilla_cbte_1
    into v_rec
    from cd.tpago_simple c
    inner join cd.ttipo_pago_simple tc
    on tc.id_tipo_pago_simple = c.id_tipo_pago_simple
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

    ---------------------------------------------------
    -- ACTUALIZACION DE LIBO DE BANCOS YCUENTA BANCARIA
    ---------------------------------------------------
    if p_estado_anterior = 'vbtesoreria' then
          
        update cd.tpago_simple set 
        id_depto_lb             = p_id_depto_lb,
        id_cuenta_bancaria      = p_id_cuenta_bancaria
        where id_proceso_wf = p_id_proceso_wf;

    elsif p_estado_anterior = 'borrador' then

        --Verifica que tenga facturas/recibos registrados cuando sea primero devengado y luego pago
        if v_rec.codigo_tipo_pago_simple not in ( 'PAG_DEV', 'SOLO_PAG','ADU_GEST_ANT','DVPGPR') then
            if not exists(select 1 from cd.tpago_simple_det
                        where id_pago_simple = v_rec.id_pago_simple) then
                raise exception 'Debe agregar al menos un documento (facturas, recibos, etc.) para procesar el pago.';
            end if;
        end if;

    elsif p_estado_anterior = 'rendicion' then
      
        --Verifica que tenga facturas/recibos registrados para asociar al comprobante diario (caso Pago - Devengado)
        /*if v_rec.codigo_tipo_pago_simple IN ('PAG_DEV','ADU_GEST_ANT') then
            if not exists(select 1 from cd.tpago_simple_det
                        where id_pago_simple = v_rec.id_pago_simple) then
                raise exception 'Debe agregar al menos un documento (facturas, recibos, etc.) para generar el comprobante diario';
            end if;
        end if;*/

        /*if v_rec.codigo_tipo_pago_simple IN ('ADU_GEST_ANT') then
            if not exists(select 1 from cd.tpago_simple_pro
                        where id_pago_simple = v_rec.id_pago_simple) then
                raise exception 'Debe registrar el prorrateo para generar el comprobante diario';
            end if;
        end if;*/

    elsif p_estado_anterior = 'vbconta' then

        --Verifica que tenga facturas/recibos registrados para asociar al comprobante diario (caso Pago - Devengado)
        if v_rec.codigo_tipo_pago_simple IN ('PAG_DEV','ADU_GEST_ANT','SOLO_DEV','DVPGPR') then
            if not exists(select 1 from cd.tpago_simple_det
                        where id_pago_simple = v_rec.id_pago_simple) then
                raise exception 'Debe agregar al menos un documento (facturas, recibos, etc.) para generar el comprobante diario';
            end if;
        end if;

        if v_rec.codigo_tipo_pago_simple IN ('PAG_DEV','ADU_GEST_ANT','SOLO_DEV','DVPGPR') then
            if not exists(select 1 from cd.tpago_simple_pro
                        where id_pago_simple = v_rec.id_pago_simple) then
                raise exception 'Debe registrar el prorrateo para generar el comprobante diario';
            end if;
        end if;

    end if;

    ------------------------------------
    -- Generación de comprobante diario
    ------------------------------------
    --Si el estado es pendiente genera el comprobante
    if p_codigo_estado = 'pendiente' then
        --Variable global para sincronización con ENDESIS
        v_sincronizar = pxp.f_get_variable_global('sincronizar');

        if v_rec.codigo_tipo_pago_simple NOT IN ('PAG_DEV','ADU_GEST_ANT') then
            
            --Inicio de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_nombre_conexion from migra.f_crear_conexion();     
            end if;

            --Generación del comprobante
            v_id_int_comprobante = conta.f_gen_comprobante(v_rec.id_pago_simple, 
                                                            v_rec.plantilla_cbte,
                                                            p_id_estado_wf,                                                     
                                                            p_id_usuario,
                                                            p_id_usuario_ai, 
                                                            p_usuario_ai, 
                                                            v_nombre_conexion);

            --Actualización del Id del comprobante en la cuenta documentada
            update cd.tpago_simple set 
            id_int_comprobante = v_id_int_comprobante          
            where id_proceso_wf = p_id_proceso_wf;
            
            --Relacionar facturas con el comprobante
            update conta.tdoc_compra_venta set
            id_int_comprobante = v_id_int_comprobante,
            fecha_mod = now(),
            id_usuario_reg = p_id_usuario
            from cd.tpago_simple_det psd
            where psd.id_pago_simple = v_rec.id_pago_simple
            and psd.id_doc_compra_venta = conta.tdoc_compra_venta.id_doc_compra_venta;

            --Fin de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
            end if;

        elsif v_rec.codigo_tipo_pago_simple IN ('PAG_DEV','ADU_GEST_ANT') then

            --Inicio de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_nombre_conexion from migra.f_crear_conexion();     
            end if;

            --Generación del comprobante
            v_id_int_comprobante = conta.f_gen_comprobante(v_rec.id_pago_simple, 
                                                            v_rec.plantilla_cbte_1,
                                                            p_id_estado_wf,                                                     
                                                            p_id_usuario,
                                                            p_id_usuario_ai, 
                                                            p_usuario_ai, 
                                                            v_nombre_conexion);

            --Actualización del Id del comprobante en la cuenta documentada
            update cd.tpago_simple set 
            id_int_comprobante_pago = v_id_int_comprobante          
            where id_proceso_wf = p_id_proceso_wf;

            --Fin de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
            end if;

            --Relacionar facturas con el comprobante
            update conta.tdoc_compra_venta set
            id_int_comprobante = v_id_int_comprobante,
            fecha_mod = now(),
            id_usuario_reg = p_id_usuario
            from cd.tpago_simple_det psd
            where psd.id_pago_simple = v_rec.id_pago_simple
            and psd.id_doc_compra_venta = conta.tdoc_compra_venta.id_doc_compra_venta;

        end if;
        

    elsif p_codigo_estado = 'pendiente_pago' then

        --Variable global para sincronización con ENDESIS
        v_sincronizar = pxp.f_get_variable_global('sincronizar');

        if v_rec.codigo_tipo_pago_simple NOT IN  ('PAG_DEV','ADU_GEST_ANT') then
            
            --Inicio de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_nombre_conexion from migra.f_crear_conexion();     
            end if;

            --Generación del comprobante
            v_id_int_comprobante = conta.f_gen_comprobante(v_rec.id_pago_simple, 
                                                            v_rec.plantilla_cbte_1,
                                                            p_id_estado_wf,                                                     
                                                            p_id_usuario,
                                                            p_id_usuario_ai, 
                                                            p_usuario_ai, 
                                                            v_nombre_conexion);

            --Actualización del Id del comprobante en la cuenta documentada
            update cd.tpago_simple set 
            id_int_comprobante_pago = v_id_int_comprobante          
            where id_proceso_wf = p_id_proceso_wf;
            
            --Fin de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
            end if;

        elsif v_rec.codigo_tipo_pago_simple IN ('PAG_DEV','ADU_GEST_ANT') then
        
            --Inicio de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_nombre_conexion from migra.f_crear_conexion();     
            end if;

            --Generación del comprobante
            v_id_int_comprobante = conta.f_gen_comprobante(v_rec.id_pago_simple, 
                                                            v_rec.plantilla_cbte,
                                                            p_id_estado_wf,                                                     
                                                            p_id_usuario,
                                                            p_id_usuario_ai, 
                                                            p_usuario_ai, 
                                                            v_nombre_conexion);

            --Actualización del Id del comprobante en la cuenta documentada
            update cd.tpago_simple set 
            id_int_comprobante = v_id_int_comprobante
            where id_proceso_wf = p_id_proceso_wf;
            
            --Fin de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
            end if;

            

        end if;
        

        

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