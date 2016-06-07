--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_bloqueo_cd_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_bloqueo_cd_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tbloqueo_cd'
 AUTOR: 		 (admin)
 FECHA:	        06-06-2016 16:40:35
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

	v_nombre_funcion = 'cd.ft_bloqueo_cd_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_BLOCD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		06-06-2016 16:40:35
	***********************************/

	if(p_transaccion='CD_BLOCD_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            blocd.id_bloqueo_cd,
                            blocd.id_tipo_cuenta_doc,
                            blocd.estado_reg,
                            blocd.estado,
                            blocd.id_funcionario,
                            blocd.fecha_reg,
                            blocd.usuario_ai,
                            blocd.id_usuario_reg,
                            blocd.id_usuario_ai,
                            blocd.fecha_mod,
                            blocd.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,	
                            fun.desc_funcionario1 as desc_funcionario,
                            tcd.descripcion	as desc_tipo_cuenta_doc
                        from cd.tbloqueo_cd blocd
                        inner join orga.vfuncionario fun on fun.id_funcionario = blocd.id_funcionario
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = blocd.id_tipo_cuenta_doc
                        inner join segu.tusuario usu1 on usu1.id_usuario = blocd.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = blocd.id_usuario_mod  
                        WHERE  blocd.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_BLOCD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		06-06-2016 16:40:35
	***********************************/

	elsif(p_transaccion='CD_BLOCD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select 
            					count(id_bloqueo_cd)
					    from cd.tbloqueo_cd blocd
                        inner join orga.vfuncionario fun on fun.id_funcionario = blocd.id_funcionario
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = blocd.id_tipo_cuenta_doc
                        inner join segu.tusuario usu1 on usu1.id_usuario = blocd.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = blocd.id_usuario_mod 
                        WHERE blocd.estado_reg = ''activo'' and ';
			
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