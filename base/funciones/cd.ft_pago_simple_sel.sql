--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_pago_simple_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Cuenta Documenta
 FUNCION:       cd.ft_pago_simple_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple'
 AUTOR:          (admin)
 FECHA:         31-12-2017 12:33:30
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE              FECHA               AUTOR               DESCRIPCION
 #0             31-12-2017 12:33:30                             Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple'
 #
 ***************************************************************************/

DECLARE

    v_consulta          varchar;
    v_parametros        record;
    v_nombre_funcion    text;
    v_resp              varchar;
    v_estado            varchar;
    v_filtro            varchar;
    v_historico         varchar;
    v_inner             varchar;
    v_strg_cd           varchar;
    v_strg_obs          varchar;

BEGIN

    v_nombre_funcion = 'cd.ft_pago_simple_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
    #TRANSACCION:  'CD_PAGSIM_SEL'
    #DESCRIPCION:   Consulta de datos
    #AUTOR:     admin
    #FECHA:     31-12-2017 12:33:30
    ***********************************/

    if(p_transaccion='CD_PAGSIM_SEL')then

        begin

            /*if pxp.f_existe_parametro(p_tabla,'estado') then
                v_estado =  v_parametros.estado;
            else
                v_estado = 'ninguno';
            end if;

            v_filtro='';
            if (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            end if;

            if  pxp.f_existe_parametro(p_tabla,'historico') then
                v_historico =  v_parametros.historico;
            else
                v_historico = 'no';
            end if;

            if v_parametros.tipo_interfaz in ('PagoSol') then

                if p_administrador != 1  then
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                end if;

            end if;

            if v_parametros.tipo_interfaz in ('PagoSimpleVb') then

                select
                pxp.aggarray(depu.id_depto)
                into
                va_id_depto
                from param.tdepto_usuario depu
                where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';

                if v_historico = 'no' then
                    if p_administrador !=1 then
                        v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||') and pagsim.estado in( ''vbtesoreria''))  ) and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
                    else
                        v_filtro = ' (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
                    end if;
                else
                    if p_administrador !=1 then
                        v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and  (lower(cdoc.estado)!=''borrador'')  and ';
                    else
                        v_filtro = ' (lower(cdoc.estado)!=''borrador'')  and ';
                    end if;

                end if;

            end if;

            if v_historico =  'si' then
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pagsim.id_proceso_wf';
               v_strg_cd = 'DISTINCT(pagsim.id_pago_simple)';
               v_strg_obs = '''---''::text';
            else
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = pagsim.id_estado_wf';
               v_strg_cd = 'pagsim.id_pago_simple';
               v_strg_obs = 'ew.obs';
            end if;*/

            --Filtros
            v_filtro='';

            if pxp.f_existe_parametro(p_tabla,'historico') then
                v_historico =  v_parametros.historico;
            else
                v_historico = 'no';
            end if;

            if v_parametros.tipo_interfaz in ('PagoSimpleSol') then

                if p_administrador != 1  then
                    --Filtro para  visualizacion de usuarios
                    v_filtro = '(
                        (pagsim.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or pagsim.id_usuario_reg='||p_id_usuario||')
                        or
                        ('||p_id_usuario||' in (select id_usuario from param.tdepto_usuario where id_depto = pagsim.id_depto_conta))
                    ) and ';

                    --Filtro de los estados
                    if v_historico = 'no' then
                        v_filtro = v_filtro || 'pagsim.estado in (''borrador'') and ';
                    end if;

                end if;

            elsif v_parametros.tipo_interfaz in ('PagoSimpleVb') then
                v_filtro = ' pagsim.estado not in (''borrador'',''finalizado'') and ';

                if p_administrador != 1  then
                    --v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                    v_filtro = v_filtro||'(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and ';
                end if;

            end if;

            --Sentencia de la consulta
            v_consulta:='select
                            pagsim.id_pago_simple,
                            pagsim.estado_reg,
                            pagsim.id_depto_conta,
                            pagsim.nro_tramite,
                            pagsim.fecha,
                            pagsim.id_funcionario,
                            pagsim.estado,
                            pagsim.id_estado_wf,
                            pagsim.id_proceso_wf,
                            pagsim.obs,
                            pagsim.id_cuenta_bancaria,
                            pagsim.id_depto_lb,
                            pagsim.id_usuario_reg,
                            pagsim.fecha_reg,
                            pagsim.id_usuario_ai,
                            pagsim.usuario_ai,
                            pagsim.id_usuario_mod,
                            pagsim.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            dep.codigo as desc_depto_conta,
                            fun.desc_funcionario1 as desc_funcionario,
                            (ins.nombre||'' - ''||cban.nro_cuenta)::varchar as desc_cuenta_bancaria,
                            deplb.codigo as desc_depto_lb,
                            pagsim.id_moneda,
                            pagsim.id_proveedor,
                            mon.codigo as desc_moneda,
                            pro.desc_proveedor,
                            pagsim.id_tipo_pago_simple,
                            pagsim.id_funcionario_pago,
                            fun1.desc_funcionario1 as desc_funcionario_pago,
                            tps.codigo || '' - '' || tps.nombre as desc_tipo_pago_simple,
                            tps.codigo as codigo_tipo_pago_simple,
                            pagsim.nro_tramite_asociado,
                            pagsim.importe,
                            pagsim.id_obligacion_pago,
                            op.num_tramite as desc_obligacion_pago,
                            pagsim.id_caja,
                            caj.codigo as desc_caja,
                            (select
                            ges.id_gestion
                            from param.tgestion ges
                            where ges.gestion = (date_part(''year'', pagsim.fecha))::integer
                            limit 1 offset 0) as id_gestion,
                            (select
                            id_periodo
                            from param.tperiodo
                            where pagsim.fecha between fecha_ini and fecha_fin
                            limit 1 offset 0) as id_periodo,
                             prov.desc_proveedor as proveedor_obligacion_pago
                        from cd.tpago_simple pagsim
                        inner join wf.testado_wf ew on ew.id_estado_wf = pagsim.id_estado_wf
                        inner join segu.tusuario usu1 on usu1.id_usuario = pagsim.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = pagsim.id_usuario_mod
                        inner join param.tdepto dep on dep.id_depto = pagsim.id_depto_conta
                        inner join orga.vfuncionario fun on fun.id_funcionario = pagsim.id_funcionario
                        left join tes.tcuenta_bancaria cban on cban.id_cuenta_bancaria = pagsim.id_cuenta_bancaria
                        left join param.tdepto deplb on deplb.id_depto = pagsim.id_depto_lb
                        left join param.tinstitucion ins on ins.id_institucion = cban.id_institucion
                        inner join param.tmoneda mon on mon.id_moneda = pagsim.id_moneda
                        left join param.vproveedor pro on pro.id_proveedor = pagsim.id_proveedor
                        inner join cd.ttipo_pago_simple tps on tps.id_tipo_pago_simple = pagsim.id_tipo_pago_simple
                        left join orga.vfuncionario fun1 on fun1.id_funcionario = pagsim.id_funcionario_pago
                        left join tes.tobligacion_pago op on op.id_obligacion_pago = pagsim.id_obligacion_pago
                        left join param.vproveedor prov on prov.id_proveedor = op.id_proveedor
                        left join tes.tcaja caj on caj.id_caja = pagsim.id_caja
                        where  ';

            v_consulta = v_consulta || v_filtro;

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
    #TRANSACCION:  'CD_DETPAG_SEL'
    #DESCRIPCION:   Consulta de datos
    #AUTOR:     JUAN
    #FECHA:     07-01-2018 12:33:30
    ***********************************/

    ELSIF(p_transaccion='CD_DETPAG_SEL')then

        begin


            --Sentencia de la consulta
            v_consulta:='SELECT
                          cv.id_doc_compra_venta::INTEGER,
                          cv.id_funcionario::INTEGER,
                          (select vf.desc_funcionario1 from orga.tfuncionario f join orga.vfuncionario vf on vf.id_funcionario=f.id_funcionario where f.id_funcionario=cv.id_funcionario)::varchar desc_funcionario1,
                          cv.id_plantilla::INTEGER,
                          (select p.desc_plantilla from param.tplantilla p where  p.id_plantilla=cv.id_plantilla)::varchar desc_plantilla,
                          ps.id_proveedor::INTEGER,
                          (SELECT pr.rotulo_comercial from param.tproveedor pr where pr.id_proveedor=ps.id_proveedor)::VARCHAR rotulo_comercial,
                          cv.importe_pago_liquido::numeric,
                          cv.importe_excento::numeric,
                          cv.fecha::date fecha_compra_venta,
                          ps.fecha::date fecha_pago_simple,
                          cv.sw_pgs::varchar sw_pgs
                          FROM conta.tdoc_compra_venta cv
                          join cd.tpago_simple_det psd on psd.id_doc_compra_venta=cv.id_doc_compra_venta
                          join cd.tpago_simple ps on ps.id_pago_simple= psd.id_pago_simple
                          inner join wf.testado_wf ew on ew.id_estado_wf = ps.id_estado_wf
                        where  ';


            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
    #TRANSACCION:  'CD_DETPAG_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     JUAN
    #FECHA:     07-01-2018 12:33:30
    ***********************************/

    elsif(p_transaccion='CD_DETPAG_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT
                count(cv.id_funcionario)
                FROM conta.tdoc_compra_venta cv
                join cd.tpago_simple_det psd on psd.id_doc_compra_venta=cv.id_doc_compra_venta
                join cd.tpago_simple ps on ps.id_pago_simple= psd.id_pago_simple
                inner join wf.testado_wf ew on ew.id_estado_wf = ps.id_estado_wf
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'CD_PAGSIM_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:     admin
    #FECHA:     31-12-2017 12:33:30
    ***********************************/

    elsif(p_transaccion='CD_PAGSIM_CONT')then

        begin

            v_filtro='';
            if v_parametros.tipo_interfaz in ('PagoSimpleSol') then

                if p_administrador != 1  then
                    --Filtro para  visualizacion de usuarios
                    v_filtro = '(
                        (pagsim.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or pagsim.id_usuario_reg='||p_id_usuario||')
                        or
                        ('||p_id_usuario||' in (select id_usuario from param.tdepto_usuario where id_depto = pagsim.id_depto_conta))
                    ) and ';

                    --Filtro de los estados
                    if v_historico = 'no' then
                        v_filtro = v_filtro || 'pagsim.estado in (''borrador'') and ';
                    end if;

                end if;

            elsif v_parametros.tipo_interfaz in ('PagoSimpleVb') then
                v_filtro = ' pagsim.estado not in (''borrador'',''finalizado'') and ';

                if p_administrador != 1  then
                    --v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                    v_filtro = v_filtro||'(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') and ';
                end if;

            end if;


            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_pago_simple)
                        from cd.tpago_simple pagsim
                        inner join wf.testado_wf ew on ew.id_estado_wf = pagsim.id_estado_wf
                        inner join segu.tusuario usu1 on usu1.id_usuario = pagsim.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = pagsim.id_usuario_mod
                        inner join param.tdepto dep on dep.id_depto = pagsim.id_depto_conta
                        inner join orga.vfuncionario fun on fun.id_funcionario = pagsim.id_funcionario
                        left join tes.tcuenta_bancaria cban on cban.id_cuenta_bancaria = pagsim.id_cuenta_bancaria
                        left join param.tdepto deplb on deplb.id_depto = pagsim.id_depto_lb
                        left join param.tinstitucion ins on ins.id_institucion = cban.id_institucion
                        inner join param.tmoneda mon on mon.id_moneda = pagsim.id_moneda
                        left join param.vproveedor pro on pro.id_proveedor = pagsim.id_proveedor
                        inner join cd.ttipo_pago_simple tps on tps.id_tipo_pago_simple = pagsim.id_tipo_pago_simple
                        left join orga.vfuncionario fun1 on fun1.id_funcionario = pagsim.id_funcionario_pago
                        left join tes.tobligacion_pago op on op.id_obligacion_pago = pagsim.id_obligacion_pago
                        left join tes.tcaja caj on caj.id_caja = pagsim.id_caja
                        left join param.vproveedor prov on prov.id_proveedor = op.id_proveedor
                        where ';

            v_consulta = v_consulta || v_filtro;

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
    /*********************************
    #TRANSACCION:  'CD_DEPASIMPLE_SEL'
    #DESCRIPCION:   Consulta de datos
    #AUTOR:     JUAN
    #FECHA:     20-01-2018 12:33:30
    ***********************************/

    ELSIF(p_transaccion='CD_DEPASIMPLE_SEL')then

        begin

            --raise exception 'error provocado %',v_parametros.id_pago_simple;
            --Sentencia de la consulta
            v_consulta:='select
                         id_doc_compra_venta::integer,
                         tipo::Varchar,
                         fecha::date,
                         nit::varchar,
                         razon_social::Varchar,
                         COALESCE(nro_documento::varchar, ''0'')::Varchar as nro_documento,
                         COALESCE(nro_dui::varchar, ''0'')::Varchar as nro_dui,
                         nro_autorizacion::Varchar,
                         importe_doc::numeric,
                         total_excento::numeric,
                         sujeto_cf::numeric,
                         importe_descuento::numeric,
                         subtotal::numeric,
                         credito_fiscal::numeric,
                         importe_iva::numeric,
                         codigo_control::varchar,
                         --tipo_doc::varchar,
                         id_plantilla::integer,
                         id_moneda::integer,
                         codigo_moneda::Varchar,
                         id_periodo::integer,
                         id_gestion::integer,
                         periodo::integer,
                         gestion::integer,
                         venta_gravada_cero::numeric,
                         subtotal_venta::numeric,
                         sujeto_df::numeric,
                         importe_ice::numeric,
                         importe_excento::numeric

                         from conta.vldet_doc_pag_simple
                         where  id_pago_simple='||v_parametros.id_pago_simple||'  ';

        RAISE NOTICE 'ver consulta juan %',v_consulta;
            --Definicion de la respuesta
            --v_consulta:=v_consulta||v_parametros.filtro;
            --v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --raise exception 'error provocado %',v_consulta;
            --Devuelve la respuesta
            return v_consulta;

        end;

	/*********************************
 	#TRANSACCION:  'CD_DCV_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CD_DCV_SEL')then

    	begin

            v_filtro = ' 0 = 0 and ';

            IF  pxp.f_existe_parametro(p_tabla, 'nombre_vista') THEN
                IF v_parametros.nombre_vista = 'DocCompraPS' THEN
                   v_filtro = ' dcv.sw_pgs = ''reg'' and  ';
                   IF  p_administrador != 1 THEN
                      v_filtro = v_filtro || ' dcv.id_usuario_reg = '||p_id_usuario|| ' and ';
                   END IF;

                END IF;
            END IF;

    		--Sentencia de la consulta
			v_consulta:='select
                        dcv.id_doc_compra_venta,
                        dcv.revisado,
                        dcv.movil,
                        dcv.tipo,
                        COALESCE(dcv.importe_excento,0)::numeric as importe_excento,
                        dcv.id_plantilla,
                        dcv.fecha,
                        dcv.nro_documento,
                        dcv.nit,
                        COALESCE(dcv.importe_ice,0)::numeric as importe_ice,
                        dcv.nro_autorizacion,
                        COALESCE(dcv.importe_iva,0)::numeric as importe_iva,
                        COALESCE(dcv.importe_descuento,0)::numeric as importe_descuento,
                        COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                        dcv.sw_contabilizar,
                        COALESCE(dcv.tabla_origen,''ninguno'') as tabla_origen,
                        dcv.estado,
                        dcv.id_depto_conta,
                        dcv.id_origen,
                        dcv.obs,
                        dcv.estado_reg,
                        dcv.codigo_control,
                        COALESCE(dcv.importe_it,0)::numeric as importe_it,
                        dcv.razon_social,
                        dcv.id_usuario_ai,
                        dcv.id_usuario_reg,
                        dcv.fecha_reg,
                        dcv.usuario_ai,
                        dcv.id_usuario_mod,
                        dcv.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        dep.nombre as desc_depto,
                        pla.desc_plantilla,
                        COALESCE(dcv.importe_descuento_ley,0)::numeric as importe_descuento_ley,
                        COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,
                        dcv.nro_dui,
                        dcv.id_moneda,
                        mon.codigo as desc_moneda,
                        dcv.id_int_comprobante,
                        COALESCE(dcv.nro_tramite,''''),
                        COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante,
                        COALESCE(dcv.importe_pendiente,0)::numeric as importe_pendiente,
                        COALESCE(dcv.importe_anticipo,0)::numeric as importe_anticipo,
                        COALESCE(dcv.importe_retgar,0)::numeric as importe_retgar,
                        COALESCE(dcv.importe_neto,0)::numeric as importe_neto,
                        aux.id_auxiliar,
                        aux.codigo_auxiliar,
                        aux.nombre_auxiliar,
                        dcv.id_tipo_doc_compra_venta,
                        (tdcv.codigo||'' - ''||tdcv.nombre)::Varchar as desc_tipo_doc_compra_venta,
                        (dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0))     as importe_aux_neto,
                        fun.id_funcionario,
                        fun.desc_funcionario2::varchar,
                        ic.fecha as fecha_cbte,
                        ic.estado_reg as estado_cbte,
                        COALESCE(dcv.codigo_aplicacion,'''') as  codigo_aplicacion,
                        pla.tipo_informe,
                        dcv.id_doc_compra_venta_fk,
                        dcv.nota_debito_agencia,
                        dcv.consumido
						from conta.tdoc_compra_venta dcv
                        inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                        inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                        inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                        inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                        left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                        left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                        left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                        left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                        left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
				        where '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;
            --raise EXCEPTION '%',v_consulta;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;

		end;
        
    /*********************************
 	#TRANSACCION:  'CD_DCV_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		18-08-2015 15:57:09
	***********************************/

	elsif(p_transaccion='CD_DCV_CONT')then

		begin

            v_filtro = ' 0 = 0 and ';

            IF  pxp.f_existe_parametro(p_tabla,'nombre_vista') THEN
              IF v_parametros.nombre_vista = 'DocCompraPS' THEN
                 v_filtro = '  dcv.sw_pgs = ''reg''   and   ';
                 IF  p_administrador != 1 THEN
                    v_filtro = v_filtro || ' dcv.id_usuario_reg = '||p_id_usuario|| ' and ';
                 END IF;
              END IF;
            END IF;

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                              count(dcv.id_doc_compra_venta),
                              COALESCE(sum(dcv.importe_ice),0)::numeric  as total_importe_ice,
                              COALESCE(sum(dcv.importe_excento),0)::numeric  as total_importe_excento,
                              COALESCE(sum(dcv.importe_it),0)::numeric  as total_importe_it,
                              COALESCE(sum(dcv.importe_iva),0)::numeric  as total_importe_iva,
                              COALESCE(sum(dcv.importe_descuento),0)::numeric  as total_importe_descuento,
                              COALESCE(sum(dcv.importe_doc),0)::numeric  as total_importe_doc,
                              COALESCE(sum(dcv.importe_retgar),0)::numeric  as total_importe_retgar,
                              COALESCE(sum(dcv.importe_anticipo),0)::numeric  as total_importe_anticipo,
                              COALESCE(sum(dcv.importe_pendiente),0)::numeric  as tota_importe_pendiente,
                              COALESCE(sum(dcv.importe_neto),0)::numeric  as total_importe_neto,
                              COALESCE(sum(dcv.importe_descuento_ley),0)::numeric  as total_importe_descuento_ley,
                              COALESCE(sum(dcv.importe_pago_liquido),0)::numeric  as total_importe_pago_liquido,
                              COALESCE(sum(dcv.importe_doc -  COALESCE(dcv.importe_descuento,0) - COALESCE(dcv.importe_excento,0)),0) as total_importe_aux_neto
						from conta.tdoc_compra_venta dcv
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                          left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
				        where  '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;    
	
    
    else

        raise exception 'Transaccion inexistente';

    end if;

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
PARALLEL UNSAFE
COST 100;