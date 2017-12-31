CREATE OR REPLACE FUNCTION cd.f_get_total_cuenta_doc_sol (
  p_id_cuenta_doc INTEGER,
  p_moneda_base VARCHAR = 'si',
  out o_estado VARCHAR,
  out o_total NUMERIC,
  out o_tipo_cuenta_doc VARCHAR,
  out o_id_moneda INTEGER,
  out o_id_concepto_ingas INTEGER [],
  out o_importe_sol NUMERIC []
)
RETURNS record AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.f_get_total_cuenta_doc_sol
 DESCRIPCION:   Obtiene el total de la solicitud o rendicion de la cuenta documentada(viático, fondo en avance). También devuelve en array el
 				total solicitado por concepto de gasto.
 AUTOR: 		RCM
 FECHA:	        24-11-2017
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
    v_rec_cd            record;
    v_id_moneda_base    integer;
    v_importe_total     numeric;

BEGIN

	--Identificación de la función
	v_nombre_funcion = 'cd.f_get_total_cuenta_doc_sol';
    
    ------------------
    --DATOS INICIALES
    ------------------
    --Obtención de datos de la cuenta documentada
    select
    cd.id_cuenta_doc, cd.id_moneda, cd.importe, tcd.codigo as tipo_cuenta_doc, cd.estado,
    cd.fecha
    into v_rec_cd
    from cd.tcuenta_doc cd
    inner join cd.ttipo_cuenta_doc tcd
    on tcd.id_tipo_cuenta_doc = cd.id_tipo_cuenta_doc
    where cd.id_cuenta_doc = p_id_cuenta_doc;
    
    if v_rec_cd.id_cuenta_doc is null then
    	raise exception 'Cuenta documentada no encontrada';
    end if;
    
	--Obtener moneda base
    v_id_moneda_base = param.f_get_moneda_base();

	--Conversión del importe total a la moneda base o la original    
    o_id_moneda = v_rec_cd.id_moneda;
    
    if p_moneda_base = 'si' then
    
    	o_id_moneda = v_id_moneda_base;
        v_importe_total = param.f_convertir_moneda(v_rec_cd.id_moneda, --moneda origen para conversion
                                                    v_id_moneda_base,   --moneda a la que sera convertido
                                                    v_rec_cd.importe, --monto a convertir
                                                    v_rec_cd.fecha, 
                                                    'O',-- tipo oficial, venta, compra 
                                                    NULL);--defecto dos decimales  
    end if;
    
    --Asignación a variables de salida
    o_tipo_cuenta_doc = v_rec_cd.tipo_cuenta_doc;
    o_estado = v_rec_cd.estado;

    ------------------------------------------------------------------
    -- LOGICA POR TIPO DE CUENTA DOC PARA OBTENER EL TOTAL REGISTRADO
    ------------------------------------------------------------------
    if v_rec_cd.tipo_cuenta_doc in ('SOLVIA','SOLFONAVA') then
        --Solicitud de viatico: obtiene el total del detalle, si este es nulo de la cabecera
        o_total = 0;
        
        --Recorrido del detalle del viático
        for v_rec in select id_concepto_ingas, sum(monto_mb) as total_mb, sum(monto_mo) as total
                    from cd.tcuenta_doc_det
                    where id_cuenta_doc = p_id_cuenta_doc
                    group by id_concepto_ingas loop
        
            --Se guarda concepto gasto en array
            o_id_concepto_ingas = array_append(o_id_concepto_ingas, v_rec.id_concepto_ingas);            
            
            --Se guarda importe del concepto de gasto en array
            if p_moneda_base = 'si' then
                o_importe_sol = array_append(o_importe_sol, v_rec.total_mb);
                --Suma de los parciales para obtener el total
                o_total = o_total + v_rec.total_mb;
            else
                o_importe_sol = array_append(o_importe_sol, v_rec.total);
                --Suma de los parciales para obtener el total
                o_total = o_total + v_rec.total;
            end if;

        end loop;

        --Si el monto del detalle es cero, entonces devuelve el importe de la cabecera por tratarse fondo en avance
        if o_total = 0 then
            o_total = v_importe_total;
        end if;

    elsif v_rec_cd.tipo_cuenta_doc in ('RVI','RFA') then
        --Rendicion de viatico: obtiene el total a partir de los documentos registrados (facturas, recibos, etc.)
        o_total = 0;

        for v_rec in select
                    dcv.id_moneda, dc.id_concepto_ingas, sum(dc.precio_total_final) as total
                    from cd.tcuenta_doc cdoc
                    inner join cd.trendicion_det rd
                    on rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc
                    inner join conta.tdoc_compra_venta dcv
                    on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                    inner join conta.tdoc_concepto dc
                    on dc.id_doc_compra_venta = dcv.id_doc_compra_venta
                    where cdoc.id_cuenta_doc = p_id_cuenta_doc
                    group by dcv.id_moneda, dc.id_concepto_ingas loop

            --Se guarda concepto gasto en array
            o_id_concepto_ingas = array_append(o_id_concepto_ingas, v_rec.id_concepto_ingas);            
            
            --Se guarda importe del concepto de gasto en array
            if p_moneda_base = 'si' then
                o_importe_sol = array_append(o_importe_sol, v_rec.total);
                --Suma de los parciales para obtener el total
                o_total = o_total + v_rec.total;
            else
                o_importe_sol = array_append(o_importe_sol, v_rec.total);
                --Suma de los parciales para obtener el total
                o_total = o_total + v_rec.total;
            end if;

        end loop;

        --Si el monto del detalle es cero, entonces devuelve el importe de la cabecera por tratarse fondo en avance
        if o_total = 0 then
            o_total = v_importe_total;
        end if;

    else
        
        raise exception 'Tipo de cuenta documentada no válido (%)',coalesce(v_rec_cd.tipo_cuenta_doc,'N/D');

    end if;

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