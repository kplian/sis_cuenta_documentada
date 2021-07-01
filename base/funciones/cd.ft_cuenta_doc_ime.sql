CREATE OR REPLACE FUNCTION cd.ft_cuenta_doc_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Cuenta Documentada
 FUNCION:     cd.ft_cuenta_doc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcuenta_doc'
 AUTOR:      (admin)
 FECHA:         05-05-2016 16:41:21
 COMENTARIOS:
***************************************************************************
ISSUE SIS       EMPRESA      FECHA         AUTOR         DESCRIPCION
      CD        ETR          05/05/2019
      CD        ETR          05/09/2019    RCM           Modificaciones para el caso de viaticos
#1    CD        ETR          28/11/2018    RCM           Validación al editar solicitud, no permitir cambiar de gestión (CD_CDOC_MOD)
#8    CD        ETR          15/10/2019    RCM           Adición de detalle de funcionarios en viáticos para más de una persona
***************************************************************************
*/

DECLARE

    v_parametros              record;
    v_registros               record;
    v_sw_max_doc_rend         varchar;
    v_resp                    varchar;
    v_nombre_funcion          text;
    v_id_cuenta_doc           integer;
    v_codigo_proceso_macro    varchar;
    va_id_funcionario_gerente integer[];
    v_id_proceso_macro        integer;
    v_codigo_tipo_proceso     varchar;
    v_num_tramite             varchar;
    v_id_proceso_wf           integer;
    v_id_estado_wf            integer;
    v_codigo_estado           varchar;
    v_resp_doc                boolean;
    v_id_gestion              integer;
    v_id_uo                   integer;
    v_id_tipo_cuenta_doc      integer;
    v_id_tipo_estado          integer;
    v_codigo_estado_siguiente varchar;
    v_id_depto                integer;
    v_obs                     varchar;
    v_id_estado_actual        integer;
    v_registros_proc          record;
    v_codigo_tipo_pro         varchar;
    v_operacion               varchar;
    v_registros_cd            record;
    v_id_funcionario          integer;
    v_id_usuario_reg          integer;
    v_id_estado_wf_ant        integer;
    v_acceso_directo          varchar;
    v_clase                   varchar;
    v_parametros_ad           varchar;
    v_tipo_noti               varchar;
    v_titulo                  varchar;
    v_id_depto_lb             integer;
    v_id_cuenta_bancaria      integer;
    v_id_depto_conta          integer;
    v_contador                integer;
    v_codigo_tp               varchar;
    v_contador_libro_bancos   integer;
    v_id_cuenta_bancaria_mov  integer;
    v_temp                    interval;
    v_num_rend                integer;
    v_asunto                  varchar;
    v_destinatorio            varchar;
    v_template                varchar;
    v_id_alarma               integer[];
    v_fecha_ini               date;
    v_fecha_fin               date;
    v_id_periodo              integer;
    v_periodo                 integer;
    v_codigo_tipo_cuenta_doc  varchar;
    v_resp1                   varchar;
    v_id_escala               integer;
    v_total                   bigint;
    v_id_plantilla            integer;
    v_id_solicitud_efectivo   integer;
    v_mensaje                 varchar;
    v_solo_una_rendicion_mes  varchar;
    v_sol_efect               varchar;
    v_id_concepto_ingas       integer;
    v_total_prorrateo         numeric;
    v_tipo_pago               varchar;
    v_id_caja                 integer;
    v_importe_total           numeric;
    v_max_cd_caja             numeric;
    v_importe_maximo_caja     numeric;
    v_tipo_contrato           varchar;
    v_cod_concepto_ingas      varchar;
    v_regla_max_sol           integer;
    v_sol_abiertas            varchar;
    v_permitir_mod            varchar;
    v_cc_sigema               text;
    v_saldo                   numeric;
    v_tmp_resp                boolean;
    v_codigos                 varchar;
    v_id_gestion_sol          integer;
    v_id_funcionarios         integer[]; --#8

