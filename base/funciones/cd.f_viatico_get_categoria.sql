CREATE OR REPLACE FUNCTION cd.f_viatico_get_categoria (
  p_id_escala integer,
  p_id_cuenta_doc integer
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.f_viatico_get_categoria
 DESCRIPCION:   Obtiene la categoría de la escala de viáticos de la solicitud enviada
 AUTOR: 		RCM
 FECHA:	        05-09-2017 17:54:29
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/
DECLARE

	v_resp varchar;
    v_nombre_funcion text;
    v_id_tipo_categoria integer;

BEGIN

	v_nombre_funcion = 'f_viatico_get_categoria';
    
    --Verifica que existan categorías registradas
    if not exists(select 1 from cd.ttipo_categoria
    			where id_escala = p_id_escala) then
    	raise exception 'No existen categorías en la Escala de Viáticos vigente';
    end if;

    --Verifica si existen varias categorías registradas    
    if (select count(1) from cd.ttipo_categoria
    	where id_escala = p_id_escala) > 1 then
    	--Existe más de un categoría. Debe implementarse la lógica en función del solicitante
        raise exception 'Existe más de una Categoría en la Escala de Viáticos vigente. Debe implementarse la lógica para automatizar la selección de la categoría';
    else
    	--Existe sólo un registro, entonces se considera esa categoría como de aplicación general
        select id_tipo_categoria
        into v_id_tipo_categoria
        from cd.ttipo_categoria
        where id_escala = p_id_escala;
    end if;
    
    --Respuesta
    return v_id_tipo_categoria;

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