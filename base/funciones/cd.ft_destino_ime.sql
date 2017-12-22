CREATE OR REPLACE FUNCTION "cd"."ft_destino_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_destino_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tdestino'
 AUTOR: 		 (admin)
 FECHA:	        04-09-2017 15:10:59
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
	v_id_destino	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_destino_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_DEST_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 15:10:59
	***********************************/

	if(p_transaccion='CD_DEST_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.tdestino(
			codigo,
			estado_reg,
			descripcion,
			nombre,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
			tipo,
			id_escala
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.descripcion,
			v_parametros.nombre,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.tipo,
			v_parametros.id_escala
			) RETURNING id_destino into v_id_destino;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Destinos almacenado(a) con exito (id_destino'||v_id_destino||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_destino',v_id_destino::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_DEST_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 15:10:59
	***********************************/

	elsif(p_transaccion='CD_DEST_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tdestino set
			codigo = v_parametros.codigo,
			descripcion = v_parametros.descripcion,
			nombre = v_parametros.nombre,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			tipo = v_parametros.tipo,
			id_escala = v_parametros.id_escala
			where id_destino=v_parametros.id_destino;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Destinos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_destino',v_parametros.id_destino::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_DEST_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 15:10:59
	***********************************/

	elsif(p_transaccion='CD_DEST_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tdestino
            where id_destino=v_parametros.id_destino;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Destinos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_destino',v_parametros.id_destino::varchar);
              
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
ALTER FUNCTION "cd"."ft_destino_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
