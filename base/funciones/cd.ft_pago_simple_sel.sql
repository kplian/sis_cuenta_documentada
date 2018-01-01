--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_pago_simple_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_pago_simple_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple'
 AUTOR: 		 (admin)
 FECHA:	        31-12-2017 12:33:30
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-12-2017 12:33:30								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tpago_simple'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
	v_estado			varchar;
	v_filtro			varchar;
	v_historico			varchar;
	v_inner 			varchar;
    v_strg_cd 			varchar;
    v_strg_obs			varchar;
			    
BEGIN

	v_nombre_funcion = 'cd.ft_pago_simple_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_PAGSIM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		31-12-2017 12:33:30
	***********************************/

	if(p_transaccion='CD_PAGSIM_SEL')then
     				
    	begin

			/*if pxp.f_existe_parametro(p_tabla,'estado') then
				v_estado =  v_parametros.estado;
			else
				v_estado = 'ninguno';
			end if;

			v_filtro='';
			if (v_parametros.id_funcionario_usu is null) then
				v_parametros.id_funcionario_usu = -1;
			end if;

			if  pxp.f_existe_parametro(p_tabla,'historico') then
				v_historico =  v_parametros.historico;
			else
				v_historico = 'no';
			end if;

			if v_parametros.tipo_interfaz in ('PagoSol') then

                if p_administrador != 1  then
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                end if;

            end if;

			if v_parametros.tipo_interfaz in ('PagoSimpleVb') then

				select  
				pxp.aggarray(depu.id_depto)
				into 
				va_id_depto
				from param.tdepto_usuario depu 
				where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';

				if v_historico = 'no' then  
					if p_administrador !=1 then
					  	v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||') and pagsim.estado in( ''vbtesoreria''))  ) and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
					else
					  	v_filtro = ' (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
					end if;
				else
					if p_administrador !=1 then
					  	v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and  (lower(cdoc.estado)!=''borrador'')  and ';
					else
					  	v_filtro = ' (lower(cdoc.estado)!=''borrador'')  and ';
					end if;

				end if;

			end if;

			if v_historico =  'si' then            
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = pagsim.id_proceso_wf';
               v_strg_cd = 'DISTINCT(pagsim.id_pago_simple)'; 
               v_strg_obs = '''---''::text';               
           	else            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = pagsim.id_estado_wf';
               v_strg_cd = 'pagsim.id_pago_simple';
               v_strg_obs = 'ew.obs'; 
           	end if;*/

           	--Filtros
           	v_filtro='';

           	if v_parametros.tipo_interfaz in ('PagoSol') then

                if p_administrador != 1  then
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                end if;

            elsif v_parametros.tipo_interfaz in ('PagoSimpleVb') then
                v_filtro = ' pagsim.estado not in (''borrador'',''finalizado'') and ';

                if p_administrador != 1  then
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                end if;

            end if;

    		--Sentencia de la consulta
			v_consulta:='select
						pagsim.id_pago_simple,
						pagsim.estado_reg,
						pagsim.id_depto_conta,
						pagsim.nro_tramite,
						pagsim.fecha,
						pagsim.id_funcionario,
						pagsim.estado,
						pagsim.id_estado_wf,
						pagsim.id_proceso_wf,
						pagsim.obs,
						pagsim.id_cuenta_bancaria,
						pagsim.id_depto_lb,
						pagsim.id_usuario_reg,
						pagsim.fecha_reg,
						pagsim.id_usuario_ai,
						pagsim.usuario_ai,
						pagsim.id_usuario_mod,
						pagsim.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						dep.codigo as desc_depto_conta,
						fun.desc_funcionario1 as desc_funcionario,
						(ins.nombre||'' - ''||cban.nro_cuenta)::varchar as desc_cuenta_bancaria,
						deplb.codigo as desc_depto_lb,
						pagsim.id_moneda,
						pagsim.id_proveedor,
						mon.codigo as desc_moneda,
						pro.desc_proveedor,
						pagsim.id_tipo_pago_simple,
						pagsim.id_funcionario_pago,
						fun1.desc_funcionario1 as desc_funcionario_pago,
						tps.codigo || '' - '' || tps.nombre as desc_tipo_pago_simple,
						tps.codigo as codigo_tipo_pago_simple
						from cd.tpago_simple pagsim
						inner join segu.tusuario usu1 on usu1.id_usuario = pagsim.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pagsim.id_usuario_mod
						inner join param.tdepto dep on dep.id_depto = pagsim.id_depto_conta
						inner join orga.vfuncionario fun on fun.id_funcionario = pagsim.id_funcionario
						left join tes.tcuenta_bancaria cban on cban.id_cuenta_bancaria = pagsim.id_cuenta_bancaria
						left join param.tdepto deplb on deplb.id_depto = pagsim.id_depto_lb
						left join param.tinstitucion ins on ins.id_institucion = cban.id_institucion
						inner join param.tmoneda mon on mon.id_moneda = pagsim.id_moneda
						left join param.vproveedor pro on pro.id_proveedor = pagsim.id_proveedor
						inner join cd.ttipo_pago_simple tps on tps.id_tipo_pago_simple = pagsim.id_tipo_pago_simple
						left join orga.vfuncionario fun1 on fun1.id_funcionario = pagsim.id_funcionario_pago
				        where  ';

			v_consulta = v_consulta || v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
	/*********************************    
 	#TRANSACCION:  'CD_DETPAG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		JUAN	
 	#FECHA:		07-01-2018 12:33:30
	***********************************/

	ELSIF(p_transaccion='CD_DETPAG_SEL')then
     				
    	begin

    		v_filtro='';
    		if v_parametros.tipo_interfaz in ('PagoSol') then

                if p_administrador != 1  then
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                end if;

            elsif v_parametros.tipo_interfaz in ('PagoSimpleVb') then
                v_filtro = ' pagsim.estado not in (''borrador'',''finalizado'') and ';

                if p_administrador != 1  then
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or pagsim.id_usuario_reg='||p_id_usuario||') and ';
                end if;

            end if;


    		--Sentencia de la consulta
			v_consulta:='SELECT 
                          cv.id_doc_compra_venta::INTEGER,
                          cv.id_funcionario::INTEGER,
                          (select vf.desc_funcionario1 from orga.tfuncionario f join orga.vfuncionario vf on vf.id_funcionario=f.id_funcionario where f.id_funcionario=cv.id_funcionario)::varchar desc_funcionario1,
                          cv.id_plantilla::INTEGER,
                          (select p.desc_plantilla from param.tplantilla p where  p.id_plantilla=cv.id_plantilla)::varchar desc_plantilla,
                          ps.id_proveedor::INTEGER,
                          (SELECT pr.rotulo_comercial from param.tproveedor pr where pr.id_proveedor=ps.id_proveedor)::VARCHAR rotulo_comercial,
                          cv.importe_pago_liquido::numeric,
                          cv.importe_excento::numeric,
                          cv.fecha::date fecha_compra_venta,
                          ps.fecha::date fecha_pago_simple,
                          cv.sw_pgs::varchar sw_pgs 
                          FROM conta.tdoc_compra_venta cv 
                          join cd.tpago_simple_det psd on psd.id_doc_compra_venta=cv.id_doc_compra_venta
                          join cd.tpago_simple ps on ps.id_pago_simple= psd.id_pago_simple
				        where  ';

			v_consulta = v_consulta || v_filtro;				        
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;
    /*********************************    
 	#TRANSACCION:  'CD_DETPAG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		JUAN	
 	#FECHA:		07-01-2018 12:33:30
	***********************************/

	elsif(p_transaccion='CD_DETPAG_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='SELECT 
                count(cv.id_funcionario)
                FROM conta.tdoc_compra_venta cv 
                join cd.tpago_simple_det psd on psd.id_doc_compra_venta=cv.id_doc_compra_venta
                join cd.tpago_simple ps on ps.id_pago_simple= psd.id_pago_simple
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
	/*********************************    
 	#TRANSACCION:  'CD_PAGSIM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		31-12-2017 12:33:30
	***********************************/

	elsif(p_transaccion='CD_PAGSIM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_pago_simple)
					    from cd.tpago_simple pagsim
					    inner join segu.tusuario usu1 on usu1.id_usuario = pagsim.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pagsim.id_usuario_mod
						inner join param.tdepto dep on dep.id_depto = pagsim.id_depto_conta
						inner join orga.vfuncionario fun on fun.id_funcionario = pagsim.id_funcionario
						left join tes.tcuenta_bancaria cban on cban.id_cuenta_bancaria = pagsim.id_cuenta_bancaria
						left join param.tdepto deplb on deplb.id_depto = pagsim.id_depto_lb
						left join param.tinstitucion ins on ins.id_institucion = cban.id_institucion
						inner join param.tmoneda mon on mon.id_moneda = pagsim.id_moneda
						left join param.vproveedor pro on pro.id_proveedor = pagsim.id_proveedor
						inner join cd.ttipo_pago_simple tps on tps.id_tipo_pago_simple = pagsim.id_tipo_pago_simple
						left join orga.vfuncionario fun1 on fun1.id_funcionario = pagsim.id_funcionario_pago
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