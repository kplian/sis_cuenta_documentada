--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_pago_simple_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_pago_simple_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple_det'
 AUTOR: 		 (admin)
 FECHA:	        01-01-2018 06:21:25
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				01-01-2018 06:21:25								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple_det'	
 #99            18-06-2018              RAC                 solucion BUG donde facturas pierden estado PROC  
 #ETR-779	29/09/2020		manuel guerra			mostrar nota de debitoe en grilla
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_pago_simple_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_PASIDE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		01-01-2018 06:21:25
	***********************************/

	if(p_transaccion='CD_PASIDE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						paside.id_pago_simple_det,
						paside.estado_reg,
						paside.id_pago_simple,
						paside.id_doc_compra_venta,
						paside.id_usuario_reg,
						paside.fecha_reg as fecha_reg_ps,
						paside.id_usuario_ai,
						paside.usuario_ai,
						paside.id_usuario_mod,
						paside.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,

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
                        dcv.codigo_control,
                        COALESCE(dcv.importe_it,0)::numeric as importe_it,
                        dcv.razon_social,
                        
                        dcv.fecha_reg,

                        usu3.cuenta as usr_reg_dcv,
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
                        dcv.sw_pgs,  --#99+
                        dcv.nota_debito_agencia  --#ETR-779
                        

						from cd.tpago_simple_det paside
						inner join segu.tusuario usu1 on usu1.id_usuario = paside.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = paside.id_usuario_mod

						inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = paside.id_doc_compra_venta
						inner join segu.tusuario usu3 on usu3.id_usuario = dcv.id_usuario_reg
						inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
						inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
						inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
						left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
						left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante                         
						left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                        left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
				        
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_PASIDE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		01-01-2018 06:21:25
	***********************************/

	elsif(p_transaccion='CD_PASIDE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_pago_simple_det),
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
					    from cd.tpago_simple_det paside
						inner join segu.tusuario usu1 on usu1.id_usuario = paside.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = paside.id_usuario_mod

						inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = paside.id_doc_compra_venta
						inner join segu.tusuario usu3 on usu3.id_usuario = dcv.id_usuario_reg
						inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
						inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
						inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
						left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
						left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante                         
						left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                        left join orga.vfuncionario fun on fun.id_funcionario = dcv.id_funcionario
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

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