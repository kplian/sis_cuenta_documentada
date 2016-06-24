--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_gestionar_presupuesto_cd (
  p_id_cuenta_doc integer,
  p_id_usuario integer,
  p_operacion varchar,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Cuenta Documentada
 FUNCION           cd.f_gestionar_presupuesto_cd(p_id_solicitud_compra integer, p_id_usuario integer, p_operacion varchar)CION: 		cd.f_gestionar_presupuesto_cd
                
 DESCRIPCION:   Esta funcion gestion el presupeusto para las cuentas documentadas
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        22-06-2016
 COMENTARIOS:	
***************************************************************************/

DECLARE
  v_registros record;
  v_nombre_funcion varchar;
  v_resp varchar;
 
  va_id_presupuesto 		integer[];
  va_id_partida     		integer[];
  va_momento				INTEGER[];
  va_monto          		numeric[];
  va_id_moneda    			integer[];
  va_id_partida_ejecucion 	integer[];
  va_columna_relacion     	varchar[];
  va_fk_llave             	integer[];
  v_id_partida      	  	integer;
  v_i   				  	integer;
  v_cont				  	integer;
  va_id_doc_concepto	  	integer[];
  v_id_moneda_base		  	integer;
  va_resp_ges              	numeric[];
  
  va_fecha                	date[];
  
  v_monto_a_revertir 	numeric;
  v_total_adjudicado  	numeric;
  v_aux 				numeric;
  v_comprometido  	    numeric;
  v_comprometido_ga     numeric;
  v_ejecutado     	    numeric;
  
  v_men_presu			varchar;
  v_monto_a_revertir_mb  numeric;
  v_ano_1 integer;
  v_ano_2 integer;
  v_reg_sol				record;
  va_num_tramite		varchar[];
  v_mensage_error		varchar;
  v_sw_error			boolean;
  v_resp_pre 			varchar;
  
  
  v_rendicion				record;
  v_rendicion_det			record;
  v_id_presupuesto			integer;
  v_pre_verificar_categoria			varchar;
  

  
BEGIN
 
  v_nombre_funcion = 'cd.f_gestionar_presupuesto_cd';
   
  v_id_moneda_base =  param.f_get_moneda_base();
  
  select 
    c.*
  into
   v_reg_sol
  from cd.tcuenta_doc c
  where c.id_cuenta_doc = p_id_cuenta_doc;
  
 
  
  
      IF p_operacion = 'comprometer' THEN
      
      
          IF(v_reg_sol.presu_comprometido='si') THEN                     
             raise exception 'El presupuesto ya se encuentra comprometido';                     
          END IF;
  
        
          --compromete al aprobar la solicitud  
           v_i = 0;
           
          -- verifica que solicitud
          -- recorres todas las facturas
          FOR v_rendicion in (
                             SELECT 
                                 r.id_doc_compra_venta,
                                 r.id_rendicion_det
                             FROM  cd.trendicion_det r
                             inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                             where r.id_cuenta_doc_rendicion = p_id_cuenta_doc
                             
                             ) LOOP
             
             -- recorrer todos los detalles
             FOR  v_rendicion_det in (
                                      select 
                                         dc.id_centro_costo,
                                         dc.id_concepto_ingas,
                                         dc.precio_total_final,
                                         dc.id_doc_concepto,
                                         cig.desc_ingas,
                                         dc.id_partida
                                      from  conta.tdoc_concepto dc 
                                      inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                                      where dc.id_doc_compra_venta = v_rendicion.id_doc_compra_venta
                                      ) LOOP
                                      
                    
             
                    --  determinar partida a comprometer
                     v_i = v_i +1;
                           
                     --armamos los array para enviar a presupuestos          
           
                    va_id_presupuesto[v_i] = v_rendicion_det.id_centro_costo;
                    va_id_partida[v_i] = v_rendicion_det.id_partida; 
                    va_momento[v_i]	= 1; --el momento 1 es el comprometido
                    va_monto[v_i]  = v_rendicion_det.precio_total_final; --RAC Cambio por moneda de la solicitud , v_registros.precio_ga_mb;
                    va_id_moneda[v_i]  = v_reg_sol.id_moneda;        --  RAC Cambio por moneda de la solicitud , v_id_moneda_base;
                  
                    va_columna_relacion[v_i]= 'id_doc_concepto';
                    va_fk_llave[v_i] = v_rendicion_det.id_doc_concepto;
                    va_id_doc_concepto[v_i]= v_rendicion_det.id_doc_concepto;
                    va_num_tramite[v_i] = v_reg_sol.nro_tramite; 
                    
                    -- la fecha de solictud es la fecha de compromiso 
                    IF  now()  < v_reg_sol.fecha THEN
                      va_fecha[v_i] = v_reg_sol.fecha::date;
                    ELSE
                       -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                       va_fecha[v_i] = now()::date;
                       v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                       v_ano_2 =  EXTRACT(YEAR FROM  v_reg_sol.fecha::date);
                       
                       IF  v_ano_1  >  v_ano_2 THEN
                         va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                       END IF;
                    END IF;
                     
                     
             END LOOP; 
            
         
         END LOOP; 
           
             
         IF v_i > 0 THEN 
              
                    --llamada a la funcion de compromiso
                    va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                    										   NULL, --tipo cambio
                                                               va_id_presupuesto, 
                                                               va_id_partida, 
                                                               va_id_moneda, 
                                                               va_monto, 
                                                               va_fecha, --p_fecha
                                                               va_momento, 
                                                               NULL,--  p_id_partida_ejecucion 
                                                               va_columna_relacion, 
                                                               va_fk_llave,
                                                               va_num_tramite,--nro_tramite
                                                               NULL,
                                                               p_conexion);
                 
                   --  actualizacion de los id_partida_ejecucion en el detalle de solicitud
               
                    FOR v_cont IN 1..v_i LOOP
                   
                      update conta.tdoc_concepto  d set
                         id_partida_ejecucion = va_resp_ges[v_cont],
                         fecha_mod = now(),
                         id_usuario_mod = p_id_usuario
                      where d.id_doc_concepto =  va_id_doc_concepto[v_cont];
                   
                     
                   END LOOP;
                   
                  update cd.tcuenta_doc c set
                    presu_comprometido = 'si'
                  where c.id_cuenta_doc = p_id_cuenta_doc;  
                   
           END IF;
      
      
      
       ELSEIF p_operacion = 'revertir' THEN
       
           v_i = 0;
           v_men_presu = '';
           FOR v_registros in (
                                select 
                                   dc.id_centro_costo,
                                   dc.id_concepto_ingas,
                                   dc.precio_total_final,
                                   dc.id_doc_concepto,
                                   cig.desc_ingas,
                                   dc.id_partida,
                                   dc.id_partida_ejecucion,
                                   r.id_rendicion_det
                                   
                                from  cd.trendicion_det r
                                inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = r.id_doc_compra_venta 
                                inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                                where r.id_cuenta_doc_rendicion =  p_id_cuenta_doc
                                	  and dc.estado_reg = 'activo' ) LOOP
                                     
                     IF(v_registros.id_partida_ejecucion is NULL) THEN                     
                        raise exception 'El presupuesto del detalle con el identificador (%)  no se encuentra comprometido',v_registros.id_doc_concepto;
                     END IF;
                     
                     v_comprometido=0;
                     v_ejecutado=0;
                     
                     SELECT 
                           COALESCE(ps_comprometido,0), 
                           COALESCE(ps_ejecutado,0)  
                       into 
                           v_comprometido,
                           v_ejecutado
                     FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion, v_reg_sol.id_moneda);   --  RAC,  v_id_moneda_base);
                     
                     
                    v_monto_a_revertir = COALESCE(v_comprometido,0) - COALESCE(v_ejecutado,0);  
                     
                     
                    --armamos los array para enviar a presupuestos          
                    IF v_monto_a_revertir != 0 THEN
                     
                       	v_i = v_i +1;                
                       
                        va_id_presupuesto[v_i] = v_registros.id_centro_costo;
                        va_id_partida[v_i]= v_registros.id_partida;
                        va_momento[v_i]	= 2; --el momento 2 con signo positivo es revertir
                        va_monto[v_i]  = (v_monto_a_revertir)*-1;  -- considera la posibilidad de que a este item se le aya revertido algun monto
                        va_id_moneda[v_i]  = v_reg_sol.id_moneda; -- RAC,  v_id_moneda_base;
                        va_id_partida_ejecucion[v_i]= v_registros.id_partida_ejecucion;
                        va_columna_relacion[v_i]= 'id_doc_concepto';
                        va_fk_llave[v_i] = v_registros.id_doc_concepto;
                        va_id_doc_concepto[v_i]= v_registros.id_doc_concepto;
                        va_num_tramite[v_i] = v_reg_sol.nro_tramite;
                        
                        
                         -- la fecha de solictud es la fecha de compromiso 
                        IF  now()  < v_reg_sol.fecha THEN
                          va_fecha[v_i] = v_reg_sol.fecha::date;
                        ELSE
                           -- la fecha de reversion como maximo puede ser el 31 de diciembre   
                           va_fecha[v_i] = now()::date;
                           v_ano_1 =  EXTRACT(YEAR FROM  now()::date);
                           v_ano_2 =  EXTRACT(YEAR FROM  v_reg_sol.fecha::date);
                           
                           IF  v_ano_1  >  v_ano_2 THEN
                             va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                           END IF;
                        END IF;
                    
                        
                    END IF;
                    
                    
                    v_men_presu = ' comprometido: '||COALESCE(v_comprometido,0)::varchar||'  ejecutado: '||COALESCE(v_ejecutado,0)::varchar||' \n'||v_men_presu;
                    
             
             END LOOP;
             
               --raise exception '%', v_men_presu;
             
             --llamada a la funcion de para reversion
             IF v_i > 0 THEN 
                  va_resp_ges =  pre.f_gestionar_presupuesto(p_id_usuario,
                    										 NULL, --tipo cambio
                  											 va_id_presupuesto, 
                                                             va_id_partida, 
                                                             va_id_moneda, 
                                                             va_monto, 
                                                             va_fecha, --p_fecha
                                                             va_momento, 
                                                             va_id_partida_ejecucion,--  p_id_partida_ejecucion 
                                                             va_columna_relacion, 
                                                             va_fk_llave,
                                                             va_num_tramite,--nro_tramite
                                                             NULL,
                                                             p_conexion);
            END IF;
            
          
            update cd.tcuenta_doc c set
               presu_comprometido = 'no'
            where c.id_cuenta_doc = p_id_cuenta_doc;  
             
       
       
       ELSIF p_operacion = 'verificar' THEN
        
           --  verifica si tenemos suficiente presupuesto para comprometer
           v_i = 0;
           v_mensage_error = '';
           v_sw_error = false;
           
           
          v_pre_verificar_categoria = pxp.f_get_variable_global('pre_verificar_categoria');
          
          IF v_pre_verificar_categoria = 'no' THEN 
               -- verifica agrupando por presupuesto    
              FOR v_registros in (
              
                                  SELECT                 
                                          dc.id_centro_costo,
                                          c.id_gestion,
                                          c.id_cuenta_doc,
                                          dc.id_partida,
                                          sum(dc.precio_total_final) as precio_total_final,
                                          p.id_presupuesto,
                                          c.id_moneda,
                                          par.codigo,
                                          par.nombre_partida,
                                          p.codigo_cc
                                    FROM  cd.tcuenta_doc c
                                    INNER JOIN cd.trendicion_det r on r.id_cuenta_doc_rendicion = c.id_cuenta_doc
                                    INNER JOIN conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                                    INNER JOIN conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta 
                                    inner join pre.tpartida par on par.id_partida = dc.id_partida
                                    inner join pre.vpresupuesto_cc   p  on p.id_centro_costo = dc.id_centro_costo and dc.estado_reg = 'activo'
                                    WHERE  dc.estado_reg = 'activo'   and c.id_cuenta_doc = p_id_cuenta_doc                           
                                    group by                              
                                              dc.id_centro_costo,
                                              c.id_gestion,
                                              c.id_cuenta_doc,
                                              dc.id_partida,
                                              p.id_presupuesto,
                                              c.id_moneda,
                                              par.codigo,
                                              par.nombre_partida,
                                              p.codigo_cc
                                              ) LOOP
                                         
                                    
                                  v_resp_pre = pre.f_verificar_presupuesto_partida ( v_registros.id_presupuesto,
                                                            v_registros.id_partida,
                                                            v_registros.id_moneda,
                                                            v_registros.precio_total_final);
                                                            
                                                            
                                  IF   v_resp_pre = 'false' THEN        
                                       v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <BR/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                                       v_sw_error = true;
                                  
                                  END IF;                         
                       
                 
                 
                 END LOOP;
             ELSE
             
             --  verifica agrupando por categoria programatica
             
                FOR v_registros in (SELECT               
                                            c.id_gestion,
                                            c.id_cuenta_doc,
                                            dc.id_partida,
                                            sum(dc.precio_total_final) as precio_total_final,    
                                            c.id_moneda,
                                            par.codigo,
                                            par.nombre_partida,
                                            p.id_categoria_prog,
                                            cp.codigo_categoria
                                      FROM  cd.tcuenta_doc c
                                      INNER JOIN cd.trendicion_det r on r.id_cuenta_doc_rendicion = c.id_cuenta_doc
                                      INNER JOIN conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                                      INNER JOIN conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta 
                                      inner join pre.tpartida par on par.id_partida = dc.id_partida
                                      inner join pre.vpresupuesto_cc   p  on p.id_centro_costo = dc.id_centro_costo and dc.estado_reg = 'activo'
                                      inner join pre.vcategoria_programatica cp on p.id_categoria_prog = cp.id_categoria_programatica
                                      WHERE  
                                             dc.estado_reg = 'activo'
                                             and c.id_cuenta_doc = p_id_cuenta_doc                            
                                      group by                              
                                            p.id_categoria_prog,
                                            cp.codigo_categoria,
                                            c.id_gestion,
                                            c.id_cuenta_doc,
                                            dc.id_partida,
                                            c.id_moneda,
                                            par.codigo,
                                            par.nombre_partida) LOOP
                                      
                                      
                                      --recupera un presupuesto cualqueira con la misma categoria para la verificacion
                                      select 
                                         p.id_presupuesto
                                      into 
                                         v_id_presupuesto                                      
                                      from pre.vpresupuesto_cc p
                                      where p.id_categoria_prog =  v_registros.id_categoria_prog
                                      OFFSET 0 limit 1; 
                                           
                                      
                                    v_resp_pre = pre.f_verificar_presupuesto_partida ( v_id_presupuesto,
                                                              v_registros.id_partida,
                                                              v_registros.id_moneda,
                                                              v_registros.precio_total_final);
                                                              
                                                              
                                    IF   v_resp_pre = 'false' THEN        
                                         v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <BR/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                                         v_sw_error = true;
                                    
                                    END IF;                         
                         
                   
                   
                   END LOOP;
             
             
             END IF;     
             
             
             IF v_sw_error THEN
                 raise exception 'No se tiene suficiente presupuesto para: <BR/> %', v_mensage_error;
             END IF;
              
       
             return TRUE;
       
       ELSE
       
          raise exception 'Operacion no implementada';
       
       END IF;
   

  
  return  TRUE;


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