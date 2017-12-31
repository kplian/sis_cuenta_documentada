CREATE OR REPLACE FUNCTION cd.f_viatico_registrar_concepto_gasto (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_cuenta_doc INTEGER
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.f_viatico_registrar_concepto_gasto
 DESCRIPCION:   Registra el total del viático calcularo con su concepto de gasto
 AUTOR: 		RCM
 FECHA:	        16/11/2017
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
    v_rec               record;
    v_total_viatico     numeric;
    v_id_moneda_base    integer;
    v_id_partida        integer;
    v_id_gestion        integer;
    v_id_centro_costo   integer;
    v_total_prorrateo   numeric;
    v_tipo_contrato     varchar;
    v_clave             varchar;
    v_clave_hotel       varchar;
    v_rec_hot           record;

BEGIN
    
    --Nombre de la función
	v_nombre_funcion = 'cd.f_viatico_registrar_concepto_gasto';

    --Obtencion del tipo de contrato de la solicitud
    select tipo_contrato
    into v_tipo_contrato
    from cd.tcuenta_doc
    where id_cuenta_doc = p_id_cuenta_doc;

    if v_tipo_contrato is null then
        raise exception 'Tipo de contrato del solicitante no encontrado';
    end if;

    if v_tipo_contrato = 'planta_obra_determinada' then
        v_clave = 'CONGAS_VIA_PLA';
        v_clave_hotel = 'CONGAS_HOT_PLA';
    elsif v_tipo_contrato = 'servicio' then
        v_clave = 'CONGAS_VIA_SER';
        v_clave_hotel = 'CONGAS_HOT_SER';
    else
        raise exception 'Tipo de contrato no valido: %',v_tipo_contrato;
    end if;

    --Obtención de datos de la solicitud (VIATICO)
    select escr.id_concepto_ingas, cd.fecha_entrega, cd.fecha, cd.id_moneda
    into v_rec
    from cd.tcuenta_doc cd
    left join cd.tescala_regla escr
    on escr.id_escala = cd.id_escala
    where cd.id_cuenta_doc = p_id_cuenta_doc
    and escr.codigo = v_clave;

    --Verificación de existencia de Concepto de Gasto en la escala
    if v_rec.id_concepto_ingas is null then
        raise exception 'No se encuenta definido el Concepto de Gasto para Viáticos para la escala de la solicitud. Comuníquese con el Administrador';
    end if;

    --Obtención de datos de la solicitud (HOTEL)
    select escr.id_concepto_ingas, cd.fecha_entrega, cd.fecha, cd.id_moneda
    into v_rec_hot
    from cd.tcuenta_doc cd
    left join cd.tescala_regla escr
    on escr.id_escala = cd.id_escala
    where cd.id_cuenta_doc = p_id_cuenta_doc
    and escr.codigo = v_clave_hotel;

    --Verificación de existencia de Concepto de Gasto en la escala
    if v_rec_hot.id_concepto_ingas is null then
        raise exception 'No se encuenta definido el Concepto de Gasto para Hotel para la escala de la solicitud. Comuníquese con el Administrador';
    end if;

    --Eliminación del registro del concepto de gasto registrado
    delete from cd.tcuenta_doc_det
    where id_cuenta_doc = p_id_cuenta_doc
    and id_concepto_ingas in (select id_concepto_ingas
                            from cd.tcuenta_doc cd
                            left join cd.tescala_regla escr
                            on escr.id_escala = cd.id_escala
                            where cd.id_cuenta_doc = p_id_cuenta_doc
                            and escr.codigo in ('CONGAS_VIA_PLA','CONGAS_VIA_SER','CONGAS_HOT_PLA','CONGAS_HOT_SER'));

    --Obtencion del primer centro de costo registrado en el prorrateo
    select id_centro_costo
    into v_id_centro_costo
    from cd.tcuenta_doc_prorrateo
    where id_cuenta_doc = p_id_cuenta_doc
    order by id_cuenta_doc_prorrateo limit 1;

    if v_id_centro_costo is null then
        --No genera nada
        return 'hecho';
    end if;

    --Obtención de la gestión de la solicitud
    select id_gestion
    into v_id_gestion
    from param.tgestion
    where gestion = extract('year' from v_rec.fecha);

    --Obtención de la partida del concepto de gasto VIATICO
    select ps_id_partida
    into v_id_partida
    from conta.f_get_config_relacion_contable(
        'CUECOMP',
        v_id_gestion,
        v_rec.id_concepto_ingas,
        v_id_centro_costo,
        'No se encontró relación contable para Viáticos. <br> Mensaje: ',
        v_rec.id_moneda
        );
    
    --Obtención de la moneda base
    v_id_moneda_base = param.f_get_moneda_base();

    --Inserción del registro con el total del viático calculado en el concepto de gasto parametrizado
    insert into cd.tcuenta_doc_det(
    id_usuario_reg,
    fecha_reg,
    estado_reg,
    id_usuario_ai,
    usuario_ai,
    id_cuenta_doc,
    id_centro_costo,
    id_partida,
    id_concepto_ingas,
    monto_mo,
    monto_mb,
    id_moneda,
    id_moneda_mb,
    generado
    )
    select
    p_id_usuario, now(),'activo',p_id_usuario_ai,p_usuario_ai,p_id_cuenta_doc,
    cp.id_centro_costo,
    v_id_partida,
    v_rec.id_concepto_ingas,
    sum(cdocca.parcial_viatico) * cp.prorrateo,
    param.f_convertir_moneda(cdoc.id_moneda, --moneda origen para conversion
                            v_id_moneda_base,   --moneda a la que sera convertido
                            sum(cdocca.parcial_viatico)*cp.prorrateo, --este monto siemrpe estara en moenda base
                            cdoc.fecha, 
                            'O',-- tipo oficial, venta, compra 
                            NULL),--defecto dos decimales   
    cdoc.id_moneda,
    v_id_moneda_base,
    'si'
    from cd.vcuenta_doc_calculo cdocca
    inner join cd.tcuenta_doc cdoc
    on cdoc.id_cuenta_doc = cdocca.id_cuenta_doc
    inner join cd.tcuenta_doc_prorrateo cp
    on cp.id_cuenta_doc = cdoc.id_cuenta_doc
    where cdocca.id_cuenta_doc = p_id_cuenta_doc
    group by cdoc.id_moneda, cdoc.fecha, cp.id_centro_costo, cp.prorrateo;

    --Obtención de la partida del concepto de gasto HOTEL
    select ps_id_partida
    into v_id_partida
    from conta.f_get_config_relacion_contable(
        'CUECOMP',
        v_id_gestion,
        v_rec_hot.id_concepto_ingas,
        v_id_centro_costo,
        'No se encontró relación contable para Hotel. <br> Mensaje: ',
        v_rec.id_moneda
        );

    --Inserción del registro con el total del viático calculado en el concepto de gasto parametrizado
    insert into cd.tcuenta_doc_det(
    id_usuario_reg,
    fecha_reg,
    estado_reg,
    id_usuario_ai,
    usuario_ai,
    id_cuenta_doc,
    id_centro_costo,
    id_partida,
    id_concepto_ingas,
    monto_mo,
    monto_mb,
    id_moneda,
    id_moneda_mb,
    generado
    )
    select
    p_id_usuario, now(),'activo',p_id_usuario_ai,p_usuario_ai,p_id_cuenta_doc,
    cp.id_centro_costo,
    v_id_partida,
    v_rec_hot.id_concepto_ingas,
    sum(cdocca.parcial_hotel) * cp.prorrateo,
    param.f_convertir_moneda(cdoc.id_moneda, --moneda origen para conversion
                            v_id_moneda_base,   --moneda a la que sera convertido
                            sum(cdocca.parcial_hotel)*cp.prorrateo, --este monto siemrpe estara en moenda base
                            cdoc.fecha, 
                            'O',-- tipo oficial, venta, compra 
                            NULL),--defecto dos decimales   
    cdoc.id_moneda,
    v_id_moneda_base,
    'si'
    from cd.vcuenta_doc_calculo cdocca
    inner join cd.tcuenta_doc cdoc
    on cdoc.id_cuenta_doc = cdocca.id_cuenta_doc
    inner join cd.tcuenta_doc_prorrateo cp
    on cp.id_cuenta_doc = cdoc.id_cuenta_doc
    where cdocca.id_cuenta_doc = p_id_cuenta_doc
    group by cdoc.id_moneda, cdoc.fecha, cp.id_centro_costo, cp.prorrateo;


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
SECURITY INVOKER;