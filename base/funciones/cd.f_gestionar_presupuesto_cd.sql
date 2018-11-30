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
 FUNCION:       cd.f_gestionar_presupuesto_cd(p_id_solicitud_compra integer, p_id_usuario integer, p_operacion varchar)
                
 DESCRIPCION:   Esta funcion gestion el presupeusto para las cuentas documentadas
 AUTOR: 		Rensi Arteaga Copari
 FECHA:	        22-06-2016
 COMENTARIOS:	

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   Comprometer presupuesto en la aprobación de la solicitud. (Previamente se arregla el formato del archivo y se aumentan comentarios)
 AUTOR:         RCM
 FECHA:         22-11-2017
***************************************************************************/

DECLARE

    v_registros                 record;
    v_nombre_funcion            varchar;
    v_resp                      varchar;
    va_id_presupuesto           integer[];
    va_id_partida               integer[];
    va_momento                  integer[];
    va_monto                    numeric[];
    va_id_moneda    			integer[];
    va_id_partida_ejecucion 	integer[];
    va_columna_relacion     	varchar[];
    va_fk_llave             	integer[];
    v_id_partida                integer;
    v_i                         integer;
    v_cont                      integer;
    va_id_doc_concepto          integer[];
    v_id_moneda_base		  	integer;
    va_resp_ges              	numeric[];
    va_fecha                	date[];
    v_monto_a_revertir          numeric;
    v_total_adjudicado          numeric;
    v_aux                       numeric;
    v_comprometido              numeric;
    v_comprometido_ga           numeric;
    v_ejecutado                 numeric;
    v_men_presu                 varchar;
    v_monto_a_revertir_mb       numeric;
    v_ano_1 					integer;
    v_ano_2 					integer;
    v_reg_sol					record;
    va_num_tramite              varchar[];
    v_mensage_error             varchar;
    v_sw_error                  boolean;
    v_resp_pre                  varchar;  
    v_rendicion                 record;
    v_rendicion_det             record;
    v_id_presupuesto			integer;
    v_pre_verificar_categoria   varchar;
    v_pre_verificar_tipo_cc     varchar;
    v_control_partida           varchar;
    va_resp_pre                 varchar[];
    v_cod_pre           varchar;
  
