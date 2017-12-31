CREATE OR REPLACE FUNCTION cd.f_actualizar_cuenta_doc_total_cabecera (
  p_id_usuario integer,
  p_id_cuenta_doc integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Cuenta Documentada
 FUNCION: 		cd.f_actualizar_cuenta_doc_total_cabecera
 DESCRIPCION:   Actualiza el total del importe solicitado en la cabecera de la cuenta documentada
 AUTOR: 		RCM
 FECHA:	        29/11/2017
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/
DECLARE

	v_nombre_funcion   	text;
	v_resp				varchar;
    v_total             numeric;

BEGIN

	v_nombre_funcion = 'cd.f_actualizar_cuenta_doc_total_cabecera';
    

    --Obtener el total de los conceptos de gasto registrados
    select o_total into v_total from cd.f_get_total_cuenta_doc_sol(p_id_cuenta_doc,'no');

    --Actualizacion de la cuenta documentada
    update cd.tcuenta_doc set
    id_usuario_mod = p_id_usuario,
    fecha_mod = now(),
    importe = v_total
    where id_cuenta_doc = p_id_cuenta_doc;

    --Respuesta
    return 'hecho';
    
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