BEGIN

    v_nombre_funcion = 'cd.ft_cuenta_doc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /******************************************
    #TRANSACCION: 'CD_CDOC_INS'
    #DESCRIPCION: Insercion de registros de fondos en avance
    #AUTOR:   admin
    #FECHA:   05-05-2016 16:41:21
    *******************************************/

    if (p_transaccion = 'CD_CDOC_INS') then

        begin

            --Obtención del proceso macro en función del tipo de cuenta documentada
            select codigo
            into v_codigo_tipo_cuenta_doc
            from cd.ttipo_cuenta_doc
            where id_tipo_cuenta_doc = v_parametros.id_tipo_cuenta_doc;

            if v_codigo_tipo_cuenta_doc = 'SOLFONAVA' then
                v_codigo_proceso_macro = pxp.f_get_variable_global('cd_codigo_macro_fondo_avance');
            elsif v_codigo_tipo_cuenta_doc = 'SOLVIA' then
                v_codigo_proceso_macro = pxp.f_get_variable_global('cd_codigo_macro_viatico');
            else
                raise exception 'Tipo de Cuenta no válida para el inicio del proceso de WF';
            end if;

            --Si el funcionario que solicita es un gerente .... es el mimso encargado de aprobar
            IF exists(select 1
                      from orga.tuo_funcionario uof
                               inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = 'activo'
                               inner join orga.tnivel_organizacional no
                                          on no.id_nivel_organizacional = uo.id_nivel_organizacional and
                                             no.numero_nivel in (1)
                      where uof.estado_reg = 'activo'
                        and uof.id_funcionario = v_parametros.id_funcionario) THEN

                va_id_funcionario_gerente[1] = v_parametros.id_funcionario;

            ELSE
                --si tiene funcionario identificar el gerente correspondientes
                IF v_parametros.id_funcionario is not NULL THEN

                    SELECT pxp.aggarray(id_funcionario)
                    into
                        va_id_funcionario_gerente
                    FROM orga.f_get_aprobadores_x_funcionario(v_parametros.fecha, v_parametros.id_funcionario, 'todos',
                                                              'si', 'todos', 'ninguno') AS (id_funcionario integer);
                    --NOTA el valor en la primera posicion del array es el genre de menor nivel
                END IF;
            END IF;

            -- recupera la uo gerencia del funcionario
            v_id_uo = orga.f_get_uo_gerencia_ope(NULL, v_parametros.id_funcionario, v_parametros.fecha::Date);

            --obtener id del proceso macro

            select pm.id_proceso_macro
            into
                v_id_proceso_macro
            from wf.tproceso_macro pm
            where pm.codigo = v_codigo_proceso_macro;


            If v_id_proceso_macro is NULL THEN
                raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;
            END IF;


            --   obtener el codigo del tipo_proceso
            select tp.codigo
            into v_codigo_tipo_proceso
            from wf.ttipo_proceso tp
            where tp.id_proceso_macro = v_id_proceso_macro
              and tp.estado_reg = 'activo'
              and tp.inicio = 'si';


            IF v_codigo_tipo_proceso is NULL THEN
                raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
            END IF;

            select per.id_gestion
            into
                v_id_gestion
            from param.tperiodo per
            where per.fecha_ini <= v_parametros.fecha
              and per.fecha_fin >= v_parametros.fecha
            limit 1 offset 0;


            -- inciar el tramite en el sistema de WF
            SELECT ps_num_tramite,
                   ps_id_proceso_wf,
                   ps_id_estado_wf,
                   ps_codigo_estado
            into
                v_num_tramite,
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado

            FROM wf.f_inicia_tramite(
                    p_id_usuario,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    v_id_gestion,
                    v_codigo_tipo_proceso,
                    v_parametros.id_funcionario,
                    v_parametros.id_depto,
                    'Solicitud de efectivo por Fondos con Cargo a Rendición de Cuentas',
                    '');


            --recupera el tipo de cuenta documentada, SOLFONAVA, para solicutd de fondo en avance
            /*
            select
               tcd.id_tipo_cuenta_doc
            into
              v_id_tipo_cuenta_doc
            from cd.ttipo_cuenta_doc tcd
            where tcd.codigo = 'SOLFONAVA'; */

            --Obtiene la Escala vigente
            if v_codigo_tipo_cuenta_doc = 'SOLFONAVA' then
                v_id_escala = cd.f_get_escala('fondo_avance', v_parametros.fecha);
            elsif v_codigo_tipo_cuenta_doc = 'SOLVIA' then
                v_id_escala = cd.f_get_escala('viatico', v_parametros.fecha);
            end if;

            --Verifica si existe plantilla para la rendicion
            if pxp.f_existe_parametro(p_tabla, 'id_plantilla') then
                v_id_plantilla = v_parametros.id_plantilla;
            end if;

            -------------------------------------
            -- Evalua el limite de solicitudes
            -------------------------------------
            --v_limite_fondos = pxp.f_get_variable_global('cd_limite_fondos')::integer;
            select valor
            into v_regla_max_sol
            from cd.tescala_regla
            where id_escala = v_id_escala
              and codigo = 'MAX_SOL';

            if v_regla_max_sol is null then
                raise exception 'No está definida la cantidad máxima de Solicitudes abiertas (MAX_SOL). Comuníquese con el administrador';
            end if;


            -- validar que no sobre pase el limite de solicitudes abiertas
            select count(c.id_cuenta_doc)
            into v_contador
            from cd.tcuenta_doc c
                     inner join cd.ttipo_cuenta_doc tc on tc.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
            where c.estado_reg = 'activo'
              and tc.sw_solicitud = 'si'
              and c.estado != 'finalizado'
              and c.id_funcionario = v_parametros.id_funcionario;

            IF v_contador = v_regla_max_sol THEN
                INSERT INTO cd.tbloqueo_cd(id_usuario_reg,
                                           fecha_reg,
                                           estado_reg,
                                           id_tipo_cuenta_doc,
                                           id_funcionario,
                                           estado)
                VALUES (p_id_usuario,
                        now(),
                        'activo',
                        v_parametros.id_tipo_cuenta_doc,
                        v_parametros.id_funcionario,
                        'bloqueado');

            ELSEIF v_contador > v_regla_max_sol THEN

                select pxp.list(c.nro_tramite)
                into v_sol_abiertas
                from cd.tcuenta_doc c
                         inner join cd.ttipo_cuenta_doc tc on tc.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
                where c.estado_reg = 'activo'
                  and tc.sw_solicitud = 'si'
                  and c.estado != 'finalizado'
                  and c.id_funcionario = v_parametros.id_funcionario;

                raise exception 'Ya superó la cantidad máxima permitida de solicitudes abiertas. (Máximo permitido: %). Solicitudes abiertas: %', v_regla_max_sol,v_sol_abiertas;
            END IF;

            if pxp.f_existe_parametro(p_tabla, 'id_funcionarios') then
                v_id_funcionarios = string_to_array(v_parametros.id_funcionarios, ',');
            end if;

            --Sentencia de la insercion
            INSERT INTO cd.tcuenta_doc(id_tipo_cuenta_doc,
                                       id_proceso_wf,
                                       nombre_cheque,
                                       id_uo,
                                       id_funcionario,
                                       tipo_pago,
                                       id_depto,
                                       nro_tramite,
                                       motivo,
                                       fecha,
                                       id_moneda,
                                       estado,
                                       estado_reg,
                                       id_estado_wf,
                                       id_usuario_ai,
                                       usuario_ai,
                                       fecha_reg,
                                       id_usuario_reg,
                                       fecha_mod,
                                       id_usuario_mod,
                                       id_funcionario_gerente,
                                       importe,
                                       id_funcionario_cuenta_bancaria,
                                       id_gestion,
                                       fecha_salida,
                                       fecha_llegada,
                                       tipo_viaje,
                                       medio_transporte,
                                       cobertura,
                                       id_escala,
                                       id_centro_costo,
                                       id_caja,
                                       id_plantilla,
                                       tipo_contrato,
                                       cantidad_personas,
                                       aplicar_regla_15,
                                       id_funcionarios --#8
            )
            VALUES (v_parametros.id_tipo_cuenta_doc,
                    v_id_proceso_wf,
                    v_parametros.nombre_cheque,
                    v_id_uo,
                    v_parametros.id_funcionario,
                    v_parametros.tipo_pago,
                    v_parametros.id_depto,
                    v_num_tramite,
                    v_parametros.motivo,
                    v_parametros.fecha,
                    v_parametros.id_moneda,
                    v_codigo_estado,
                    'activo',
                    v_id_estado_wf,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    now(),
                    p_id_usuario,
                    null,
                    null,
                    va_id_funcionario_gerente[1],
                    v_parametros.importe,
                    v_parametros.id_funcionario_cuenta_bancaria,
                    v_id_gestion,
                    v_parametros.fecha_salida,
                    v_parametros.fecha_llegada,
                    v_parametros.tipo_viaje,
                    v_parametros.medio_transporte,
                    v_parametros.cobertura,
                    v_id_escala,
                    v_parametros.id_centro_costo,
                    v_parametros.id_caja,
                    v_id_plantilla,
                    v_parametros.tipo_contrato,
                    coalesce(v_parametros.cantidad_personas, 1),
                    coalesce(v_parametros.aplicar_regla_15, 'si'),
                    v_id_funcionarios --#8
                   )
            RETURNING id_cuenta_doc INTO v_id_cuenta_doc;

            --Inserta documentos en estado borrador si estan configurados
            v_resp_doc = wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
            --Verificar documentos
            v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Cuenta Documentada almacenado(a) con exito (id_cuenta_doc' ||
                                        v_id_cuenta_doc || ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
      #TRANSACCION:  'CD_LIMREN_INS'
      #DESCRIPCION:   Registra alertas por limite de fecha en dias de rendicion
      #AUTOR:   Gonzalo Sarmiento
      #FECHA:   07-02-2017
      ***********************************/

    ELSEIF (p_transaccion = 'CD_LIMREN_INS') then

        begin

            -- seleccionar los fondos en avanccr que requieren alerta
            FOR v_registros in (
                with fondos_entregados as (
                    select ((cdoc.fecha_entrega::date - (now()::date))::integer +
                            pxp.f_get_variable_global('cd_dias_entrega')::integer + pxp.f_get_weekend_days
                                (cdoc.fecha_entrega::date, now()::date))::integer as dias_para_rendir,
                           cdoc.nro_tramite,
                           cdoc.id_funcionario,
                           sol.desc_funcionario1,
                           sol.email_empresa,
                           cdoc.importe,
                           cdoc.motivo,
                           cdoc.id_usuario_reg
                    from cd.tcuenta_doc cdoc
                             inner join cd.ttipo_cuenta_doc tcdoc on tcdoc.id_tipo_cuenta_doc =
                                                                     cdoc.id_tipo_cuenta_doc
                             inner join orga.vfuncionario_persona sol on sol.id_funcionario =
                                                                         cdoc.id_funcionario
                             inner join orga.vfuncionario_persona sup on sup.id_funcionario =
                                                                         cdoc.id_funcionario_aprobador
                    where tcdoc.codigo = 'SOLFONAVA'
                      and cdoc.estado in ('contabilizado'))
                select *
                from fondos_entregados
                where dias_para_rendir = pxp.f_get_variable_global('cd_alerta_dias_finalizar_rendicion')::integer)
                LOOP
                ----------------------------
                -- arma template de correo
                -----------------------------


                    v_asunto = 'Fondos con Cargo a Rendición de Cuentas :  ' || v_registros.nro_tramite;
                    v_destinatorio = '<br>Estimad@';
                    v_template = '<br>
                        <br>A la fecha esta por cumplirse el plazo previsto para realizar sus rendiciones,
                              <br>aun cuenta con 2 dias para realizar sus rendiciones, el monto a rendir es  ' ||
                                 v_registros.importe || ' Bs.
                              <br>del Fondos con Cargo a Rendicion de Cuentas con numero de tramite <b>' ||
                                 v_registros.nro_tramite || '
                              <br>solicitado con el motivo ' || v_registros.motivo || '</b>
                              <br>
                              <br>Es obligatorio realizar sus rendiciones antes del plazo establecido segun la normativa de Tesoreria.
                              <br>
                              <br> Atentamente
                              <br> &nbsp;&nbsp;&nbsp;Control de limite de rendiciones de Fondos en Avance del Sistema ERP BOA';

                    v_titulo = 'Recordatorio de rendicion Fondos con Cargo a Rendicion de Cuentas';

                    v_parametros_ad = '{}';

                    -- inserta registros de alarmas par ael usario que creo la obligacion
                    v_id_alarma[1] := param.f_inserta_alarma(v_registros.id_funcionario,
                                                             v_destinatorio || v_template, --descripcion alarmce
                                                             COALESCE(v_acceso_directo, ''),--acceso directo
                                                             now()::date,
                                                             'notificacion',
                                                             '', -->
                                                             p_id_usuario,
                                                             v_clase,
                                                             v_titulo,--titulo
                                                             COALESCE(v_parametros_ad, ''),
                                                             null::integer, --destino de la alarma
                                                             v_asunto,
                                                             v_registros.email_empresa);

                END LOOP;

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_CDOC_MOD'
        #DESCRIPCION: Modificacion de registros
        #AUTOR:   admin
        #FECHA:   05-05-2016 16:41:21
        ***********************************/

    elsif (p_transaccion = 'CD_CDOC_MOD') then

        begin

            IF exists(select 1
                      from orga.tuo_funcionario uof
                               inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = 'activo'
                               inner join orga.tnivel_organizacional no
                                          on no.id_nivel_organizacional = uo.id_nivel_organizacional and
                                             no.numero_nivel in (1)
                      where uof.estado_reg = 'activo'
                        and uof.id_funcionario = v_parametros.id_funcionario) THEN

                va_id_funcionario_gerente[1] = v_parametros.id_funcionario;

            ELSE
                --si tiene funcionario identificar el gerente correspondientes
                IF v_parametros.id_funcionario is not NULL THEN

                    SELECT pxp.aggarray(id_funcionario)
                    into
                        va_id_funcionario_gerente
                    FROM orga.f_get_aprobadores_x_funcionario(v_parametros.fecha, v_parametros.id_funcionario, 'todos',
                                                              'si', 'todos', 'ninguno') AS (id_funcionario integer);
                    --NOTA el valor en la primera posicion del array es el genre de menor nivel
                END IF;
            END IF;

            -- recupera la uo gerencia del funcionario
            v_id_uo = orga.f_get_uo_gerencia_ope(NULL, v_parametros.id_funcionario, v_parametros.fecha::Date);

            select per.id_gestion
            into
                v_id_gestion
            from param.tperiodo per
            where per.fecha_ini <= v_parametros.fecha
              and per.fecha_fin >= v_parametros.fecha
            limit 1 offset 0;

            --Obtención del tipo de cuenta documentada
            select codigo
            into v_codigo_tipo_cuenta_doc
            from cd.ttipo_cuenta_doc
            where id_tipo_cuenta_doc = v_parametros.id_tipo_cuenta_doc;

            --Obtiene la Escala vigente
            if v_codigo_tipo_cuenta_doc = 'SOLFONAVA' then
                v_id_escala = cd.f_get_escala('fondo_avance', v_parametros.fecha);
            elsif v_codigo_tipo_cuenta_doc = 'SOLVIA' then
                v_id_escala = cd.f_get_escala('viatico', v_parametros.fecha);
            end if;

            if pxp.f_existe_parametro(p_tabla, 'id_plantilla') then
                v_id_plantilla = v_parametros.id_plantilla;
            end if;

            --#2 Inicio
            --Verifica que no esté modificando la gestión de la fecha de la solicitud
            select id_gestion, fecha
            into v_registros
            from cd.tcuenta_doc
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            if v_registros.id_gestion <> v_id_gestion then
                raise exception 'La solicitud fue creada en la gestión % y no puede cambiarse a la gestión % debido a que el Nro. de trámite se generó para la gestión original. Si necesita cambiar de gestión, tendrá que eliminar esta solicitud y crear otra', to_char(v_registros.fecha, 'yyyy'),to_char(v_parametros.fecha, 'yyyy');
            end if;
            --#2 Fin

            if pxp.f_existe_parametro(p_tabla, 'id_funcionarios') then
                if (v_parametros.id_funcionarios != '{}')then
                    v_id_funcionarios = string_to_array(v_parametros.id_funcionarios, ',');
                end if;
            end if;

            --Sentencia de la modificacion
            update cd.tcuenta_doc
            set nombre_cheque                  = v_parametros.nombre_cheque,
                id_funcionario                 = v_parametros.id_funcionario,
                tipo_pago                      = v_parametros.tipo_pago,
                id_depto                       = v_parametros.id_depto,
                motivo                         = v_parametros.motivo,
                fecha                          = v_parametros.fecha,
                id_moneda                      = v_parametros.id_moneda,
                fecha_mod                      = now(),
                id_usuario_mod                 = p_id_usuario,
                id_usuario_ai                  = v_parametros._id_usuario_ai,
                usuario_ai                     = v_parametros._nombre_usuario_ai,
                importe                        = v_parametros.importe,
                id_funcionario_cuenta_bancaria = v_parametros.id_funcionario_cuenta_bancaria,
                id_funcionario_gerente         = va_id_funcionario_gerente[1],
                id_uo                          = v_id_uo,
                id_gestion                     = v_id_gestion,
                fecha_salida                   = v_parametros.fecha_salida,
                fecha_llegada                  = v_parametros.fecha_llegada,
                tipo_viaje                     = v_parametros.tipo_viaje,
                medio_transporte               = v_parametros.medio_transporte,
                cobertura                      = v_parametros.cobertura,
                id_escala                      = v_id_escala,
                id_centro_costo                = v_parametros.id_centro_costo,
                id_caja                        = v_parametros.id_caja,
                id_plantilla                   = v_id_plantilla,
                tipo_contrato                  = v_parametros.tipo_contrato,
                cantidad_personas              = coalesce(v_parametros.cantidad_personas, 1),
                aplicar_regla_15               = coalesce(v_parametros.aplicar_regla_15, 'si'),
                id_funcionarios                = v_id_funcionarios --#8
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Cálculo del viático
            if v_codigo_tipo_cuenta_doc = 'SOLVIA' then
                v_resp1 = cd.f_viatico_calcular(p_id_usuario, v_parametros._id_usuario_ai,
                                                v_parametros._nombre_usuario_ai, v_parametros.id_cuenta_doc);
                --Registro del total de Viático con su conepto de gasto, excepto cuando es una rendicion
                v_resp1 = cd.f_viatico_registrar_concepto_gasto(p_id_usuario, v_parametros._id_usuario_ai,
                                                                v_parametros._nombre_usuario_ai,
                                                                v_parametros.id_cuenta_doc);
            end if;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Cuenta Documentada modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_CDOC_ELI'
        #DESCRIPCION: Eliminacion de registros
        #AUTOR:   admin
        #FECHA:   05-05-2016 16:41:21
        ***********************************/

    elsif (p_transaccion = 'CD_CDOC_ELI') then

        begin

            select c.id_cuenta_doc,
                   c.estado
            into
                v_registros_cd
            from cd.tcuenta_doc c
            where id_cuenta_doc = v_parametros.id_cuenta_doc;


            IF v_registros_cd.estado != 'borrador' THEN
                raise exception 'Solo puede eliminar regitros en borrador';
            END IF;

            --Sentencia de la modificacion
            update cd.tcuenta_doc
            set estado_reg = 'inactivo'
            where id_cuenta_doc = v_parametros.id_cuenta_doc;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Cuenta Documentada inactivada(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_SIGESCD_IME'
        #DESCRIPCION:  cambia al siguiente estado
        #AUTOR:   RAC
        #FECHA:   16-05-2016 12:12:51
        ***********************************/

    elseif (p_transaccion = 'CD_SIGESCD_IME') then

        begin

            /*   PARAMETROS

           $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
           $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
           $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
           $this->setParametro('id_depto_wf','id_depto_wf','int4');
           $this->setParametro('obs','obs','text');
           $this->setParametro('json_procesos','json_procesos','text');
           */

            --Obtenermos datos basicos
            select c.id_proceso_wf,
                   c.id_estado_wf,
                   c.estado,
                   c.tipo_pago,
                   c.id_caja,
                   c.tipo_contrato
            into
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado,
                v_tipo_pago,
                v_id_caja,
                v_tipo_contrato
            from cd.tcuenta_doc c
            where c.id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Recupera datos del estado
            select ew.id_tipo_estado,
                   te.codigo
            into
                v_id_tipo_estado,
                v_codigo_estado
            from wf.testado_wf ew
                     inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
            where ew.id_estado_wf = v_parametros.id_estado_wf_act;


            --Obtener datos tipo estado
            select te.codigo
            into v_codigo_estado_siguiente
            from wf.ttipo_estado te
            where te.id_tipo_estado = v_parametros.id_tipo_estado;

            IF pxp.f_existe_parametro(p_tabla, 'id_depto_wf') THEN
                v_id_depto = v_parametros.id_depto_wf;
            END IF;

            IF pxp.f_existe_parametro(p_tabla, 'obs') THEN
                v_obs = v_parametros.obs;
            ELSE
                v_obs = '---';
            END IF;

            IF v_codigo_estado_siguiente in ('vbgerencia', 'vbgaf') THEN

                --Verifica que si la cuenta documentada va por caja no exceda el maximo de la caja
                if v_tipo_pago = 'caja' then
                    --Obtención del total del importe
                    select o_total
                    into v_importe_total
                    from cd.f_get_total_cuenta_doc_sol(v_parametros.id_cuenta_doc, 'si');

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
                    where id_caja = v_id_caja;

                    if v_importe_maximo_caja < v_importe_total then
                        raise exception 'El importe solicitado (%) supera al máximo permitido en la caja seleccionada (%)',v_importe_total, v_importe_maximo_caja;
                    end if;

                end if;

                UPDATE cd.tcuenta_doc
                SET id_funcionario_aprobador = v_parametros.id_funcionario_wf
                WHERE id_cuenta_doc = v_parametros.id_cuenta_doc;

                --RCM 26/10/2017: Verificación de Viático
                select tcdo.codigo
                into v_codigo_tipo_cuenta_doc
                from cd.tcuenta_doc cdo
                         inner join cd.ttipo_cuenta_doc tcdo
                                    on tcdo.id_tipo_cuenta_doc = cdo.id_tipo_cuenta_doc
                where cdo.id_cuenta_doc = v_parametros.id_cuenta_doc;

                if v_codigo_tipo_cuenta_doc = 'SOLVIA' then
                    --Debe tener registrado el Itinerario
                    if not exists(select 1
                                  from cd.tcuenta_doc_itinerario
                                  where id_cuenta_doc = v_parametros.id_cuenta_doc) then
                        raise exception 'Debe registrar el Itinerario del viaje.';
                    end if;

                    --Verificación del prorrateo
                    select sum(prorrateo)
                    into v_total_prorrateo
                    from cd.tcuenta_doc_prorrateo
                    where id_cuenta_doc = v_parametros.id_cuenta_doc;

                    if v_total_prorrateo > 1 then
                        raise exception 'El prorrateo supera a 1 (prorrateo = %). Corrija y vuelva a interntarlo',v_total_prorrateo;
                    elsif v_total_prorrateo < 1 then
                        raise exception 'El prorrateo es inferior a 1 (prorrateo = %). Corrija y vuelva a intentarlo',v_total_prorrateo;
                    end if;


                    if v_tipo_contrato = 'planta_obra_determinada' then
                        v_cod_concepto_ingas = 'CONGAS_VIA_PLA';
                    elsif v_tipo_contrato = 'servicio' then
                        v_cod_concepto_ingas = 'CONGAS_VIA_SER';
                    else
                        raise exception 'No se ha definido el Tipo de contrato del solicitante';
                    end if;

                    --Verifica que tenga registrado al menos el concepto de gasto de viático
                    select escr.id_concepto_ingas
                    into v_id_concepto_ingas
                    from cd.tcuenta_doc cd
                             left join cd.tescala_regla escr
                                       on escr.id_escala = cd.id_escala
                    where cd.id_cuenta_doc = v_parametros.id_cuenta_doc
                      and escr.codigo = v_cod_concepto_ingas;

                    --Si no existe en la escala despliega el error
                    if v_id_concepto_ingas is null then
                        raise exception 'No se encuenta definido el Concepto de Gasto para la escala de la solicitud. Comuníquese con el Administrador';
                    end if;

                    v_permitir_mod = pxp.f_get_variable_global('cd_permitir_modificar_monto_sol');

                    if v_permitir_mod = 'no' then
                        --Verifica que tenga registrado al menos el concepto de gasto de viático
                        if not exists(select 1
                                      from cd.tcuenta_doc_det
                                      where id_cuenta_doc = v_parametros.id_cuenta_doc
                                        and id_concepto_ingas = v_id_concepto_ingas) then
                            raise exception 'Debe registrar el presupuesto para el Concepto de gasto de viáticos';
                        end if;
                    end if;


                end if;

            END IF;

            ---------------------------------------
            -- REGISTRA EL SIGUIENTE ESTADO DEL WF
            ---------------------------------------
            --Configurar acceso directo para la alarma
            v_acceso_directo = '';
            v_clase = '';
            v_parametros_ad = '';
            v_tipo_noti = 'notificacion';
            v_titulo = 'Visto Bueno';

            IF v_codigo_estado_siguiente not in ('borrador', 'finalizado', 'anulado') THEN
                v_acceso_directo = '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVb.php';
                v_clase = 'CuentaDocVb';
                v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf",valor:"' || v_id_proceso_wf::varchar ||
                                  '"}}';
                v_tipo_noti = 'notificacion';
                v_titulo = 'Visto Bueno';
            END IF;

            v_id_estado_actual = wf.f_registra_estado_wf(v_parametros.id_tipo_estado,
                                                         v_parametros.id_funcionario_wf,
                                                         v_parametros.id_estado_wf_act,
                                                         v_id_proceso_wf,
                                                         p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_id_depto, --depto del estado anterior
                                                         v_obs,
                                                         v_acceso_directo,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);

            --------------------------------------
            -- Registra los procesos disparados
            --------------------------------------
            FOR v_registros_proc in (select *
                                     from json_populate_recordset(null::wf.proceso_disparado_wf,
                                                                  v_parametros.json_procesos::json))
                LOOP

                    --Get codigo tipo proceso
                    select tp.codigo
                    into v_codigo_tipo_pro
                    from wf.ttipo_proceso tp
                    where tp.id_tipo_proceso = v_registros_proc.id_tipo_proceso_pro;

                    --Disparar creacion de procesos seleccionados
                    SELECT ps_id_proceso_wf,
                           ps_id_estado_wf,
                           ps_codigo_estado
                    into
                        v_id_proceso_wf,
                        v_id_estado_wf,
                        v_codigo_estado
                    FROM wf.f_registra_proceso_disparado_wf(
                            p_id_usuario,
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            v_id_estado_actual,
                            v_registros_proc.id_funcionario_wf_pro,
                            v_registros_proc.id_depto_wf_pro,
                            v_registros_proc.obs_pro,
                            v_codigo_tipo_pro,
                            v_codigo_tipo_pro);
                END LOOP;

            IF pxp.f_existe_parametro(p_tabla, 'id_cuenta_bancaria') THEN
                v_id_cuenta_bancaria = v_parametros.id_cuenta_bancaria;
            END IF;

            IF pxp.f_existe_parametro(p_tabla, 'id_depto_lb') THEN
                v_id_depto_lb = v_parametros.id_depto_lb;
            END IF;

            IF pxp.f_existe_parametro(p_tabla, 'id_depto_conta') THEN
                v_id_depto_conta = v_parametros.id_depto_conta;
            END IF;

            IF pxp.f_existe_parametro(p_tabla, 'id_cuenta_bancaria_mov') THEN
                v_id_cuenta_bancaria_mov = v_parametros.id_cuenta_bancaria_mov;
            END IF;


            --------------------------------------------------
            --  ACTUALIZA EL NUEVO ESTADO DE LA CUENTA DOCUMENTADA
            ----------------------------------------------------
/*if v_parametros.id_cuenta_doc = 6039 then
    raise exception 'En revision ... ... %',v_id_proceso_wf;
end if;*/
            IF cd.f_fun_inicio_cuenta_doc_wf(p_id_usuario,
                                             v_parametros._id_usuario_ai,
                                             v_parametros._nombre_usuario_ai,
                                             v_id_estado_actual,
                                             v_id_proceso_wf,
                                             v_codigo_estado_siguiente,
                                             v_id_depto_lb,
                                             v_id_cuenta_bancaria,
                                             v_id_depto_conta,
                                             v_codigo_estado,
                                             v_id_cuenta_bancaria_mov
                ) THEN

            END IF;

            --Respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Se realizo el cambio de estado del cuenta documentada id=' ||
                                        v_parametros.id_cuenta_doc);
            v_resp = pxp.f_agrega_clave(v_resp, 'operacion', 'cambio_exitoso');

            --Devuelve la respuesta
            return v_resp;

        end;


        /*********************************
        #TRANSACCION:  'CD_ANTECD_IME'
        #DESCRIPCION: retrocede el estado de la cuenta documentada
        #AUTOR:   RAC
        #FECHA:   16-05-2016 12:12:51
        ***********************************/

    elseif (p_transaccion = 'CD_ANTECD_IME') then
        begin

            v_operacion = 'anterior';

            IF pxp.f_existe_parametro(p_tabla, 'estado_destino') THEN
                v_operacion = v_parametros.estado_destino;
            END IF;


            --obtenermos datos basicos
            select c.id_cuenta_doc,
                   c.id_proceso_wf,
                   c.estado,
                   pwf.id_tipo_proceso
            into
                v_registros_cd

            from cd.tcuenta_doc c
                     inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = c.id_proceso_wf
            where c.id_proceso_wf = v_parametros.id_proceso_wf;


            IF v_registros_cd.estado = 'aprobado' THEN
                raise exception 'El presupuesto ya se encuentra aprobado, solo puede modificar a traves de la interface de ajustes presupuestarios';
            END IF;


            v_id_proceso_wf = v_registros_cd.id_proceso_wf;

            IF v_operacion = 'anterior' THEN
                --------------------------------------------------
                --Retrocede al estado inmediatamente anterior
                -------------------------------------------------
                --recuperaq estado anterior segun Log del WF
                SELECT ps_id_tipo_estado,
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
                FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);


            ELSE
                --recupera el estado inicial
                -- recuperamos el estado inicial segun tipo_proceso

                SELECT ps_id_tipo_estado,
                       ps_codigo_estado
                into
                    v_id_tipo_estado,
                    v_codigo_estado
                FROM wf.f_obtener_tipo_estado_inicial_del_tipo_proceso(v_registros_cd.id_tipo_proceso);


                --busca en log e estado de wf que identificamos como el inicial
                SELECT ps_id_funcionario,
                       ps_id_depto
                into
                    v_id_funcionario,
                    v_id_depto
                FROM wf.f_obtener_estado_segun_log_wf(v_id_estado_wf, v_id_tipo_estado);


            END IF;


            --configurar acceso directo para la alarma
            v_acceso_directo = '';
            v_clase = '';
            v_parametros_ad = '';
            v_tipo_noti = 'notificacion';
            v_titulo = 'Visto Bueno';


            IF v_codigo_estado_siguiente not in ('borrador', 'finalizado', 'anulado') THEN
                v_acceso_directo = '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVb.php';
                v_clase = 'CuentaDocVb';
                v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf",valor:"' || v_id_proceso_wf::varchar ||
                                  '"}}';
                v_tipo_noti = 'notificacion';
                v_titulo = 'Visto Bueno';

            END IF;


            -- registra nuevo estado

            v_id_estado_actual = wf.f_registra_estado_wf(
                    v_id_tipo_estado, --  id_tipo_estado al que retrocede
                    v_id_funcionario, --  funcionario del estado anterior
                    v_parametros.id_estado_wf, --  estado actual ...
                    v_id_proceso_wf, --  id del proceso actual
                    p_id_usuario, -- usuario que registra
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    v_id_depto, --depto del estado anterior
                    '[RETROCESO] ' || v_parametros.obs,
                    v_acceso_directo,
                    v_clase,
                    v_parametros_ad,
                    v_tipo_noti,
                    v_titulo);

            IF not cd.f_fun_regreso_cuenta_doc_wf(p_id_usuario,
                                                  v_parametros._id_usuario_ai,
                                                  v_parametros._nombre_usuario_ai,
                                                  v_id_estado_actual,
                                                  v_parametros.id_proceso_wf,
                                                  v_codigo_estado) THEN

                raise exception 'Error al retroceder estado';

            END IF;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Se realizo el cambio de estado de la cuenta documentada)');
            v_resp = pxp.f_agrega_clave(v_resp, 'operacion', 'cambio_exitoso');


            --Devuelve la respuesta
            return v_resp;


        end;


        /*********************************
      #TRANSACCION:  'CD_CDOCREN_INS'
      #DESCRIPCION: Insercion de registros de  rendicon para  fondos en avance
      #AUTOR:   admin
      #FECHA:   05-05-2016 16:41:21
      ***********************************/

    elseif (p_transaccion = 'CD_CDOCREN_INS') then

        begin

            --Obtiene variable global para permitir o no rendiciones múltiples en un mes
            v_solo_una_rendicion_mes = pxp.f_get_variable_global('cd_solo_una_rendicion_mes');

            --Recuperar datos de la solicitud
            select c.id_estado_wf,
                   c.id_proceso_wf,
                   c.estado,
                   c.id_funcionario,
                   c.id_depto,
                   c.id_depto_conta,
                   c.id_depto_lb,
                   c.id_moneda,
                   c.id_uo,
                   c.id_funcionario_gerente,
                   c.nro_tramite,
                   c.id_gestion,
                   c.importe,
                   c.id_escala,
                   c.tipo_contrato,
                   c.cantidad_personas,
                   c.aplicar_regla_15,
                   c.tipo_pago,
                   c.fecha
            into
                v_registros_cd
            from cd.tcuenta_doc c
            where c.id_cuenta_doc = v_parametros.id_cuenta_doc_fk;

            /*
            --validamos que el total de importes a rendir no sobrepase el total de importe solicitado

            select
              sum(dcr.importe)
            into
              v_importe_rendicion
            from cd.tcuenta_doc dcr
            where  dcr.estado_reg = 'activo'  and
                   dcr.estado != 'anulado' and
                   dcr.id_cuenta_doc_fk = v_parametros.id_cuenta_doc_fk;

            IF COALESCE(v_importe_rendicion,0) + v_parametros.importe >  v_registros_cd.importe THEN
              raise exception 'el importe a rendir no puede ser mayor que el importe solicitado %. (Revise las otras rendiciones registradas %)'  ,v_registros_cd.importe,(v_importe_rendicion,0);
            END IF;*/


            -----------------------------------
            -- dispara el proceso de rendicion
            ----------------------------------

            SELECT ps_id_proceso_wf,
                   ps_id_estado_wf,
                   ps_codigo_estado
            into
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado
            FROM wf.f_registra_proceso_disparado_wf(
                    p_id_usuario,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    v_registros_cd.id_estado_wf,
                    v_registros_cd.id_funcionario,
                    v_registros_cd.id_depto,
                    'Rendición de Cuentas',
                    '', '');


            -- recuperar el tipo de cuenta doc para rendiciones

            select tcd.id_tipo_cuenta_doc,
                   tp.codigo,
                   tcd.codigo as codigo_tipo_cuenta_doc
            into
                v_id_tipo_cuenta_doc,
                v_codigo_tp,
                v_codigo_tipo_cuenta_doc
            from wf.tproceso_wf pwf
                     inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                     inner join cd.ttipo_cuenta_doc tcd on tcd.codigo_wf = tp.codigo
            where pwf.id_proceso_wf = v_id_proceso_wf;

            IF v_id_tipo_cuenta_doc is null THEN
                raise exception 'No se encontro un tipo de cuenta doc para el proceso de WF %', v_codigo_tp;
            END IF;

            select per.id_gestion
            into
                v_id_gestion
            from param.tperiodo per
            where per.fecha_ini <= v_parametros.fecha
              and per.fecha_fin >= v_parametros.fecha
            limit 1 offset 0;


            IF v_id_tipo_cuenta_doc is null THEN
                raise exception 'No se encontro una gestión para la fecha  %', v_parametros.fecha;
            END IF;

            --validamos que es la unica rendicion del periodo
            SELECT per.fecha_ini, per.fecha_fin
            into v_fecha_ini, v_fecha_fin
            FROM cd.tcuenta_doc cd
                     INNER JOIN param.tperiodo per on per.id_periodo = cd.id_periodo
            WHERE cd.id_cuenta_doc_fk = v_parametros.id_cuenta_doc_fk
              AND cd.id_periodo = v_parametros.id_periodo
              AND cd.estado_reg = 'activo';

            if v_solo_una_rendicion_mes = 'si' then
                IF v_fecha_ini IS NOT NULL and v_fecha_fin IS NOT NULL THEN
                    raise exception 'Ya se registro una rendicion parcial para el rango de fechas %  %', v_fecha_ini, v_fecha_fin;
                END IF;
            end if;

            --contamos la cantidad rendciones para la misma solicitud
            select count(c.id_cuenta_doc)
            into
                v_num_rend
            from cd.tcuenta_doc c
            where c.id_cuenta_doc_fk = v_parametros.id_cuenta_doc_fk;

            v_num_rend = COALESCE(v_num_rend, 0) + 1;

            --Obtencion del depto de conta
            v_id_depto_conta = v_registros_cd.id_depto_conta;
            if v_registros_cd.id_depto_conta is null then
                select dede.id_depto_destino
                into v_id_depto_conta
                from param.tdepto_depto dede
                         inner join param.tdepto ddes on ddes.id_depto = dede.id_depto_destino
                         inner join segu.tsubsistema sdes on sdes.id_subsistema = ddes.id_subsistema
                where dede.id_depto_origen = v_registros_cd.id_depto
                  and sdes.codigo = 'CONTA';
            end if;

            --Verifica si existe plantilla para la rendicion
            if pxp.f_existe_parametro(p_tabla, 'id_plantilla') then
                v_id_plantilla = v_parametros.id_plantilla;
            end if;

            --Validacion para no permitir mas de una rendicion en borrador
            if exists(select 1
                      from cd.tcuenta_doc
                      where id_cuenta_doc_fk = v_parametros.id_cuenta_doc_fk
                        and estado not in ('rendido', 'anulado')) then
                raise exception 'No es posible registrar la rendición porque tiene una rendición pendiente';
            end if;


            --Sentencia de la insercion
            insert into cd.tcuenta_doc(id_tipo_cuenta_doc,
                                       id_proceso_wf,
                                       id_uo,
                                       id_funcionario,
                                       id_depto,
                                       id_depto_conta,
                                       id_depto_lb,
                                       nro_tramite,
                                       fecha,
                                       id_moneda,
                                       estado,
                                       estado_reg,
                                       id_estado_wf,
                                       id_usuario_ai,
                                       usuario_ai,
                                       fecha_reg,
                                       id_usuario_reg,
                                       id_funcionario_gerente,
                                       id_gestion,
                                       id_cuenta_doc_fk,
                                       motivo,
                                       nro_correspondencia,
                                       num_rendicion,
                                       id_periodo,
                                       fecha_salida,
                                       hora_salida,
                                       fecha_llegada,
                                       hora_llegada,
                                       cobertura,
                                       id_escala,
                                       id_plantilla,
                                       tipo_contrato,
                                       cantidad_personas,
                                       tipo_rendicion,
                                       aplicar_regla_15,
                                       tipo_pago)
            values (v_id_tipo_cuenta_doc,
                    v_id_proceso_wf,
                    v_registros_cd.id_uo,
                    v_registros_cd.id_funcionario,
                    v_registros_cd.id_depto,
                    v_id_depto_conta,
                    v_registros_cd.id_depto_lb,
                    v_registros_cd.nro_tramite,
                    v_parametros.fecha,
                    v_registros_cd.id_moneda,
                    v_codigo_estado,
                    'activo',
                    v_id_estado_wf,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    now(),
                    p_id_usuario,
                    v_registros_cd.id_funcionario_gerente,
                    v_id_gestion,
                    v_parametros.id_cuenta_doc_fk, -- referencia a cuenta de solicitud
                    v_parametros.motivo,
                    v_parametros.nro_correspondencia,
                    'R' || v_num_rend::varchar,
                    v_parametros.id_periodo,
                    v_parametros.fecha_salida,
                    v_parametros.hora_salida::time,
                    v_parametros.fecha_llegada,
                    v_parametros.hora_llegada::time,
                    v_parametros.cobertura,
                    v_registros_cd.id_escala,
                    v_id_plantilla,
                    v_registros_cd.tipo_contrato,
                    v_registros_cd.cantidad_personas,
                    v_parametros.tipo_rendicion,
                    v_registros_cd.aplicar_regla_15,
                    v_registros_cd.tipo_pago)
            RETURNING id_cuenta_doc into v_id_cuenta_doc;

            ----------------------------------------------------------
            --Replica el prorrateo de la solicitud (usado en viaticos)
            ----------------------------------------------------------
            if v_registros_cd.id_gestion <> v_id_gestion then
                --Valida que existan las equivalencias de CC en la gestión de la rendición
                if exists(select 1
                          from cd.tcuenta_doc_prorrateo cp
                                   inner join param.tcentro_costo cc
                                              on cc.id_centro_costo = cp.id_centro_costo
                                   inner join param.ttipo_cc tcc
                                              on tcc.id_tipo_cc = cc.id_tipo_cc
                                   left join param.tcentro_costo ccd
                                             on ccd.id_tipo_cc = tcc.id_tipo_cc
                                                 and ccd.id_gestion = v_id_gestion
                          where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk
                            and coalesce(ccd.id_centro_costo, 0) = 0) then

                    --Obtiene los códigos de CC que no tienen la equivalencia
                    select pxp.list(tcc.codigo)::varchar
                    into v_codigos
                    from cd.tcuenta_doc_prorrateo cp
                             inner join param.tcentro_costo cc
                                        on cc.id_centro_costo = cp.id_centro_costo
                             inner join param.ttipo_cc tcc
                                        on tcc.id_tipo_cc = cc.id_tipo_cc
                             left join param.tcentro_costo ccd
                                       on ccd.id_tipo_cc = tcc.id_tipo_cc
                                           and ccd.id_gestion = v_id_gestion
                    where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk
                      and coalesce(ccd.id_centro_costo, 0) = 0;

                    raise exception 'No existen Centro de Costo: %, para la gestión %',v_codigos, to_char(v_parametros.fecha, 'yyyy');
                end if;

                --Hace copia del prorrateo de la solicitud, pero busca los CC equivalentes en la gestión definida en la rendición
                insert into cd.tcuenta_doc_prorrateo(id_usuario_reg, fecha_reg, estado_reg, id_cuenta_doc,
                                                     id_centro_costo, prorrateo)
                select p_id_usuario,
                       now(),
                       'activo',
                       v_id_cuenta_doc,
                       ccd.id_centro_costo,
                       cp.prorrateo
                from cd.tcuenta_doc_prorrateo cp
                         inner join param.tcentro_costo cc
                                    on cc.id_centro_costo = cp.id_centro_costo
                         inner join param.ttipo_cc tcc
                                    on tcc.id_tipo_cc = cc.id_tipo_cc
                         inner join param.tcentro_costo ccd
                                    on ccd.id_tipo_cc = tcc.id_tipo_cc
                                        and ccd.id_gestion = v_id_gestion
                where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk;

            else
                --Replica el prorrateo sin ninguna modificación
                insert into cd.tcuenta_doc_prorrateo(id_usuario_reg, fecha_reg, estado_reg, id_cuenta_doc,
                                                     id_centro_costo, prorrateo)
                select p_id_usuario,
                       now(),
                       'activo',
                       v_id_cuenta_doc,
                       id_centro_costo,
                       prorrateo
                from cd.tcuenta_doc_prorrateo cp
                where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk;
            end if;

            --Replica el destino registrado en la solicitud
            insert into cd.tcuenta_doc_itinerario(id_usuario_reg, fecha_reg, estado_reg, id_cuenta_doc, id_destino,
                                                  cantidad_dias)
            select p_id_usuario,
                   now(),
                   'activo',
                   v_id_cuenta_doc,
                   id_destino,
                   cantidad_dias
            from cd.tcuenta_doc_itinerario
            where id_cuenta_doc = v_parametros.id_cuenta_doc_fk;

            --Cálculo del viático
            if v_codigo_tipo_cuenta_doc in ('SOLVIA', 'RVI') then
                v_resp1 = cd.f_viatico_calcular(p_id_usuario, v_parametros._id_usuario_ai,
                                                v_parametros._nombre_usuario_ai, v_id_cuenta_doc, 'rendicion');
                --Generación automática de documento de rendición de viático
                v_resp1 = cd.f_viatico_registrar_doc_rendicion(p_id_usuario, v_parametros._id_usuario_ai,
                                                               v_parametros._nombre_usuario_ai, v_id_cuenta_doc);

                --Actualizacion del importe total en la cabecera
                v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_id_cuenta_doc);
            end if;

            -- inserta documentos en estado borrador si estan configurados
            v_resp_doc = wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);

            -- verificar documentos
            v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Cuenta de rendicion almacenada con exito (id_cuenta_doc' || v_id_cuenta_doc ||
                                        ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;


        /*********************************
      #TRANSACCION:  'CD_CDOCREN_MOD'
      #DESCRIPCION: Modificacion de rendiciones de FA
      #AUTOR:   rac
      #FECHA:   05-05-2016 16:41:21
      ***********************************/
    elsif (p_transaccion = 'CD_CDOCREN_MOD') then

        begin

            --Obtiene variable global para permitir o no rendiciones múltiples en un mes
            v_solo_una_rendicion_mes = pxp.f_get_variable_global('cd_solo_una_rendicion_mes');

            select per.id_gestion
            into
                v_id_gestion
            from param.tperiodo per
            where per.fecha_ini <= v_parametros.fecha
              and per.fecha_fin >= v_parametros.fecha
            limit 1 offset 0;

            select per.id_periodo, per.periodo
            into v_id_periodo, v_periodo
            from cd.tcuenta_doc cd
                     inner join cd.trendicion_det ren on ren.id_cuenta_doc_rendicion = cd.id_cuenta_doc
                     inner join conta.tdoc_compra_venta doc on doc.id_doc_compra_venta = ren.id_doc_compra_venta
                     inner join param.tperiodo per on per.fecha_ini <= doc.fecha and per.fecha_fin >= doc.fecha
            where cd.id_cuenta_doc = v_parametros.id_cuenta_doc
            limit 1 offset 0;

            IF v_id_periodo != v_parametros.id_periodo THEN
                raise exception 'Ya existen facturas registradas pertenecientes al periodo %, el periodo debe ser registrado como %', pxp.f_obtener_literal_periodo(v_periodo, 0), v_periodo;
            END IF;

            select c.id_estado_wf,
                   c.id_proceso_wf,
                   c.estado,
                   c.id_funcionario,
                   c.id_depto,
                   c.id_depto_conta,
                   c.id_depto_lb,
                   c.id_moneda,
                   c.id_uo,
                   c.id_funcionario_gerente,
                   c.nro_tramite,
                   c.id_gestion,
                   c.importe,
                   cdr.estado   as estado_cdr,
                   tcdoc.codigo as codigo_tipo_cuenta_doc
            into
                v_registros_cd
            from cd.tcuenta_doc c
                     inner join cd.ttipo_cuenta_doc tcdoc on tcdoc.id_tipo_cuenta_doc = c.id_tipo_cuenta_doc
                     inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
            where cdr.id_cuenta_doc = v_parametros.id_cuenta_doc;


            IF v_registros_cd.estado_cdr not in ('borrador', 'vbtesoreria') THEN
                raise exception 'Solo puede modificar facturas en rediciones en borrador o vbtesoreria, (no en  %)',v_registros.estado_cdr;
            END IF;

            /*
           --  validamos que el total de importes a rendir no sobrepase el total de importe solicitado

           select
             sum(dcr.importe)
           into
             v_importe_rendicion
           from cd.tcuenta_doc dcr
           where  dcr.estado_reg = 'activo'  and
                  dcr.estado != 'anulado' and
                  dcr.id_cuenta_doc_fk = v_parametros.id_cuenta_doc_fk and
                  dcr.id_cuenta_doc  != v_parametros.id_cuenta_doc;

           IF COALESCE(v_importe_rendicion,0) + v_parametros.importe >  v_registros_cd.importe THEN
             raise exception 'el importe a rendir no puede ser mayor que el importe solicitado %. (Revise las otras rendiciones registradas %)'  ,v_registros_cd.importe,(v_importe_rendicion,0);
           END IF;*/

            SELECT per.fecha_ini, per.fecha_fin
            into v_fecha_ini, v_fecha_fin
            FROM cd.tcuenta_doc cd
                     INNER JOIN param.tperiodo per on per.id_periodo = cd.id_periodo
            WHERE cd.id_cuenta_doc_fk = v_parametros.id_cuenta_doc_fk
              AND cd.id_periodo = v_parametros.id_periodo
              AND cd.id_cuenta_doc != v_parametros.id_cuenta_doc
              AND cd.estado_reg = 'activo';

            select id_gestion
            into v_id_gestion_sol
            from cd.tcuenta_doc
            where id_cuenta_doc = v_parametros.id_cuenta_doc_fk;

            if v_solo_una_rendicion_mes = 'si' then
                IF v_fecha_ini IS NOT NULL and v_fecha_fin IS NOT NULL THEN
                    raise exception 'Ya se registro una rendicion parcial para el rango de fechas %  %', v_fecha_ini, v_fecha_fin;
                END IF;
            end if;

            --Verifica si existe plantilla para la rendicion
            if pxp.f_existe_parametro(p_tabla, 'id_plantilla') then
                v_id_plantilla = v_parametros.id_plantilla;
            end if;

            --Sentencia de la modificacion
            update cd.tcuenta_doc
            set motivo              = v_parametros.motivo,
                fecha               = v_parametros.fecha,
                nro_correspondencia = v_parametros.nro_correspondencia,
                id_periodo          = v_parametros.id_periodo,
                fecha_salida        = v_parametros.fecha_salida,
                hora_salida         = v_parametros.hora_salida::time,
                fecha_llegada       = v_parametros.fecha_llegada,
                hora_llegada        = v_parametros.hora_llegada::time,
                cobertura           = v_parametros.cobertura,
                id_plantilla        = v_id_plantilla,
                tipo_rendicion      = v_parametros.tipo_rendicion,
                aplicar_regla_15    = coalesce(v_parametros.aplicar_regla_15, 'si')
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            ----------------------------------------------------------
            --Replica el prorrateo de la solicitud (usado en viaticos)
            ----------------------------------------------------------
            delete from cd.tcuenta_doc_prorrateo where id_cuenta_doc = v_parametros.id_cuenta_doc;
            if v_id_gestion_sol <> v_id_gestion then
                --Valida que existan las equivalencias de CC en la gestión de la rendición
                if exists(select 1
                          from cd.tcuenta_doc_prorrateo cp
                                   inner join param.tcentro_costo cc
                                              on cc.id_centro_costo = cp.id_centro_costo
                                   inner join param.ttipo_cc tcc
                                              on tcc.id_tipo_cc = cc.id_tipo_cc
                                   left join param.tcentro_costo ccd
                                             on ccd.id_tipo_cc = tcc.id_tipo_cc
                                                 and ccd.id_gestion = v_id_gestion
                          where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk
                            and coalesce(ccd.id_centro_costo, 0) = 0) then

                    --Obtiene los códigos de CC que no tienen la equivalencia
                    select pxp.list(tcc.codigo)::varchar
                    into v_codigos
                    from cd.tcuenta_doc_prorrateo cp
                             inner join param.tcentro_costo cc
                                        on cc.id_centro_costo = cp.id_centro_costo
                             inner join param.ttipo_cc tcc
                                        on tcc.id_tipo_cc = cc.id_tipo_cc
                             left join param.tcentro_costo ccd
                                       on ccd.id_tipo_cc = tcc.id_tipo_cc
                                           and ccd.id_gestion = v_id_gestion
                    where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk
                      and coalesce(ccd.id_centro_costo, 0) = 0;

                    raise exception 'No existen Centro de Costo: %, para la gestión %',v_codigos, to_char(v_parametros.fecha, 'yyyy');
                end if;

                --Hace copia del prorrateo de la solicitud, pero busca los CC equivalentes en la gestión definida en la rendición
                insert into cd.tcuenta_doc_prorrateo(id_usuario_reg, fecha_reg, estado_reg, id_cuenta_doc,
                                                     id_centro_costo, prorrateo)
                select p_id_usuario,
                       now(),
                       'activo',
                       v_parametros.id_cuenta_doc,
                       ccd.id_centro_costo,
                       cp.prorrateo
                from cd.tcuenta_doc_prorrateo cp
                         inner join param.tcentro_costo cc
                                    on cc.id_centro_costo = cp.id_centro_costo
                         inner join param.ttipo_cc tcc
                                    on tcc.id_tipo_cc = cc.id_tipo_cc
                         inner join param.tcentro_costo ccd
                                    on ccd.id_tipo_cc = tcc.id_tipo_cc
                                        and ccd.id_gestion = v_id_gestion
                where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk;

            else
                --Replica el prorrateo sin ninguna modificación
                insert into cd.tcuenta_doc_prorrateo(id_usuario_reg, fecha_reg, estado_reg, id_cuenta_doc,
                                                     id_centro_costo, prorrateo)
                select p_id_usuario,
                       now(),
                       'activo',
                       v_parametros.id_cuenta_doc,
                       id_centro_costo,
                       prorrateo
                from cd.tcuenta_doc_prorrateo cp
                where cp.id_cuenta_doc = v_parametros.id_cuenta_doc_fk;
            end if;

            --Cálculo del viático
            if v_registros_cd.codigo_tipo_cuenta_doc in ('SOLVIA', 'RVI') then
                v_resp1 = cd.f_viatico_calcular(p_id_usuario, v_parametros._id_usuario_ai,
                                                v_parametros._nombre_usuario_ai, v_parametros.id_cuenta_doc,
                                                'rendicion');
            end if;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Cuenta Documentada rendición  modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;


        /*********************************
      #TRANSACCION:  'CD_CDOCREN_ELI'
      #DESCRIPCION: Eliminacion de de cuento documentada de rendicion
      #AUTOR:   admin
      #FECHA:   05-05-2016 16:41:21
      ***********************************/

    elsif (p_transaccion = 'CD_CDOCREN_ELI') then

        begin

            select c.id_cuenta_doc,
                   c.estado,
                   c.id_proceso_wf,
                   c.id_estado_wf,
                   c.estado,
                   c.estado_reg,
                   c.id_cuenta_doc_fk as id_cuenta_doc_solicitud
            into
                v_registros_cd
            from cd.tcuenta_doc c
            where id_cuenta_doc = v_parametros.id_cuenta_doc;


            IF v_registros_cd.estado != 'borrador' THEN
                raise exception 'Solo puede eliminar registros en borrador';
            END IF;


            select count(rd.id_rendicion_det)
            into v_contador
            from cd.trendicion_det rd
            where rd.id_cuenta_doc_rendicion = v_parametros.id_cuenta_doc;


            -- contar depositos
            select count(lb.id_libro_bancos)
            into
                v_contador_libro_bancos
            from tes.tts_libro_bancos lb
                     inner join cd.tcuenta_doc c
                                on c.id_cuenta_doc = lb.columna_pk_valor
                                    and lb.columna_pk = 'id_cuenta_doc'
                                    and lb.tabla = 'cd.tcuenta_doc'
            where c.id_cuenta_doc = v_parametros.id_cuenta_doc
              and lb.estado_reg = 'activo'
              and lb.estado != 'anulado';


            IF COALESCE(v_contador, 0) != 0 or COALESCE(v_contador_libro_bancos, 0) != 0 THEN
                raise exception 'Elimine primero las facturas y depositos registrados';
            END IF;


            ---------------------------------
            --   Anulacion de la rendicion
            ----------------------------------


            select te.id_tipo_estado
            into
                v_id_tipo_estado
            from wf.tproceso_wf pw
                     inner join wf.ttipo_proceso tp on pw.id_tipo_proceso = tp.id_tipo_proceso
                     inner join wf.ttipo_estado te on te.id_tipo_proceso = tp.id_tipo_proceso and te.codigo = 'anulado'
            where pw.id_proceso_wf = v_registros_cd.id_proceso_wf;


            IF v_id_tipo_estado is NULL THEN
                raise exception 'No se parametrizo el estado "anulado" para la rendición';
            END IF;

            select f.id_funcionario
            into v_id_funcionario
            from segu.tusuario u
                     inner join orga.tfuncionario f on f.id_persona = u.id_persona
            where u.id_usuario = p_id_usuario;

            IF p_administrador != 1 THEN
                IF v_id_funcionario is null THEN
                    raise exception 'El usuario no tiene un funcionario';
                END IF;
            END IF;


            v_id_estado_actual = wf.f_registra_estado_wf(v_id_tipo_estado,
                                                         v_id_funcionario,
                                                         v_registros_cd.id_estado_wf,
                                                         v_registros_cd.id_proceso_wf,
                                                         p_id_usuario,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         'Anulacion de la rendición');


            -- Sentencia de la modificacion
            update cd.tcuenta_doc
            set estado_reg   = 'inactivo',
                id_estado_wf = v_registros_cd.id_estado_wf,
                estado       = 'anulado'
            where id_cuenta_doc = v_parametros.id_cuenta_doc;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Cuenta Documentada inactivada');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;


        /*********************************
     #TRANSACCION:  'CD_AMPCDREN_IME'
     #DESCRIPCION: Ampliar dias para rendir cuenta documentada
     #AUTOR:   rac
     #FECHA:   05-05-2016 16:41:21
     ***********************************/
    elsif (p_transaccion = 'CD_AMPCDREN_IME') then

        begin

            --raise exception '%',v_parametros.dias_ampliado::varchar;
            v_temp = v_parametros.dias_ampliado::varchar || ' days';

            --Sentencia de la modificacion
            update cd.tcuenta_doc
            set fecha_entrega  = (fecha_entrega::Date + v_temp)::date,
                id_usuario_mod = p_id_usuario,
                fecha_mod      = now()
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Dias de rendicion ampliados)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
     #TRANSACCION:  'CD_CAMBLOQ_IME'
     #DESCRIPCION: cambia el estado de bloqueo de facturas grandes
     #AUTOR:   admin
     #FECHA:   17-05-2016 18:01:48
     ***********************************/

    elsif (p_transaccion = 'CD_CAMBLOQ_IME') then

        begin

            select c.id_cuenta_doc,
                   c.sw_max_doc_rend
            into
                v_registros
            from cd.tcuenta_doc c
            where c.id_cuenta_doc = v_parametros.id_cuenta_doc;

            IF v_registros.sw_max_doc_rend = 'si' THEN
                v_sw_max_doc_rend = 'no';
            ELSE
                v_sw_max_doc_rend = 'si';
            END IF;

            update cd.tcuenta_doc
            set sw_max_doc_rend = v_sw_max_doc_rend,
                id_usuario_mod  = p_id_usuario,
                fecha_mod       = now()
            where id_cuenta_doc = v_parametros.id_cuenta_doc;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Cambia el bloqueo de facturas grandes para la rendicion');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_libro_bancos', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
      #TRANSACCION:  'CD_CAMBUSUREG_IME'
      #DESCRIPCION: Cambia el usuario responsable red registro
      #AUTOR:   admin
      #FECHA:   17-05-2016 18:01:48
      ***********************************/

    elsif (p_transaccion = 'CD_CAMBUSUREG_IME') then

        begin


            select c.id_cuenta_doc,
                   c.id_usuario_reg,
                   c.id_usuario_reg_ori
            into
                v_registros
            from cd.tcuenta_doc c
            where c.id_cuenta_doc = v_parametros.id_cuenta_doc;


            IF v_registros.id_usuario_reg_ori is NULL THEN
                update cd.tcuenta_doc
                set id_usuario_reg_ori = v_registros.id_usuario_reg
                where id_cuenta_doc = v_parametros.id_cuenta_doc;
            END IF;


            update cd.tcuenta_doc
            set id_usuario_reg = v_parametros.id_usuario_new,
                id_usuario_mod = p_id_usuario,
                fecha_mod      = now()
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            update cd.tcuenta_doc
            set id_usuario_reg = v_parametros.id_usuario_new,
                id_usuario_mod = p_id_usuario,
                fecha_mod      = now()
            where id_cuenta_doc_fk = v_parametros.id_cuenta_doc;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        format('Se cambio el usuario de registro de  id  %s por el id %s ',
                                               v_registros.id_usuario_reg::varchar,
                                               v_parametros.id_usuario_new::varchar));
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_RENREGDOC_VAL'
        #DESCRIPCION:   Valida si se registro o no documentos en la rendicion
        #AUTOR:         RCM
        #FECHA:         01-12-2017
        ***********************************/

    elsif (p_transaccion = 'CD_RENREGDOC_VAL') then

        begin

            --Cuenta la cantidad de documentos registrados en la rendicion
            select count(1)
            into v_total
            from cd.trendicion_det rd
            where rd.id_cuenta_doc_rendicion = v_parametros.id_cuenta_doc;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Recuento de los documentos de rendicion realizado');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'total_docs', v_total::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_RENREGITI_VAL'
        #DESCRIPCION:   Valida si el viatico tiene registrado el itinerario
        #AUTOR:         RCM
        #FECHA:         01-12-2017
        ***********************************/

    elsif (p_transaccion = 'CD_RENREGITI_VAL') then

        begin
            --Obtencion del tipo de cuenta doc del registro enviado
            select tcd.codigo
            into v_codigo_tipo_cuenta_doc
            from cd.tcuenta_doc cdoc
                     inner join cd.ttipo_cuenta_doc tcd
                                on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
            where cdoc.id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Si es viatico verifica si se registro el Itinerario
            if v_codigo_tipo_cuenta_doc in ('SOLVIA', 'RVI') then
                select count(1)
                into v_total
                from cd.tcuenta_doc_itinerario it
                where it.id_cuenta_doc = v_parametros.id_cuenta_doc;
            else
                v_total = 1;
            end if;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Verificacion de registro de Itinerario realizado');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'total_itinerario', v_total::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_CDTOT_VAL'
        #DESCRIPCION:   Devuelve los totales y saldo de la cuenta documentada
        #AUTOR:         RCM
        #FECHA:         11-12-2017
        ***********************************/

    elsif (p_transaccion = 'CD_CDRETOT_VAL') then

        begin

            select * into v_registros_cd from cd.f_get_saldo_totales_cuenta_doc(v_parametros.id_cuenta_doc);

            --Casos especiales para devolver en bolivianos lo entregado en dólares, geda, vi-000473-2018
            v_saldo = v_registros_cd.o_saldo;

            --Temporal
            /*select id_moneda into v_id_moneda from cd.tcuenta_doc where id_cuenta_doc = v_parametros.id_cuenta_doc;

            if v_id_moneda = 2 then
              v_saldo = round(v_saldo*6.96,2);
            end if;*/


            /*if v_parametros.id_cuenta_doc = 1602 then
                v_saldo = round(v_saldo*6.96,2);
            elsif v_parametros.id_cuenta_doc = 1665 then
                v_saldo = round(v_saldo*6.96,2);
            end if;*/

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Verificacion de registro de Itinerario realizado');
            v_resp = pxp.f_agrega_clave(v_resp, 'total_solicitado', v_registros_cd.o_total_solicitado::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'total_rendido', v_registros_cd.o_total_rendido::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'saldo', v_saldo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'a_favor_de', v_registros_cd.o_a_favor_de::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'por_caja', 'si');--v_registros_cd.o_por_caja::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'dev_tipo', v_registros_cd.o_tipo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'saldo_parcial', v_registros_cd.o_saldo_parcial::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'tipo_rendicion', v_registros_cd.o_tipo_rendicion::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_CDDEVOL_GEN'
        #DESCRIPCION:   Genera recibo de caja o cheque para la devolución de saldos
        #AUTOR:         RCM
        #FECHA:         12-12-2017
        ***********************************/

    elsif (p_transaccion = 'CD_CDDEVOL_GEN') then

        begin

            --Verifica existencia de la cuenta documentada
            if not exists(select 1
                          from cd.tcuenta_doc
                          where id_cuenta_doc = v_parametros.id_cuenta_doc) then
                raise exception 'Cuenta documentada inexistente';
            end if;

            --Recuperar datos de la solicitud
            select c.id_estado_wf,
                   c.id_proceso_wf,
                   c.estado,
                   c.id_funcionario,
                   c.id_depto,
                   c.id_depto_conta,
                   c.id_depto_lb,
                   c.id_moneda,
                   c.id_uo,
                   c.id_funcionario_gerente,
                   c.nro_tramite,
                   c.id_gestion,
                   c.importe,
                   c.id_escala,
                   cd.dev_tipo
            into
                v_registros_cd
            from cd.tcuenta_doc cd
                     inner join cd.tcuenta_doc c on c.id_cuenta_doc = cd.id_cuenta_doc_fk
            where cd.id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Verifica el tipo de devolución
            if v_parametros.dev_tipo not in ('deposito', 'cheque', 'caja') and v_parametros.dev_saldo > 0 then
                raise exception 'Forma de devolución no identificada';
            end if;

            --Verifica si ya previamente se habría generado la devolución
            if coalesce(v_registros_cd.dev_tipo, '') <> '' then
                raise exception 'La devolución ya fue generada anteriormente';
            end if;

            --Obtiene los datos del saldo
            select *
            into v_registros_proc
            from cd.f_get_saldo_totales_cuenta_doc(v_parametros.id_cuenta_doc);

            --Actualiza cuenta doc guardando los datos de la devolución
            update cd.tcuenta_doc
            set dev_tipo              = v_parametros.dev_tipo,
                dev_a_favor_de        = v_parametros.dev_a_favor_de,
                dev_nombre_cheque     = v_parametros.dev_nombre_cheque,
                id_caja_dev           = v_parametros.id_caja_dev,
                dev_saldo             = v_parametros.dev_saldo,
                id_cuenta_bancaria    = v_parametros.id_cuenta_bancaria,
                importe_total_rendido = v_registros_proc.o_total_dev,
                id_depto_lb           = v_parametros.id_depto_lb,
                dev_saldo_original    = v_parametros.dev_saldo_original,
                id_moneda_dev         = v_parametros.id_moneda_dev
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Verifica si el saldo es mayor a cero para generar el documento en función del tipo de desembolso/reposición a realizar
            if v_parametros.dev_saldo > 0 then

                --Lógica para creación de la forma de devolución
                if v_parametros.dev_a_favor_de = 'empresa' then

                    if v_parametros.dev_tipo = 'caja' then
                        --Genera la solicitud de efectivo para la reposición a la empresa
                        select v_parametros.id_caja_dev                                   as id_caja,
                               v_parametros.dev_saldo                                     as monto,
                               v_registros_cd.id_funcionario                              as id_funcionario,
                               'ingreso'                                                  as tipo_solicitud,
                               now()                                                      as fecha,
                               'Devolución de fondos por cuenta documentada a la empresa' as motivo,
                               null::integer                                              as id_solicitud_efectivo_fk
                        into v_registros;

                        --Generacion de la solicitud de efectivo
                        v_resp = tes.f_inserta_solicitud_efectivo(0, p_id_usuario, hstore(v_registros),
                                                                  v_parametros.id_cuenta_doc);
                        v_id_solicitud_efectivo =
                                pxp.f_obtiene_clave_valor(v_resp, 'id_solicitud_efectivo', '', '', 'valor')::integer;

                        --Actualiza al cuenta documentada con la solicitud de efectivo creada
                        update cd.tcuenta_doc
                        set id_solicitud_efectivo = v_id_solicitud_efectivo
                        where id_cuenta_doc = v_parametros.id_cuenta_doc;

                        --Obtiene el nro_tramite de la solicitud de efectivo
                        select nro_tramite
                        into v_sol_efect
                        from tes.tsolicitud_efectivo
                        where id_solicitud_efectivo = v_id_solicitud_efectivo;

                        --Marca el recibo de ingreso
                        update tes.tsolicitud_efectivo
                        set ingreso_cd = 'si'
                        where id_solicitud_efectivo = v_id_solicitud_efectivo;

                        v_mensaje = 'Recibo de caja de ingreso generado para la devolucion a la empresa número: ' ||
                                    v_sol_efect;

                    elsif v_parametros.dev_tipo = 'deposito' then
                        v_mensaje =
                                'Debe registrar el(los) depósito(s) que el solicitante realice para poder cerrar la cuenta documentada.';
                    end if;

                elsif v_parametros.dev_a_favor_de = 'funcionario' then

                    if v_parametros.dev_tipo = 'caja' then
                        --Genera la solicitud de efectivo para la devolución al funcionario
                        select v_parametros.id_caja_dev                                     as id_caja,
                               v_parametros.dev_saldo                                       as monto,
                               v_registros_cd.id_funcionario                                as id_funcionario,
                               'solicitud'                                                  as tipo_solicitud,
                               now()                                                        as fecha,
                               'Reposición de fondos por cuenta documentada al funcionario' as motivo,
                               null::integer                                                as id_solicitud_efectivo_fk
                        into v_registros;

                        --Generacion de la solicitud de efectivo
                        v_resp = tes.f_inserta_solicitud_efectivo(0, p_id_usuario, hstore(v_registros),
                                                                  v_parametros.id_cuenta_doc);
                        v_id_solicitud_efectivo =
                                pxp.f_obtiene_clave_valor(v_resp, 'id_solicitud_efectivo', '', '', 'valor')::integer;

                        --Actualiza al cuenta documentada con la solicitud de efectivo creada
                        update cd.tcuenta_doc
                        set id_solicitud_efectivo = v_id_solicitud_efectivo
                        where id_cuenta_doc = v_parametros.id_cuenta_doc;

                        --Obtiene el nro_tramite de la solicitud de efectivo
                        select nro_tramite
                        into v_sol_efect
                        from tes.tsolicitud_efectivo
                        where id_solicitud_efectivo = v_id_solicitud_efectivo;

                        v_mensaje = 'Recibo de caja de ingreso generado para la reposicion al funcionario número: ' ||
                                    v_sol_efect;

                    else
                        --Se generará el cheque al momento de validar el comprobante
                        v_mensaje = 'El cheque se generará cuando el comprobante contable sea validado.';
                    end if;

                    v_mensaje = 'Devolución/Reposición procesada correctamente. ' || v_mensaje;

                else
                    raise exception 'No se puede determinar a favor de quien es el saldo de la cuenta documentada';
                end if;

            else
                v_mensaje = 'Acción realizada';
            end if;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', v_mensaje);
            v_resp = pxp.f_agrega_clave(v_resp, 'dev_tipo', v_parametros.dev_tipo);
            v_resp = pxp.f_agrega_clave(v_resp, 'id_solicitud_efectivo', v_id_solicitud_efectivo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'sol_efect', v_sol_efect);
            v_resp = pxp.f_agrega_clave(v_resp, 'respuesta',
                                        'Devolución/Reposición procesada correctamente. ' || v_mensaje);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION:  'CD_CDSIGEMA_INS'
        #DESCRIPCION:   Guarda los datos para integracion con SIGEMA
        #AUTO:          RCM
        #FECHA:         29-12-2017
        ***********************************/
    elsif (p_transaccion = 'CD_CDSIGEMA_INS') then

        begin

            --Sentencia de la modificacion
            update cd.tcuenta_doc
            set tipo_sol_sigema = v_parametros.tipo_sol_sigema,
                id_sigema       = v_parametros.id_sigema,
                fecha_mod       = now(),
                id_usuario_mod  = p_id_usuario
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            --Elimna todo el prorrateo y lo vuelve a generar
            delete from cd.tcuenta_doc_prorrateo where id_cuenta_doc = v_parametros.id_cuenta_doc;

            if v_parametros.id_cuenta_doc = 800 then
