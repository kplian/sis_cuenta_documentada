CREATE OR REPLACE FUNCTION "cd"."ft_tipo_pago_simple_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_tipo_pago_simple_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.ttipo_pago_simple'
 AUTOR: 		 (admin)
 FECHA:	        02-12-2017 02:49:10
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				02-12-2017 02:49:10								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.ttipo_pago_simple'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_pago_simple	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_tipo_pago_simple_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_TIPASI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		02-12-2017 02:49:10
	***********************************/

	if(p_transaccion='CD_TIPASI_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.ttipo_pago_simple(
			estado_reg,
			codigo,
			nombre,
			plantilla_cbte,
			plantilla_cbte_1,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.codigo,
			v_parametros.nombre,
			v_parametros.plantilla_cbte,
			v_parametros.plantilla_cbte_1,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_tipo_pago_simple into v_id_tipo_pago_simple;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo dePago almacenado(a) con exito (id_tipo_pago_simple'||v_id_tipo_pago_simple||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_pago_simple',v_id_tipo_pago_simple::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_TIPASI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		02-12-2017 02:49:10
	***********************************/

	elsif(p_transaccion='CD_TIPASI_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.ttipo_pago_simple set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			plantilla_cbte = v_parametros.plantilla_cbte,
			plantilla_cbte_1 = v_parametros.plantilla_cbte_1,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_pago_simple=v_parametros.id_tipo_pago_simple;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo dePago modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_pago_simple',v_parametros.id_tipo_pago_simple::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_TIPASI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		02-12-2017 02:49:10
	***********************************/

	elsif(p_transaccion='CD_TIPASI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.ttipo_pago_simple
            where id_tipo_pago_simple=v_parametros.id_tipo_pago_simple;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo dePago eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_pago_simple',v_parametros.id_tipo_pago_simple::varchar);
              
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
ALTER FUNCTION "cd"."ft_tipo_pago_simple_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
