--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_viatico_registrar_doc_rendicion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_cuenta_doc integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.f_viatico_registrar_doc_rendicion
 DESCRIPCION:   Genera automáticamente el documento de viático para la rendición
 AUTOR: 		RCM
 FECHA:	        04/12/2017
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/
DECLARE

	v_resp                          varchar;
    v_nombre_funcion                text;
    v_rec                           record;
    v_total_viatico                 numeric;
    v_id_moneda_base                integer;
    v_id_partida                    integer;
    v_id_gestion                    integer;
    v_id_concepto_ingas             integer;
    v_id_doc_compra_venta           integer;
    v_fun                           record;
    v_id_depto_conta                integer;
    v_id_tipo_doc_compra_venta      integer;
    v_registros                     record;
    v_parametros                    record;
    v_desc_ingas                    varchar;
    v_descuento_porc                numeric;
    v_descuento                     numeric;
    v_iva                           numeric;
    v_it                            numeric;
    v_ice                           numeric;

BEGIN
    
    -----------------------------
    --(1) VALIDACIONES INICIALES
    -----------------------------
    --Nombre de la función
	v_nombre_funcion = 'cd.f_viatico_registrar_doc_rendicion';

    --Obtiene datos de la cuenta documentada
    select tcdoc.codigo as codigo_tipo_cuenta_doc, cdoc.id_cuenta_doc,
    cdoc.id_plantilla, pla.desc_plantilla, cdoc.estado,
    cdoc.fecha_entrega, cdoc.nro_tramite, cdoc.id_funcionario, cdoc.id_depto,
    cdoc.id_moneda, cdoc.id_plantilla
    into v_rec
    from cd.tcuenta_doc cdoc
    inner join cd.ttipo_cuenta_doc tcdoc
    on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
    left join param.tplantilla pla
    on pla.id_plantilla = cdoc.id_plantilla
    where cdoc.id_cuenta_doc = p_id_cuenta_doc;

    if v_rec.codigo_tipo_cuenta_doc is null then
        raise exception 'Cuenta documentada no encontrada';
    end if;

    --Verifica que la rendición del viático esté en estado borrador
    if v_rec.estado <> 'borrador' then
        raise exception 'La rendición de viático debe estar en estado borrador';
    end if;

    --Obtención del concepto de gasto del viático
    select escr.id_concepto_ingas, cig.desc_ingas
    into v_id_concepto_ingas, v_desc_ingas
    from cd.tcuenta_doc cd
    left join cd.tescala_regla escr
    on escr.id_escala = cd.id_escala
    inner join param.tconcepto_ingas cig
    on cig.id_concepto_ingas = escr.id_concepto_ingas
    where cd.id_cuenta_doc = p_id_cuenta_doc
    and escr.codigo = 'CONGAS_VIA';

    if v_id_concepto_ingas is null then
        raise exception 'No se encuentra al concepto de gasto de viáticos.';
    end if;

    --Obtención de la gestión de la solicitud
    select id_gestion
    into v_id_gestion
    from param.tgestion
    where gestion = extract('year' from v_rec.fecha_entrega);

    --------------------------------------------------
    --(2) REGISTRO DEL DOCUMENTO DE RENDICIÓN DE VIÁTICO
    --------------------------------------------------
    --Obtener el total que corresponde al itinerario realizado
    select
    sum((cdocca.dias_destino * cdocca.cobertura_aplicada * cdocca.escala_viatico) +
    ((cdocca.dias_destino-1) * cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel))
    into v_total_viatico
    from cd.tcuenta_doc_calculo cdocca
    where cdocca.id_cuenta_doc = p_id_cuenta_doc;

    --Eliminación del documento de viático generado anteriormente si existe
    delete from cd.trendicion_det
    where id_cuenta_doc_rendicion = p_id_cuenta_doc
    and generado = 'si';

    if coalesce(v_total_viatico,0) <= 0 then
        return 'hecho';
    end if;

    --------------------------------------------------------
    --Generación del documento de viático para la rendición
    --------------------------------------------------------
    --Obtencion de datos del recibo de caja
    select
    funp.desc_funcionario1 as desc_funcionario, funp.ci, aux.id_auxiliar
    into v_fun
    from orga.tfuncionario fun
    inner join orga.vfuncionario_persona funp
    on funp.id_funcionario = fun.id_funcionario
    left join conta.tauxiliar aux on aux.id_auxiliar = fun.id_auxiliar
    where fun.id_funcionario = v_rec.id_funcionario;

    if v_fun.id_auxiliar is null then
        raise exception 'No existe registrado un auxiliar para %. Comuníquese con el depto. contable.',v_fun.desc_funcionario;
    end if;

    --Obtencion del depto de conta
    select dede.id_depto_destino
    into v_id_depto_conta
    from param.tdepto_depto dede
    inner join param.tdepto ddes on ddes.id_depto = dede.id_depto_destino
    inner join segu.tsubsistema sdes on sdes.id_subsistema = ddes.id_subsistema
    where dede.id_depto_origen = v_rec.id_depto
    and sdes.codigo = 'CONTA';

    if v_id_depto_conta is null then
        raise exception 'Depto. de Contabilidad no definido';
    end if;

    --Obtiene el id_tipo_doc_compra_venta
    select id_tipo_doc_compra_venta
    into v_id_tipo_doc_compra_venta
    from conta.ttipo_doc_compra_venta
    where codigo = 'V';

    if v_id_tipo_doc_compra_venta is null then
        raise exception 'Tipo documento compra venta invalido';
    end if;

    ----------------------------------------------------------------------------------------------
    --Genera automáticamente el documento de respaldo de la rendicion de la solicitud de efectivo
    ----------------------------------------------------------------------------------------------
    --obtener descuento porcentaje
    select  
       ps_descuento_porc,
       ps_descuento
     into
      v_descuento_porc,
      v_descuento
     FROM  conta.f_get_descuento_plantilla_calculo(v_rec.id_plantilla);
    
    --obtener iva
     select  
       ps_monto_porc
     into
      v_iva
     FROM  conta.f_get_detalle_plantilla_calculo(v_rec.id_plantilla, 'IVA');
     
   
    --recupera IT           
    select  
       ps_monto_porc
     into
      v_it
     FROM  conta.f_get_detalle_plantilla_calculo(v_rec.id_plantilla, 'IT');
    
    --recupera ICE            
    select  
       ps_monto_porc
     into
      v_ice
     FROM  conta.f_get_detalle_plantilla_calculo(v_rec.id_plantilla, 'ICE');

    --1. Documento de rendicion
    select
    'si' as revisado,-- = (p_hstore->'revisado')::varchar; --'si',--'revisado',
    'no' as movil,-- = (p_hstore->'movil')::varchar; --'no',--'movil',
    'compra' as tipo, -- (p_hstore->'tipo')::varchar; --'venta',--'tipo',
    0 as importe_excento, -- (p_hstore->'importe_excento')::numeric; --coalesce(null as venta.excento::varchar,'0'),--'importe_excento',
    v_rec.fecha_entrega as fecha, -- (p_hstore->'fecha')::date; --to_char(null as venta.fecha,'DD/MM/YYYY'),--'fecha',
    v_rec.nro_tramite as nro_documento, --v_rec.nro_tramite as nro_documento, -- (p_hstore->'nro_documento')::varchar; --COALESCE(null as venta.nro_factura,'0')::varchar,--'nro_documento',
    v_fun.ci as nit, -- (p_hstore->'nit')::varchar; --coalesce(null as venta.nit,''),--'nit',
    0 as importe_ice, -- (p_hstore->'importe_ice')::numeric; --null as venta.total_venta_msuc::varchar,--'importe_ice',
    '' as nro_autorizacion, -- (p_hstore->'nro_autorizacion')::varchar; --coalesce(null as venta.nroaut,''); --'nro_autorizacion',
    v_total_viatico * coalesce(v_iva,0) as importe_iva, -- (p_hstore->'importe_iva')::numeric; --(null as venta.total_venta_msuc * null as iva)::varchar,--'importe_iva',
    0 as importe_descuento, -- (p_hstore->'importe_descuento')::numeric; --'0',--'importe_descuento',
    v_total_viatico as importe_doc, -- (p_hstore->'importe_doc')::numeric; --(null as venta.total_venta_msuc )::varchar,--'importe_doc',
    'no' as sw_contabilizar, -- (p_hstore->'sw_contabilizar')::varchar; --'no',--'sw_contabilizar',
    'trendicion_det' as tabla_origen, -- (p_hstore->'tabla_origen')::varchar; --'vef.tventa',--'tabla_origen',
    'validado' as estado, -- (p_hstore->'estado')::varchar; --'validado',--'estado',
    v_id_depto_conta as id_depto_conta, -- (p_hstore->'id_depto_conta')::integer; --null as id_depto_conta::varchar,--'id_depto_conta',
    v_rec.id_cuenta_doc as id_origen, -- (p_hstore->'id_origen')::integer; --null as venta.id_venta::varchar,--'id_origen',
    'Rendición de viatico' as obs, -- (p_hstore->'obs')::varchar; --coalesce(null as venta.observaciones,''),--'obs',
    'activo' as estado_reg, -- (p_hstore->'estado_reg')::varchar; --'activo',--'estado_reg',
    '' as codigo_control, -- (p_hstore->'codigo_control')::varchar; --coalesce(null as venta.cod_control,''),--'codigo_control',
    v_total_viatico * coalesce(v_it,0) as importe_it, -- (p_hstore->'importe_it')::numeric; --(null as venta.total_venta_msuc * null as it)::varchar,--'importe_it',
    v_fun.desc_funcionario as razon_social, -- (p_hstore->'razon_social')::varchar; --coalesce(null as venta.nombre_factura,''),--'razon_social',
    v_total_viatico * coalesce(v_descuento_porc,0) as importe_descuento_ley, -- (p_hstore->'importe_descuento_ley')::numeric; --(null as venta.total_venta_msuc * null as descuento_porc)::varchar,--'importe_descuento_ley',
    v_total_viatico - (v_total_viatico * coalesce(v_descuento_porc,0)) as importe_pago_liquido, -- (p_hstore->'importe_pago_liquido')::numeric; --coalesce((null as venta.total_venta_msuc - (null as venta.total_venta_msuc * null as descuento_porc))::varchar,''),--'importe_pago_liquido',
    '' as nro_dui, -- (p_hstore->'nro_dui')::varchar; --'0',--'nro_dui',
    v_rec.id_moneda as id_moneda, -- (p_hstore->'id_moneda')::integer; --null as venta.id_moneda_sucursal::varchar,--'id_moneda',
    0 as importe_pendiente, -- (p_hstore->'importe_pendiente')::numeric; --'0',--'',
    0 as importe_anticipo, -- (p_hstore->'importe_anticipo')::numeric; --'0',--'importe_antimporte_pendienteicipo',
    0 as importe_retgar, -- (p_hstore->'importe_retgar')::numeric; --'0',--'importe_retgar',
    v_total_viatico - (v_total_viatico * coalesce(v_descuento_porc,0)) as importe_neto, -- (p_hstore->'importe_neto')::numeric; --(null as venta.total_venta_msuc - (null as venta.total_venta_msuc * null as descuento_porc))::varchar,--'importe_neto',--
    v_fun.id_auxiliar as id_auxiliar, -- (p_hstore->'id_auxiliar')::integer; --'',--'id_auxiliar',
    v_id_tipo_doc_compra_venta as id_tipo_compra_venta -- (p_hstore->'id_tipo_compra_venta')::integer; --v_id_tipo_compra_venta::varchar
    into v_registros;

    v_id_doc_compra_venta = conta.f_registrar_documento(0,p_id_usuario, v_rec.id_plantilla, '', p_usuario_ai, p_id_usuario_ai::varchar,hstore(v_registros));

    --Define las variables para el registro de la rendición
    select
    p_id_cuenta_doc as id_cuenta_doc,
    v_total_viatico as importe_doc,
    v_id_doc_compra_venta as id_doc_compra_venta,
    p_usuario_ai as _nombre_usuario_ai,
    p_id_usuario_ai as _id_usuario_ai,
    'si' as generado
    into v_parametros;

    --2 Creación del registro de la rendicion detalle
    v_resp = cd.f_insertar_rendicion_det (
        p_id_usuario,
        p_id_cuenta_doc,
        hstore(v_parametros)
    );

    --3 Detalle del documento de rendicion
    insert into conta.tdoc_concepto(
        estado_reg,
        id_orden_trabajo,
        id_centro_costo,
        id_concepto_ingas,
        descripcion,
        cantidad_sol,
        precio_unitario,
        precio_total,
        id_usuario_reg,
        fecha_reg,
        id_doc_compra_venta,
        precio_total_final,
        id_partida
    )
    select
    'activo',
    null,                               --id_orden_trabajo
    cp.id_centro_costo,               
    v_id_concepto_ingas,
    v_desc_ingas,                       -- <- Mejr poner una descripcion de viaje
    1,                                  -- cantidad_sol
    v_total_viatico * cp.prorrateo,     -- precio_unitario
    v_total_viatico * cp.prorrateo,     -- precio_total
    p_id_usuario,
    now(),
    v_id_doc_compra_venta,
    v_total_viatico * cp.prorrateo,    -- precio_total_final
    (select ps_id_partida
    from conta.f_get_config_relacion_contable('CUECOMP', v_id_gestion, v_id_concepto_ingas, cp.id_centro_costo,
    'No se encontró relación contable para Viáticos. <br> Mensaje: ')) as id_partida
    from cd.tcuenta_doc_prorrateo cp
    where cp.id_cuenta_doc = p_id_cuenta_doc;

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