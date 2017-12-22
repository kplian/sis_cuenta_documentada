CREATE OR REPLACE FUNCTION "cd"."ft_escala_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_escala_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tescala'
 AUTOR: 		 (admin)
 FECHA:	        04-09-2017 16:10:44
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
	v_id_escala	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_escala_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_EVIA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 16:10:44
	***********************************/

	if(p_transaccion='CD_EVIA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.tescala(
			estado_reg,
			desde,
			observaciones,
			hasta,
			codigo,
			tipo,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.estado_reg,
			v_parametros.desde,
			v_parametros.observaciones,
			v_parametros.hasta,
			v_parametros.codigo,
			v_parametros.tipo,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_escala into v_id_escala;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Escala de Viáticos almacenado(a) con exito (id_escala'||v_id_escala||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_escala',v_id_escala::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_EVIA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 16:10:44
	***********************************/

	elsif(p_transaccion='CD_EVIA_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tescala set
			desde = v_parametros.desde,
			observaciones = v_parametros.observaciones,
			hasta = v_parametros.hasta,
			codigo = v_parametros.codigo,
			tipo = v_parametros.tipo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			estado_reg = v_parametros.estado_reg
			where id_escala=v_parametros.id_escala;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Escala de Viáticos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_escala',v_parametros.id_escala::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_EVIA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-09-2017 16:10:44
	***********************************/

	elsif(p_transaccion='CD_EVIA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tescala
            where id_escala=v_parametros.id_escala;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Escala de Viáticos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_escala',v_parametros.id_escala::varchar);
              
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
ALTER FUNCTION "cd"."ft_escala_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
