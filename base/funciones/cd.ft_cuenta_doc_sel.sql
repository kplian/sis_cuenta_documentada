CREATE OR REPLACE FUNCTION cd.ft_cuenta_doc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:   Cuenta Documentada
 FUNCION:     cd.ft_cuenta_doc_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'cd.tcuenta_doc'
 AUTOR:      rac kplian
 FECHA:         05-05-2016 16:41:21
 COMENTARIOS: 
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION: 
 AUTOR:     
 FECHA:   
***************************************************************************/

DECLARE

    v_consulta          varchar;
    v_parametros        record;
    v_nombre_funcion    text;
    v_resp              varchar;
    v_inner             varchar;
    v_strg_obs          varchar;
    v_filtro            varchar;
    v_historico         varchar;
    v_strg_cd           varchar;
    v_importe_fac       varchar;
    v_estado            varchar;
    va_id_depto         integer[];
    v_cd_dias_entrega   varchar;
    v_gaf               varchar[];
    va_codigos          varchar[];
    v_ids               varchar;
    v_rec               record;
    v_id_cuenta_doc     integer;
    v_gestion           varchar;
          
BEGIN

    v_nombre_funcion = 'cd.ft_cuenta_doc_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
    #TRANSACCION:  'CD_CDOC_SEL'
    #DESCRIPCION: Consulta de datos
    #AUTOR:   admin 
    #FECHA:   05-05-2016 16:41:21
    ***********************************/

    if(p_transaccion='CD_CDOC_SEL')then
            
        begin

            v_cd_dias_entrega = pxp.f_get_variable_global('cd_dias_entrega');

            IF  pxp.f_existe_parametro(p_tabla,'estado') THEN
              v_estado =  v_parametros.estado;
            ELSE
              v_estado = 'ninguno';
            END IF;
           
         
              
          v_importe_fac = '
                              CASE WHEN  lower(cdoc.estado)!=''finalizado'' and sw_solicitud = ''si'' THEN
                               
                                 COALESCE((select sum(COALESCE(dcv.importe_pago_liquido + dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                                 inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                                 where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric   
                              
                              WHEN  lower(cdoc.estado)!=''rendido'' and sw_solicitud = ''no'' THEN
                               
                                 COALESCE((select sum(COALESCE(dcv.importe_pago_liquido + dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                                 inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                                 where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc),0)::numeric 
                              
                              ELSE
                                 0::numeric 
                              END  as  importe_documentos,
                              
                              ' ;
                              
            v_importe_fac = v_importe_fac ||'
                              CASE WHEN  lower(cdoc.estado)!=''finalizado'' and sw_solicitud = ''si''   THEN
                               COALESCE((select sum(COALESCE(dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                                 inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                                 where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric   
                              WHEN  lower(cdoc.estado)!=''rendido'' and sw_solicitud = ''no'' THEN
                                 COALESCE((select sum(COALESCE(dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                                 inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                                 where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc),0)::numeric 
                              ELSE
                                 0::numeric 
                              END  as  importe_retenciones,
                              
                              ' ;                  
                              
            v_importe_fac = v_importe_fac ||'
                              CASE WHEN  lower(cdoc.estado)!=''finalizado'' and sw_solicitud = ''si'' THEN
                               COALESCE((select sum(COALESCE(lb.importe_deposito,0)) from tes.tts_libro_bancos lb
                               inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = ''id_cuenta_doc'' and lb.tabla = ''cd.tcuenta_doc''
                                 where c.estado_reg = ''activo'' and c.id_cuenta_doc_fk = cdoc.id_cuenta_doc),0)::numeric  
                              WHEN  lower(cdoc.estado)!=''rendido'' and sw_solicitud = ''no'' THEN
                                 COALESCE((select sum(COALESCE(lb.importe_deposito,0)) from tes.tts_libro_bancos lb
                               inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = ''id_cuenta_doc'' and lb.tabla = ''cd.tcuenta_doc''
                                 where c.estado_reg = ''activo'' and c.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric  
                              
                              ELSE
                                 0::numeric 
                              END  as  importe_depositos
                              
                              ' ;                
           
           
            v_filtro='';
            IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
            END IF;

            IF  pxp.f_existe_parametro(p_tabla,'historico') THEN
                v_historico =  v_parametros.historico;
            ELSE
                v_historico = 'no';
            END IF;
           
           
            IF v_parametros.tipo_interfaz in ('CuentaDocReg','CuentaDocSol') THEN

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
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||') and cdoc.estado in( ''vbtesoreria'',''vbrendicion''))  ) and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
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
           
           IF  (v_parametros.tipo_interfaz) in ('CuentaDocVbContaCentral') THEN
                                       
               IF v_historico =  'no' THEN  
                  IF p_administrador !=1 THEN
                        v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or cdoc.id_usuario_reg = '||p_id_usuario||') and  (cdoc.estado in(''vbrendicion'',''borrador'')  ) and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''finalizado'' ) and cdoc.id_cuenta_doc_fk is not null and ';
                  ELSE
                        v_filtro = '  (lower(cdoc.estado)!=''rendido'') and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''finalizado'' ) and cdoc.id_cuenta_doc_fk is not null and ';
                  END IF;
                ELSE
                  IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or cdoc.id_usuario_reg = '||p_id_usuario||') and  (lower(cdoc.estado)!=''borrador'')  and cdoc.id_cuenta_doc_fk is not null and ';
                  ELSE
                      v_filtro = '   (lower(cdoc.estado)!=''borrador'')  and cdoc.id_cuenta_doc_fk is not null and ';
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
                --(cdoc.fecha_entrega::date - (now()::date) +'||v_cd_dias_entrega||' + pxp.f_get_weekend_days(cdoc.fecha_entrega::date,now()::date))::integer as dias_para_rendir,
                pxp.f_add_dias_fecha(cdoc.fecha_entrega,escr.valor::integer,''habiles'') - now()::date  as dias_para_rendir,
                pxp.f_add_dias_fecha(cdoc.fecha_entrega,escr.valor::integer,''habiles'') as max_fecha_rendicion,
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
                cdoc.fecha_entrega,
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
                tcd.nombre as tipo_cuenta_doc,
                tcd.sw_solicitud,
                cdoc.sw_max_doc_rend,
                COALESCE(cdoc.num_rendicion,'''') as num_rendicion,
                importe_total_rendido,
                cdoc.fecha_salida,
                cdoc.fecha_llegada,
                cdoc.tipo_viaje,
                cdoc.medio_transporte,
                tcd.codigo as codigo_tipo_cuenta_doc,
                cdoc.cobertura,
                cdoc.id_escala,
                esc.codigo as desc_escala,
                cdoc.id_centro_costo,
                cc.descripcion_tcc,
                caj.codigo as desc_caja,
                cdoc.id_solicitud_efectivo,
                cdoc.dev_tipo,
                cdoc.dev_a_favor_de,
                cdoc.dev_nombre_cheque,
                cdoc.id_caja_dev,
                cdoc.dev_saldo,
                se.nro_tramite as desc_sol_efectivo,
                cajdev.codigo as dev_caja,
                cdoc.tipo_sol_sigema,
                cdoc.id_sigema,
                cdoc.tipo_contrato,
                cdoc.cantidad_personas,
                cdoc.tipo_rendicion,
                cdoc.aplicar_regla_15
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
                inner join cd.tescala esc on esc.id_escala = cdoc.id_escala
                left join cd.tescala_regla escr on escr.id_escala = cdoc.id_escala and escr.codigo = ''DIAS_REND''
                left join param.vcentro_costo cc on cc.id_centro_costo = cdoc.id_centro_costo
                left join tes.tcaja caj on caj.id_caja = cdoc.id_caja
                left join tes.tsolicitud_efectivo se on se.id_solicitud_efectivo = cdoc.id_solicitud_efectivo
                left join tes.tcaja cajdev on cajdev.id_caja = cdoc.id_caja_dev
--                left join cd.vsigema_gral sigra on sigra.tipo_sol_sigema = cdoc.tipo_sol_sigema and sigra.id_sigema = cdoc.id_sigema--
                where cdoc.estado_reg = ''activo'' and '||v_filtro;
      
      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            raise notice '%', v_consulta;
      --Devuelve la respuesta
      return v_consulta;
            
    end;

  /*********************************    
  #TRANSACCION:  'CD_CDOC_CONT'
  #DESCRIPCION: Conteo de registros
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
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
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or   (ew.id_depto  in ('|| COALESCE(array_to_string(va_id_depto,','),'0')||') and cdoc.estado in( ''vbrendicion'',''vbtesoreria''))  ) and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''borrador'') and (lower(cdoc.estado)!=''finalizado'' ) and ';
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
           
           IF  (v_parametros.tipo_interfaz) in ('CuentaDocVbContaCentral') THEN
                                       
               IF v_historico =  'no' THEN  
                  IF p_administrador !=1 THEN
            v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or cdoc.id_usuario_reg = '||p_id_usuario||') and  (cdoc.estado in(''vbrendicion'',''borrador'')  ) and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''finalizado'' ) and cdoc.id_cuenta_doc_fk is not null and ';
                  ELSE
                      v_filtro = '  (lower(cdoc.estado)!=''rendido'') and (lower(cdoc.estado)!=''contabilizado'') and (lower(cdoc.estado)!=''finalizado'' ) and cdoc.id_cuenta_doc_fk is not null and ';
                  END IF;
                ELSE
                  IF p_administrador !=1 THEN
                      v_filtro = ' (ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||' or cdoc.id_usuario_reg = '||p_id_usuario||') and  (lower(cdoc.estado)!=''borrador'') and cdoc.id_cuenta_doc_fk is not null and ';
                  ELSE
                      v_filtro = '   (lower(cdoc.estado)!=''borrador'')  and cdoc.id_cuenta_doc_fk is not null and ';
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
            inner join cd.tescala esc on esc.id_escala = cdoc.id_escala
            left join cd.tescala_regla escr on escr.id_escala = cdoc.id_escala and escr.codigo = ''DIAS_REND''
            left join param.vcentro_costo cc on cc.id_centro_costo = cdoc.id_centro_costo
            left join tes.tcaja caj on caj.id_caja = cdoc.id_caja
            left join tes.tsolicitud_efectivo se on se.id_solicitud_efectivo = cdoc.id_solicitud_efectivo
            left join tes.tcaja cajdev on cajdev.id_caja = cdoc.id_caja_dev
           -- left join cd.vsigema_gral sigra on sigra.tipo_sol_sigema = cdoc.tipo_sol_sigema and sigra.id_sigema = cdoc.id_sigema
            where  cdoc.estado_reg = ''activo'' and '||v_filtro;
      
      --Definicion de la respuesta        
      v_consulta:=v_consulta||v_parametros.filtro;
      --Devuelve la respuesta
      return v_consulta;
    end;
        
  /*********************************    
  #TRANSACCION:  'CD_CDOCREN_SEL'
  #DESCRIPCION: Consulta de datos  rendicion
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
  ***********************************/

  elseif(p_transaccion='CD_CDOCREN_SEL')then
            
      begin
        
        
           
           v_filtro='';
           IF (v_parametros.id_funcionario_usu is null) then
                v_parametros.id_funcionario_usu = -1;
           END IF;
            
           
           IF  v_parametros.tipo_interfaz in ('CuentaDocRen') THEN
                
                select  
                   pxp.aggarray(depu.id_depto)
                into 
                   va_id_depto
                from param.tdepto_usuario depu 
                where depu.id_usuario =  p_id_usuario;-- and depu.cargo in ('responsable','auxiliar');
           
           
           
                IF p_administrador !=1 THEN
                      v_filtro = ' ((ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') or cdoc.id_usuario_reg='||p_id_usuario||' or cdoc.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||'  ) and ';
                END IF;

                v_filtro = v_filtro || ' tcd.sw_solicitud = ''no'' and ';
           END IF;
                     
           
           v_importe_fac = '
                             
                               COALESCE((select sum(COALESCE(dcv.importe_pago_liquido + dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                                 inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                                 where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc),0)::numeric   
                               as  importe_documentos,
                              
                              ' ;
                              
            v_importe_fac = v_importe_fac ||'
                              
                               COALESCE((select sum(COALESCE(dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                                 inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                                 where dcv.estado_reg = ''activo'' and rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc),0)::numeric   
                                as  importe_retenciones,
                              
                              ' ;                  
                              
            v_importe_fac = v_importe_fac ||'
                              
                               COALESCE((select sum(COALESCE(lb.importe_deposito,0)) from tes.tts_libro_bancos lb
                               inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = ''id_cuenta_doc'' and lb.tabla = ''cd.tcuenta_doc''
                                where c.estado_reg = ''activo'' and c.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric  
                                as  importe_depositos
                              
                              ' ;  
           
            
            
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
                             '||v_importe_fac||' ,
                            tcd.nombre as tipo_cuenta_doc,
                            tcd.sw_solicitud,
                            cdoc.nro_correspondencia,
                            COALESCE(cdoc.num_rendicion,'''') as num_rendicion,
                            cdo.importe::numeric as importe_solicitado,
                            cdo.importe_total_rendido::numeric,
                            cdoc.id_periodo,
                            pxp.f_obtener_literal_periodo(per.periodo,0) as periodo,
                            cdoc.fecha_salida,
                            cdoc.fecha_llegada,
                            cdoc.tipo_viaje,
                            cdoc.medio_transporte,
                            tcd.codigo as codigo_tipo_cuenta_doc,
                            cdoc.cobertura,
                            to_char(cdoc.hora_salida,''HH24:mm'')::varchar as hora_salida,
                            to_char(cdoc.hora_llegada,''HH24:mm'')::varchar as hora_llegada,
                            cdoc.id_plantilla,
                            pla.desc_plantilla,
                            cdoc.cantidad_personas,
                            cdoc.tipo_rendicion,
                            cdoc.aplicar_regla_15
            from cd.tcuenta_doc cdoc
            inner join cd.tcuenta_doc cdo on cdo.id_cuenta_doc = cdoc.id_cuenta_doc_fk
            inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
            inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
            inner join param.tdepto dep on dep.id_depto = cdoc.id_depto
            left join param.tperiodo per on per.id_periodo = cdoc.id_periodo 
            inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
            inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
            inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
            inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf 
            left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
            left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
            left join param.tplantilla pla on pla.id_plantilla = cdoc.id_plantilla
            where  cdoc.estado_reg = ''activo'' and '||v_filtro;
      
      --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
           -- raise exception 'sss';
            raise notice '%', v_consulta;
      --Devuelve la respuesta
      return v_consulta;
            
    end;

  /*********************************    
  #TRANSACCION:  'CD_CDOCREN_CONT'
  #DESCRIPCION: Conteo de registros de rendicion
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
  ***********************************/
  elsif(p_transaccion='CD_CDOCREN_CONT')then

    begin
             v_filtro='';
             IF (v_parametros.id_funcionario_usu is null) then
                  v_parametros.id_funcionario_usu = -1;
             END IF;
              
             
            IF  v_parametros.tipo_interfaz in ('CuentaDocRen') THEN
                IF p_administrador !=1 THEN
                      v_filtro = ' ((ew.id_funcionario='||v_parametros.id_funcionario_usu::varchar||') or cdoc.id_usuario_reg='||p_id_usuario||' or cdoc.id_funcionario = '||v_parametros.id_funcionario_usu::varchar||')and ';
                END IF;
                v_filtro = v_filtro || ' tcd.sw_solicitud = ''no'' and ';
            END IF;
           
        
        
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select count(cdoc.id_cuenta_doc)
                from cd.tcuenta_doc cdoc
                inner join cd.tcuenta_doc cdo on cdo.id_cuenta_doc = cdoc.id_cuenta_doc_fk
                inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
                inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf 
                left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
                left join param.tplantilla pla on pla.id_plantilla = cdoc.id_plantilla
                where  cdoc.estado_reg = ''activo'' and '||v_filtro;
      
      --Definicion de la respuesta        
      v_consulta:=v_consulta||v_parametros.filtro;
      --Devuelve la respuesta
      return v_consulta;
    end;    
    
    /*********************************    
  #TRANSACCION:  'CD_REPCD_SEL'
  #DESCRIPCION: Consulta de datos fondo en avance
  #AUTOR:   Gonzalo Sarmiento
  #FECHA:   04-11-2016 16:41:21
  ***********************************/

  elseif(p_transaccion='CD_REPCD_SEL')then
    
    
        v_filtro = ' 0=0 and';
    
    
        IF v_parametros.codigo_tipo_cuenta_doc = 'todos' THEN
             select
               pxp.list(tcd.id_tipo_cuenta_doc::varchar)
            into
              v_ids 
            from cd.ttipo_cuenta_doc tcd
            where  tcd.sw_solicitud = 'si';
        
        ELSE
        
            va_codigos =   string_to_array(v_parametros.codigo_tipo_cuenta_doc,',');
            v_ids = '0';
            select
               pxp.list(tcd.id_tipo_cuenta_doc::varchar)
            into
              v_ids 
            from cd.ttipo_cuenta_doc tcd
            where tcd.codigo =ANY(va_codigos);
        
        
        END IF;
        
        IF  pxp.f_existe_parametro(p_tabla,'estado')  THEN
             IF v_parametros.estado is not null and v_parametros.estado != '' THEN
                v_filtro = v_filtro||' estado = ANY( string_to_array('''||v_parametros.estado||''','','')) and ';
             END IF;
        END IF;
           
         IF  pxp.f_existe_parametro(p_tabla,'fuera_estado')  THEN
             IF v_parametros.fuera_estado is not null and v_parametros.fuera_estado != '' THEN
                v_filtro = v_filtro||' NOT (estado = ANY (string_to_array('''||v_parametros.fuera_estado||''','',''))) and ';
             END IF;
        END IF;
        
            
      begin          
        --Sentencia de la consulta
      v_consulta:='select  
                       v.id_cuenta_doc,
                               v.fecha,
                               v.fecha_entrega,
                               v.desc_funcionario1,
                               v.nro_tramite,
                               v.motivo,
                               v.nro_cheque,
                               v.importe_solicitado,
                               v.importe_cheque,
                               v.importe_documentos,
                               v.importe_depositos,
                               v.importe_cheque -(importe_documentos + importe_depositos) as saldo,
                               v.estado,
                               v.id_proceso_wf,
                               v.id_estado_wf
                        from cd.vcuenta_doc_revision v
                        where v.fecha_entrega between '''||v_parametros.fecha_ini::date ||''' and ''' ||v_parametros.fecha_fin::date ||'''
                             and v.id_tipo_cuenta_doc in ('||v_ids||') and '||v_filtro;
            
            IF v_parametros.id_funcionario != 0 THEN
              v_consulta := v_consulta || '  v.id_funcionario = ' || v_parametros.id_funcionario;
            END IF;
            
            raise notice  'consulta %', v_consulta;
            
      --Devuelve la respuesta
      return v_consulta;
            
    end;
        
        
      /*********************************    
  #TRANSACCION:  'CD_REPCD2_SEL'
  #DESCRIPCION: Consulta de datos fondo en avance
  #AUTOR:   Rensi Arteaga Copari 
  #FECHA:   25-08-2017 16:41:21
  ***********************************/

  elseif(p_transaccion='CD_REPCD2_SEL')then
    
    
        v_filtro = ' 0=0 and';
    
    
        IF v_parametros.codigo_tipo_cuenta_doc = 'todos' THEN
             select
               pxp.list(tcd.id_tipo_cuenta_doc::varchar)
            into
              v_ids 
            from cd.ttipo_cuenta_doc tcd
            where  tcd.sw_solicitud = 'si';
        
        ELSE
        
            va_codigos =   string_to_array(v_parametros.codigo_tipo_cuenta_doc,',');
            v_ids = '0';
            select
               pxp.list(tcd.id_tipo_cuenta_doc::varchar)
            into
              v_ids 
            from cd.ttipo_cuenta_doc tcd
            where tcd.codigo =ANY(va_codigos);
        
        
        END IF;
        
        IF  pxp.f_existe_parametro(p_tabla,'estado')  THEN
             IF v_parametros.estado is not null and v_parametros.estado != '' THEN
                v_filtro = v_filtro||' estado = ANY( string_to_array('''||v_parametros.estado||''','','')) and ';
             END IF;
        END IF;
           
         IF  pxp.f_existe_parametro(p_tabla,'fuera_estado')  THEN
             IF v_parametros.fuera_estado is not null and v_parametros.fuera_estado != '' THEN
                v_filtro = v_filtro||' NOT (estado = ANY (string_to_array('''||v_parametros.fuera_estado||''','',''))) and ';
             END IF;
        END IF;
        
            
      begin          
        --Sentencia de la consulta
      v_consulta:='select  
                       v.id_cuenta_doc,
                               v.fecha,
                               v.fecha_entrega,
                               v.desc_funcionario1,
                               v.nro_tramite,
                               v.motivo,
                               v.nro_cheque,
                               v.importe_solicitado,
                               v.importe_cheque,
                               v.importe_documentos,
                               v.importe_depositos,
                               v.importe_cheque -(importe_documentos + importe_depositos) as saldo,
                               v.estado,
                               v.id_proceso_wf,
                               v.id_estado_wf
                        from cd.vcuenta_doc_revision v
                        where v.fecha_entrega between '''||v_parametros.fecha_ini::date ||''' and ''' ||v_parametros.fecha_fin::date ||'''
                             and v.id_tipo_cuenta_doc in ('||v_ids||') and '||v_filtro;
            
            IF v_parametros.id_funcionario != 0 THEN
              v_consulta := v_consulta || '  v.id_funcionario = ' || v_parametros.id_funcionario||' and';
            END IF;
            
            --Definicion de la respuesta
      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            
            
            raise notice  'consulta %', v_consulta;
            
      --Devuelve la respuesta
      return v_consulta;
            
    end;    
        
    /*********************************    
  #TRANSACCION:  'CD_REPCD2_CONT'
  #DESCRIPCION: Conteo de registros de rendicion
  #AUTOR:   rac 
  #FECHA:   25-08-2017 16:41:21
  ***********************************/
  elsif(p_transaccion='CD_REPCD2_CONT')then

    begin
            
        
             v_filtro = ' 0=0 and';
        
        
            IF v_parametros.codigo_tipo_cuenta_doc = 'todos' THEN
                 select
                   pxp.list(tcd.id_tipo_cuenta_doc::varchar)
                into
                  v_ids 
                from cd.ttipo_cuenta_doc tcd
                where  tcd.sw_solicitud = 'si';
            
            ELSE
            
                va_codigos =   string_to_array(v_parametros.codigo_tipo_cuenta_doc,',');
                v_ids = '0';
                select
                   pxp.list(tcd.id_tipo_cuenta_doc::varchar)
                into
                  v_ids 
                from cd.ttipo_cuenta_doc tcd
                where tcd.codigo =ANY(va_codigos);
            
            
            END IF;
            
            IF  pxp.f_existe_parametro(p_tabla,'estado')  THEN
                 IF v_parametros.estado is not null and v_parametros.estado != '' THEN
                    v_filtro = v_filtro||' estado = ANY( string_to_array('''||v_parametros.estado||''','','')) and ';
                 END IF;
            END IF;
               
             IF  pxp.f_existe_parametro(p_tabla,'fuera_estado')  THEN
                 IF v_parametros.fuera_estado is not null and v_parametros.fuera_estado != '' THEN
                    v_filtro = v_filtro||' NOT (estado = ANY (string_to_array('''||v_parametros.fuera_estado||''','',''))) and ';
                 END IF;
            END IF;
        
            
        
        
      --Sentencia de la consulta de conteo de registros
      v_consulta:='select 
                                count(v.id_cuenta_doc),
                                sum(importe_solicitado) as importe_solicitado,
                                sum(importe_cheque) as importe_cheque,
                                sum(importe_documentos) as importe_documentos,
                                sum(importe_depositos) as importe_depositos,
                                sum(v.importe_cheque -(importe_documentos + importe_depositos)) as saldo
              
                        from cd.vcuenta_doc_revision v
                        where v.fecha_entrega between '''||v_parametros.fecha_ini::date ||''' and ''' ||v_parametros.fecha_fin::date ||'''
                             and v.id_tipo_cuenta_doc in ('||v_ids||') and '||v_filtro;
      
           
            
            IF v_parametros.id_funcionario != 0 THEN
              v_consulta := v_consulta || '  v.id_funcionario = ' || v_parametros.id_funcionario||' and ';
            END IF;
            
            
            v_consulta:=v_consulta||v_parametros.filtro;
            
            raise notice 'consulta %', v_consulta;
            
      --Definicion de la respuesta        
      
            
      --Devuelve la respuesta
      return v_consulta;
    end;       
        
    /*********************************    
  #TRANSACCION:  'CD_REPCDOC_SEL'
  #DESCRIPCION: Cabecera de reporte de solicitud de fondos
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
  ***********************************/

  elsif(p_transaccion='CD_REPCDOC_SEL')then
            
      begin       
           --recupera el gerente financiero ...
          v_gaf = orga.f_obtener_gerente_x_codigo_uo('gerente_financiero', now()::Date);
          
        
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
                              upper(cdoc.motivo)::varchar as motivo,
                              case when cdoc.id_tipo_cuenta_doc = 1 then lb.fecha else cdoc.fecha end as fecha,
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
                              mon.moneda as desc_moneda,
                              dep.codigo as desc_depto,
                              ew.obs, 
                              fun.desc_funcionario1 as desc_funcionario,
                              cdoc.importe,
                              fcb.nro_cuenta as desc_funcionario_cuenta_bancaria,
                              cdoc.id_funcionario_cuenta_bancaria,
                              cdoc.id_depto_lb,
                              cdoc.id_depto_conta,
                              tcd.nombre as tipo_cuenta_doc,
                              tcd.sw_solicitud,
                              (select l.nombre  
                            from param.tlugar l 
                            inner join orga.tcargo c on  c.id_lugar =  l.id_lugar
                            where  c.id_cargo = ANY (orga.f_get_cargo_x_funcionario(cdoc.id_funcionario  , cdoc.fecha , ''oficial'')))::varchar as lugar, 
                            upper(orga.f_get_cargo_x_funcionario_str(cdoc.id_funcionario  , cdoc.fecha , ''oficial''))::Varchar as cargo_funcionario,
                            uo.nombre_unidad,
                            pxp.f_convertir_num_a_letra(cdoc.importe)::varchar as importe_literal,
                            cdori.motivo::varchar as motivo_ori,
                            '''||v_gaf[3]||'''::varchar as  gerente_financiero,
                            upper( '''||v_gaf[4]||''')::varchar as  cargo_gerente_financiero,
                            funapro.desc_funcionario1 as aprobador,
                  upper(orga.f_get_cargo_x_funcionario_str(funapro.id_funcionario,CURRENT_DATE)) as cargo_aprobador,
                            cbte.nro_cbte,
                            cdoc.num_memo,
                            COALESCE(cdoc.num_rendicion,''s/n'') as num_rendicion,
                            lb.nro_cheque,
                            cdori.importe as importe_solicitado
                        from cd.tcuenta_doc cdoc
                        inner join orga.tuo uo on uo.id_uo = cdoc.id_uo
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        inner join param.tmoneda mon on mon.id_moneda = cdoc.id_moneda
                        inner join param.tdepto dep on dep.id_depto = cdoc.id_depto 
                        inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = cdoc.id_proceso_wf
                        inner join orga.vfuncionario fun on fun.id_funcionario = cdoc.id_funcionario
                        left join orga.vfuncionario funapro on funapro.id_funcionario = cdoc.id_funcionario_aprobador
            inner join segu.tusuario usu1 on usu1.id_usuario = cdoc.id_usuario_reg
                        inner join wf.testado_wf ew on ew.id_estado_wf = cdoc.id_estado_wf
                        left join conta.tint_comprobante cbte on cbte.id_int_comprobante = cdoc.id_int_comprobante
                        left join tes.tts_libro_bancos lb on lb.id_int_comprobante=cbte.id_int_comprobante
                        left join cd.tcuenta_doc cdori on cdori.id_cuenta_doc = cdoc.id_cuenta_doc_fk
            left join segu.tusuario usu2 on usu2.id_usuario = cdoc.id_usuario_mod
                        left join orga.tfuncionario_cuenta_bancaria fcb on fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
                          
                            
            where  cdoc.id_proceso_wf = '||v_parametros.id_proceso_wf;

                        raise notice '%', v_consulta;
      
            return v_consulta;
            
    end;
    
  /*********************************    
    #TRANSACCION:  'CD_DATPRO_SEL'
    #DESCRIPCION: recupera datos de prorrateo
    #AUTOR:   manuel guerra 
    #FECHA:   27-12-2017 16:41:21
    ***********************************/ 
  elsif(p_transaccion='CD_DATPRO_SEL')then            
      begin
        --Sentencia de la consulta
        v_consulta:='SELECT (cc.codigo_tcc || '' - '' || cc.descripcion_tcc)::varchar,c.prorrateo
                    FROM cd.tcuenta_doc_prorrateo c
                    join param.vcentro_costo cc on cc.id_centro_costo = c.id_centro_costo
                    WHERE c.id_cuenta_doc IN(SELECT a.id_cuenta_doc
                                            FROM cd.tcuenta_doc a
                                            WHERE a.id_proceso_wf = '||v_parametros.id_proceso_wf || ')';
        --Devuelve la respuesta
        return v_consulta;            
    end;     
    
    /*********************************    
    #TRANSACCION:  'CD_DATITI_SEL'
    #DESCRIPCION: recupera datos de itinerario
    #AUTOR:   manuel guerra 
    #FECHA:   27-12-2017 16:41:21
    ***********************************/ 
    elsif(p_transaccion='CD_DATITI_SEL')then            
        begin
        --Sentencia de la consulta
        v_consulta:=' SELECT sum(c.cantidad_dias)::INTEGER,(dest.codigo::VARCHAR || '' - '' || dest.nombre::VARCHAR)::VARCHAR as desc_destino
                      FROM cd.tcuenta_doc_itinerario c
                      JOIN cd.tdestino dest on dest.id_destino = c.id_destino
                      join cd.tcuenta_doc a on a.id_cuenta_doc=c.id_cuenta_doc
                      WHERE a.id_proceso_wf = '||v_parametros.id_proceso_wf || '
                      group by 2';
        --Devuelve la respuesta
        return v_consulta;            
    end;     
    /*********************************    
    #TRANSACCION:  'CD_DATPRE_SEL'
    #DESCRIPCION: recupera datos de presupuesto
    #AUTOR:   manuel guerra 
    #FECHA:   27-12-2017 16:41:21
    ***********************************/ 
    elsif(p_transaccion='CD_DATPRE_SEL')then            
        begin
        --Sentencia de la consulta
        v_consulta:='SELECT sum(c.monto_mo),max(m.moneda)::varchar,cing.desc_ingas
                    FROM cd.tcuenta_doc_det c
                    JOIN param.tmoneda m ON m.id_moneda=c.id_moneda
                    JOIN param.tconcepto_ingas cing on cing.id_concepto_ingas = c.id_concepto_ingas
                    JOIN cd.tcuenta_doc a on c.id_cuenta_doc = a.id_cuenta_doc
                    WHERE a.id_proceso_wf = '||v_parametros.id_proceso_wf || '
                    group by 3';
        --Devuelve la respuesta
        return v_consulta;            
    end; 

      
  /*********************************    
  #TRANSACCION:  'CD_REPRENDET_SEL'
  #DESCRIPCION: Cabecera de reporte de solicitud de fondos
  #AUTOR:   admin 
  #FECHA:   17-05-2016 18:01:48
  ***********************************/

  elsif(p_transaccion='CD_REPRENDET_SEL')then
            
      begin
        --Sentencia de la consulta
      v_consulta:='select
                            dcv.id_doc_compra_venta,
                            dcv.revisado,
                            dcv.movil,
                            dcv.tipo,
                            COALESCE(dcv.importe_excento,0)::numeric as importe_excento,
                            dcv.id_plantilla,
                            dcv.fecha,
                            dcv.nro_documento,
                            dcv.nit,
                            COALESCE(dcv.importe_ice,0)::numeric as importe_ice,
                            dcv.nro_autorizacion,
                            COALESCE(dcv.importe_iva,0)::numeric as importe_iva,
                            COALESCE(dcv.importe_descuento,0)::numeric as importe_descuento,
                            COALESCE(dcv.importe_doc,0)::numeric as importe_doc,
                            dcv.sw_contabilizar,
                            COALESCE(dcv.tabla_origen,''ninguno'') as tabla_origen,
                            dcv.estado,
                            dcv.id_depto_conta,
                            dcv.id_origen,
                            dcv.obs,
                            dcv.estado_reg,
                            dcv.codigo_control,
                            COALESCE(dcv.importe_it,0)::numeric as importe_it,
                            dcv.razon_social,
                            dcv.id_usuario_ai,
                            dcv.id_usuario_reg,
                            dcv.fecha_reg,
                            dcv.usuario_ai,
                            dcv.id_usuario_mod,
                            dcv.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            dep.nombre as desc_depto,
                            pla.desc_plantilla,
                            COALESCE(dcv.importe_descuento_ley,0)::numeric as importe_descuento_ley,
                            COALESCE(dcv.importe_pago_liquido,0)::numeric as importe_pago_liquido,
                            dcv.nro_dui,
                            dcv.id_moneda,
                            mon.codigo as desc_moneda,
                            dcv.id_int_comprobante,
                            COALESCE(ic.nro_cbte,dcv.id_int_comprobante::varchar)::varchar  as desc_comprobante,
                            COALESCE(dcv.importe_pendiente,0)::numeric as importe_pendiente,
                            COALESCE(dcv.importe_anticipo,0)::numeric as importe_anticipo,
                            COALESCE(dcv.importe_retgar,0)::numeric as importe_retgar,
                            COALESCE(dcv.importe_neto,0)::numeric as importe_neto,
                            aux.id_auxiliar,
                            aux.codigo_auxiliar,
                            aux.nombre_auxiliar,
                            dcv.id_tipo_doc_compra_venta,
                            (tdcv.codigo||'' - ''||tdcv.nombre)::Varchar as desc_tipo_doc_compra_venta,
                            rd.id_rendicion_det,
                            rd.id_cuenta_doc,
                            rd.id_cuenta_doc_rendicion,
                            (select pxp.list_br(''-''||cig.desc_ingas||'' (''||d.descripcion||'')'') 
                            from conta.tdoc_concepto d
                            inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = d.id_concepto_ingas
                            where d.id_doc_compra_venta = dcv.id_doc_compra_venta ) as detalle
                        
            from conta.tdoc_compra_venta dcv
                        inner join cd.trendicion_det rd on rd.id_doc_compra_venta = dcv.id_doc_compra_venta
                        inner join cd.tcuenta_doc cdd on  cdd.id_cuenta_doc = rd.id_cuenta_doc_rendicion
                          inner join segu.tusuario usu1 on usu1.id_usuario = dcv.id_usuario_reg
                          inner join param.tplantilla pla on pla.id_plantilla = dcv.id_plantilla
                          inner join param.tmoneda mon on mon.id_moneda = dcv.id_moneda
                          inner join conta.ttipo_doc_compra_venta tdcv on tdcv.id_tipo_doc_compra_venta = dcv.id_tipo_doc_compra_venta
                          left join conta.tauxiliar aux on aux.id_auxiliar = dcv.id_auxiliar
                          left join conta.tint_comprobante ic on ic.id_int_comprobante = dcv.id_int_comprobante
                          left join param.tdepto dep on dep.id_depto = dcv.id_depto_conta
                          left join segu.tusuario usu2 on usu2.id_usuario = dcv.id_usuario_mod
                where  cdd.id_proceso_wf = '||v_parametros.id_proceso_wf::varchar||' 
                        order by  dcv.fecha asc';
                        
                     

      --Devuelve la respuesta
      return v_consulta;
            
    end;
    
    /*********************************    
  #TRANSACCION:  'CD_REPRENRET_SEL'
  #DESCRIPCION: recupera el importe total de las rendiciones
  #AUTOR:   Gonzalo Sarmiento Sejas
  #FECHA:   04-08-2016
  ***********************************/

  elsif(p_transaccion='CD_REPRENRET_SEL')then
            
      begin
        --Sentencia de la consulta
      v_consulta:='select COALESCE(sum(dcv.importe_descuento_ley),0) as retenciones
            from conta.tdoc_compra_venta dcv
              inner join cd.trendicion_det rd on rd.id_doc_compra_venta = dcv.id_doc_compra_venta
              inner join cd.tcuenta_doc cdd on cdd.id_cuenta_doc = rd.id_cuenta_doc_rendicion
            where cdd.id_proceso_wf = '||v_parametros.id_proceso_wf::varchar||'';

      --Devuelve la respuesta
      return v_consulta;
            
    end;
        
    /*********************************    
  #TRANSACCION:  'CD_REPDEPREN_SEL'
  #DESCRIPCION: listado de depositos para el reporte de rendicion
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
  ***********************************/

  elsif(p_transaccion='CD_REPDEPREN_SEL')then
            
      begin
        
        --Sentencia de la consulta
      v_consulta := 'select cb.id_cuenta_bancaria,
                             cb.denominacion,
                             cb.nro_cuenta,
                             t.fecha,
                             t.tipo,
                             t.importe_deposito,
                             t.origen,
                             f.nombre_finalidad,
                             t.id_libro_bancos,
                             t.observaciones
                      from tes.tts_libro_bancos t
                           inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria = t.id_cuenta_bancaria
                           inner join tes.tfinalidad f on f.id_finalidad = t.id_finalidad
                           inner join cd.tcuenta_doc cdd on cdd.id_cuenta_doc = t.columna_pk_valor and t.tabla = ''cd.tcuenta_doc''
                      where  cdd.id_proceso_wf = '||v_parametros.id_proceso_wf;
                        
                       
      
            return v_consulta;
            
    end; 
        
      
    
     /*********************************    
  #TRANSACCION:  'CD_REPDEPRENCO_SEL'
  #DESCRIPCION: listado de depositos para el reporte de rendicion consolidado
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
  ***********************************/

  elsif(p_transaccion='CD_REPDEPRENCO_SEL')then
            
      begin
        
        --Sentencia de la consulta
      v_consulta := 'select  cb.id_cuenta_bancaria,
                                 cb.denominacion,
                                 cb.nro_cuenta,
                                 t.fecha,
                                 t.tipo,
                                 t.importe_deposito,
                                 t.origen,
                                 f.nombre_finalidad,
                                 t.id_libro_bancos,
                                 t.observaciones
                          from tes.tts_libro_bancos t
                               inner join tes.tcuenta_bancaria cb on cb.id_cuenta_bancaria = t.id_cuenta_bancaria
                               inner join tes.tfinalidad f on f.id_finalidad = t.id_finalidad
                               inner join cd.tcuenta_doc cdd on cdd.id_cuenta_doc = t.columna_pk_valor and t.tabla = ''cd.tcuenta_doc''
                               inner join cd.tcuenta_doc cddo on cddo.id_cuenta_doc = cdd.id_cuenta_doc_fk
                          where  cddo.id_proceso_wf = '||v_parametros.id_proceso_wf;
                        
                       
      
            return v_consulta;
            
    end;   
           
    /*********************************    
  #TRANSACCION:  'CD_REPCONFA_SEL'
  #DESCRIPCION: listado para reporte consolidado de fondo en avance
  #AUTOR:   admin 
  #FECHA:   05-05-2016 16:41:21
  ***********************************/

  elsif(p_transaccion='CD_REPCONFA_SEL')then
            
      begin
        
        --Sentencia de la consulta
      v_consulta := 'select 
                          dc.id_doc_concepto,
                          cc.codigo_cc,
                          cc.desc_tipo_presupuesto,
                          cp.descripcion as desc_categoria_programatica,
                          cp.codigo_categoria,
                          cig.desc_ingas,
                          dc.descripcion,
                          dc.precio_total_final,
                          dc.precio_total,
                          dc.precio_unitario,
                          dc.cantidad_sol,
                          dcv.fecha,
                          dcv.razon_social,
                          dcv.nro_documento,
                          plt.desc_plantilla,
                          (SELECT 
                               par.codigo || '' - ''||par.nombre_partida 
                           FROM conta.f_get_config_relacion_contable(''CUECOMP'', 
                                                                      cc.id_gestion, 
                                                                      cig.id_concepto_ingas, 
                                                                      cc.id_centro_costo,  
                                                                      ''No se encontro relación contable para el conceto de gasto: ''||cig.desc_ingas||''. <br> Mensaje: '',
                                                                      c.id_moneda) rel
                                                                      inner join pre.tpartida par on par.id_partida = rel.ps_id_partida )::varchar as partida,
                          ren.id_int_comprobante
                          from cd.trendicion_det rd
                          inner join cd.tcuenta_doc c on c.id_cuenta_doc = rd.id_cuenta_doc
                          inner join cd.tcuenta_doc ren on ren.id_cuenta_doc=rd.id_cuenta_doc_rendicion   
                          inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                          inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta
                          inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = dc.id_centro_costo
                          inner join pre.vcategoria_programatica cp on cp.id_categoria_programatica = cc.id_categoria_prog
                          inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                          inner join param.tplantilla plt on plt.id_plantilla = dcv.id_plantilla
                      where  c.id_proceso_wf = '||v_parametros.id_proceso_wf;
                        
                       
      raise notice 'consulta %', v_consulta;
            return v_consulta;
            
    end; 
    
  /*********************************    
  #TRANSACCION:  'CD_REPCON_SEL'
  #DESCRIPCION: listado para reporte consolidado
  #AUTOR:   admin 
  #FECHA:   13-09-2016
  ***********************************/

    elsif(p_transaccion='CD_REPCON_SEL')then
            
        begin
        
            --Sentencia de la consulta
            v_consulta := 'select cp.codigo_categoria,
                               (
                                 SELECT par.codigo || '' - '' || par.nombre_partida
                                 FROM conta.f_get_config_relacion_contable(''CUECOMP'',
                                                                            cc.id_gestion,
                                                                            cig.id_concepto_ingas,
                                                                            cc.id_centro_costo,
                                                                            ''No se encontro relación contable para el conceto de gasto: '' || cig.desc_ingas || '' . <br> Mensaje: '',
                                                                            c.id_moneda) rel
                                      inner join pre.tpartida par on par.id_partida = rel.ps_id_partida
                               )::varchar as partida ,
                               sum(dc.precio_total_final) as importe
                        from cd.trendicion_det rd
                        inner join cd.tcuenta_doc c on c.id_cuenta_doc = rd.id_cuenta_doc
                        inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                        inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta
                        inner join pre.vpresupuesto_cc cc on cc.id_centro_costo = dc.id_centro_costo
                        inner join pre.vcategoria_programatica cp on cp.id_categoria_programatica = cc.id_categoria_prog
                        inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                        where c.id_proceso_wf = ' || v_parametros.id_proceso_wf || '
                        group by codigo_categoria, partida
                        order by codigo_categoria, partida';
                                               
            raise notice 'consulta %', v_consulta;
            return v_consulta;
            
        end;

    /*********************************    
    #TRANSACCION:  'CD_CDOCDEP_SEL'
    #DESCRIPCION:   Devuelve el total registrado en depósitos para la solicitud de cuenta documentada
    #AUTOR:         RCM
    #FECHA:         15/12/2017
    ***********************************/
    elsif(p_transaccion='CD_CDOCDEP_SEL')then
            
        begin

            --Obtención/verificación de id_cuenta_doc de la solicitud
            select
            id_cuenta_doc_fk
            into v_rec
            from cd.tcuenta_doc
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            v_id_cuenta_doc = v_parametros.id_cuenta_doc;
            if v_rec.id_cuenta_doc_fk is not null then
                v_id_cuenta_doc = v_rec.id_cuenta_doc_fk;
            end if;
        
            --Sentencia de la consulta
            v_consulta = 'select
                        coalesce(sum(lb.importe_deposito),0)
                        from cd.tcuenta_doc cdoc
                        inner join cd.vlibro_bancos_deposito lb
                        on cdoc.id_cuenta_doc = lb.id_cuenta_doc
                        where cdoc.estado_reg = ''activo''
                        and cdoc.id_cuenta_doc_fk = '||v_id_cuenta_doc;
            --Salida
            return v_consulta;
            
        end; 

    /*********************************    
    #TRANSACCION:  'CD_CDSIGEMAID_SEL'
    #DESCRIPCION:   Listado del ID de Sigema
    #AUTOR:         RCM
    #FECHA:         29/12/2017
    ***********************************/
    elsif(p_transaccion='CD_CDSIGEMAID_SEL')then
            
        begin

            --Sentencia de la consulta
            v_consulta = 'with sigema as (select * from cd.vsigema_gral)
                        select 
                        distinct tipo_sol_sigema, id_sigema,nro_solicitud,gestion
                        from sigema sigra
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            
            --Salida
            return v_consulta;
            
        end; 


  /*********************************    
  #TRANSACCION:  'CD_CDSIGEMAID_CONT'
  #DESCRIPCION:   Conteo listado SIGEMA
  #AUTOR:         RCM
  #FECHA:         29-12-2017
  ***********************************/
  elsif(p_transaccion='CD_CDSIGEMAID_CONT')then

    begin
            
        --Sentencia de la consulta de conteo de registros
        v_consulta:='select count (1) from
                    (with sigema as (select * from cd.vsigema_gral)
                    select 
                        distinct tipo_sol_sigema, id_sigema,nro_solicitud,gestion
                        from sigema sigra
                        where ';
        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro||') as f';

        --Devuelve la respuesta
        return v_consulta;

    end;

    /*********************************    
    #TRANSACCION:  'CD_CDSIGEMADAT_SEL'
    #DESCRIPCION:   Listado de los datos del sigema guardados en la cuenta doc
    #AUTOR:         RCM
    #FECHA:         29/12/2017
    ***********************************/
    elsif(p_transaccion='CD_CDSIGEMADAT_SEL')then
            
        begin

            if v_parametros.id_cuenta_doc is null then
              raise exception 'Id de la cuenta documentada no puede ser nulo';
            end if;

            --Obtiene la gestion en base a la fecha de la cuenta documentada
            select extract(year from fecha)
            into v_gestion
            from cd.tcuenta_doc
            where id_cuenta_doc = v_parametros.id_cuenta_doc;

            if v_gestion is null then
              raise exception 'La gestion no puede ser nula';
            end if;

            --Sentencia de la consulta
            v_consulta = 'with sigema as (select * from cd.vsigema_gral)
                        select distinct cd.id_cuenta_doc, cd.tipo_sol_sigema, cd.id_sigema, sigra.nro_solicitud
                        from cd.tcuenta_doc cd
                        left join sigema sigra
                        on sigra.tipo_sol_sigema = cd.tipo_sol_sigema
                        and sigra.id_sigema = cd.id_sigema
                        and sigra.gestion::integer = '||v_gestion::integer||'
                        where cd.id_cuenta_doc = ' || v_parametros.id_cuenta_doc;

            --Salida
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