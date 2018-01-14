CREATE OR REPLACE FUNCTION "cd"."ft_pago_simple_pro_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_pago_simple_pro_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple_pro'
 AUTOR: 		 (admin)
 FECHA:	        14-01-2018 21:26:07
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				14-01-2018 21:26:07								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple_pro'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_pago_simple_pro_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_PASIPR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		14-01-2018 21:26:07
	***********************************/

	if(p_transaccion='CD_PASIPR_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pasipr.id_pago_simple_pro,
						pasipr.factor,
						pasipr.estado_reg,
						pasipr.id_centro_costo,
						pasipr.id_partida,
						pasipr.id_concepto_ingas,
						pasipr.id_pago_simple,
						pasipr.id_usuario_reg,
						pasipr.fecha_reg,
						pasipr.usuario_ai,
						pasipr.id_usuario_ai,
						pasipr.id_usuario_mod,
						pasipr.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cc.codigo_cc as desc_cc,
						par.codigo || '' - '' || par.nombre_partida as desc_partida,
						cing.desc_ingas,
						ges.gestion
						from cd.tpago_simple_pro pasipr
						inner join segu.tusuario usu1 on usu1.id_usuario = pasipr.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pasipr.id_usuario_mod
						inner join param.tconcepto_ingas cing on cing.id_concepto_ingas = pasipr.id_concepto_ingas
						inner join pre.tpartida par on par.id_partida = pasipr.id_partida
						inner join param.tgestion ges on ges.id_gestion = par.id_gestion
						inner join param.vcentro_costo cc on cc.id_centro_costo = pasipr.id_centro_costo
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_PASIPR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2018 21:26:07
	***********************************/

	elsif(p_transaccion='CD_PASIPR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_pago_simple_pro)
					    from cd.tpago_simple_pro pasipr
					    inner join segu.tusuario usu1 on usu1.id_usuario = pasipr.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pasipr.id_usuario_mod
						inner join param.tconcepto_ingas cing on cing.id_concepto_ingas = pasipr.id_concepto_ingas
						inner join pre.tpartida par on par.id_partida = pasipr.id_partida
						inner join param.tgestion ges on ges.id_gestion = par.id_gestion
						inner join param.vcentro_costo cc on cc.id_centro_costo = pasipr.id_centro_costo
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
ALTER FUNCTION "cd"."ft_pago_simple_pro_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
