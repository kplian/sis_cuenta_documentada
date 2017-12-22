CREATE OR REPLACE FUNCTION cd.f_insertar_rendicion_det (
  p_id_usuario integer,
  p_id_cuenta_doc integer,
  p_parametros public.hstore
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.f_viatico_registrar_doc_rendicion
 DESCRIPCION:   Inserta el registro en la tabla cd.trendicion_det
 AUTOR: 		RCM
 FECHA:	        05/12/2017
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/
DECLARE

	v_resp              varchar;
    v_nombre_funcion    text;
    v_tope                  numeric;
    v_registros             record;
    v_fecha_doc             date;
    v_cd_comprometer_presupuesto     varchar;
    v_id_rendicion_det integer;
    v_generado varchar;

BEGIN

    v_nombre_funcion = 'cd.f_insertar_rendicion_det';
    
    --Obtención de parámetros
    v_tope  = pxp.f_get_variable_global('cd_monto_factura_maximo')::numeric;
    v_cd_comprometer_presupuesto = pxp.f_get_variable_global('cd_comprometer_presupuesto');

    --Obtención de datos de la cuenta documentada
    select
    c.importe,
    c.estado,
    c.id_cuenta_doc,
    cdr.sw_max_doc_rend,
    cdr.estado as estado_cdr,
    cdr.importe as importe_rendicion,
    per.fecha_ini,
    per.fecha_fin
    into
    v_registros
    from cd.tcuenta_doc c
    inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
    left join param.tperiodo per on per.id_periodo=cdr.id_periodo
    where cdr.id_cuenta_doc = p_id_cuenta_doc;


    if v_registros.estado != 'contabilizado' then
        raise exception 'Solo puede añadir facturas en solicitudes entregadas (contabilizada)';
    end if;

    if v_registros.estado_cdr not in ('borrador','vbrendicion') then
        raise exception 'Solo puede añadir facturas en rediciones en borrador o vbtesoreria, (no en  %)',v_registros.estado_cdr;
    end if;

    if v_registros.estado_cdr not in ('borrador') and v_cd_comprometer_presupuesto = 'si' then
        raise exception 'Solo puede añadir en borrador por que los documentos se encuentran comprometidos';
    end if;

    --TODO considerar moneda del documento, el tope esta en moneda base ...
    if v_registros.sw_max_doc_rend = 'no' and  (p_parametros->'importe_doc')::numeric > v_tope then
        raise exception 'No puede registrarse documentos mayortes a %, si es necesario solicite la autorización en tesoreria para proceder',v_tope;
    end if;

    select fecha into v_fecha_doc
    from conta.tdoc_compra_venta
    where id_doc_compra_venta = (p_parametros->'id_doc_compra_venta')::integer;

    if not v_fecha_doc between v_registros.fecha_ini and v_registros.fecha_fin then
        raise exception 'El documento no corresponde al periodo % %', v_registros.fecha_ini, v_registros.fecha_fin;
    end if;

    v_generado = coalesce((p_parametros->'generado')::varchar,'no');

    --Sentencia de la insercion
    insert into cd.trendicion_det(
    id_doc_compra_venta,
    estado_reg,
    id_cuenta_doc_rendicion,
    id_cuenta_doc,
    id_usuario_reg,
    usuario_ai,
    fecha_reg,
    id_usuario_ai,
    fecha_mod,
    id_usuario_mod,
    generado
    ) values(
    (p_parametros->'id_doc_compra_venta')::integer,
    'activo',
    (p_parametros->'id_cuenta_doc')::integer, --registro de la rendicion
    v_registros.id_cuenta_doc, --reg de la solicitud
    p_id_usuario,
    (p_parametros->'_nombre_usuario_ai')::varchar,
    now(),
    (p_parametros->'_id_usuario_ai')::integer,
    null,
    null,
    v_generado
    ) returning id_rendicion_det into v_id_rendicion_det;

    -------------------------------------
    -- Valida registros de la rendicion
    -------------------------------------
    if not cd.f_validar_documentos(p_id_usuario, (p_parametros->'id_cuenta_doc')::integer) then
        raise exception 'Error al validar documentos de la rendición';
    end if;

    --Actualiza la relación con la tabla compra venta
    update conta.tdoc_compra_venta dcv set
    tabla_origen = 'cd.trendicion_det',
    id_origen = v_id_rendicion_det
    where dcv.id_doc_compra_venta = (p_parametros->'id_doc_compra_venta')::integer;


    --Definicion de la respuesta
    v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición almacenada con éxito (id_rendicion_det'||v_id_rendicion_det||')');
    v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_id_rendicion_det::varchar);

    --Devuelve la respuesta
    return v_resp;
    

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
SECURITY INVOKER;