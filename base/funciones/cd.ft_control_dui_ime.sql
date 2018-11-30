--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_control_dui_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_control_dui_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcontrol_dui'
 AUTOR: 		 (jjimenez)
 FECHA:	        13-09-2018 15:32:16
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				13-09-2018 15:32:16								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcontrol_dui'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_control_dui	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_control_dui_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDUI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 15:32:16
	***********************************/

	if(p_transaccion='CD_CDUI_INS')then
					
        begin
        	--Sentencia de la insercion
            --raise exception '%','llega';
        	insert into cd.tcontrol_dui(
			tramite_anticipo_dui,
			dui,
			archivo_comision,
			nro_comprobante_diario_dui,
			archivo_dui,
			nro_comprobante_diario_comision,
			nro_comprobante_pago_dui,
			estado_reg,
			monto_comision,
			tramite_pedido_endesis,
			monto_dui,
			nro_factura_proveedor,
			tramite_comision_agencia,
			pedido_sap,
			id_agencia_despachante,
			nro_comprobante_pago_comision,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            observaciones
          	) values(
			v_parametros.tramite_anticipo_dui,
			v_parametros.dui,
			v_parametros.archivo_comision,
			v_parametros.nro_comprobante_diario_dui,
			v_parametros.archivo_dui,
			v_parametros.nro_comprobante_diario_comision,
			v_parametros.nro_comprobante_pago_dui,
			'activo',
			v_parametros.monto_comision::NUMERIC,
			v_parametros.tramite_pedido_endesis,
			v_parametros.monto_dui::NUMERIC,
			v_parametros.nro_factura_proveedor,
			v_parametros.tramite_comision_agencia,
			v_parametros.pedido_sap,
			v_parametros.id_agencia_despachante,
			v_parametros.nro_comprobante_pago_comision,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.observaciones
							
			
			
			)RETURNING id_control_dui into v_id_control_dui;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control de Duis almacenado(a) con exito (id_control_dui'||v_id_control_dui||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_control_dui',v_id_control_dui::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDUI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 15:32:16
	***********************************/

	elsif(p_transaccion='CD_CDUI_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tcontrol_dui set
			tramite_anticipo_dui = v_parametros.tramite_anticipo_dui,
			dui = v_parametros.dui,
			archivo_comision = v_parametros.archivo_comision,
			nro_comprobante_diario_dui = v_parametros.nro_comprobante_diario_dui,
			archivo_dui = v_parametros.archivo_dui,
			nro_comprobante_diario_comision = v_parametros.nro_comprobante_diario_comision,
			nro_comprobante_pago_dui = v_parametros.nro_comprobante_pago_dui,
			monto_comision = v_parametros.monto_comision,
			tramite_pedido_endesis = v_parametros.tramite_pedido_endesis,
			monto_dui = v_parametros.monto_dui::NUMERIC,
			nro_factura_proveedor = v_parametros.nro_factura_proveedor,
			tramite_comision_agencia = v_parametros.tramite_comision_agencia,
			pedido_sap = v_parametros.pedido_sap,
			id_agencia_despachante = v_parametros.id_agencia_despachante,
			nro_comprobante_pago_comision = v_parametros.nro_comprobante_pago_comision,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            observaciones=v_parametros.observaciones
			where id_control_dui=v_parametros.id_control_dui;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control de Duis modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_control_dui',v_parametros.id_control_dui::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDUI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		13-09-2018 15:32:16
	***********************************/

	elsif(p_transaccion='CD_CDUI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tcontrol_dui
            where id_control_dui=v_parametros.id_control_dui;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control de Duis eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_control_dui',v_parametros.id_control_dui::varchar);
              
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