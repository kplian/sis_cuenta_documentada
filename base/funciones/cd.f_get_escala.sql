CREATE OR REPLACE FUNCTION cd.f_get_escala (
  p_tipo varchar,
  p_fecha date
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Cuenta Documentada
 FUNCION: 		cd.f_get_escala
 DESCRIPCION:   Funcion que devuelve el ID de la escala vigente a la fecha. Verifica que sólo haya una escala activa a la vez por Viático y por Fondo en avance
 AUTOR: 		RCM
 FECHA:	        15/11/2017
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
    v_cont				bigint;
    v_id_escala			integer;

BEGIN

	v_nombre_funcion = 'cd.f_get_escala';
    
    --Verificación de parámetro: tipo
    if p_tipo not in ('viatico','fondo_avance') then
    	raise exception 'Tipo de Cuenta documentada inválido';
    end if;
    
    --Verifica si existe una escala vigente, o si existe más de una
    select count(1)
    into v_cont
    from cd.tescala
    where tipo = p_tipo
    and estado_reg = 'activo'
    and ((p_fecha between desde and hasta) or (p_fecha >= desde and hasta is null));
    
    if v_cont = 0 then
    	raise exception 'No se encuentra Escala vigente para el tipo solicitado (%). Comuníquese con el administrador.',p_tipo;
    elsif v_cont > 1 then
    	raise exception 'Existe más de una Escala vigente para el tipo solicitado (%). Comuníquese con el administrador.',p_tipo;
    end if;
    
    --Obtiene el ID de la escala vigente
    select id_escala
    into v_id_escala
    from cd.tescala
    where tipo = p_tipo
    and estado_reg = 'activo'
    and ((p_fecha between desde and hasta) or (p_fecha >= desde and hasta is null));
    
    --Respuesta
    return v_id_escala;
    
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