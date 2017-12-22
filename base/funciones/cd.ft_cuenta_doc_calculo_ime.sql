CREATE OR REPLACE FUNCTION "cd"."ft_cuenta_doc_calculo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_cuenta_doc_calculo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcuenta_doc_calculo'
 AUTOR: 		 (admin)
 FECHA:	        15-09-2017 13:16:03
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
	v_id_cuenta_doc_calculo	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_cuenta_doc_calculo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDOCCA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2017 13:16:03
	***********************************/

	if(p_transaccion='CD_CDOCCA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.tcuenta_doc_calculo(
			numero,
			destino,
			dias_saldo_ant,
			dias_destino,
			cobertura_sol,
			cobertura_hotel_sol,
			dias_total_viaje,
			dias_aplicacion_regla,
			hora_salida,
			hora_llegada,
			escala_viatico,
			escala_hotel,
			regla_cobertura_dias_acum,
			regla_cobertura_hora_salida,
			regla_cobertura_hora_llegada,
			regla_cobertura_total_dias,
			cobertura_aplicada,
			cobertura_aplicada_hotel,
			estado_reg,
			id_cuenta_doc,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.numero,
			v_parametros.destino,
			v_parametros.dias_saldo_ant,
			v_parametros.dias_destino,
			v_parametros.cobertura_sol,
			v_parametros.cobertura_hotel_sol,
			v_parametros.dias_total_viaje,
			v_parametros.dias_aplicacion_regla,
			v_parametros.hora_salida,
			v_parametros.hora_llegada,
			v_parametros.escala_viatico,
			v_parametros.escala_hotel,
			v_parametros.regla_cobertura_dias_acum,
			v_parametros.regla_cobertura_hora_salida,
			v_parametros.regla_cobertura_hora_llegada,
			v_parametros.regla_cobertura_total_dias,
			v_parametros.cobertura_aplicada,
			v_parametros.cobertura_aplicada_hotel,
			'activo',
			v_parametros.id_cuenta_doc,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_cuenta_doc_calculo into v_id_cuenta_doc_calculo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cálculo de Viático almacenado(a) con exito (id_cuenta_doc_calculo'||v_id_cuenta_doc_calculo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_calculo',v_id_cuenta_doc_calculo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOCCA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2017 13:16:03
	***********************************/

	elsif(p_transaccion='CD_CDOCCA_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tcuenta_doc_calculo set
			numero = v_parametros.numero,
			destino = v_parametros.destino,
			dias_saldo_ant = v_parametros.dias_saldo_ant,
			dias_destino = v_parametros.dias_destino,
			cobertura_sol = v_parametros.cobertura_sol,
			cobertura_hotel_sol = v_parametros.cobertura_hotel_sol,
			dias_total_viaje = v_parametros.dias_total_viaje,
			dias_aplicacion_regla = v_parametros.dias_aplicacion_regla,
			hora_salida = v_parametros.hora_salida,
			hora_llegada = v_parametros.hora_llegada,
			escala_viatico = v_parametros.escala_viatico,
			escala_hotel = v_parametros.escala_hotel,
			regla_cobertura_dias_acum = v_parametros.regla_cobertura_dias_acum,
			regla_cobertura_hora_salida = v_parametros.regla_cobertura_hora_salida,
			regla_cobertura_hora_llegada = v_parametros.regla_cobertura_hora_llegada,
			regla_cobertura_total_dias = v_parametros.regla_cobertura_total_dias,
			cobertura_aplicada = v_parametros.cobertura_aplicada,
			cobertura_aplicada_hotel = v_parametros.cobertura_aplicada_hotel,
			id_cuenta_doc = v_parametros.id_cuenta_doc,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cuenta_doc_calculo=v_parametros.id_cuenta_doc_calculo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cálculo de Viático modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_calculo',v_parametros.id_cuenta_doc_calculo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOCCA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-09-2017 13:16:03
	***********************************/

	elsif(p_transaccion='CD_CDOCCA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tcuenta_doc_calculo
            where id_cuenta_doc_calculo=v_parametros.id_cuenta_doc_calculo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cálculo de Viático eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_calculo',v_parametros.id_cuenta_doc_calculo::varchar);
              
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
ALTER FUNCTION "cd"."ft_cuenta_doc_calculo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
