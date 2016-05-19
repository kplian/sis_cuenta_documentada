--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_rendicion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_rendicion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.trendicion_det'
 AUTOR: 		 (admin)
 FECHA:	        17-05-2016 18:01:48
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_rendicion_det		integer;
    v_registros				record;
    v_rec					record;
    v_tmp_resp				boolean;
    v_importe_documentos	numeric;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_rendicion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_REND_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	if(p_transaccion='CD_REND_INS')then
					
        begin
        
              select  
                c.importe,
                c.estado,
                c.id_cuenta_doc,
                cdr.estado as estado_cdr,
                cdr.importe as importe_rendicion
             into
                v_registros 
             from cd.tcuenta_doc c
             inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
             where cdr.id_cuenta_doc = v_parametros.id_cuenta_doc;
           
           
             IF v_registros.estado != 'contabilizado' THEN
              raise exception 'Solo puede añadir facturas en solicitudes entragadas (contabilizada)';
             END IF; 
           
           
            --raise exception 'llega..';
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
              id_usuario_mod
          	) values(
              v_parametros.id_doc_compra_venta,
              'activo',
              v_parametros.id_cuenta_doc,   -- registro de la rendicion
              v_registros.id_cuenta_doc, --reg de la solicitud
              p_id_usuario,
              v_parametros._nombre_usuario_ai,
              now(),
              v_parametros._id_usuario_ai,
              null,
              null
  							
			)RETURNING id_rendicion_det into v_id_rendicion_det;
            
            
            --------------------------------------------------------------------------
            --validar que no soprepasa el monto de facturas en al SOLICITUD
            --------------------------------------------------------------------------
            
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
                 rd.id_cuenta_doc = v_registros.id_cuenta_doc;
           
        
            IF v_importe_documentos > v_registros.importe THEN
               raise exception 'El importe del liquido pagado en documentos registrados supera el monto entregado en %, el monto registrado en facturas tiene que ser menor o igual al importe recibido  %',v_importe_documentos - v_registros.importe, v_registros.importe;
            END IF;
            
            
            --------------------------------------------------------------------------
            --validar que no soprepasa el monto a rendir registrado   EN RENDIRICION
            --------------------------------------------------------------------------
            
            --suma todas las facturas registradas en la rendicion 
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
               rd.id_cuenta_doc_rendicion = v_parametros.id_cuenta_doc;  --registro de rendicion
               
            --TODO sumar el monto en depositos para esta rendicion 
            
            
           
            IF v_importe_documentos  > v_registros.importe_rendicion THEN
              raise exception 'El monto en documentos  no puede sobrepasar el monto a rendir (sobre pasado por: % )', v_importe_documentos - v_registros.importe_rendicion;
            END IF; 
            
            
           
            update conta.tdoc_compra_venta dcv set
               tabla_origen = 'cd.trendicion_det',
               id_origen = v_id_rendicion_det
            where dcv.id_doc_compra_venta = v_parametros.id_doc_compra_venta;
            
            --validar que la suma de facturas y depositos no sobre pase el total entregado y ampliado
            
            
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición almacenado(a) con exito (id_rendicion_det'||v_id_rendicion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_id_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
        
   /*********************************    
 	#TRANSACCION:  'CD_VALEDI_MOD'
 	#DESCRIPCION:	Valida la edicion de facturas
 	#AUTOR:		admin	
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	elseif(p_transaccion='CD_VALEDI_MOD')then
					
        begin
        
            
            
            
             select  
                c.importe,
                c.estado,
                c.id_cuenta_doc,
                cdr.estado as estado_cdr,
                cdr.importe as importe_rendicion
             into
                v_registros 
             from cd.tcuenta_doc c
             inner join cd.tcuenta_doc cdr on cdr.id_cuenta_doc_fk = c.id_cuenta_doc
             where cdr.id_cuenta_doc = v_parametros.id_cuenta_doc; --registro de solicitud
           
           
            IF v_registros.estado != 'contabilizado' THEN
              raise exception 'Solo puede modificar facturas en solicitudes entragada(contabilizada)';
            END IF;
            
            
            IF v_registros.estado_cdr not in ('borrador','vbtesoreria') THEN
              raise exception 'Solo puede modificar facturas en rediciones en borrador o vbtesoreria, (no en  %)',v_registros.estado_cdr;
            END IF;
            
             
            --suma todas las facturas registradas en la colisitud 
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
               rd.id_cuenta_doc = v_registros.id_cuenta_doc;  --registro deregistor de solicitud
               
            --TODO suma todos los depositos registrados en solicitud
            
           
           
        
            IF v_importe_documentos > v_registros.importe THEN
               raise exception 'El importe del liquido pagado en documentos registrados supera el monto entregado en %, el monto registrado en facturas tiene que ser menor o igual al importe recibido  %',v_importe_documentos - v_registros.importe, v_registros.importe;
            END IF;
            
            --------------------------------------------------------
            --validar que no soprepasa el monto a rendir registrado 
            --------------------------------------------------------
            
            --suma todas las facturas registradas en la rendicion 
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0)) 
            into
               v_importe_documentos
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta
            where dcv.estado_reg = 'activo' and 
               rd.id_cuenta_doc_rendicion = v_parametros.id_cuenta_doc;   --registro de rendicion
               
            --TODO sumar el monto en depositos para esta rendicion 
            
            IF v_importe_documentos  > v_registros.importe_rendicion THEN
              raise exception 'El monto en documentos  no puede sobrepasar el monto a rendir (sobre pasado por: % )', v_importe_documentos - v_registros.importe_rendicion;
            END IF; 
            
            
        
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','validado factura rendicion'||v_id_rendicion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_id_rendicion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;     
        


	/*********************************    
 	#TRANSACCION:  'CD_RENDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		17-05-2016 18:01:48
	***********************************/

	elsif(p_transaccion='CD_RENDET_ELI')then

		begin
			
            select 
               rd.*,
               dcv.id_depto_conta,
               dcv.fecha 
            into 
               v_registros
            from cd.trendicion_det rd
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = rd.id_doc_compra_venta  
            where rd.id_rendicion_det = v_parametros.id_rendicion_det;
            
            
            --validar si el periodo de conta esta cerrado o abierto
            -- recuepra el periodo de la fecha ...
            --Obtiene el periodo a partir de la fecha
        	v_rec = param.f_get_periodo_gestion(v_registros.fecha);
            
            -- valida que period de libro de compras y ventas este abierto
            v_tmp_resp = conta.f_revisa_periodo_compra_venta(p_id_usuario, v_registros.id_depto_conta, v_rec.po_id_periodo);
            
            
            --elimina el dadetalle del documento
            delete 
            from conta.tdoc_concepto d 
            where d.id_doc_compra_venta = v_registros.id_doc_compra_venta;
            
            --elimina la rendicion
			delete from cd.trendicion_det
            where id_rendicion_det=v_parametros.id_rendicion_det;
            
            --elimina el documento
            delete 
            from conta.tdoc_compra_venta d 
            where d.id_doc_compra_venta = v_registros.id_doc_compra_venta;
            
            
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle de Rendición eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rendicion_det',v_parametros.id_rendicion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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
SECURITY INVOKER
COST 100;