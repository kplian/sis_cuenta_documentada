CREATE OR REPLACE FUNCTION "cd"."ft_cuenta_doc_calculo_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_cuenta_doc_calculo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcuenta_doc_calculo'
 AUTOR: 		 (admin)
 FECHA:	        15-09-2017 13:16:03
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_cuenta_doc_calculo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDOCCA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		15-09-2017 13:16:03
	***********************************/

	if(p_transaccion='CD_CDOCCA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cdocca.id_cuenta_doc_calculo,
						cdocca.numero,
						cdocca.destino,
						cdocca.dias_saldo_ant,
						cdocca.dias_destino,
						cdocca.cobertura_sol,
						cdocca.cobertura_hotel_sol,
						cdocca.dias_total_viaje,
						cdocca.dias_aplicacion_regla,
						cdocca.hora_salida,
						cdocca.hora_llegada,
						cdocca.escala_viatico,
						cdocca.escala_hotel,
						cdocca.regla_cobertura_dias_acum,
						cdocca.regla_cobertura_hora_salida,
						cdocca.regla_cobertura_hora_llegada,
						cdocca.regla_cobertura_total_dias,
						cdocca.cobertura_aplicada,
						cdocca.cobertura_aplicada_hotel,
						cdocca.estado_reg,
						cdocca.id_cuenta_doc,
						cdocca.id_usuario_ai,
						cdocca.usuario_ai,
						cdocca.fecha_reg,
						cdocca.id_usuario_reg,
						cdocca.fecha_mod,
						cdocca.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cdocca.parcial_viatico,
						cdocca.parcial_hotel,
						cdocca.total_viatico,
						cdocca.dias_hotel,
						mon.codigo as desc_moneda,
						cdocca.cantidad_personas
						from cd.vcuenta_doc_calculo cdocca
						inner join segu.tusuario usu1 on usu1.id_usuario = cdocca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdocca.id_usuario_mod
						inner join cd.tcuenta_doc cdoc
						on cdoc.id_cuenta_doc = cdocca.id_cuenta_doc
						inner join param.tmoneda mon
						on mon.id_moneda = cdoc.id_moneda
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOCCA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2017 13:16:03
	***********************************/

	elsif(p_transaccion='CD_CDOCCA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
						count(id_cuenta_doc_calculo),
						coalesce(sum(cdocca.total_viatico),0)::numeric as total_viatico,
						coalesce(sum(cdocca.parcial_viatico),0)::numeric as parcial_viatico,
						coalesce(sum(cdocca.parcial_hotel),0)::numeric as parcial_hotel
					    from cd.vcuenta_doc_calculo cdocca
					    inner join segu.tusuario usu1 on usu1.id_usuario = cdocca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdocca.id_usuario_mod
						inner join cd.tcuenta_doc cdoc
						on cdoc.id_cuenta_doc = cdocca.id_cuenta_doc
						inner join param.tmoneda mon
						on mon.id_moneda = cdoc.id_moneda
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "cd"."ft_cuenta_doc_calculo_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
