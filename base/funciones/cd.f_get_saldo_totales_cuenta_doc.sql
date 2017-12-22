    CREATE OR REPLACE FUNCTION cd.f_get_saldo_totales_cuenta_doc (
      p_id_cuenta_doc_rendicion integer,
      p_solo_esta_rendicion varchar = 'no',
      out o_total_solicitado numeric,
      out o_total_rendido numeric,
      out o_saldo numeric,
      out o_a_favor_de varchar,
      out o_por_caja varchar,
      out o_tipo varchar,
      out o_total_dev numeric,
      out o_total_rep numeric
    )
    RETURNS record AS
    $body$
    /**************************************************************************
     SISTEMA:       Cuenta Documenta
     FUNCION:       cd.f_get_saldo_totales_cuenta_doc
     DESCRIPCION:   Obtiene el total solicitado, rendido, depositos realizados, sol efectivo realizadas, cheques, y  principalmente el saldo
     AUTOR:         RCM
     FECHA:         11-12-2017
     COMENTARIOS:   
    ***************************************************************************
     HISTORIAL DE MODIFICACIONES:

     DESCRIPCION:   
     AUTOR:         
     FECHA:     
    ***************************************************************************/
    DECLARE

        v_resp                      varchar;
        v_nombre_funcion            text;
        v_rec                       record;
        v_rec_cd                    record;
        v_id_cuenta_doc_sol         integer;
        v_total_solicitado          numeric;
        v_total_rendido             numeric;
        v_total_rendido_borrador    numeric;
        v_saldo                     numeric;
        v_saldo_parcial             numeric;
        v_a_favor_de                varchar;
        v_por_caja                  varchar = 'no';
        v_total_dev                 numeric;
        v_total_recibo_ingreso      numeric;
        v_max_cd_caja               numeric;
        v_finalizacion              varchar;
        v_total_rep                 numeric;

    BEGIN

        --Identificación de la función
        v_nombre_funcion = 'cd.f_get_saldo_totales_cuenta_doc';

        -------------------------------
        -- (1) OBTENCIÓN DE DATOS
        ------------------------------
        if not exists(select 1 from cd.tcuenta_doc
                    where id_cuenta_doc = p_id_cuenta_doc_rendicion) then
            raise exception 'Cuenta Documentada no encontrada';
        end if;

        --Validación que el importe no supere al máximo permitido
        v_max_cd_caja = pxp.f_get_variable_global('cd_importe_maximo_cajas');

        --Obtención de datos de la cuenta documentada (rendición)
        select
        cd.id_cuenta_doc, cd.id_moneda, cd.importe, tcd.codigo as tipo_cuenta_doc, cd.estado,
        cd.fecha_entrega, cd.id_cuenta_doc_fk, tcd.sw_solicitud, cd.id_cuenta_doc_fk,
        cd.dev_tipo, cd.dev_a_favor_de, cd.dev_nombre_cheque, cd.id_caja_dev, cd.dev_saldo
        into v_rec_cd
        from cd.tcuenta_doc cd
        inner join cd.ttipo_cuenta_doc tcd
        on tcd.id_tipo_cuenta_doc = cd.id_tipo_cuenta_doc
        where cd.id_cuenta_doc = p_id_cuenta_doc_rendicion;

        --Verifica que sea rendición
        if v_rec_cd.id_cuenta_doc_fk is null then
            raise exception 'La cuenta documentada no es una rendición (%)',p_id_cuenta_doc_rendicion;
        end if;

        --Obtiene el id de la solicitud de cuenta documentada
        v_id_cuenta_doc_sol = v_rec_cd.id_cuenta_doc_fk;

        v_finalizacion = 'no';
        if coalesce(v_rec_cd.dev_tipo,'') <> '' then
            v_finalizacion = 'si';
        end if;

        -------------------------------------------------------------------------------------------------------
        -- (2) OBTENCIÓN DE TOTALES DE : SOLICITUD, RENDIDO, DEPOSITOS, RECIBOS DE INGRESO (DEV), CHEQUES (DEV)
        -------------------------------------------------------------------------------------------------------

        --2.1 TOTAL SOLICITADO
        select coalesce(importe,0)
        into v_total_solicitado
        from cd.tcuenta_doc
        where id_cuenta_doc = v_id_cuenta_doc_sol;

        --2.2 TOTAL RENDIDO. Incluye solamente las rendiciones finalizadas (estado = 'rendido')
        select
        coalesce(sum(coalesce(dcv.importe_pago_liquido,0)),0)
        into v_total_rendido
        from cd.tcuenta_doc cd
        inner join  cd.trendicion_det rd
        on rd.id_cuenta_doc_rendicion = cd.id_cuenta_doc
        inner join conta.tdoc_compra_venta dcv
        on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
        and dcv.estado_reg = 'activo'
        where cd.id_cuenta_doc_fk = v_id_cuenta_doc_sol
        and cd.estado = 'rendido';

        --2.2.1 TOTAL RENDIDO. Incluye el total de documentos de la rendición que se está queriendo validar
        select
        coalesce(sum(coalesce(dcv.importe_pago_liquido,0)),0)
        into v_total_rendido_borrador
        from cd.tcuenta_doc cd
        inner join  cd.trendicion_det rd
        on rd.id_cuenta_doc_rendicion = cd.id_cuenta_doc
        inner join conta.tdoc_compra_venta dcv
        on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
        and dcv.estado_reg = 'activo'
        where cd.id_cuenta_doc = p_id_cuenta_doc_rendicion;    

        --Si p_solo_esta_rendicion es 'si', entonces sólo se toma en cuenta la rendición_borrador
        if p_solo_esta_rendicion = 'no' then
            v_total_rendido = v_total_rendido + v_total_rendido_borrador;
        else
            v_total_rendido = v_total_rendido_borrador;
        end if;

        --2.3 Obtencion del saldo parcial
        v_saldo_parcial = v_total_solicitado - v_total_rendido;

        --2.4 TOTAL DEVOLUCIONES
        v_total_dev = 0;
        v_total_rep = 0;

        --Lógica en función del signo del saldo
        if v_saldo_parcial > 0 then
            --A favor de la empresa
            v_a_favor_de   = 'empresa';

            if coalesce(v_rec_cd.dev_tipo,'deposito') = 'deposito' then
                if p_solo_esta_rendicion = 'si' then

                    --Se suman los depósitos registrados sólo de la rendición
                    select
                    coalesce(sum(lb.importe_deposito),0)
                    into v_total_dev
                    from cd.tcuenta_doc cdoc
                    inner join cd.vlibro_bancos_deposito lb
                    on cdoc.id_cuenta_doc = lb.id_cuenta_doc
                    where cdoc.id_cuenta_doc = p_id_cuenta_doc_rendicion
                    and cdoc.estado_reg = 'activo';

                else 
                    --Se suman los depósitos registrados de TODA la SOLICITUD
                    select
                    coalesce(sum(lb.importe_deposito),0)
                    into v_total_dev
                    from cd.tcuenta_doc cdoc
                    inner join cd.vlibro_bancos_deposito lb
                    on cdoc.id_cuenta_doc = lb.id_cuenta_doc
                    where cdoc.id_cuenta_doc_fk = v_id_cuenta_doc_sol
                    and cdoc.estado_reg = 'activo';

                end if;
                

            elsif coalesce(v_rec_cd.dev_tipo,'deposito') = 'caja' then
                --Como el sistema generará automáticamente el recibo de ingreso, se asume el total de saldo como registrado (SÓLO PARA v_finalizacion = 'si')
                if v_finalizacion = 'si' then
                    v_total_dev = v_saldo_parcial;
                end if;
            else
                raise exception 'Tipo de devolución incorrecta (%)',coalesce(v_rec_cd.dev_tipo,'deposito');
            end if;

        elsif v_saldo_parcial < 0 then
            --A favor del funcionario
            v_a_favor_de = 'funcionario';
            --Como el sistema generará automáticamente el cheque o recibo de caja, se asume el total de saldo como registrado (SÓLO PARA v_finalizacion = 'si')
            if v_finalizacion = 'si' then
                v_total_rep = v_saldo_parcial*(-1);
            end if;
        else
            --Saldo cero
            v_a_favor_de = '';
            --Saldo cero
            v_total_dev = v_saldo_parcial;
        end if;

        --2.5 OBTIENE EL SALDO FINAL
        v_saldo = v_total_solicitado - v_total_rendido - v_total_dev + v_total_rep;

        --Convierte a positivo siempre el saldo a positivo
        v_saldo = abs(v_saldo);

        --Verifica si el saldo puede ir por caja o no
        if v_saldo <= v_max_cd_caja then
            v_por_caja = 'si';
        end if;

        --SALIDA
        o_total_solicitado = v_total_solicitado;
        o_total_rendido = v_total_rendido;
        o_saldo = v_saldo;
        o_a_favor_de = v_a_favor_de;
        o_por_caja = v_por_caja;
        o_tipo = v_rec_cd.dev_tipo;
        o_total_dev = v_total_dev;
        o_total_rep = v_total_rep;


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
    SECURITY INVOKER;