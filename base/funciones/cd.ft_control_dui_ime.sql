CREATE OR REPLACE FUNCTION "cd"."ft_control_dui_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_control_dui_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcontrol_dui'
 AUTOR: 		 (jjimenez)
 FECHA:	        29-11-2018 20:36:19
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-11-2018 20:36:19								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcontrol_dui'	
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
 	#TRANSACCION:  'CD_CONDUI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:36:19
	***********************************/

	if(p_transaccion='CD_CONDUI_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.tcontrol_dui(
			tramite_comision_agencia,
			id_agencia_despachante,
			monto_dui,
			nro_comprobante_pago_dui,
			dui,
			nro_comprobante_diario_dui,
			tramite_anticipo_dui,
			monto_comision,
			estado_reg,
			archivo_dui,
			observaciones,
			archivo_comision,
			pedido_sap,
			nro_comprobante_diario_comision,
			nro_factura_proveedor,
			tramite_pedido_endesis,
			nro_comprobante_pago_comision,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.tramite_comision_agencia,
			v_parametros.id_agencia_despachante,
			v_parametros.monto_dui,
			v_parametros.nro_comprobante_pago_dui,
			v_parametros.dui,
			v_parametros.nro_comprobante_diario_dui,
			v_parametros.tramite_anticipo_dui,
			v_parametros.monto_comision,
			'activo',
			v_parametros.archivo_dui,
			v_parametros.observaciones,
			v_parametros.archivo_comision,
			v_parametros.pedido_sap,
			v_parametros.nro_comprobante_diario_comision,
			v_parametros.nro_factura_proveedor,
			v_parametros.tramite_pedido_endesis,
			v_parametros.nro_comprobante_pago_comision,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_control_dui into v_id_control_dui;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control dui almacenado(a) con exito (id_control_dui'||v_id_control_dui||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_control_dui',v_id_control_dui::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CONDUI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:36:19
	***********************************/

	elsif(p_transaccion='CD_CONDUI_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tcontrol_dui set
			tramite_comision_agencia = v_parametros.tramite_comision_agencia,
			id_agencia_despachante = v_parametros.id_agencia_despachante,
			monto_dui = v_parametros.monto_dui,
			nro_comprobante_pago_dui = v_parametros.nro_comprobante_pago_dui,
			dui = v_parametros.dui,
			nro_comprobante_diario_dui = v_parametros.nro_comprobante_diario_dui,
			tramite_anticipo_dui = v_parametros.tramite_anticipo_dui,
			monto_comision = v_parametros.monto_comision,
			archivo_dui = v_parametros.archivo_dui,
			observaciones = v_parametros.observaciones,
			archivo_comision = v_parametros.archivo_comision,
			pedido_sap = v_parametros.pedido_sap,
			nro_comprobante_diario_comision = v_parametros.nro_comprobante_diario_comision,
			nro_factura_proveedor = v_parametros.nro_factura_proveedor,
			tramite_pedido_endesis = v_parametros.tramite_pedido_endesis,
			nro_comprobante_pago_comision = v_parametros.nro_comprobante_pago_comision,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_control_dui=v_parametros.id_control_dui;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control dui modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_control_dui',v_parametros.id_control_dui::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CONDUI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:36:19
	***********************************/

	elsif(p_transaccion='CD_CONDUI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tcontrol_dui
            where id_control_dui=v_parametros.id_control_dui;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control dui eliminado(a)'); 
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "cd"."ft_control_dui_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
