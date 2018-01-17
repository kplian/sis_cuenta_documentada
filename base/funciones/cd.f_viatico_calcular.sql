CREATE OR REPLACE FUNCTION cd.f_viatico_calcular (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_cuenta_doc integer,
  p_tipo varchar = 'solicitud'::character varying,
  out o_viatico numeric,
  out o_hotel numeric,
  out o_total_dias integer,
  out o_total_viatico numeric
)
RETURNS record AS
$body$
/**************************************************************************
 SISTEMA:       Cuenta Documenta
 FUNCION:       cd.f_viatico_calcular
 DESCRIPCION:   Calcula el importe de los viáticos
 AUTOR:         RCM
 FECHA:         05-09-2017 17:54:29
 COMENTARIOS:   
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:     
***************************************************************************/
DECLARE

    v_resp                              varchar;
    v_nombre_funcion                    text;
    v_viatico                           NUMERIC;
    v_hotel                             NUMERIC;
    v_total_viatico                     NUMERIC;
    v_rec                               record;
    v_rec_cd                            record;
    v_rec_escala                        record;
    v_aux                               numeric = 0;
    v_id_tipo_categoria                 integer;
    v_hora_salida                       time;
    v_hora_llegada                      time;
    v_dias_total_viaje                  integer;
    v_dias_destino                      integer;
    v_cobertura_rendicion_salida        integer = 1;
    v_cobertura_rendicion_llegada       integer = 1;
    v_cont                              integer = 0;
    v_saldo_inicial_dias                integer = 0;
    v_saldo_ant_dias                    integer = 0;
    v_parametro_cant_dias_anteriores    integer = 3;
    v_dias_aplicacion_regla             integer;
    v_cobertura_aplicada                numeric;
    v_cobertura_aplicada_hotel          numeric;
    v_regla_cobertura_dias_acum         numeric;
    v_regla_cobertura_hora_salida       numeric;
    v_regla_cobertura_hora_llegada      numeric;
    v_regla_cobertura_total_dias        numeric;
    v_control_dias                      integer = 0;
    v_aux_dias_normal                   integer = 0;
    v_mensaje                           varchar;
    v_dias_hotel                        integer=0;
    v_aplico_regla_rend_llegada         boolean = false;
    v_cob_aux                           numeric;

