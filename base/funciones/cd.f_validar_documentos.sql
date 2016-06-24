--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.f_validar_documentos (
  p_id_usuario integer,
  p_id_cuenta_doc integer
)
RETURNS boolean AS
$body$
/*
*
*  Autor:   RAC
*  DESC:    esta funcion reliza validacion en el registro de documentos y facturas 
*  Fecha:   23/05/2016
*
*/

DECLARE

	v_nombre_funcion   			text;
    v_resp    					varchar;
    v_mensaje 					varchar;    
    v_registros 				record;
    v_importe_documentos		numeric;
    v_importe_depositos			numeric;
   
	
    
BEGIN

	         v_nombre_funcion = 'cd.f_validar_documentos';
      /*
             select  
                c.importe,
                c.estado,
                c.id_cuenta_doc as id_cuenta_doc_solicitud,
                cdr.estado as estado_cdr,
                cdr.importe as importe_rendicion
             into
                v_registros 
             from cd.tcuenta_doc c
             inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
             where cdr.id_cuenta_doc = p_id_cuenta_doc; --cuenta doc rendicion
            
            
            --------------------------------------------------------------------------
            --validar que no soprepasa el monto de facturas en al SOLICITUD
            --------------------------------------------------------------------------
            
            
            -- suma total de facturas registrada para la solicitud
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
                 rd.id_cuenta_doc = v_registros.id_cuenta_doc_solicitud; 
                 
                 
            -- sumar el total de depositos depositos registrados para la solicitud 
            select
              sum(lb.importe_deposito)
            into
               v_importe_depositos
            from tes.tts_libro_bancos lb
            inner join cd.tcuenta_doc c on c.id_cuenta_doc = lb.columna_pk_valor and  lb.columna_pk = 'id_cuenta_doc' and lb.tabla = 'cd.tcuenta_doc' 
            where c.id_cuenta_doc_fk = v_registros.id_cuenta_doc_solicitud 
                  and lb.estado_reg = 'activo' 
                  and lb.estado != 'anulado';
                     
           
        
            IF COALESCE(v_importe_documentos,0) + COALESCE(v_importe_depositos,0) > v_registros.importe THEN
               raise exception 'El importe del liquido pagado en documentos  registrados supera el monto entregado en %, el monto registrado en facturas tiene que ser menor o igual al importe recibido  %',COALESCE(v_importe_documentos,0) + COALESCE(v_importe_depositos,0) - v_registros.importe, v_registros.importe;
            END IF;
            
            
            v_importe_documentos = 0;
            v_importe_depositos = 0;
            
            
            --------------------------------------------------------------------------
            --validar que no soprepasa el monto a rendir (registrado   EN RENDIRICION)
            --------------------------------------------------------------------------
            
            
           --suma todas las facturas registradas en la rendicion 
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
               rd.id_cuenta_doc_rendicion = p_id_cuenta_doc;  --registro de rendicion
               
            -- sumar el monto en depositos para esta rendicion 
            select
              sum(lb.importe_deposito)
            into
               v_importe_depositos
            from tes.tts_libro_bancos lb
            where lb.columna_pk_valor = p_id_cuenta_doc --cuenta doc de la rendicion
                 and  lb.columna_pk = 'id_cuenta_doc'
                 and lb.tabla = 'cd.tcuenta_doc';
            
           
            IF COALESCE(v_importe_documentos,0)  + COALESCE(v_importe_depositos,0) > v_registros.importe_rendicion THEN
              raise exception 'El monto en documentos  no puede sobrepasar el monto a rendir (sobre pasado por: % )',  COALESCE(v_importe_documentos,0)  + COALESCE(v_importe_depositos,0) - v_registros.importe_rendicion;
            END IF; 
      */
     
   

      RETURN   TRUE;



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