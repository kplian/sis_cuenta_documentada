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
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       cd.f_fun_inicio_cuenta_doc_wf
                
 DESCRIPCION:   funcion que actualiza los estados despues del registro de estado en cuenta ddocumentada
 AUTOR:         RAC
 FECHA:         16/05/2016
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   Se incluye la lógica para viáticos. Que se pueda comprometer presupuesto de la solicitud (cuenta_doc_det)
 AUTOR:         RCM
 FECHA:         23/11/2017
***************************************************************************/
DECLARE

    v_nombre_funcion                text;
    v_resp                          varchar; 
    v_mensaje                       varchar; 
    v_registros                     record;
    v_regitros_pp                   record;
    v_monto_ejecutar_mo             numeric;
    v_id_uo                         integer;
    v_id_usuario_excepcion          integer;
    v_resp_doc                      boolean;
    v_id_usuario_firma              integer;
    v_id_moneda_base                integer;
    v_fecha                         date; 
    v_importe_aprobado_total        numeric;
    v_importe_total                 numeric;
    v_sincronizar                   varchar;
    v_nombre_conexion               varchar;
    v_id_int_comprobante            integer;
    v_codigo_plantilla_cbte         varchar;
    v_reg_cuenta_doc                record;
    v_importe_documentos            numeric;
    v_importe_depositos             numeric;
    v_contador                      integer;
    v_rendicion                     record;
    v_rendicion_det                 record;
    v_cd_comprometer_presupuesto    varchar;
    v_total_documentos              numeric;
    v_regla_max_sol                 numeric;
    v_sw_comprometer_sol            boolean;
    v_max_cd_caja                   numeric;
    v_importe_maximo_caja           numeric;
    v_id_solicitud_efectivo         integer;
    v_sw_generar_sol_efectivo       boolean;
    v_id_plantilla                  integer = 41;
    v_resp1                         varchar;
   
