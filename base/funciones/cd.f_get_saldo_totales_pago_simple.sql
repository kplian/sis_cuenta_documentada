CREATE OR REPLACE FUNCTION cd.f_get_saldo_totales_pago_simple (
  p_id_pago_simple integer,
  out p_monto numeric,
  out o_total_documentos numeric,
  out o_liquido_pagado numeric
)
RETURNS record AS
$body$
    /**************************************************************************
     SISTEMA:       Cuenta Documenta
     FUNCION:       cd.f_get_saldo_totales_pago_simple
     DESCRIPCION:   Obtiene los totales de los documentos asociados
     AUTOR:         RAC
     FECHA:         06-01-2018
     COMENTARIOS:   
    ***************************************************************************
     HISTORIAL DE MODIFICACIONES:

     DESCRIPCION:   
     AUTOR:         
     FECHA:     
    ***************************************************************************/
    DECLARE

        v_resp                      varchar;
        v_nombre_funcion            text;
        v_rec                       record;
        v_rec_cd                    record;
        v_id_cuenta_doc_sol         integer;
        v_total_solicitado          numeric;
        v_total_rendido             numeric;
        v_total_rendido_borrador    numeric;
        v_saldo                     numeric;
        v_saldo_parcial             numeric;
        v_a_favor_de                varchar;
        v_por_caja                  varchar = 'no';
        v_total_dev                 numeric;
        v_total_recibo_ingreso      numeric;
        v_max_cd_caja               numeric;
        v_finalizacion              varchar;
        v_total_rep                 numeric;

    BEGIN

        --Identificación de la función
        v_nombre_funcion = 'cd.f_get_saldo_totales_pago_simple';

        select 
          sum(dcv.importe_pago_liquido) as importe_pago_liquido,
          sum(dcv.importe_doc ) as importe_doc
        INTO
          o_total_documentos,
          o_liquido_pagado          
        from cd.tpago_simple_det psd
        inner join conta.tdoc_compra_venta dcv   on dcv.id_doc_compra_venta = psd.id_doc_compra_venta
        where  psd.id_pago_simple = p_id_pago_simple;
        
       

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