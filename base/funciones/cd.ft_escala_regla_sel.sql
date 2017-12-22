CREATE OR REPLACE FUNCTION "cd"."ft_escala_regla_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_escala_regla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tescala_regla'
 AUTOR: 		 (admin)
 FECHA:	        15-11-2017 18:38:10
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-11-2017 18:38:10								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tescala_regla'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_escala_regla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_REGLA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		15-11-2017 18:38:10
	***********************************/

	if(p_transaccion='CD_REGLA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						regla.id_escala_regla,
						regla.valor,
						regla.id_escala,
						regla.estado_reg,
						regla.nombre,
						regla.id_concepto_ingas,
						regla.id_unidad_medida,
						regla.codigo,
						regla.id_usuario_reg,
						regla.fecha_reg,
						regla.usuario_ai,
						regla.id_usuario_ai,
						regla.fecha_mod,
						regla.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						um.codigo as desc_unidad_medida,
						cig.desc_ingas
						from cd.tescala_regla regla
						inner join segu.tusuario usu1 on usu1.id_usuario = regla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = regla.id_usuario_mod
						left join param.tunidad_medida um
						on um.id_unidad_medida = regla.id_unidad_medida
						left join param.tconcepto_ingas cig
						on cig.id_concepto_ingas = regla.id_concepto_ingas
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_REGLA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		15-11-2017 18:38:10
	***********************************/

	elsif(p_transaccion='CD_REGLA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_escala_regla)
					    from cd.tescala_regla regla
					    inner join segu.tusuario usu1 on usu1.id_usuario = regla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = regla.id_usuario_mod
						left join param.tunidad_medida um
						on um.id_unidad_medida = regla.id_unidad_medida
						left join param.tconcepto_ingas cig
						on cig.id_concepto_ingas = regla.id_concepto_ingas
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
ALTER FUNCTION "cd"."ft_escala_regla_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