BEGIN
 
    --Identificación de la función
    v_nombre_funcion = 'cd.f_gestionar_presupuesto_cd';
  
    --Obtención de la moneda base 
    v_id_moneda_base =  param.f_get_moneda_base();
  
    --Obtención de datos de la cuenta documentada
    select 
    c.*
    into
    v_reg_sol
    from cd.tcuenta_doc c
    where c.id_cuenta_doc = p_id_cuenta_doc;
    
  
    --Lógica a aplicar por operación
    if p_operacion = 'comprometer' then
        --COMPROMETER RENDICIÓN

        --Validación      
        if(v_reg_sol.presu_comprometido='si') then
            raise exception 'El presupuesto ya se encuentra comprometido';                     
        end if;
  
        --Inicialización del contador
        v_i = 0;
           
        --Recorrido de todas las facturas
        for v_rendicion in (select 
                            r.id_doc_compra_venta,
                            r.id_rendicion_det
                            from  cd.trendicion_det r
                            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                            where r.id_cuenta_doc_rendicion = p_id_cuenta_doc) loop
             
            --Recorrido del detalle
            for v_rendicion_det in (select 
                                    dc.id_centro_costo,
                                    dc.id_concepto_ingas,
                                    dc.precio_total_final,
                                    dc.id_doc_concepto,
                                    cig.desc_ingas,
                                    dc.id_partida,
                                    par.sw_movimiento,
                                    tp.movimiento
                                    from conta.tdoc_concepto dc
                                    inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                                    inner join pre.vpresupuesto p on p.id_presupuesto = dc.id_centro_costo
                                    inner join pre.ttipo_presupuesto tp on p.tipo_pres = tp.codigo
                                    inner join pre.tpartida par on par.id_partida = dc.id_partida
                                    where dc.id_doc_compra_venta = v_rendicion.id_doc_compra_venta) loop
                                      
                --Validación de partida de flujo
                if v_rendicion_det.sw_movimiento = 'flujo' then
                    if v_rendicion_det.movimiento != 'administrativo' then
                        raise exception 'partida de flujo solo son admitidas con presupuestos administrativos';
                    end if;
                else
                    --Incremento del contador
                    v_i = v_i +1;

                    --Determinar partida a comprometer: armamos los array para enviar a presupuestos        
                    va_id_presupuesto[v_i] = v_rendicion_det.id_centro_costo;
                    va_id_partida[v_i] = v_rendicion_det.id_partida; 
                    va_momento[v_i]	= 1; --el momento 1 es el comprometido
                    va_monto[v_i]  = v_rendicion_det.precio_total_final; --RAC Cambio por moneda de la solicitud , v_registros.precio_ga_mb;
                    va_id_moneda[v_i]  = v_reg_sol.id_moneda;        --  RAC Cambio por moneda de la solicitud , v_id_moneda_base;
                    va_columna_relacion[v_i]= 'id_doc_concepto';
                    va_fk_llave[v_i] = v_rendicion_det.id_doc_concepto;
                    va_id_doc_concepto[v_i]= v_rendicion_det.id_doc_concepto;
                    va_num_tramite[v_i] = v_reg_sol.nro_tramite; 

                    --La fecha de solictud es la fecha de compromiso 
                    if now() < v_reg_sol.fecha then
                        va_fecha[v_i] = v_reg_sol.fecha::date;
                    else
                        --La fecha de reversion como maximo puede ser el 31 de diciembre   
                        va_fecha[v_i] = now()::date;
                        v_ano_1 = extract(year from now()::date);
                        v_ano_2 = extract(year from v_reg_sol.fecha::date);

                        if v_ano_1  >  v_ano_2 then
                            va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                        end if;
                    end if;
                end if;
            end loop;
        end loop;
           
        --Si el contador es mayor a cero
        if v_i>0 then
            --Llamada a la funcion de compromiso
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
                 
            --Actualizacion de los id_partida_ejecucion en el detalle de solicitud
            for v_cont in 1..v_i loop
                update conta.tdoc_concepto d set
                id_partida_ejecucion = va_resp_ges[v_cont],
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario
                where d.id_doc_concepto =  va_id_doc_concepto[v_cont];
            end loop;

            --Actualización de bandera de comprometido
            update cd.tcuenta_doc c set
            presu_comprometido = 'si'
            where c.id_cuenta_doc = p_id_cuenta_doc;  
        end if;
      
    elsif p_operacion = 'revertir' then
       --REVERSIÓN DE PRESUPUESTO DE LA RENDICIÓN
        v_i = 0;
        v_men_presu = '';
        
        --Recorrido del detalle de la rendición
        for v_registros in (select 
                            dc.id_centro_costo,
                            dc.id_concepto_ingas,
                            dc.precio_total_final,
                            dc.id_doc_concepto,
                            cig.desc_ingas,
                            dc.id_partida,
                            dc.id_partida_ejecucion,
                            r.id_rendicion_det,
                            par.sw_movimiento
                            from  cd.trendicion_det r
                            inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = r.id_doc_compra_venta 
                            inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = dc.id_concepto_ingas
                            inner join pre.tpartida par on par.id_partida = dc.id_partida
                            where r.id_cuenta_doc_rendicion =  p_id_cuenta_doc
                            and dc.estado_reg = 'activo' ) loop
                            
                        
                     
            --Si no es partida de flujo
            if v_registros.sw_movimiento != 'flujo'  then

                --Validación partida ejecución
                if(v_registros.id_partida_ejecucion is null) then
                    raise exception 'El presupuesto del detalle con el identificador (%) no se encuentra comprometido',v_registros.id_doc_concepto;
                end if;
                
               -- raise exception 'entr aal revertir.. %',p_id_cuenta_doc;
                             
                --Inicialiación de variables             
                v_comprometido=0;
                v_ejecutado=0;

                --Verificación del presupuesto
                select
                coalesce(ps_comprometido,0), coalesce(ps_ejecutado,0)  
                into v_comprometido, v_ejecutado
                FROM pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion, v_reg_sol.id_moneda);   --  RAC,  v_id_moneda_base);
                
                
                --raise exception 'entr aal revertir.. % . %',v_registros.id_partida_ejecucion, v_reg_sol.id_moneda; 

                --Definición de monto a revertir
                
                --TODO  Analizar mejor el codigo comentado
                --RAC 04/01/2018 comentado por que al no considerar partidas intentava revertido dos veces lo  mismo
               -- v_monto_a_revertir = coalesce(v_comprometido,0) - coalesce(v_ejecutado,0); 
                
                  v_monto_a_revertir = v_registros.precio_total_final;
               --FIN TODO

                --Armamos los array para enviar a presupuestos          
                if v_monto_a_revertir != 0 then
                    --Incremento contador
                    v_i = v_i +1;                

                    --Parámetros para la reversión
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

                    --La fecha de solictud es la fecha de compromiso 
                    if now() < v_reg_sol.fecha then
                        va_fecha[v_i] = v_reg_sol.fecha::date;
                    else
                        --La fecha de reversion como maximo puede ser el 31 de diciembre   
                        va_fecha[v_i] = now()::date;
                        v_ano_1 = extract(year from now()::date);
                        v_ano_2 = extract(year from v_reg_sol.fecha::date);

                        if v_ano_1 > v_ano_2 then
                            va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                        end if;
                    end if;
                end if;

                --Definición del mensaje                
                v_men_presu = ' comprometido: '||coalesce(v_comprometido,0)::varchar||'  ejecutado: '||coalesce(v_ejecutado,0)::varchar||' \n'||v_men_presu;
              
            end if;
           
        end loop;
             
               --raise exception '%', v_men_presu;
             
        --Llamada a la funcion de para reversion del presupuesto
        if v_i > 0 then
            va_resp_ges = pre.f_gestionar_presupuesto(p_id_usuario,
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
        end if;

        --Actualización de la bandera del comprometido de la cuenta documentada
        update cd.tcuenta_doc c set
        presu_comprometido = 'no'
        where c.id_cuenta_doc = p_id_cuenta_doc;  
             
    elsif p_operacion = 'verificar' then
        --VERIFICACIÓN DE PRESUPUESTO DE LA RENDICIÓN

        v_i = 0;
        v_mensage_error = '';
        v_sw_error = false;
        v_pre_verificar_categoria = pxp.f_get_variable_global('pre_verificar_categoria');
        v_pre_verificar_tipo_cc = pxp.f_get_variable_global('pre_verificar_tipo_cc');
        v_control_partida = 'si'; --por defeto controlamos los monstos por partidas 
           
        --Lógica en función si la verificación es agrupada o no
        if v_pre_verificar_categoria = 'no' and v_pre_verificar_tipo_cc = 'no' then
            --Verifica agrupando por presupuesto    
            for v_registros in (select
                                dc.id_centro_costo,
                                c.id_gestion,
                                c.id_cuenta_doc,
                                dc.id_partida,
                                sum(dc.precio_total_final) as precio_total_final,
                                p.id_presupuesto,
                                c.id_moneda,
                                par.codigo,
                                par.nombre_partida,
                                p.codigo_cc,
                                par.sw_movimiento
                                from cd.tcuenta_doc c
                                inner join cd.trendicion_det r on r.id_cuenta_doc_rendicion = c.id_cuenta_doc
                                inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                                inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta 
                                inner join pre.tpartida par on par.id_partida = dc.id_partida
                                inner join pre.vpresupuesto_cc p on p.id_centro_costo = dc.id_centro_costo and dc.estado_reg = 'activo'
                                where dc.estado_reg = 'activo' and c.id_cuenta_doc = p_id_cuenta_doc                           
                                group by                              
                                dc.id_centro_costo,
                                c.id_gestion,
                                c.id_cuenta_doc,
                                dc.id_partida,
                                p.id_presupuesto,
                                c.id_moneda,
                                par.codigo,
                                par.nombre_partida,
                                p.codigo_cc,
                                par.sw_movimiento
                                ) loop
                                         
                --Verifica que no sea partida de flujo
                if v_registros.sw_movimiento != 'flujo' then

                    v_resp_pre = pre.f_verificar_presupuesto_partida (v_registros.id_presupuesto,
                                                                      v_registros.id_partida,
                                                                      v_registros.id_moneda,
                                                                      v_registros.precio_total_final);
                                                                      
                     --raise exception 'AMTENIMIETNO UTI, % , %, %, %', v_registros.id_presupuesto, v_registros.id_partida, v_registros.id_moneda, v_registros.precio_total_final;  
                                                                    
                    if v_resp_pre = 'false' then
                        v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <br/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);    
                        v_sw_error = true;
                    end if;

                end if;

            end loop;
        
        else
      
            IF  v_pre_verificar_categoria = 'si'  THEN
            
                  --Verifica agrupando por categoria programatica
                  for v_registros in (select
                                          c.id_gestion,
                                          c.id_cuenta_doc,
                                          dc.id_partida,
                                          sum(dc.precio_total_final) as precio_total_final,    
                                          c.id_moneda,
                                          par.codigo,
                                          par.nombre_partida,
                                          p.id_categoria_prog,
                                          cp.codigo_categoria,
                                          par.sw_movimiento,
                                          p.codigo_cc
                                      from cd.tcuenta_doc c
                                      inner join cd.trendicion_det r on r.id_cuenta_doc_rendicion = c.id_cuenta_doc
                                      inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                                      inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta 
                                      inner join pre.tpartida par on par.id_partida = dc.id_partida
                                      inner join pre.vpresupuesto_cc p on p.id_centro_costo = dc.id_centro_costo and dc.estado_reg = 'activo'
                                      inner join pre.vcategoria_programatica cp on p.id_categoria_prog = cp.id_categoria_programatica
                                      where dc.estado_reg = 'activo'
                                      and c.id_cuenta_doc = p_id_cuenta_doc                            
                                      group by                              
                                          p.id_categoria_prog,
                                          cp.codigo_categoria,
                                          c.id_gestion,
                                          c.id_cuenta_doc,
                                          dc.id_partida,
                                          c.id_moneda,
                                          par.codigo,
                                          par.nombre_partida,
                                          par.sw_movimiento,
                                          p.codigo_cc) loop
                                            
                      --Verifica que no sea partida de flujo                      
                      if v_registros.sw_movimiento != 'flujo' then
                          --Recupera un presupuesto cualquiera con la misma categoria para la verificacion
                          select 
                          p.id_presupuesto
                          into 
                          v_id_presupuesto                                      
                          from pre.vpresupuesto_cc p
                          where p.id_categoria_prog = v_registros.id_categoria_prog
                          offset 0 limit 1; 

                          --Verificación del presupuesto
                          v_resp_pre = pre.f_verificar_presupuesto_partida (v_id_presupuesto,
                                                                          v_registros.id_partida,
                                                                          v_registros.id_moneda,
                                                                          v_registros.precio_total_final);

                          --Verificación de error para definir el mensaje
                          if v_resp_pre = 'false' then
                              v_mensage_error = v_mensage_error||format('Presupuesto:  %s, partida (%s) %s <br/>', v_registros.codigo_cc, v_registros.codigo,v_registros.nombre_partida);
                              v_sw_error = true;
                          end if;

                      end if;

                  end loop;
            
            
            ELSEIF v_pre_verificar_tipo_cc = 'si' THEN

                        --RAC 27/02/2018  verificacion presupeustaria por control de techo y partida
                        --Verifica agrupando por TIPO DE PRESUPUESTO TECHO    
                        for v_registros in (select                                           
                                                c.id_gestion,
                                                c.id_cuenta_doc,                                          
                                                sum(dc.precio_total_final) as precio_total_final,                                           
                                                c.id_moneda,                                                
                                                tcc.codigo_techo,
                                                CASE
                                                 WHEN  tcc.control_partida::text = 'no' THEN
                                                    0
                                                 ELSE 
                                                     dc.id_partida
                                                 END     AS id_par,
                                             CASE
                                                 WHEN  tcc.control_partida::text = 'no' THEN
                                                    'No se considera partida'::varchar
                                                ELSE 
                                                   par.nombre_partida
                                             END AS nombre_partida_desc,
                                             pxp.aggarray(p.id_centro_costo) AS id_centro_costos  
                                                
                                                
                                            from cd.tcuenta_doc c
                                            inner join cd.trendicion_det r on r.id_cuenta_doc_rendicion = c.id_cuenta_doc
                                            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
                                            inner join conta.tdoc_concepto dc on dc.id_doc_compra_venta = dcv.id_doc_compra_venta 
                                            inner join pre.tpartida par on par.id_partida = dc.id_partida
                                            inner join param.vcentro_costo p on p.id_centro_costo = dc.id_centro_costo and dc.estado_reg = 'activo'
                                            inner join param.vtipo_cc_techo tcc ON tcc.id_tipo_cc = p.id_tipo_cc
                                            where dc.estado_reg = 'activo' and c.id_cuenta_doc = p_id_cuenta_doc                           
                                            group by                              
                                                
                                                c.id_gestion,
                                                c.id_cuenta_doc,
                                                tcc.control_partida,                                               
                                                tcc.codigo_techo,                                            
                                                c.id_moneda,                                                                                         
                                                p.codigo_cc,                                               
                                                id_par,                             
                                                nombre_partida_desc
                                            ) loop
                                            
                                            select 
                                            tp.codigo
                                            into v_cod_pre
                                            from pre.tpresupuesto pres
                                            join pre.ttipo_presupuesto tp on tp.codigo = pres.tipo_pres
                                            where pres.id_centro_costo = v_registros.id_centro_costos[1];
                                            
                                            
                                                     
                              --Verifica que no sea partida de flujo
                              --if v_registros.sw_movimiento != 'flujo' then
                               if v_cod_pre!='0' then
                                  v_resp_pre = pre.f_verificar_presupuesto_partida ( v_registros.id_centro_costos[1],
                                                                                    v_registros.id_par,
                                                                                    v_registros.id_moneda,
                                                                                    v_registros.precio_total_final,
                                                                                    'si');
                                                                                    
                                                                                    
                                  va_resp_pre = string_to_array(v_resp_pre,',');                                                  
