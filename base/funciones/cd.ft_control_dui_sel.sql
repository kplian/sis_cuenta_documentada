--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_control_dui_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_control_dui_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcontrol_dui'
 AUTOR: 		 (jjimenez)
 FECHA:	        13-09-2018 15:32:16
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 #ISSUE				FECHA				AUTOR				DESCRIPCION
 #1 ENDETR			13-09-2018 15:32:16	Juan       		    Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcontrol_dui'	
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
 	#TRANSACCION:  'CD_CDUI_SEL'    #1 ENDETR
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 15:32:16
	***********************************/

	if(p_transaccion='CD_CDUI_SEL')then
     				
    	begin
    		--Sentencia de la consulta
            
            /*if v_parametros.cmbFiltro='tram_comi_agencia' then
               v_consulta:= ' (cdui.tramite_comision_agencia = '''' or cdui.tramite_comision_agencia is null  )';
            end if;*/
            
        
			v_consulta:='select
						cdui.id_control_dui,
						cdui.tramite_anticipo_dui,
						cdui.dui,
						cdui.archivo_comision,
						cdui.nro_comprobante_diario_dui,
						cdui.archivo_dui,
						cdui.nro_comprobante_diario_comision,
						cdui.nro_comprobante_pago_dui,
						cdui.estado_reg,
						cdui.monto_comision,
						cdui.tramite_pedido_endesis,
						cdui.monto_dui,
						cdui.nro_factura_proveedor,
						cdui.tramite_comision_agencia,
						cdui.pedido_sap,
						ad.nombre as agencia_despachante,
						cdui.nro_comprobante_pago_comision,
						cdui.fecha_reg,
						cdui.usuario_ai,
						cdui.id_usuario_reg,
						cdui.id_usuario_ai,
						cdui.fecha_mod,
						cdui.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        --ad.nombre::varchar as nombre_agencia_despachante,
                        cdui.id_agencia_despachante	,
                        cdui.observaciones::text,
                        (select pg.id_proceso_wf from cd.tpago_simple pg where pg.nro_tramite=cdui.tramite_anticipo_dui limit 1)::integer as id_proceso_wf,
                        (select pg.id_proceso_wf from cd.tpago_simple pg where pg.nro_tramite=cdui.tramite_comision_agencia limit 1)::integer as id_proceso_wf_comision
						from cd.tcontrol_dui cdui
						inner join segu.tusuario usu1 on usu1.id_usuario = cdui.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdui.id_usuario_mod
                        join cd.tagencia_despachante ad on ad.id_agencia_despachante=cdui.id_agencia_despachante
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            --raise notice 'eee %',v_consulta;
            --raise EXCEPTION 'aa %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;
	/*********************************    
 	#TRANSACCION:  'CD_CDUI_REPORTE_SEL' #1  ENDETR
 	#DESCRIPCION:	Consulta de datos para reporte de Dui
 	#AUTOR:		jjimenez	
 	#FECHA:		18-12-2018 15:32:16
	***********************************/

	elsif(p_transaccion='CD_CDUI_REPORTE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
            
            /*if v_parametros.cmbFiltro='tram_comi_agencia' then
               v_consulta:= ' (cdui.tramite_comision_agencia = '''' or cdui.tramite_comision_agencia is null  )';
            end if;*/
            
			v_consulta:='select
						cdui.id_control_dui,
						cdui.tramite_anticipo_dui,
						cdui.dui,
						cdui.archivo_comision,
						cdui.nro_comprobante_diario_dui,
						cdui.archivo_dui,
						cdui.nro_comprobante_diario_comision,
						cdui.nro_comprobante_pago_dui,
						cdui.estado_reg,
						cdui.monto_comision,
						cdui.tramite_pedido_endesis,
						cdui.monto_dui,
						cdui.nro_factura_proveedor,
						cdui.tramite_comision_agencia,
						cdui.pedido_sap,
						ad.nombre as agencia_despachante,
						cdui.nro_comprobante_pago_comision,
						cdui.fecha_reg,
						cdui.usuario_ai,
						cdui.id_usuario_reg,
						cdui.id_usuario_ai,
						cdui.fecha_mod,
						cdui.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        --ad.nombre::varchar as nombre_agencia_despachante,
                        cdui.id_agencia_despachante	,
                        cdui.observaciones::text,
                        (select pg.id_proceso_wf from cd.tpago_simple pg where pg.nro_tramite=cdui.tramite_anticipo_dui limit 1)::integer as id_proceso_wf,
                        (select pg.id_proceso_wf from cd.tpago_simple pg where pg.nro_tramite=cdui.tramite_comision_agencia limit 1)::integer as id_proceso_wf_comision
						from cd.tcontrol_dui cdui
						inner join segu.tusuario usu1 on usu1.id_usuario = cdui.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdui.id_usuario_mod
                        join cd.tagencia_despachante ad on ad.id_agencia_despachante=cdui.id_agencia_despachante
				        where  ';
			
			v_consulta:=v_consulta||v_parametros.filtro||' order by id_control_dui';

            --raise notice 'eee %',v_consulta;
            --raise EXCEPTION 'aa %',v_consulta;

			return v_consulta;
						
		end;
	/*********************************    
 	#TRANSACCION:  'CD_CDUI_CONT'   #1  ENDETR
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 15:32:16
	***********************************/

	elsif(p_transaccion='CD_CDUI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_control_dui)
					    from cd.tcontrol_dui cdui
					    inner join segu.tusuario usu1 on usu1.id_usuario = cdui.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cdui.id_usuario_mod
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