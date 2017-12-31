CREATE OR REPLACE FUNCTION "cd"."ft_cuenta_doc_det_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_cuenta_doc_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcuenta_doc_det'
 AUTOR: 		 (admin)
 FECHA:	        05-09-2017 17:54:29
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

	v_nombre_funcion = 'cd.ft_cuenta_doc_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		05-09-2017 17:54:29
	***********************************/

	if(p_transaccion='CD_CDET_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cdet.id_cuenta_doc_det,
						cdet.id_cuenta_doc,
						cdet.monto_mb,
						cdet.id_centro_costo,
						cdet.id_concepto_ingas,
						cdet.id_partida,
						cdet.monto_mo,
						cdet.estado_reg,
						cdet.id_usuario_ai,
						cdet.usuario_ai,
						cdet.fecha_reg,
						cdet.id_usuario_reg,
						cdet.fecha_mod,
						cdet.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cdet.id_moneda,
						cdet.id_moneda_mb,
						mon.moneda,
						mon1.moneda as moneda_mb,
						cc.descripcion_tcc,
						cing.desc_ingas,
						par.codigo || '' - '' || par.nombre_partida as desc_partida,
						cc.codigo_cc as desc_cc,
						ges.gestion
						from cd.tcuenta_doc_det cdet
						inner join segu.tusuario usu1 on usu1.id_usuario = cdet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdet.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda = cdet.id_moneda
						inner join param.tmoneda mon1 on mon1.id_moneda = cdet.id_moneda_mb
						inner join param.vcentro_costo cc on cc.id_centro_costo = cdet.id_centro_costo
						inner join param.tconcepto_ingas cing on cing.id_concepto_ingas = cdet.id_concepto_ingas
						inner join pre.tpartida par on par.id_partida = cdet.id_partida
						inner join param.tgestion ges on ges.id_gestion = par.id_gestion
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-09-2017 17:54:29
	***********************************/

	elsif(p_transaccion='CD_CDET_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cuenta_doc_det),
						coalesce(sum(cdet.monto_mo),0)::numeric as total_monto_mo,
						coalesce(sum(cdet.monto_mb),0)::numeric as total_monto_mb
					    from cd.tcuenta_doc_det cdet
					    inner join segu.tusuario usu1 on usu1.id_usuario = cdet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdet.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda = cdet.id_moneda
						inner join param.tmoneda mon1 on mon1.id_moneda = cdet.id_moneda_mb
						inner join param.vcentro_costo cc on cc.id_centro_costo = cdet.id_centro_costo
						inner join param.tconcepto_ingas cing on cing.id_concepto_ingas = cdet.id_concepto_ingas
						inner join pre.tpartida par on par.id_partida = cdet.id_partida
						inner join param.tgestion ges on ges.id_gestion = par.id_gestion
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
ALTER FUNCTION "cd"."ft_cuenta_doc_det_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
