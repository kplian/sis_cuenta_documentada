--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_cuenta_doc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_cuenta_doc_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcuenta_doc'
 AUTOR: 		 rac kplian
 FECHA:	        05-05-2016 16:41:21
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_consulta    			varchar;
	v_parametros  			record;
	v_nombre_funcion   		text;
	v_resp					varchar;
    v_inner					varchar;
    v_strg_obs				varchar;
    v_filtro				varchar;
    v_historico				varchar;
    v_strg_cd				varchar;
    v_importe_fac			varchar;
    v_estado				varchar;
    va_id_depto				integer[];
			    
BEGIN

	v_nombre_funcion = 'cd.ft_cuenta_doc_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDOC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/

	if(p_transaccion='CD_CDOC_SEL')then
     				
    	begin
        
        
           
           IF  pxp.f_existe_parametro(p_tabla,'estado') THEN
              v_estado =  v_parametros.estado;
           ELSE
              v_estado = 'ninguno';
           END IF;
           
           
           IF  v_estado in  ('entregados')  THEN
              v_importe_fac = 'COALESCE((select sum(COALESCE(dcv.importe_pago_liquido,0)) from cd.trendicion_det rd
                              inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                              where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric as importe_documentos,  ' ;
                              
              v_importe_fac = v_importe_fac ||'
                              COALESCE((select sum(COALESCE(lb.importe_deposito,0)) from tes.tts_libro_bancos lb
                              inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = ''id_cuenta_doc'' and lb.tabla = ''cd.tcuenta_doc''
                              where c.estado_reg = ''activo'' and c.id_cuenta_doc_fk = cdoc.id_cuenta_doc),0)::numeric as importe_documentos  ' ;                
           
           
           
           
           ELSE
              v_importe_fac =' 0::numeric as importe_documentos,
                               0::numeric as importe_depositos ';
           END IF;
           
           
           v_filtro='';
           IF (v_parametros.id_funcionario_usu is null) then
              	v_parametros.id_funcionario_usu = -1;
           END IF;
            
           IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
              v_historico =  v_parametros.historico;
           ELSE
              v_historico = 'no';
           END IF;
           
           
           IF v_parametros.tipo_interfaz = 'CuentaDocReg' THEN
        
               IF p_administrador != 1  THEN
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or cdoc.id_usuario_reg='||p_id_usuario||' or cdoc.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||') and ';
               END IF;
               
               v_filtro = v_filtro || ' tcd.sw_solicitud = ''si'' and ';
           
           END IF;
           
             
         
           
           IF  (v_parametros.tipo_interfaz) in ('CuentaDocVb') THEN
           
                --TODO ver lo usuarios miembros del departemento
                
                
                select  
                   pxp.aggarray(depu.id_depto)
                into 
                   va_id_depto
                from param.tdepto_usuario depu 
                where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';
                
                
            
               IF v_historico =  'no' THEN  
                  IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||') and cdoc.estado = ''vbtesoreria'')  ) and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
                  ELSE
                      v_filtro = '  (lower(cdoc.estado)!=''rendido'') and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
                  END IF;
                ELSE
                  IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and  (lower(cdoc.estado)!=''borrador'')  and ';
                  ELSE
                      v_filtro = '   (lower(cdoc.estado)!=''borrador'')  and ';
                  END IF;
                
                END IF;
                
              
          
           END IF;
            
           IF v_historico =  'si' THEN            
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = cdoc.id_proceso_wf';
               v_strg_cd = 'DISTINCT(cdoc.id_cuenta_doc)'; 
               v_strg_obs = '''---''::text';               
           ELSE            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf';
               v_strg_cd = 'cdoc.id_cuenta_doc';
               v_strg_obs = 'ew.obs'; 
           END IF;
           
          
          
            
    	  --Sentencia de la consulta
		  v_consulta:='select
                            '||v_strg_cd||',  
                            cdoc.id_tipo_cuenta_doc,
                            cdoc.id_proceso_wf,
                            cdoc.id_caja,
                            cdoc.nombre_cheque,
                            cdoc.id_uo,
                            cdoc.id_funcionario,
                            cdoc.tipo_pago,
                            cdoc.id_depto,
                            cdoc.id_cuenta_doc_fk,
                            cdoc.nro_tramite,
                            cdoc.motivo,
                            cdoc.fecha,
                            cdoc.id_moneda,
                            cdoc.estado,
                            cdoc.estado_reg,
                            cdoc.id_estado_wf,
                            cdoc.id_usuario_ai,
                            cdoc.usuario_ai,
                            cdoc.fecha_reg,
                            cdoc.id_usuario_reg,
                            cdoc.fecha_mod,
                            cdoc.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            mon.codigo as desc_moneda,
                            dep.nombre as desc_depto,
                            '||v_strg_obs||', 
                            fun.desc_funcionario1 as desc_funcionario,
                            cdoc.importe,
                            fcb.nro_cuenta as desc_funcionario_cuenta_bancaria,
                            cdoc.id_funcionario_cuenta_bancaria,
                            cdoc.id_depto_lb,
                            cdoc.id_depto_conta,
                            '||v_importe_fac||' ,
                            tcd.nombre as desc_tipo_cuenta_doc,
                            tcd.sw_solicitud
						from cd.tcuenta_doc cdoc
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                        inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                        '||v_inner||' 
						left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                        left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
                        where  cdoc.estado_reg = ''activo'' and '||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
           -- raise exception 'sss';
            raise NOTICE '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/
	elsif(p_transaccion='CD_CDOC_CONT')then

		begin
            v_filtro='';
           IF (v_parametros.id_funcionario_usu is null) then
              	v_parametros.id_funcionario_usu = -1;
           END IF;
            
           IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
              v_historico =  v_parametros.historico;
           ELSE
              v_historico = 'no';
           END IF;
           
           
           IF v_parametros.tipo_interfaz = 'CuentaDocReg' THEN
        
               IF p_administrador != 1  THEN
                    v_filtro = '(ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||'  or cdoc.id_usuario_reg='||p_id_usuario||' or cdoc.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||') and ';
               END IF;
               
               v_filtro = v_filtro || ' tcd.sw_solicitud = ''si'' and ';
           
           END IF;
           
             
         
           
           IF  (v_parametros.tipo_interfaz) in ('CuentaDocVb') THEN
           
                --TODO ver lo usuarios miembros del departemento
                
                
                select  
                   pxp.aggarray(depu.id_depto)
                into 
                   va_id_depto
                from param.tdepto_usuario depu 
                where depu.id_usuario =  p_id_usuario and depu.cargo = 'responsable';
                
                
            
               IF v_historico =  'no' THEN  
                  IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||') and cdoc.estado = ''vbrendicion'')  ) and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
                  ELSE
                      v_filtro = '  (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
                  END IF;
                ELSE
                  IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||')) and  (lower(cdoc.estado)!=''borrador'')  and ';
                  ELSE
                      v_filtro = '   (lower(cdoc.estado)!=''borrador'')  and ';
                  END IF;
                
                END IF;
                
              
          
           END IF;
            
           IF v_historico =  'si' THEN            
               v_inner =  'inner join wf.testado_wf ew on ew.id_proceso_wf = cdoc.id_proceso_wf';
               v_strg_cd = 'DISTINCT(cdoc.id_cuenta_doc)'; 
               v_strg_obs = '''---''::text';               
           ELSE            
               v_inner =  'inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf';
               v_strg_cd = 'cdoc.id_cuenta_doc';
               v_strg_obs = 'ew.obs'; 
           END IF;
           
          
        
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count('||v_strg_cd||')
					    from cd.tcuenta_doc cdoc
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                        inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                        '||v_inner||' 
						left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                        left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
      				    where  cdoc.estado_reg = ''activo'' and '||v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;
		end;
        
    /*********************************    
 	#TRANSACCION:  'CD_CDOCREN_SEL'
 	#DESCRIPCION:	Consulta de datos  rendicion
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/

	elseif(p_transaccion='CD_CDOCREN_SEL')then
     				
    	begin
        
        
           
           v_filtro='';
           IF (v_parametros.id_funcionario_usu is null) then
              	v_parametros.id_funcionario_usu = -1;
           END IF;
            
           
           IF  v_parametros.tipo_interfaz in ('CuentaDocRen') THEN
                IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||')  and ';
                END IF;
                v_filtro = v_filtro || ' tcd.sw_solicitud = ''no'' and ';
           END IF;
           
            
            
    	  --Sentencia de la consulta
		  v_consulta:='select
                            cdoc.id_cuenta_doc,  
                            cdoc.id_tipo_cuenta_doc,
                            cdoc.id_proceso_wf,
                            cdoc.id_caja,
                            cdoc.nombre_cheque,
                            cdoc.id_uo,
                            cdoc.id_funcionario,
                            cdoc.tipo_pago,
                            cdoc.id_depto,
                            cdoc.id_cuenta_doc_fk,
                            cdoc.nro_tramite,
                            cdoc.motivo,
                            cdoc.fecha,
                            cdoc.id_moneda,
                            cdoc.estado,
                            cdoc.estado_reg,
                            cdoc.id_estado_wf,
                            cdoc.id_usuario_ai,
                            cdoc.usuario_ai,
                            cdoc.fecha_reg,
                            cdoc.id_usuario_reg,
                            cdoc.fecha_mod,
                            cdoc.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            mon.codigo as desc_moneda,
                            dep.nombre as desc_depto,
                            ew.obs, 
                            fun.desc_funcionario1 as desc_funcionario,
                            cdoc.importe,
                            fcb.nro_cuenta as desc_funcionario_cuenta_bancaria,
                            cdoc.id_funcionario_cuenta_bancaria,
                            cdoc.id_depto_lb,
                            cdoc.id_depto_conta,
                            0::numeric as importe_documentos,
                            tcd.nombre as desc_tipo_cuenta_doc,
                            tcd.sw_solicitud
						from cd.tcuenta_doc cdoc
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                        inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                        inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf 
						left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                        left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
                        where  cdoc.estado_reg = ''activo'' and '||v_filtro;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
           -- raise exception 'sss';
            raise NOTICE '%', v_consulta;
			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOCREN_CONT'
 	#DESCRIPCION:	Conteo de registros de rendicion
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/
	elsif(p_transaccion='CD_CDOCREN_CONT')then

		begin
             v_filtro='';
             IF (v_parametros.id_funcionario_usu is null) then
                  v_parametros.id_funcionario_usu = -1;
             END IF;
              
             
             IF  lower(v_parametros.tipo_interfaz) in ('CuentaDocRen') THEN
                  IF p_administrador !=1 THEN
                        v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||')  and ';
                  END IF;
                  v_filtro = v_filtro || ' tcd.sw_solicitud = ''no'' and ';
             END IF;
        
        
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(cdoc.id_cuenta_doc)
					    from cd.tcuenta_doc cdoc
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                        inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                        inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf 
						left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                        left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
                        where  cdoc.estado_reg = ''activo'' and '||v_filtro;
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;
		end;    
        
    /*********************************    
 	#TRANSACCION:  'CD_REPCDOC_SEL'
 	#DESCRIPCION:	Cabecera de reporte de solicitud de fondos
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/

	elsif(p_transaccion='CD_REPCDOC_SEL')then
     				
    	begin
        
    	  --Sentencia de la consulta
		  v_consulta:='select
                            cdoc.id_cuenta_doc, 
                            cdoc.id_tipo_cuenta_doc,
                            cdoc.id_proceso_wf,
                            cdoc.id_caja,
                            cdoc.nombre_cheque,
                            cdoc.id_uo,
                            cdoc.id_funcionario,
                            cdoc.tipo_pago,
                            cdoc.id_depto,
                            cdoc.id_cuenta_doc_fk,
                            cdoc.nro_tramite,
                            cdoc.motivo,
                            cdoc.fecha,
                            cdoc.id_moneda,
                            cdoc.estado,
                            cdoc.estado_reg,
                            cdoc.id_estado_wf,
                            cdoc.id_usuario_ai,
                            cdoc.usuario_ai,
                            cdoc.fecha_reg,
                            cdoc.id_usuario_reg,
                            cdoc.fecha_mod,
                            cdoc.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            mon.codigo as desc_moneda,
                            dep.codigo as desc_depto,
                            ew.obs, 
                            fun.desc_funcionario1 as desc_funcionario,
                            cdoc.importe,
                            fcb.nro_cuenta as desc_funcionario_cuenta_bancaria,
                            cdoc.id_funcionario_cuenta_bancaria,
                            cdoc.id_depto_lb,
                            cdoc.id_depto_conta,
                            tcd.nombre as desc_tipo_cuenta_doc,
                            tcd.sw_solicitud,
                            (select l.nombre  
                            from param.tlugar l 
                            inner join orga.tcargo c on  c.id_lugar =  l.id_lugar
                            where  c.id_cargo = ANY (orga.f_get_cargo_x_funcionario(cdoc.id_funcionario  , cdoc.fecha , ''oficial'')))::varchar as lugar, 
                            orga.f_get_cargo_x_funcionario_str(cdoc.id_funcionario  , cdoc.fecha , ''oficial'') as cargo_funcionario,
                            uo.nombre_unidad,
                            pxp.f_convertir_num_a_letra(cdoc.importe)::varchar as importe_literal
						from cd.tcuenta_doc cdoc
                        inner join orga.tuo uo on uo.id_uo = cdoc.id_uo
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                        inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                        inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf
						left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                        left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
                          
                            
						where  cdoc.id_proceso_wf = '||v_parametros.id_proceso_wf;
			
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