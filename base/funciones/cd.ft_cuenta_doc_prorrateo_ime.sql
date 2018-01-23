CREATE OR REPLACE FUNCTION "cd"."ft_cuenta_doc_prorrateo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_cuenta_doc_prorrateo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcuenta_doc_prorrateo'
 AUTOR: 		 (admin)
 FECHA:	        05-12-2017 19:08:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-12-2017 19:08:39								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcuenta_doc_prorrateo'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_cuenta_doc_prorrateo	integer;
	v_rec 					record;
	v_id_cuenta_doc integer;
	v_resp1 varchar;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_cuenta_doc_prorrateo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDPRO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-12-2017 19:08:39
	***********************************/

	if(p_transaccion='CD_CDPRO_INS')then
					
        begin

        	--Obtiene datos de la cuenta documentada
        	select tcdoc.codigo as codigo_tipo_cuenta_doc
            into v_rec
            from cd.tcuenta_doc cdoc
            inner join cd.ttipo_cuenta_doc tcdoc
            on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
            where cdoc.id_cuenta_doc = v_parametros.id_cuenta_doc;

            if v_parametros.prorrateo <= 0 then
            	raise exception 'El prorrateo no puede ser menor o igual a cero.';
            end if;

        	--Sentencia de la insercion
        	insert into cd.tcuenta_doc_prorrateo(
			id_cuenta_doc,
			id_centro_costo,
			prorrateo,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_cuenta_doc,
			v_parametros.id_centro_costo,
			v_parametros.prorrateo,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null
			)RETURNING id_cuenta_doc_prorrateo into v_id_cuenta_doc_prorrateo;


			--Cálculo del viático
			v_resp1 = cd.f_viatico_calcular(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_parametros.id_cuenta_doc);

			--Solo para los casos que no sean Rendiciones
			if v_rec.codigo_tipo_cuenta_doc = 'SOLVIA' then
				--Registro del total de Viático con su conepto de gasto, excepto cuando es una rendicion
				v_resp1 = cd.f_viatico_registrar_concepto_gasto(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_parametros.id_cuenta_doc);
				
				--Actualizacion del importe total en la cabecera
				v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_parametros.id_cuenta_doc);

			elsif v_rec.codigo_tipo_cuenta_doc = 'RVI' then
				--Generación automática de documento de rendición de viático
				v_resp1 = cd.f_viatico_registrar_doc_rendicion(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_parametros.id_cuenta_doc);

			end if;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo almacenado(a) con exito (id_cuenta_doc_prorrateo'||v_id_cuenta_doc_prorrateo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_prorrateo',v_id_cuenta_doc_prorrateo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDPRO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-12-2017 19:08:39
	***********************************/

	elsif(p_transaccion='CD_CDPRO_MOD')then

		begin

			--Obtiene datos de la cuenta documentada
        	select tcdoc.codigo as codigo_tipo_cuenta_doc
            into v_rec
            from cd.tcuenta_doc cdoc
            inner join cd.ttipo_cuenta_doc tcdoc
            on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
            where cdoc.id_cuenta_doc = v_parametros.id_cuenta_doc;

            if v_parametros.prorrateo <= 0 then
            	raise exception 'El prorrateo no puede ser menor o igual a cero.';
            end if;

			--Sentencia de la modificacion
			update cd.tcuenta_doc_prorrateo set
			id_cuenta_doc = v_parametros.id_cuenta_doc,
			id_centro_costo = v_parametros.id_centro_costo,
			prorrateo = v_parametros.prorrateo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_cuenta_doc_prorrateo=v_parametros.id_cuenta_doc_prorrateo;

			--Cálculo del viático
			v_resp1 = cd.f_viatico_calcular(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_parametros.id_cuenta_doc);

			--Solo para los casos que no sean Rendiciones
			if v_rec.codigo_tipo_cuenta_doc = 'SOLVIA' then
				--Registro del total de Viático con su conepto de gasto, excepto cuando es una rendicion
				v_resp1 = cd.f_viatico_registrar_concepto_gasto(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_parametros.id_cuenta_doc);
				
				--Actualizacion del importe total en la cabecera
				v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_parametros.id_cuenta_doc);

			elsif v_rec.codigo_tipo_cuenta_doc = 'RVI' then
				--Generación automática de documento de rendición de viático
				v_resp1 = cd.f_viatico_registrar_doc_rendicion(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_parametros.id_cuenta_doc);

			end if;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_prorrateo',v_parametros.id_cuenta_doc_prorrateo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDPRO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-12-2017 19:08:39
	***********************************/

	elsif(p_transaccion='CD_CDPRO_ELI')then

		begin

			--Obtención del id_cuenta_doc para actualización del cálculo del viático
			select id_cuenta_doc
			into v_id_cuenta_doc
			from cd.tcuenta_doc_prorrateo
			where id_cuenta_doc_prorrateo = v_parametros.id_cuenta_doc_prorrateo;

			--Obtiene datos de la cuenta documentada
        	select tcdoc.codigo as codigo_tipo_cuenta_doc
            into v_rec
            from cd.tcuenta_doc cdoc
            inner join cd.ttipo_cuenta_doc tcdoc
            on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
            where cdoc.id_cuenta_doc = v_id_cuenta_doc;

			--Sentencia de la eliminacion
			delete from cd.tcuenta_doc_prorrateo
            where id_cuenta_doc_prorrateo=v_parametros.id_cuenta_doc_prorrateo;

            --Cálculo del viático
			v_resp1 = cd.f_viatico_calcular(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_id_cuenta_doc);

			--Solo para los casos que no sean Rendiciones
			if v_rec.codigo_tipo_cuenta_doc = 'SOLVIA' then
				--Registro del total de Viático con su conepto de gasto, excepto cuando es una rendicion
				v_resp1 = cd.f_viatico_registrar_concepto_gasto(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_id_cuenta_doc);
				
				--Actualizacion del importe total en la cabecera
				v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_id_cuenta_doc);

			elsif v_rec.codigo_tipo_cuenta_doc = 'RVI' then
				--Generación automática de documento de rendición de viático
				v_resp1 = cd.f_viatico_registrar_doc_rendicion(p_id_usuario,v_parametros._id_usuario_ai,v_parametros._nombre_usuario_ai,v_id_cuenta_doc);

			end if;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_prorrateo',v_parametros.id_cuenta_doc_prorrateo::varchar);
              
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
ALTER FUNCTION "cd"."ft_cuenta_doc_prorrateo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
