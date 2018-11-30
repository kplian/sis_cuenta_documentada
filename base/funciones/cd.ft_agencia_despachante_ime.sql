CREATE OR REPLACE FUNCTION "cd"."ft_agencia_despachante_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_agencia_despachante_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tagencia_despachante'
 AUTOR: 		 (jjimenez)
 FECHA:	        29-11-2018 20:41:12
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-11-2018 20:41:12								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tagencia_despachante'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_agencia_despachante	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_agencia_despachante_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_AGEDES_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:41:12
	***********************************/

	if(p_transaccion='CD_AGEDES_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.tagencia_despachante(
			estado_reg,
			codigo,
			nombre,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.codigo,
			v_parametros.nombre,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_agencia_despachante into v_id_agencia_despachante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agencia despachante almacenado(a) con exito (id_agencia_despachante'||v_id_agencia_despachante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agencia_despachante',v_id_agencia_despachante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_AGEDES_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:41:12
	***********************************/

	elsif(p_transaccion='CD_AGEDES_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tagencia_despachante set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_agencia_despachante=v_parametros.id_agencia_despachante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agencia despachante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agencia_despachante',v_parametros.id_agencia_despachante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_AGEDES_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jjimenez	
 	#FECHA:		29-11-2018 20:41:12
	***********************************/

	elsif(p_transaccion='CD_AGEDES_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tagencia_despachante
            where id_agencia_despachante=v_parametros.id_agencia_despachante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Agencia despachante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_agencia_despachante',v_parametros.id_agencia_despachante::varchar);
              
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
ALTER FUNCTION "cd"."ft_agencia_despachante_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
