CREATE OR REPLACE FUNCTION "cd"."ft_cuenta_doc_prorrateo_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_cuenta_doc_prorrateo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcuenta_doc_prorrateo'
 AUTOR: 		 (admin)
 FECHA:	        05-12-2017 19:08:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-12-2017 19:08:39								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcuenta_doc_prorrateo'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_cuenta_doc_prorrateo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDPRO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		05-12-2017 19:08:39
	***********************************/

	if(p_transaccion='CD_CDPRO_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cdpro.id_cuenta_doc_prorrateo,
						cdpro.id_cuenta_doc,
						cdpro.id_centro_costo,
						cdpro.prorrateo,
						cdpro.estado_reg,
						cdpro.id_usuario_ai,
						cdpro.id_usuario_reg,
						cdpro.fecha_reg,
						cdpro.usuario_ai,
						cdpro.fecha_mod,
						cdpro.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cc.codigo_cc as desc_cc
						from cd.tcuenta_doc_prorrateo cdpro
						inner join segu.tusuario usu1 on usu1.id_usuario = cdpro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdpro.id_usuario_mod
						inner join param.vcentro_costo cc on cc.id_centro_costo = cdpro.id_centro_costo
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDPRO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-12-2017 19:08:39
	***********************************/

	elsif(p_transaccion='CD_CDPRO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
						count(id_cuenta_doc_prorrateo),
						coalesce(sum(cdpro.prorrateo),0)::numeric as total_prorrateo
					    from cd.tcuenta_doc_prorrateo cdpro
					    inner join segu.tusuario usu1 on usu1.id_usuario = cdpro.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdpro.id_usuario_mod
						inner join param.vcentro_costo cc on cc.id_centro_costo = cdpro.id_centro_costo
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDPRORES_SEL'
 	#DESCRIPCION:	Devuelve array del prorrateo resumido. Incluye: id_centro_costo, descripción centro de costo (desc_cc), prorrateo (factor)
 	#AUTOR:			RCM
 	#FECHA:			08/12/2017
	***********************************/

	elsif(p_transaccion='CD_CDPRORES_SEL')then
					
        begin
        	
        	--Verificación de existencia de cuenta doc
        	if not exists(select 1 from cd.tcuenta_doc
        				where id_cuenta_doc = v_parametros.id_cuenta_doc) then
        		raise exception 'Cuenta documentada no encontrada';
        	end if;

        	--Obtención del prorrateo
        	v_consulta = 'select
			        	cp.id_centro_costo, cc.descripcion_tcc, cp.prorrateo as factor
			        	from cd.tcuenta_doc_prorrateo cp
			        	inner join param.vcentro_costo cc
			        	on cc.id_centro_costo = cp.id_centro_costo
			        	where cp.id_cuenta_doc = '|| v_parametros.id_cuenta_doc;
			

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
ALTER FUNCTION "cd"."ft_cuenta_doc_prorrateo_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
