--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_categoria_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_categoria_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcategoria'
 AUTOR: 		 (admin)
 FECHA:	        05-05-2016 14:07:23
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

	v_nombre_funcion = 'cd.ft_categoria_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CAT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 14:07:23
	***********************************/

	if(p_transaccion='CD_CAT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            cat.id_categoria,
                            cat.nombre,
                            cat.id_moneda,
                            cat.codigo,
                            cat.monto,
                            cat.estado_reg,
                            cat.id_tipo_categoria,
                            cat.id_usuario_ai,
                            cat.usuario_ai,
                            cat.fecha_reg,
                            cat.id_usuario_reg,
                            cat.id_usuario_mod,
                            cat.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            mon.codigo as desc_moneda,
                            cat.id_destino,
                            dest.nombre,
                            cat.monto_sp,
                            cat.monto_hotel
                        from cd.tcategoria cat
                        inner join param.tmoneda mon on mon.id_moneda = cat.id_moneda
                        inner join segu.tusuario usu1 on usu1.id_usuario = cat.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = cat.id_usuario_mod
                        left join cd.tdestino dest on dest.id_destino = cat.id_destino
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CAT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 14:07:23
	***********************************/

	elsif(p_transaccion='CD_CAT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select 
                             count(id_categoria)
					     from cd.tcategoria cat
                         inner join param.tmoneda mon on mon.id_moneda = cat.id_moneda
                         inner join segu.tusuario usu1 on usu1.id_usuario = cat.id_usuario_reg
                         left join segu.tusuario usu2 on usu2.id_usuario = cat.id_usuario_mod
                         left join cd.tdestino dest on dest.id_destino = cat.id_destino
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