BEGIN

    v_nombre_funcion = 'cd.f_viatico_calcular';

    ----------------
    --VALIDACIONES
    ----------------
    --Obtención de datos de la solicitud y cobertura seleccionada
    select id_cuenta_doc, fecha_salida, id_funcionario, fecha_llegada, hora_salida, hora_llegada,id_escala,cantidad_personas,aplicar_regla_15,
    case cobertura
        when 'viatico_100' then 1
        when 'viatico_70' then 0.7
        when 'viatico_25' then 0.25
    end as cobertura,
    case cobertura
        when 'viatico_100' then 0
        when 'viatico_70' then 1
        when 'viatico_25' then 1
    end as cobertura_hotel
    into v_rec_cd
    from cd.tcuenta_doc
    where id_cuenta_doc = p_id_cuenta_doc;
    
    --Verificación de existencia del viático
    if v_rec_cd.id_cuenta_doc is null then
        raise exception 'Viático inexistente';
    end if;

    --Verificación de existencia de la cobertura
    if v_rec_cd.cobertura is null then
        raise exception 'Cobertura no registrada';
    end if;
    
    --Verificación de existencia de escala de viáticos vigente
    if v_rec_cd.id_escala is null then
        raise exception 'No existe una Escala de Viáticos vigente';
    end if;

    ---------------------------------------------
    --ELIMINACIÓN DE DETALLE DE CÁLCULO ANTERIOR
    ---------------------------------------------
    delete from cd.tcuenta_doc_calculo where id_cuenta_doc = v_rec_cd.id_cuenta_doc;

    -------------------------------------
    --CÁLCULO DE APLICACIÓN DE COBERTURA
    -------------------------------------
    --Obtención de la categoría del viático de la escala vigente
    v_id_tipo_categoria = cd.f_viatico_get_categoria(v_rec_cd.id_escala, p_id_cuenta_doc);

    --Obtención de la cantidad total de días
    select sum(cantidad_dias)::integer
    into v_dias_total_viaje
    from cd.tcuenta_doc_itinerario
    where id_cuenta_doc = p_id_cuenta_doc;

    ---------------------------------------------------------------------
    --VERIFICACIÓN DE DESTINOS PARAMETRIZADOS PARA LA ESCALA DEL VIÁTICO
    ---------------------------------------------------------------------
    if exists(select
                1
                from cd.tcuenta_doc_itinerario ci
                left join cd.tcategoria cat
                on cat.id_destino = ci.id_destino
                where ci.id_cuenta_doc = p_id_cuenta_doc
                and cat.id_destino is null) then

        select pxp.list(des.nombre)
        into v_mensaje
        from cd.tcuenta_doc_itinerario ci
        inner join cd.tdestino des
        on des.id_destino = ci.id_destino
        left join cd.tcategoria cat
        on cat.id_destino = des.id_destino
        where ci.id_cuenta_doc = p_id_cuenta_doc
        and cat.id_destino is null;

        raise exception 'Falta la parametrización de la escala para el (los) destino(s) siguiente(s): %',v_mensaje;

    end if;

    -----------------------------
    --OBTENCIÓN DE DATOS PREVIOS
    -----------------------------
    select
    sum(date_part('day',(cdoc.fecha_llegada::timestamp - cdoc.fecha_salida))) as dias
    into v_saldo_inicial_dias
    from cd.tcuenta_doc cdoc
    inner join cd.ttipo_cuenta_doc tcdoc
    on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
    where tcdoc.codigo = 'SOLVIA'
    and cdoc.id_funcionario = v_rec_cd.id_funcionario
    and cdoc.id_cuenta_doc <> v_rec_cd.id_cuenta_doc
    and date_part('day',(v_rec_cd.fecha_salida::timestamp - cdoc.fecha_llegada)) between 0 and v_parametro_cant_dias_anteriores;
    

    ----------------------
    --CÁLCULO DE VIÁTICOS
    ----------------------
    --Inicialización de variables
    v_viatico = 0;
    v_hotel = 0;
    v_total_viatico = 0;

    --Días acumulados para aplicación de reglas
    v_saldo_inicial_dias = coalesce(v_saldo_inicial_dias,0);
    --v_saldo_inicial_dias = 10;
    v_dias_aplicacion_regla = coalesce(v_saldo_inicial_dias,0);
    
    

    --Recorrido del itinerario de viaje
    for v_rec in select *
                from cd.tcuenta_doc_itinerario
                where id_cuenta_doc = p_id_cuenta_doc
                order by id_cuenta_doc_itinerario loop

        -----------------------------------
        --(1) Inicialización de variables
        -----------------------------------
        --Contador
        v_cont = v_cont + 1;
        v_control_dias = v_control_dias + v_rec.cantidad_dias;
        v_cobertura_aplicada = 0;
        v_regla_cobertura_total_dias = 0;
        v_regla_cobertura_hora_salida = 0;
        v_regla_cobertura_hora_llegada = 0;
        v_regla_cobertura_dias_acum = 0;
        v_hora_salida = null::time;
        v_hora_llegada = null::time;

        --Recuento de días acumulados
        v_saldo_ant_dias = v_dias_aplicacion_regla;
        v_dias_aplicacion_regla = v_dias_aplicacion_regla + coalesce(v_rec.cantidad_dias,0);
        v_dias_destino = v_rec.cantidad_dias;

        --Obtención del monto del viático definida en la escala por el destino
        select
        ca.monto, ca.monto_sp, ca.monto_hotel, des.codigo || ' - ' || des.nombre as destino
        into v_rec_escala
        from cd.tcategoria ca
        inner join cd.tdestino des
        on des.id_destino = ca.id_destino
        where ca.id_tipo_categoria = v_id_tipo_categoria
        and ca.id_destino = v_rec.id_destino;

        -------------------------------------------------------------------
        --(2) Obtención de cobertura del VIATICO en orden de priorización
        -------------------------------------------------------------------
        --Regla 1: Total días -> si el viaje es de 1 día se aplica cobertura de 100%
        if v_dias_total_viaje = 1 then
            v_cobertura_aplicada = 1;
            v_regla_cobertura_total_dias = v_cobertura_aplicada;
            v_cobertura_aplicada_hotel = 0;
            v_dias_hotel=0;
        end if;

        --Regla 2: para rendiciones -> aplicar regla de horarios de salida
        if p_tipo = 'rendicion' and v_cobertura_aplicada = 0 then

            if v_cont = 1 then
                --Cobertura hotel
                v_cobertura_aplicada_hotel = v_rec_cd.cobertura_hotel;
                
                if v_rec_cd.hora_salida::time between '00:00:00'::time and '10:00:00'::time then
                    v_cobertura_aplicada = 1 * v_rec_cd.cobertura; --se aumenta * v_rec_cd.cobertura
                    v_regla_cobertura_hora_salida = 1;
                elsif v_rec_cd.hora_salida::time between '10:01:00'::time and '18:00:00'::time then
                    v_cobertura_aplicada = 0.66 * v_rec_cd.cobertura; --se aumenta * v_rec_cd.cobertura
                    v_regla_cobertura_hora_salida = 0.66;
                else
                    v_cobertura_aplicada = 0.45 * v_rec_cd.cobertura; --se aumenta * v_rec_cd.cobertura
                    v_regla_cobertura_hora_salida = 0.45;
                end if;
                
                v_hora_salida = v_rec_cd.hora_salida;

                --Cálculo del viático por el primer día
                v_total_viatico = v_total_viatico + (v_rec_escala.monto * 1 * v_cobertura_aplicada) + (v_rec_escala.monto_hotel * 1 * v_cobertura_aplicada_hotel);
                v_viatico = v_viatico + (v_rec_escala.monto * 1 * v_cobertura_aplicada);
                v_hotel = v_hotel + (v_rec_escala.monto_hotel * 1 * v_cobertura_aplicada_hotel);

                --Registro del cálculo del primer día del viaje
                insert into cd.tcuenta_doc_calculo(
                id_usuario_reg                  ,fecha_reg                      ,estado_reg                     ,id_usuario_ai,
                usuario_ai                      ,id_cuenta_doc                  ,numero                         ,destino,
                dias_saldo_ant                  ,dias_destino                   ,cobertura_sol                  ,dias_total_viaje,
                dias_aplicacion_regla           ,hora_salida                    ,hora_llegada                   ,escala_viatico,
                escala_hotel                    ,regla_cobertura_dias_acum      ,regla_cobertura_hora_salida    ,regla_cobertura_hora_llegada,
                regla_cobertura_total_dias      ,cobertura_aplicada             ,cobertura_aplicada_hotel       ,cobertura_hotel_sol,
                dias_hotel
                ) values (
                p_id_usuario                    ,now()                          ,'activo'                       ,p_id_usuario_ai,
                p_id_usuario_ai                 ,v_rec_cd.id_cuenta_doc         ,v_cont                         ,v_rec_escala.destino,
                v_saldo_ant_dias                ,1                              ,v_rec_cd.cobertura             ,v_dias_total_viaje,
                v_saldo_ant_dias + 1            ,v_hora_salida                  ,v_hora_llegada                 ,v_rec_escala.monto,
                v_rec_escala.monto_hotel        ,v_regla_cobertura_dias_acum    ,v_regla_cobertura_hora_salida  ,v_regla_cobertura_hora_llegada,
                v_regla_cobertura_total_dias    ,v_cobertura_aplicada           ,v_cobertura_aplicada_hotel     ,v_rec_cd.cobertura_hotel,
                1
                );
                
                v_saldo_ant_dias = v_saldo_ant_dias + 1;
                
                --Incrementa el contador
                v_cont = v_cont + 1;
                --Descuenta 1 día a la cantidad de días por destino
                v_dias_destino = v_dias_destino - 1;
                --Reinicializa variable de control
                v_cobertura_aplicada = 0;
                v_hora_salida = null::time;

            end if;
            
        end if;

        --Regla 3: para rendiciones -> aplicar regla de horarios de llegada
        if p_tipo = 'rendicion' and v_cobertura_aplicada = 0 then
            
            if v_control_dias = v_dias_total_viaje then
                --Bandera para controlar si se aplico regla de llegadaen rendicion, para posteriormente no restarle un dia de hotel
                v_aplico_regla_rend_llegada = true;
                --Cobertura hotel
                v_cobertura_aplicada_hotel = v_rec_cd.cobertura_hotel;
                
                if v_rec_cd.hora_llegada::time between '00:00:00'::time and '09:00:00'::time then
                    v_cobertura_aplicada = 0.45;
                    v_regla_cobertura_hora_llegada = v_cobertura_aplicada;
                elsif v_rec_cd.hora_llegada::time between '09:01:00'::time and '15:00:00'::time then
                    v_cobertura_aplicada = 0.66;
                    v_regla_cobertura_hora_llegada = v_cobertura_aplicada;
                else
                    v_cobertura_aplicada = 1;
                    v_regla_cobertura_hora_llegada = v_cobertura_aplicada;
                end if;

                v_hora_llegada = v_rec_cd.hora_llegada;

                --Cálculo del viático por último día del viaje
                v_total_viatico = v_total_viatico + (v_rec_escala.monto * 1 * v_cobertura_aplicada) + (v_rec_escala.monto_hotel * 1 * v_cobertura_aplicada_hotel);
                v_viatico = v_viatico + (v_rec_escala.monto * 1 * v_cobertura_aplicada);
                v_hotel = v_hotel + (v_rec_escala.monto_hotel * 1 * v_cobertura_aplicada_hotel);
                
                --Para el último día si la cobertura era 70% se coloca en 1 la cobertura solicitada
                v_cob_aux = v_rec_cd.cobertura;
                if v_rec_cd.cobertura = 0.7 then
                    v_cob_aux = 1;
                end if;

                --Registro del cálculo del último día del viaje
                insert into cd.tcuenta_doc_calculo(
                id_usuario_reg                  ,fecha_reg                      ,estado_reg                     ,id_usuario_ai,
                usuario_ai                      ,id_cuenta_doc                  ,numero                         ,destino,
                dias_saldo_ant                  ,dias_destino                   ,cobertura_sol                  ,dias_total_viaje,
                dias_aplicacion_regla           ,hora_salida                    ,hora_llegada                   ,escala_viatico,
                escala_hotel                    ,regla_cobertura_dias_acum      ,regla_cobertura_hora_salida    ,regla_cobertura_hora_llegada,
                regla_cobertura_total_dias      ,cobertura_aplicada             ,cobertura_aplicada_hotel       ,cobertura_hotel_sol,
                dias_hotel
                ) values (
                p_id_usuario                    ,now()                          ,'activo'                       ,p_id_usuario_ai,
                p_id_usuario_ai                 ,v_rec_cd.id_cuenta_doc         ,v_cont + 1                     ,v_rec_escala.destino,
                v_saldo_inicial_dias+ v_dias_total_viaje - 1          ,1        ,v_cob_aux                      ,v_dias_total_viaje,
                v_dias_aplicacion_regla         ,v_hora_salida                  ,v_hora_llegada                 ,v_rec_escala.monto,
                v_rec_escala.monto_hotel        ,v_regla_cobertura_dias_acum    ,0                              ,v_regla_cobertura_hora_llegada,
                v_regla_cobertura_total_dias    ,v_cobertura_aplicada           ,v_cobertura_aplicada_hotel     ,v_rec_cd.cobertura_hotel,
                0
                );

                --Descuenta 1 día a la cantidad de días por destino
                v_dias_aplicacion_regla = v_dias_aplicacion_regla - 1;
                v_dias_destino = v_dias_destino - 1 ;
                v_hora_llegada = null::time;
                v_cobertura_aplicada = 0;
                v_regla_cobertura_hora_llegada = 0;

            end if;
            
        end if;

        --Regla 4: días consecutivos acumulados -> si supera los 15 días consecutivos aplica el 50%
        if v_dias_aplicacion_regla > 15 and v_cobertura_aplicada = 0 and coalesce(v_rec_cd.aplicar_regla_15,'si')='si' then
            --Cobertura hotel
            v_cobertura_aplicada_hotel = v_rec_cd.cobertura_hotel;
            
            --Definición de días para aplicar cobertura normal
            v_aux_dias_normal = 15 - v_saldo_ant_dias;
            v_cobertura_aplicada = v_rec_cd.cobertura;

            if v_aux_dias_normal > 0 then
                v_total_viatico = v_total_viatico + (v_rec_escala.monto * v_aux_dias_normal * v_cobertura_aplicada) + (v_rec_escala.monto_hotel * v_aux_dias_normal * v_cobertura_aplicada_hotel);
                v_viatico = v_viatico + (v_rec_escala.monto * v_aux_dias_normal * v_cobertura_aplicada);
                v_hotel = v_hotel + (v_rec_escala.monto_hotel * v_aux_dias_normal * v_cobertura_aplicada_hotel);

                --Registro del cálculo del último día del viaje
                insert into cd.tcuenta_doc_calculo(
                id_usuario_reg                  ,fecha_reg                      ,estado_reg                     ,id_usuario_ai,
                usuario_ai                      ,id_cuenta_doc                  ,numero                         ,destino,
                dias_saldo_ant                  ,dias_destino                   ,cobertura_sol                  ,dias_total_viaje,
                dias_aplicacion_regla           ,hora_salida                    ,hora_llegada                   ,escala_viatico,
                escala_hotel                    ,regla_cobertura_dias_acum      ,regla_cobertura_hora_salida    ,regla_cobertura_hora_llegada,
                regla_cobertura_total_dias      ,cobertura_aplicada             ,cobertura_aplicada_hotel       ,cobertura_hotel_sol,
                dias_hotel
                ) values (
                p_id_usuario                    ,now()                          ,'activo'                       ,p_id_usuario_ai,
                p_id_usuario_ai                 ,v_rec_cd.id_cuenta_doc         ,v_cont                         ,v_rec_escala.destino,
                v_saldo_ant_dias                ,v_aux_dias_normal              ,v_rec_cd.cobertura             ,v_dias_total_viaje,
                15                              ,v_hora_salida                  ,v_hora_llegada                 ,v_rec_escala.monto,
                v_rec_escala.monto_hotel        ,v_regla_cobertura_dias_acum    ,v_regla_cobertura_hora_salida  ,v_regla_cobertura_hora_llegada,
                v_regla_cobertura_total_dias    ,v_cobertura_aplicada           ,v_cobertura_aplicada_hotel     ,v_rec_cd.cobertura_hotel,
                v_aux_dias_normal
                );

                --Actualización de variables
                v_cont = v_cont + 1;
                v_dias_destino = v_dias_destino - v_aux_dias_normal;
                --v_dias_aplicacion_regla = v_dias_aplicacion_regla - 1;
                v_hora_llegada = null::time;
                v_cobertura_aplicada = 0.5;
                v_regla_cobertura_dias_acum = v_cobertura_aplicada;
                v_saldo_ant_dias = v_saldo_ant_dias + v_aux_dias_normal;

            end if;

            --Definición de días para aplicar cobertura según la regla
            v_cobertura_aplicada = 0.5;
            v_regla_cobertura_dias_acum = v_cobertura_aplicada;
            
        end if;
        
        

        --Regla por defecto: Cobertura solicitada. En caso de que no aplique ninguna regla anterior, aplica la cobertura de la solicitud
        if v_cobertura_aplicada = 0 then
            v_cobertura_aplicada = v_rec_cd.cobertura;
            --Cobertura Hotel
            v_cobertura_aplicada_hotel = v_rec_cd.cobertura_hotel;
        end if;
        
        
        
        ---------------------------------
        --(3) Cálculo del TOTAL VIÁTICO
        ---------------------------------
        
        --Rduce un dia de hotel en el ultimo destino registrado
        /*v_dias_hotel = v_dias_destino;
        if v_control_dias = v_dias_total_viaje and not v_aplico_regla_rend_llegada then
            ias_hotel = v_dias_destino - 1;
        end if;*/

        v_dias_hotel = v_dias_destino;
        
        
        if v_control_dias = v_dias_total_viaje and not v_aplico_regla_rend_llegada then

            --Para el último día si la cobertura era 70% se coloca en 1 la cobertura solicitada
            v_cob_aux = v_rec_cd.cobertura;
            if v_rec_cd.cobertura = 0.7 then
                v_cob_aux = 1;
            end if;
            
            

            --Registro del cálculo del último día del viaje
            v_total_viatico = v_total_viatico + (v_rec_escala.monto * 1 * v_cob_aux) + (v_rec_escala.monto_hotel * 0 * v_cobertura_aplicada_hotel);
            v_viatico = v_viatico + (v_rec_escala.monto * 1 * v_cob_aux);
            v_hotel = v_hotel + (v_rec_escala.monto_hotel * 0 * v_cobertura_aplicada_hotel);
            
            

            --Registro del cálculo del último día del viaje
            insert into cd.tcuenta_doc_calculo(
            id_usuario_reg                  ,fecha_reg                      ,estado_reg                     ,id_usuario_ai,
            usuario_ai                      ,id_cuenta_doc                  ,numero                         ,destino,
            dias_saldo_ant                  ,dias_destino                   ,cobertura_sol                  ,dias_total_viaje,
            dias_aplicacion_regla           ,hora_salida                    ,hora_llegada                   ,escala_viatico,
            escala_hotel                    ,regla_cobertura_dias_acum      ,regla_cobertura_hora_salida    ,regla_cobertura_hora_llegada,
            regla_cobertura_total_dias      ,cobertura_aplicada             ,cobertura_aplicada_hotel       ,cobertura_hotel_sol,
            dias_hotel
            ) values (
            p_id_usuario                    ,now()                          ,'activo'                       ,p_id_usuario_ai,
            p_id_usuario_ai                 ,v_rec_cd.id_cuenta_doc         ,v_cont + 1                     ,v_rec_escala.destino,
            v_saldo_inicial_dias+ v_dias_total_viaje - 1          ,1        ,v_rec_cd.cobertura             ,v_dias_total_viaje,
            v_dias_aplicacion_regla         ,v_hora_salida                  ,v_hora_llegada                 ,v_rec_escala.monto,
            v_rec_escala.monto_hotel        ,v_regla_cobertura_dias_acum    ,0                              ,v_regla_cobertura_hora_llegada,
            v_regla_cobertura_total_dias    ,v_cob_aux           ,v_cobertura_aplicada_hotel     ,v_rec_cd.cobertura_hotel,
            0
            );

            --Descuenta 1 día a la cantidad de días por destino
            v_dias_hotel = v_dias_destino - 1;
            v_dias_aplicacion_regla = v_dias_aplicacion_regla - 1;
            v_dias_destino = v_dias_destino - 1 ;
            v_hora_llegada = null::time;
            v_cobertura_aplicada = 0;
            v_regla_cobertura_hora_llegada = 0;

        end if;
        
         --Regla por defecto: Cobertura solicitada. En caso de que no aplique ninguna regla anterior, aplica la cobertura de la solicitud
        if v_cobertura_aplicada = 0 then
            v_cobertura_aplicada = v_rec_cd.cobertura;
            --Cobertura Hotel
            v_cobertura_aplicada_hotel = v_rec_cd.cobertura_hotel;
        end if;

        v_viatico = v_viatico + (v_rec_escala.monto * v_dias_destino * v_cobertura_aplicada);
        v_hotel = v_hotel + (v_rec_escala.monto_hotel * v_dias_hotel * v_cobertura_aplicada_hotel);
        v_total_viatico = v_total_viatico + (v_rec_escala.monto * v_dias_destino * v_cobertura_aplicada) + (v_rec_escala.monto_hotel * v_dias_hotel * v_cobertura_aplicada_hotel);

        ----------------------------------------
        --(4) Registro del cálculo del viático
        ----------------------------------------
        if v_dias_destino > 0 then
            insert into cd.tcuenta_doc_calculo(
            id_usuario_reg                  ,fecha_reg                      ,estado_reg                     ,id_usuario_ai,
            usuario_ai                      ,id_cuenta_doc                  ,numero                         ,destino,
            dias_saldo_ant                  ,dias_destino                   ,cobertura_sol                  ,dias_total_viaje,
            dias_aplicacion_regla           ,hora_salida                    ,hora_llegada                   ,escala_viatico,
            escala_hotel                    ,regla_cobertura_dias_acum      ,regla_cobertura_hora_salida    ,regla_cobertura_hora_llegada,
            regla_cobertura_total_dias      ,cobertura_aplicada             ,cobertura_aplicada_hotel       ,cobertura_hotel_sol,
            dias_hotel                      ,cantidad_personas
            ) values (
            p_id_usuario                    ,now()                          ,'activo'                       ,p_id_usuario_ai,
            p_id_usuario_ai                 ,v_rec_cd.id_cuenta_doc         ,v_cont                         ,v_rec_escala.destino,
            v_saldo_ant_dias                ,v_dias_destino                 ,v_rec_cd.cobertura             ,v_dias_total_viaje,
            v_dias_aplicacion_regla         ,v_hora_salida                  ,v_hora_llegada                 ,v_rec_escala.monto,
            v_rec_escala.monto_hotel        ,v_regla_cobertura_dias_acum    ,v_regla_cobertura_hora_salida  ,v_regla_cobertura_hora_llegada,
            v_regla_cobertura_total_dias    ,v_cobertura_aplicada           ,v_cobertura_aplicada_hotel     ,v_rec_cd.cobertura_hotel,
            v_dias_hotel                    ,v_rec_cd.cantidad_personas
            );
        end if;

    end loop;

    --Respuesta
    o_viatico = v_viatico;
    o_hotel = v_hotel;
    o_total_dias = v_dias_total_viaje;
    o_total_viatico = v_total_viatico;

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