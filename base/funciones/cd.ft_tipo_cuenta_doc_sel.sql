--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_tipo_cuenta_doc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_tipo_cuenta_doc_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.ttipo_cuenta_doc'
 AUTOR: 		 (admin)
 FECHA:	        04-05-2016 20:13:26
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

	v_nombre_funcion = 'cd.ft_tipo_cuenta_doc_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_TCD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		04-05-2016 20:13:26
	***********************************/

	if(p_transaccion='CD_TCD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tcd.id_tipo_cuenta_doc,
						tcd.codigo,
						tcd.estado_reg,
						tcd.descripcion,
						tcd.nombre,
						tcd.fecha_reg,
						tcd.usuario_ai,
						tcd.id_usuario_reg,
						tcd.id_usuario_ai,
						tcd.fecha_mod,
						tcd.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from cd.ttipo_cuenta_doc tcd
						inner join segu.tusuario usu1 on usu1.id_usuario = tcd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tcd.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_TCD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2016 20:13:26
	***********************************/

	elsif(p_transaccion='CD_TCD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_cuenta_doc)
					    from cd.ttipo_cuenta_doc tcd
					    inner join segu.tusuario usu1 on usu1.id_usuario = tcd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tcd.id_usuario_mod
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