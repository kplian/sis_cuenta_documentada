CREATE OR REPLACE FUNCTION "cd"."ft_control_dui_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_control_dui_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcontrol_dui'
 AUTOR: 		 (jjimenez)
 FECHA:	        29-11-2018 20:36:19
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-11-2018 20:36:19								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcontrol_dui'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_control_dui_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CONDUI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:36:19
	***********************************/

	if(p_transaccion='CD_CONDUI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						condui.id_control_dui,
						condui.tramite_comision_agencia,
						condui.id_agencia_despachante,
						condui.monto_dui,
						condui.nro_comprobante_pago_dui,
						condui.dui,
						condui.nro_comprobante_diario_dui,
						condui.tramite_anticipo_dui,
						condui.monto_comision,
						condui.estado_reg,
						condui.archivo_dui,
						condui.observaciones,
						condui.archivo_comision,
						condui.pedido_sap,
						condui.nro_comprobante_diario_comision,
						condui.nro_factura_proveedor,
						condui.tramite_pedido_endesis,
						condui.nro_comprobante_pago_comision,
						condui.id_usuario_reg,
						condui.fecha_reg,
						condui.usuario_ai,
						condui.id_usuario_ai,
						condui.fecha_mod,
						condui.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from cd.tcontrol_dui condui
						inner join segu.tusuario usu1 on usu1.id_usuario = condui.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = condui.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CONDUI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:36:19
	***********************************/

	elsif(p_transaccion='CD_CONDUI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_control_dui)
					    from cd.tcontrol_dui condui
					    inner join segu.tusuario usu1 on usu1.id_usuario = condui.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = condui.id_usuario_mod
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
ALTER FUNCTION "cd"."ft_control_dui_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
