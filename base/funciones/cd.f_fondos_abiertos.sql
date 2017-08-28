--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_fondos_abiertos (
  p_id_auxiliar integer,
  p_id_tabla integer,
  p_tabla varchar,
  p_id_tipo_estado_cuenta integer,
  p_desde date,
  p_hasta date
)
RETURNS numeric [] AS
$body$
/*
  #DESCRIPCION:     esta funcion es hecha para el estado de cuenta de proveedores
   					busca todos los pagos pendientes en tesoeria para el proveedor
                    los parametors de entrada son 
                    	p_id_auxiliar integer,
                        p_id_tabla integer,
                        p_tabla varchar,
                        p_id_tipo_estado_cuenta integer,
                        p_desde date,
                        p_hasta date
                    
                    retorna array numeric 
                    
                       [1]  moneda base
                       [2]  moneda triangulacion
                    
  #AUTOR:           rensi arteaga copari  kplian
  #FECHA:           29-07-2017

*/


DECLARE

  v_resp 				varchar;
  v_nombre_funcion 		varchar;
  va_montos				numeric[];
  v_reg_fun				record;
  v_registros			record;
  v_id_moneda_tri		integer;
  v_id_moneda_base		integer;
  v_monto_mb			numeric;
  
   v_importe					numeric;
   v_importe_documentos			numeric;
   v_importe_retenciones		numeric;
   v_importe_depositos			numeric;
   v_importe_total_rendido		numeric;


BEGIN
   
     v_nombre_funcion = 'conta.f_estado_cuenta';
     v_id_moneda_tri  =  param.f_get_moneda_triangulacion();
     v_id_moneda_base =  param.f_get_moneda_base();
     
     select 
        *
     into
       v_reg_fun
     from orga.vfuncionario f
     where f.id_funcionario = p_id_tabla;
     
     v_importe = 0;
     v_importe_documentos = 0;
     v_importe_retenciones = 0;
     v_importe_depositos = 0;
     v_importe_total_rendido = 0;
     
     FOR v_registros in (
                         select
                            cdoc.importe,
                            
                            CASE WHEN  sw_solicitud = 'si' THEN
                               COALESCE((
                               
                               select 
                                 sum(COALESCE(dcv.importe_pago_liquido + dcv.importe_descuento_ley,0)) 
                               from cd.trendicion_det rd
                               inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                               where dcv.estado_reg = 'activo' and rd.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric   
                                                  
                            WHEN   sw_solicitud = 'no' THEN
                               COALESCE((
                               
                               select sum(COALESCE(dcv.importe_pago_liquido + dcv.importe_descuento_ley,0)) 
                               from cd.trendicion_det rd
                               inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                               where dcv.estado_reg = 'activo' and rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc),0)::numeric 
                                                  
                            ELSE
                               0::numeric 
                            END  as  importe_documentos,
                                                  
                                                  
                            CASE WHEN   sw_solicitud = 'si'   THEN
                               COALESCE((select sum(COALESCE(dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                               inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                               where dcv.estado_reg = 'activo' and rd.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric   
                            WHEN  sw_solicitud = 'no' THEN
                               COALESCE((select sum(COALESCE(dcv.importe_descuento_ley,0)) from cd.trendicion_det rd
                               inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
                               where dcv.estado_reg = 'activo' and rd.id_cuenta_doc_rendicion = cdoc.id_cuenta_doc),0)::numeric 
                            ELSE
                               0::numeric 
                            END  as  importe_retenciones,
                                                  
                                                  
                            CASE WHEN   sw_solicitud = 'si' THEN
                               COALESCE((select sum(COALESCE(lb.importe_deposito,0)) from tes.tts_libro_bancos lb
                               inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc'
                               where c.estado_reg = 'activo' and c.id_cuenta_doc_fk = cdoc.id_cuenta_doc),0)::numeric  
                            WHEN   sw_solicitud = 'no' THEN
                               COALESCE((select sum(COALESCE(lb.importe_deposito,0)) from tes.tts_libro_bancos lb
                               inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc'
                               where c.estado_reg = 'activo' and c.id_cuenta_doc = cdoc.id_cuenta_doc),0)::numeric  
                                                  
                            ELSE
                               0::numeric 
                            END  as  importe_depositos ,
                            importe_total_rendido
                        from cd.tcuenta_doc cdoc
                        inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
                        where  cdoc.estado_reg = 'activo' 
                           and  tcd.sw_solicitud = 'si' 
                           and  0 = 0 
                           AND (cdoc.estado in ('contabilizado'))  
                           AND cdoc.id_funcionario = v_reg_fun.id_funcionario 
                           and cdoc.fecha BETWEEN p_desde and p_hasta
                           
                           )LOOP
     
           v_importe = v_importe + v_registros.importe ;
           v_importe_documentos = v_importe_documentos + v_registros.importe_documentos;
           v_importe_retenciones = v_importe_retenciones + v_registros.importe_retenciones;
           v_importe_depositos = v_importe_depositos + v_registros.importe_depositos;
           v_importe_total_rendido = v_importe_total_rendido + v_registros.importe_total_rendido;
     
     END LOOP;
     
     v_monto_mb = v_importe -   v_importe_documentos -  v_importe_depositos +  v_importe_retenciones;

     va_montos[1] = v_monto_mb;
      
     --convertir a dolares a la fecha fin de busqueda  
     va_montos[2] = param.f_convertir_moneda(v_id_moneda_base, v_id_moneda_tri, v_monto_mb, p_hasta,'O',2);
      
    
      
     return va_montos; 

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
SECURITY DEFINER
COST 100;