--              raise exception 'Procesando ... %  %',v_parametros.id_sigema,v_parametros.tipo_sol_sigema;
            end if;

            --Verifica que almenos exista una coincidencia
            --Verifica que almenos exista una coincidencia
            if not exists(with sigema as (select * from cd.vsigema_gral)
                          select 1
                          from sigema sigra
                                   inner join param.vcentro_costo cc
                                              on cc.codigo_tcc = sigra.codigo_cc
                                                  and cc.gestion = sigra.gestion::integer
                          where sigra.id_sigema = v_parametros.id_sigema
                            and sigra.tipo_sol_sigema = v_parametros.tipo_sol_sigema) then

                with sigema as (select * from cd.vsigema_gral)
                select pxp.list(sigra.codigo_cc)
                into v_cc_sigema
                from sigema sigra
                where sigra.id_sigema = v_parametros.id_sigema
                  and sigra.tipo_sol_sigema = v_parametros.tipo_sol_sigema;

                raise exception 'No se encuentra registrado el presupuesto en sistema para el(los) centro(s) de costo: %. Comuníquese con el Area de de Finanzas',v_cc_sigema;

            end if;


            --Replica el prorrateo de las vistas del SIGEMA
            insert into cd.tcuenta_doc_prorrateo(id_usuario_reg, fecha_reg, estado_reg, id_cuenta_doc, id_centro_costo,
                                                 prorrateo)
            with sigema as (select * from cd.vsigema_gral)
            select p_id_usuario,
                   now(),
                   'activo',
                   v_parametros.id_cuenta_doc,
                   cc.id_centro_costo,
                   sigra.porcentajeasignado / 100
            from sigema sigra
                     left join param.vcentro_costo cc
                               on cc.codigo_tcc = sigra.codigo_cc
                                   and cc.gestion = sigra.gestion::integer
            where sigra.id_sigema = v_parametros.id_sigema
              and sigra.tipo_sol_sigema = v_parametros.tipo_sol_sigema;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Prorrateo del SIGEMA importado)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_cuenta_doc', v_parametros.id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
        #TRANSACCION: 'CD_VIA110DET_MOD'
        #DESCRIPCION: Modificación funcionario en Recibos - Viáticos Form 110
        #AUTOR:       RCM
        #FECHA:       07/03/2018
        ***********************************/

    elsif (p_transaccion = 'CD_VIA110DET_MOD') then

        begin

            --Verifica existencia del registro
            if not exists(select 1
                          from conta.tdoc_compra_venta
                          where id_doc_compra_venta = v_parametros.id_doc_compra_venta) then
                raise exception 'Documento no encontrado';
            end if;

            --Verifica si el periodo está abierto
            select id_periodo, id_depto_conta
            into v_id_periodo, v_id_depto_conta
            from conta.tdoc_compra_venta
            where id_doc_compra_venta = v_parametros.id_doc_compra_venta;

            v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_id_depto_conta, v_id_periodo);

            --Validación parámetros
            if v_parametros.id_funcionario is null then
                raise exception 'El funcionario no puede tener valor nulo';
            end if;

            --Modificación del funcionario
            update conta.tdoc_compra_venta
            set id_funcionario = v_parametros.id_funcionario
            where id_doc_compra_venta = v_parametros.id_doc_compra_venta;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Funcionario modificado en el recibo de viáticos');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_doc_compra_venta', v_parametros.id_doc_compra_venta::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END;
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION cd.ft_cuenta_doc_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;