/*if p_id_cuenta_doc = 6039 then
	raise exception 'rcm verificar ... $$ %, %, %, %',v_registros.id_centro_costos[1],v_registros.id_par,v_registros.id_moneda,v_registros.precio_total_final;
end if;*/                                                                                              
                                  if va_resp_pre[1] = 'false' then
                                      v_mensage_error = v_mensage_error||format('Presupuesto:  %s, ( %s) necesitamos %s, tenemos %s <br/>', v_registros.codigo_techo, v_registros.nombre_partida_desc,v_registros.precio_total_final::varchar,va_resp_pre[2] );    
                                      v_sw_error = true;
                                      
                                      
                                       --raise exception ' UTI, % , %, %, % , %',v_registros.id_centro_costos[1],  v_registros.id_par,v_registros.id_moneda, v_registros.precio_total_final, p_id_cuenta_doc;  
                                   
                                  end if;
                           end if;

                    end loop;
            
            
            ELSE
               raise exception 'no se reconoce el tipo de verificacion presupesutaria';            
            END IF;
            

        end if;
             
        --Despliegue de error su no hay presupuesto
        if v_sw_error then
            raise exception 'No se tiene suficiente presupuesto para: <br/> %', v_mensage_error;
        end if;
        --Respuesta
        return true;

    elsif p_operacion = 'comprometer_sol' then
        --COMPROMETER PRESUPUESTO DESDE LA SOLICITUD

        --Inicialización del contador
        v_i = 0;
           
        --Recorrido del detalle de la solicitud de la cuenta documentada
        for v_rendicion in (select
                            cdocd.id_cuenta_doc_det,
                            cdocd.id_centro_costo,
                            cdocd.id_concepto_ingas,
                            cdocd.monto_mb,
                            cdocd.id_partida,
                            cdocd.id_moneda_mb,
                            cig.desc_ingas,
                            par.sw_movimiento,
                            tp.movimiento
                            from cd.tcuenta_doc_det cdocd
                            inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = cdocd.id_concepto_ingas
                            inner join pre.vpresupuesto p on p.id_presupuesto = cdocd.id_centro_costo
                            inner join pre.ttipo_presupuesto tp on p.tipo_pres = tp.codigo
                            inner join pre.tpartida par on par.id_partida = cdocd.id_partida
                            where cdocd.id_cuenta_doc = p_id_cuenta_doc) loop
                        
                --Validación de partida de flujo
                if v_rendicion.sw_movimiento = 'flujo' then
                    if v_rendicion.movimiento != 'administrativo' then
                        raise exception 'Partida de flujo solo son admitidas con presupuestos administrativos';
                    end if;
                else
                    --Incremento del contador
                    v_i = v_i +1;

                    --Determinar partida a comprometer: armamos los array para enviar a presupuestos        
                    va_id_presupuesto[v_i]      = v_rendicion.id_centro_costo;
                    va_id_partida[v_i]          = v_rendicion.id_partida; 
                    va_momento[v_i]             = 1; --el momento 1 es el comprometido
                    va_monto[v_i]               = v_rendicion.monto_mb;
                    va_id_moneda[v_i]           = v_rendicion.id_moneda_mb;
                    va_columna_relacion[v_i]    = 'id_cuenta_doc_det';
                    va_fk_llave[v_i]            = v_rendicion.id_cuenta_doc_det;
                    va_id_doc_concepto[v_i]     = v_rendicion.id_cuenta_doc_det;
                    va_num_tramite[v_i]         = v_reg_sol.nro_tramite; 

                    --La fecha de solictud es la fecha de compromiso 
                    if now() < v_reg_sol.fecha then
                        va_fecha[v_i] = v_reg_sol.fecha::date;
                    else
                        --La fecha de reversion como maximo puede ser el 31 de diciembre   
                        va_fecha[v_i] = now()::date;
                        v_ano_1 = extract(year from now()::date);
                        v_ano_2 = extract(year from v_reg_sol.fecha::date);

                        if v_ano_1  >  v_ano_2 then
                            va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                        end if;
                    end if;
                end if;

        end loop;

        --Si el contador es mayor a cero
        if v_i>0 then
            --Llamada a la funcion de compromiso
            va_resp_ges = pre.f_gestionar_presupuesto(p_id_usuario,
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
                 
            --Actualizacion de los id_partida_ejecucion en el detalle de solicitud
            for v_cont in 1..v_i loop
                update cd.tcuenta_doc_det set
                id_partida_ejecucion = va_resp_ges[v_cont],
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario
                where id_cuenta_doc_det =  va_id_doc_concepto[v_cont];
            end loop;

            --Actualización de bandera de comprometido
            update cd.tcuenta_doc c set
            presu_comprometido = 'si'
            where c.id_cuenta_doc = p_id_cuenta_doc;  
        end if;

    elsif p_operacion = 'revertir_sol' then
       --REVERSIÓN DE PRESUPUESTO DE LA SOLICITUD
        v_i = 0;
        v_men_presu = '';
        
        --Recorrido del detalle de la rendición
        for v_registros in (select
                            cdocd.id_cuenta_doc_det,
                            cdocd.id_centro_costo,
                            cdocd.id_concepto_ingas,
                            cdocd.monto_mb,
                            cdocd.id_partida,
                            cdocd.id_moneda_mb,
                            cdocd.id_partida_ejecucion,
                            cig.desc_ingas,
                            par.sw_movimiento,
                            tp.movimiento
                            from cd.tcuenta_doc_det cdocd
                            inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = cdocd.id_concepto_ingas
                            inner join pre.vpresupuesto p on p.id_presupuesto = cdocd.id_centro_costo
                            inner join pre.ttipo_presupuesto tp on p.tipo_pres = tp.codigo
                            inner join pre.tpartida par on par.id_partida = dc.id_partida
                            where cdocd.id_cuenta_doc = p_id_cuenta_doc) loop
                     
            --Si no es partida de flujo
            if v_registros.sw_movimiento != 'flujo'  then

                --Validación partida ejecución
                if(v_registros.id_partida_ejecucion is null) then
                    raise exception 'El presupuesto del detalle con el identificador (%) no se encuentra comprometido',v_registros.id_doc_cuenta_doc_det;
                end if;
                             
                --Inicialiación de variables             
                v_comprometido=0;
                v_ejecutado=0;

                --Verificación del presupuesto
                select
                coalesce(ps_comprometido,0), coalesce(ps_ejecutado,0)  
                into v_comprometido, v_ejecutado
                from pre.f_verificar_com_eje_pag(v_registros.id_partida_ejecucion, v_registros.id_moneda_mb);

                --Definición de monto a revertir
                v_monto_a_revertir = coalesce(v_comprometido,0) - coalesce(v_ejecutado,0);  

                --Armamos los array para enviar a presupuestos          
                if v_monto_a_revertir != 0 then
                    --Incremento contador
                    v_i = v_i +1;                

                    --Parámetros para la reversión
                    va_id_presupuesto[v_i]          = v_registros.id_centro_costo;
                    va_id_partida[v_i]              = v_registros.id_partida;
                    va_momento[v_i]                 = 2; --el momento 2 con signo positivo es revertir
                    va_monto[v_i]                   = (v_monto_a_revertir)*-1;  -- considera la posibilidad de que a este item se le aya revertido algun monto
                    va_id_moneda[v_i]               = v_registros.id_moneda_mb;
                    va_id_partida_ejecucion[v_i]    = v_registros.id_partida_ejecucion;
                    va_columna_relacion[v_i]        = 'id_cuenta_doc_det';
                    va_fk_llave[v_i]                = v_registros.id_cuenta_doc_det;
                    va_id_doc_concepto[v_i]         = v_registros.id_cuenta_doc_det;
                    va_num_tramite[v_i]             = v_reg_sol.nro_tramite;

                    --La fecha de solictud es la fecha de compromiso 
                    if now() < v_reg_sol.fecha then
                        va_fecha[v_i] = v_reg_sol.fecha::date;
                    else
                        --La fecha de reversion como maximo puede ser el 31 de diciembre   
                        va_fecha[v_i] = now()::date;
                        v_ano_1 = extract(year from now()::date);
                        v_ano_2 = extract(year from v_reg_sol.fecha::date);

                        if v_ano_1 > v_ano_2 then
                            va_fecha[v_i] = ('31-12-'|| v_ano_2::varchar)::date;
                        end if;
                    end if;
                end if;

                --Definición del mensaje                
                v_men_presu = ' comprometido: '||coalesce(v_comprometido,0)::varchar||'  ejecutado: '||coalesce(v_ejecutado,0)::varchar||' \n'||v_men_presu;
              
            end if;
           
        end loop;

        --Llamada a la funcion de para reversion del presupuesto
        if v_i > 0 then
            va_resp_ges = pre.f_gestionar_presupuesto(p_id_usuario,
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
        end if;

        --Actualización de la bandera del comprometido de la cuenta documentada
        update cd.tcuenta_doc c set
        presu_comprometido = 'no'
        where c.id_cuenta_doc = p_id_cuenta_doc;
       
    else
        raise exception 'Operacion no implementada';
    end if;
   
    --Respuesta  
    return true;

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