BEGIN

    -----------------------------------------------------
    --(1) OBTENCIÓN DE DATOS Y CONFIGURACIONES INICIALES
    -----------------------------------------------------
    
    --Identificación del nombre de la función
    v_nombre_funcion = 'cd.f_fun_inicio_cuenta_doc_wf';
    
    --Obtención variable que define si compromete presupuesto
    v_cd_comprometer_presupuesto = pxp.f_get_variable_global('cd_comprometer_presupuesto');
      
    --Obtención de datos de la cuenta documentada
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
    c.id_cuenta_doc_fk,
    tcd.codigo as codigo_tipo_cuenta_doc,
    c.id_escala,
    c.tipo_pago,
    c.id_caja,
    c.fecha_entrega,
    c.motivo,
    tcd.codigo_plantilla_cbte_devrep
    into
    v_reg_cuenta_doc
    from cd.tcuenta_doc c
    inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
    where c.id_proceso_wf = p_id_proceso_wf;
      
    --Actualización del estado de la solicitud
    update cd.tcuenta_doc set 
    id_estado_wf    = p_id_estado_wf,
    estado          = p_codigo_estado,
    id_usuario_mod  = p_id_usuario,
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai,
    fecha_mod       = now()                     
    where id_proceso_wf = p_id_proceso_wf;
      
    --------------------------------------------------------------------------------
    --(2) Solicitudes 
    --------------------------------------------------------------------------------
    if v_reg_cuenta_doc.sw_solicitud = 'si' then

        ------------------------------------------------------------------------
        --2.1 Verificación de cantidad máxima simultánea de solicitudes abiertas
        ------------------------------------------------------------------------
        if p_estado_anterior = 'borrador' then

            --Obtenciónd de la regla de la escala (MAX_SOL)
            select valor
            into v_regla_max_sol
            from cd.tescala_regla
            where id_escala = v_reg_cuenta_doc.id_escala
            and codigo = 'MAX_SOL';

            if v_regla_max_sol is null then
                raise exception 'No está definida la cantidad máxima de Solicitudes abiertas (MAX_SOL). Comuníquese con el administrador';
            end if;

            --Validación de que no sobrepase el limite de solicitudes abiertas
            select count(c.id_cuenta_doc)
            into v_contador
            from cd.tcuenta_doc c
            inner join cd.ttipo_cuenta_doc tc on tc.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc  
            where c.estado_reg = 'activo' 
            and tc.sw_solicitud = 'si'  
            and c.estado != 'finalizado'
            and c.id_funcionario = v_reg_cuenta_doc.id_funcionario;

            --Si está en el limite de solicitudes
            if v_contador > v_regla_max_sol then
                 
                --Verificación si tiene autorización para continuar
                select b.id_bloqueo_cd, b.estado
                into v_registros
                from cd.tbloqueo_cd b
                where b.estado_reg = 'activo'
                and b.id_tipo_cuenta_doc = v_reg_cuenta_doc.id_tipo_cuenta_doc
                and b.id_funcionario = v_reg_cuenta_doc.id_funcionario;
                      
                --Si está bloqueado lanza el error impidiendo la continuación
                if v_registros.estado = 'bloqueado' then

                   raise exception 'El funcionario llegó al límite de Solicitudes Abiertas. (Puede solicitar un desbloqueo en tesorería. Máximo permitido: % )', v_regla_max_sol;

                elsif v_registros.estado = 'autorizado' then

                   --Inactiva bloqueo
                   update cd.tbloqueo_cd set
                   estado_reg = 'inactivo'
                   where id_bloqueo_cd = v_registros.id_bloqueo_cd;

                end if;
                        
            end if;

            --Actualiza el importe de la cabecera con el total detalle del presupuesto
            v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_reg_cuenta_doc.id_cuenta_doc);

        end if;

        ----------------------------------------------------------
        --2.2 Comprometido de presupuesto a partir de la solicitud
        ----------------------------------------------------------
        v_sw_comprometer_sol = false;
        
        if v_reg_cuenta_doc.codigo_tipo_cuenta_doc = 'SOLVIA' then
            if p_codigo_estado in ('vbgerencia','vbgaf') then
                v_sw_comprometer_sol = true;
            end if;
        elsif v_reg_cuenta_doc.codigo_tipo_cuenta_doc = 'SOLFONAVA' then
            if p_codigo_estado in ('vbgerencia','vbgaf') then
                v_sw_comprometer_sol = true;
            end if;
        end if;

        --Comprometer presupuesto: RCM comentado 20171220
        /*if v_sw_comprometer_sol then
            if not cd.f_gestionar_presupuesto_cd(v_reg_cuenta_doc.id_cuenta_doc, p_id_usuario, 'comprometer_sol')  then
                raise exception 'Error al comprometer presupuesto';
            end if;
        end if;*/

        ---------------------------------------------------------------------------------------------------------------------
        --2.3 Validación estado vbtesoreria: actualiza libro de bancos y cuenta bancaria (solo para la solicitud de fondos)
        ---------------------------------------------------------------------------------------------------------------------
        if p_estado_anterior = 'vbtesoreria' then
          
            update cd.tcuenta_doc set 
            id_depto_lb             = p_id_depto_lb,
            id_cuenta_bancaria      = p_id_cuenta_bancaria,
            id_depto_conta          = p_id_depto_conta,
            id_cuenta_bancaria_mov  = p_id_cuenta_bancaria_mov
            where id_proceso_wf = p_id_proceso_wf;
          
        end if;

        -------------------------------------------------
        --2.4 Creación de Recibo de caja, si corresponde
        -------------------------------------------------
        v_sw_generar_sol_efectivo = false;
        
        if v_reg_cuenta_doc.tipo_pago = 'caja' then

            --Verificacion por viatico o fondo en avance si corresponde generar el recibo en funcion del estado
            if v_reg_cuenta_doc.codigo_tipo_cuenta_doc = 'SOLVIA' then
                if p_codigo_estado = 'pendiente' then
                    v_sw_generar_sol_efectivo = true;
                end if;
            elsif v_reg_cuenta_doc.codigo_tipo_cuenta_doc = 'SOLFONAVA' then
                if p_codigo_estado = 'pendiente' then
                    v_sw_generar_sol_efectivo = true;
                end if;
            end if;

            --Si corresponde genera la solicitud de efectivo
            if v_sw_generar_sol_efectivo then

                --Inicialización de variable
                v_importe_total = 0;

                --Obtención del total del importe
                select o_total
                into v_importe_total
                from cd.f_get_total_cuenta_doc_sol(v_reg_cuenta_doc.id_cuenta_doc,'si');

                if v_importe_total <= 0 then
                    raise exception 'No se puede generar el Recibo. El importe debe ser mayo a cero.';
                end if;

                --Validación que el importe no supere al máximo permitido
                v_max_cd_caja = pxp.f_get_variable_global('cd_importe_maximo_cajas');

                if v_importe_total > v_max_cd_caja then
                    raise exception 'El importe solicitado (%) supera al máximo permitido (%)',v_importe_total, v_max_cd_caja;
                end if;

                --Validación que el importe no supere el máximo permitido por la caja seleccionada
                select importe_maximo_item
                into v_importe_maximo_caja
                from tes.tcaja
                where id_caja = v_reg_cuenta_doc.id_caja;

                if v_importe_maximo_caja < v_importe_total then
                    raise exception 'El importe solicitado (%) supera al máximo permitido en la caja seleccionada (%)',v_importe_total, v_importe_maximo_caja;
                end if;

                --Definición de parámetros
                select
                v_reg_cuenta_doc.id_caja as id_caja,
                v_importe_total as monto,
                v_reg_cuenta_doc.id_funcionario as id_funcionario,
                'solicitud' as tipo_solicitud,
                v_reg_cuenta_doc.fecha_entrega as fecha,
                v_reg_cuenta_doc.motivo as motivo,
                null::integer as id_solicitud_efectivo_fk
                into v_registros;

                --Generacion de la solicitud de efectivo
                v_resp = tes.f_inserta_solicitud_efectivo(0,p_id_usuario,hstore(v_registros),v_reg_cuenta_doc.id_cuenta_doc);
                v_id_solicitud_efectivo = pxp.f_obtiene_clave_valor(v_resp,'id_solicitud_efectivo','','','valor')::integer;

                --Si se genero el recibo, actualiza la cuenta documentada
                if v_id_solicitud_efectivo is not null then
                    update cd.tcuenta_doc set
                    id_solicitud_efectivo = v_id_solicitud_efectivo
                    where id_cuenta_doc = v_reg_cuenta_doc.id_cuenta_doc;
                end if;

            end if;

        end if;

    end if;

    ------------------
    --(3) Rendiciones
    ------------------
    --Verifica que el total de depósitos y facturas cuadre con la rendición
    if v_reg_cuenta_doc.sw_solicitud = 'no' then
      
        if v_reg_cuenta_doc.id_cuenta_doc_fk is null then
            raise exception 'No es una rendición, verifique el tipo de cuenta documentada %',v_reg_cuenta_doc.nombre;
        end if;

        --Si es vbrendicion verifica si tiene recibo sin retencion de viaticos que tenga funcionario
        if p_codigo_estado = 'vbrendicion' then
            if exists(select 1
                        from cd.trendicion_det rd
                        inner join conta.tdoc_compra_venta dcv
                        on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                        inner join param.tplantilla pla
                        on pla.id_plantilla = dcv.id_plantilla
                        where rd.id_cuenta_doc_rendicion = v_reg_cuenta_doc.id_cuenta_doc
                        and dcv.id_plantilla = v_id_plantilla
                        and dcv.id_funcionario is null) then
                raise exception 'Existen Recibos sin Retención de Viáticos que no tienen definido el funcionario. Complete esa información requerida.';
            end if;
        end if;
         
        ------------------------------------------------------------------------------------
        --3.1 Si la rendición está saliendo del estado borrador, comprometemos presupuesto
        ------------------------------------------------------------------------------------
        if p_estado_anterior = 'borrador' and v_reg_cuenta_doc.sw_solicitud = 'no' then
            --Verificación de presupuesto            
            if not cd.f_gestionar_presupuesto_cd(v_reg_cuenta_doc.id_cuenta_doc, p_id_usuario, 'verificar')  then
                raise exception 'Error al verificar el presupuesto';                 
            end if;

            --Comprometido del presupuesto
            if v_cd_comprometer_presupuesto = 'si' then
                if not cd.f_gestionar_presupuesto_cd(v_reg_cuenta_doc.id_cuenta_doc, p_id_usuario, 'comprometer') then
                    raise exception 'Error al comprometer el presupuesto';                 
                end if;
            end if;

        end if;

        --------------------------------------------------------------------------------------------
        --3.2 Cálculo del importe de la rendición sumando documentos y depósitos de las rendiciones
        --------------------------------------------------------------------------------------------
        select coalesce(sum(coalesce(dcv.importe_pago_liquido,0)),0)::numeric
        into v_total_documentos                
        from cd.trendicion_det rd
        inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
        where dcv.estado_reg = 'activo'
        and rd.id_cuenta_doc_rendicion = v_reg_cuenta_doc.id_cuenta_doc;

        select coalesce(sum(coalesce(dpcd.importe_contable_deposito,lb.importe_deposito,0)),0)::numeric
        into v_importe_depositos
        from tes.tts_libro_bancos lb
        left join cd.tdeposito_cd dpcd on dpcd.id_libro_bancos = lb.id_libro_bancos
        inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc'
        where c.estado_reg = 'activo'
        and c.id_cuenta_doc = v_reg_cuenta_doc.id_cuenta_doc;

        --Actualziación del importe de la rendición
        update cd.tcuenta_doc set 
        importe = v_total_documentos + v_importe_depositos       
        where id_proceso_wf = p_id_proceso_wf;

    end if;
      
    --------------------------------
    --(4) Generación de comprobante
    --------------------------------
    --Si el estado es pendiente genera el comprobante
    if p_codigo_estado = 'pendiente' then
        
        --Si es solicitud y el pago es por caja no genera comprobante. Si es rendicion siempre genera comprobante
        if v_reg_cuenta_doc.sw_solicitud = 'si' then
        
            if v_reg_cuenta_doc.tipo_pago != 'caja' then
                --Variable global para sincronización con ENDESIS
                v_sincronizar = pxp.f_get_variable_global('sincronizar');

                --Inicio de sincronización si corresponde
                if v_sincronizar = 'true' then
                    select * into v_nombre_conexion from migra.f_crear_conexion();     
                end if;

                --Generación del comprobante
                v_id_int_comprobante = conta.f_gen_comprobante(v_reg_cuenta_doc.id_cuenta_doc, 
                                                                v_reg_cuenta_doc.codigo_plantilla_cbte,
                                                                p_id_estado_wf,                                                     
                                                                p_id_usuario,
                                                                p_id_usuario_ai, 
                                                                p_usuario_ai, 
                                                                v_nombre_conexion);

                --Actualización del Id del comprobante en la cuenta documentada
                update cd.tcuenta_doc set 
                id_int_comprobante = v_id_int_comprobante          
                where id_proceso_wf = p_id_proceso_wf;

                --Fin de sincronización si corresponde
                if v_sincronizar = 'true' then
                    select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
                end if;
                
            end if;
        
        elsif v_reg_cuenta_doc.sw_solicitud = 'no' then
            
            --Variable global para sincronización con ENDESIS
            v_sincronizar = pxp.f_get_variable_global('sincronizar');

            --Inicio de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_nombre_conexion from migra.f_crear_conexion();     
            end if;

            --Generación del comprobante
            v_id_int_comprobante = conta.f_gen_comprobante(v_reg_cuenta_doc.id_cuenta_doc, 
                                                            v_reg_cuenta_doc.codigo_plantilla_cbte,
                                                            p_id_estado_wf,                                                     
                                                            p_id_usuario,
                                                            p_id_usuario_ai, 
                                                            p_usuario_ai, 
                                                            v_nombre_conexion);

            --Actualización del Id del comprobante en la cuenta documentada
            update cd.tcuenta_doc set 
            id_int_comprobante = v_id_int_comprobante          
            where id_proceso_wf = p_id_proceso_wf;

            --Fin de sincronización si corresponde
            if v_sincronizar = 'true' then
                select * into v_resp from migra.f_cerrar_conexion(v_nombre_conexion,'exito'); 
            end if;
        else
            raise exception 'No se generó comprobante porque no se pudo identificar si era una solicitud de fondos o rendición';
        end if;
        
    elsif p_codigo_estado = 'pendiente_tes' then
        
        --Generación del comprobante
        v_id_int_comprobante = conta.f_gen_comprobante(v_reg_cuenta_doc.id_cuenta_doc, 
                                                        v_reg_cuenta_doc.codigo_plantilla_cbte_devrep,
                                                        p_id_estado_wf,                                                     
                                                        p_id_usuario,
                                                        p_id_usuario_ai, 
                                                        p_usuario_ai, 
                                                        v_nombre_conexion);

        --Actualización del Id del comprobante en la cuenta documentada
        update cd.tcuenta_doc set 
        id_int_comprobante_devrep = v_id_int_comprobante          
        where id_proceso_wf = p_id_proceso_wf;        
     
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