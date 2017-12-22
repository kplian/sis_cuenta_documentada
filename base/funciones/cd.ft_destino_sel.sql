CREATE OR REPLACE FUNCTION "cd"."ft_destino_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_destino_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tdestino'
 AUTOR: 		 (admin)
 FECHA:	        04-09-2017 15:10:59
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

	v_nombre_funcion = 'cd.ft_destino_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_DEST_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 15:10:59
	***********************************/

	if(p_transaccion='CD_DEST_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						dest.id_destino,
						dest.codigo,
						dest.estado_reg,
						dest.descripcion,
						dest.nombre,
						dest.id_usuario_reg,
						dest.fecha_reg,
						dest.usuario_ai,
						dest.id_usuario_ai,
						dest.fecha_mod,
						dest.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						dest.tipo,
						dest.id_escala
						from cd.tdestino dest
						inner join segu.tusuario usu1 on usu1.id_usuario = dest.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dest.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_DEST_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 15:10:59
	***********************************/

	elsif(p_transaccion='CD_DEST_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_destino)
					    from cd.tdestino dest
					    inner join segu.tusuario usu1 on usu1.id_usuario = dest.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = dest.id_usuario_mod
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
ALTER FUNCTION "cd"."ft_destino_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
