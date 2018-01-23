CREATE OR REPLACE FUNCTION cd.f_lista_depto_conta_pago_solicitante_wf (
  p_id_usuario integer,
  p_id_tipo_estado integer,
  p_fecha date = now(),
  p_id_estado_wf integer = NULL::integer,
  p_count boolean = false,
  p_limit integer = 1,
  p_start integer = 0,
  p_filtro varchar = '0=0'::character varying
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE ...
***************************************************************************
 SCRIPT:    adq.f_lista_depto_conta_x_lb_wf_sel
 DESCRIPCIÓN:   Lista los departmatos de tesoreia que coinciden con la EP y UP de la cotizacion adjudicada
 AUTOR:     Rensi Arteaga Copari
 FECHA:     20/01/2018
 COMENTARIOS: 
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      

***************************************************************************/

-------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS
/*


  p_id_usuario integer,                                identificador del actual usuario de sistema
  p_id_tipo_estado integer,                            idnetificador del tipo estado del que se quiere obtener el listado de funcionario  (se correponde con tipo_estado que le sigue a id_estado_wf proporcionado)                       
  p_fecha date = now(),                                fecha  --para verificar asginacion de cargo con organigrama
  p_id_estado_wf integer = NULL::integer,              identificaro de estado_wf actual en el proceso_wf
  p_count boolean = false,                             si queremos obtener numero de funcionario = true por defecto false
  p_limit integer = 1,                                 los siguiente son parametros para filtrar en la consulta
  p_start integer = 0,
  p_filtro varchar = '0=0'::character varying




*/

DECLARE
  
    v_depto_asignacion    varchar;
    v_nombre_depto_func_list   varchar;
    
    v_consulta varchar;
    v_nombre_funcion varchar;
    v_resp varchar;
    
    
     v_cad_ep varchar;
     v_cad_uo varchar;
    v_id_tabla   integer;
    
    v_a_eps varchar[];
    v_a_uos varchar[];
    v_uos_eps varchar;
    v_size    integer;
    v_i       integer;
    v_codigo_subsistema varchar;
    v_id_deptos_conta varchar;
    v_registros_depto   record;
    g_registros     record;

BEGIN
  v_nombre_funcion ='cd.f_lista_depto_conta_pago_solicitante_wf';

    --recuperamos la cotizacion a partir del id_estado_wf
    --validar de que sistema es el estado_wf
    
     select 
      cd.id_depto_lb,
      cd.id_depto_conta
    into
      v_registros_depto
    from cd.tpago_simple cd
    where cd.id_estado_wf =  p_id_estado_wf;
    
    
    v_id_deptos_conta = '0';
    
   
    
   
   
    IF not p_count then
    
    
              v_consulta:='SELECT 
                              DISTINCT (DEPPTO.id_depto),
                               DEPPTO.codigo as codigo_depto,
                               DEPPTO.nombre_corto as nombre_corto_depto,
                               DEPPTO.nombre as nombre_depto,
                               1 as prioridad,
                               SUBSIS.nombre as subsistema
                            FROM param.tdepto DEPPTO
                            INNER JOIN segu.tsubsistema SUBSIS on SUBSIS.id_subsistema=DEPPTO.id_subsistema
                            WHERE  DEPPTO.estado_reg = ''activo'' and
                               (
                                DEPPTO.id_depto in ('|| v_registros_depto.id_depto_conta::Varchar ||')
                               )
                               and '||p_filtro||'
                      limit '|| p_limit::varchar||' offset '||p_start::varchar; 
                      
                   
                                          
                   FOR g_registros in execute (v_consulta)LOOP     
                     RETURN NEXT g_registros;
                   END LOOP;
                      
      ELSE
                  v_consulta='select
                                  COUNT(DEPPTO.id_depto) as total
                                  FROM param.tdepto DEPPTO
                                  INNER JOIN segu.tsubsistema SUBSIS on SUBSIS.id_subsistema=DEPPTO.id_subsistema
                                where DEPPTO.estado_reg = ''activo'' and
                                
                                (
                                         DEPPTO.id_depto in ('|| v_registros_depto.id_depto_conta::Varchar ||')
                                 )
                                and '||p_filtro;   
                                          
                   FOR g_registros in execute (v_consulta)LOOP     
                     RETURN NEXT g_registros;
                   END LOOP;
                       
                       
    END IF;
               
        
       
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
COST 100 ROWS 1000;