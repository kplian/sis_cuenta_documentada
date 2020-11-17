--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_agencia_despachante_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_agencia_despachante_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tagencia_despachante'
 AUTOR: 		 (jjimenez)
 FECHA:	        13-09-2018 17:45:23
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #1 ENDETR		13-09-2018 17:45:23		Juan				Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tagencia_despachante'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_agencia_despachante_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_AGEDES_SEL'  #1 ENDETR
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 17:45:23
	***********************************/

	if(p_transaccion='CD_AGEDES_SEL')then
					
		begin
			--Sentencia de la consulta
			v_consulta:='select
						agedes.id_agencia_despachante,
						agedes.estado_reg,
						agedes.codigo,
						agedes.nombre,
						agedes.fecha_reg,
						agedes.usuario_ai,
						agedes.id_usuario_reg,
						agedes.id_usuario_ai,
						agedes.id_usuario_mod,
						agedes.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from cd.tagencia_despachante agedes
						inner join segu.tusuario usu1 on usu1.id_usuario = agedes.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = agedes.id_usuario_mod

				        where agedes.estado_reg=''activo'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_AGEDES_CONT'  #1 ENDETR
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 17:45:23
	***********************************/

	elsif(p_transaccion='CD_AGEDES_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_agencia_despachante)
					    from cd.tagencia_despachante agedes
					    inner join segu.tusuario usu1 on usu1.id_usuario = agedes.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = agedes.id_usuario_mod
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
COST 100;