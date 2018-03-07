CREATE OR REPLACE FUNCTION cd.f_cd_cambia_estado_wf_devrep_uno (
  p_id_usuario integer,
  p_id_proceso_wf integer,
  p_id_estado_anterior integer,
  p_id_tipo_estado_actual integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       cd.f_cd_cambia_estado_wf_devrep_uno
                
 DESCRIPCION:   Función para evaluar el cambio de estado cuando es una devolución/reposición
 AUTOR:         RCM
 FECHA:         26/02/2018
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/
DECLARE

	v_nombre_funcion text;
    v_id_cuenta_doc integer;
    v_rec record;
    v_saldo numeric;
    v_resp varchar;
    v_resp1 boolean = false;
    v_rec_saldo record;

BEGIN

  v_nombre_funcion = 'cd.f_cd_cambia_estado_wf_devrep_uno';

  --Obtención de datos de la cuenta documentada
  select
  cd.id_cuenta_doc, cd.id_cuenta_doc_fk, cd.tipo_rendicion, cd.dev_saldo, cd.dev_tipo
  into v_rec
  from cd.tcuenta_doc cd
  where cd.id_proceso_wf = p_id_proceso_wf;
  
  --Si es una rendición parcial devuelve TRUE;
  if v_rec.tipo_rendicion = 'parcial'  then
	v_resp1 = true;
  elsif v_rec.tipo_rendicion = 'final' then
  
  	if v_rec.dev_tipo = 'caja' then
    	v_resp1 = true;
    else
    	--Verifica el saldo, si es cero pasa a rendicion, de lo contrario va a tesoreria
    	select * into v_rec_saldo from cd.f_get_saldo_totales_cuenta_doc(v_rec.id_cuenta_doc);
    
    	if v_rec_saldo.o_saldo = 0 then

            --Actualiza el registro de cuenta doc poniendo el saldo en cero
            update cd.tcuenta_doc set
            dev_saldo = 0,
            dev_tipo = 'deposito'
            where id_cuenta_doc = v_rec.id_cuenta_doc;

        	v_resp1 = true;
        end if;
    end if;
    
  end if;	
--  raise exception 'uno: %',v_resp1;
  --Respuesta negativa por defecto
  return v_resp1;
  

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