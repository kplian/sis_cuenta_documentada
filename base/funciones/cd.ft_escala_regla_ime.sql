CREATE OR REPLACE FUNCTION "cd"."ft_escala_regla_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_escala_regla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tescala_regla'
 AUTOR: 		 (admin)
 FECHA:	        15-11-2017 18:38:10
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-11-2017 18:38:10								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tescala_regla'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_escala_regla	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_escala_regla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_REGLA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-11-2017 18:38:10
	***********************************/

	if(p_transaccion='CD_REGLA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.tescala_regla(
			valor,
			id_escala,
			estado_reg,
			nombre,
			id_concepto_ingas,
			id_unidad_medida,
			codigo,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.valor,
			v_parametros.id_escala,
			'activo',
			v_parametros.nombre,
			v_parametros.id_concepto_ingas,
			v_parametros.id_unidad_medida,
			v_parametros.codigo,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_escala_regla into v_id_escala_regla;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reglas almacenado(a) con exito (id_escala_regla'||v_id_escala_regla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_escala_regla',v_id_escala_regla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_REGLA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-11-2017 18:38:10
	***********************************/

	elsif(p_transaccion='CD_REGLA_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.tescala_regla set
			valor = v_parametros.valor,
			id_escala = v_parametros.id_escala,
			nombre = v_parametros.nombre,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_unidad_medida = v_parametros.id_unidad_medida,
			codigo = v_parametros.codigo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_escala_regla=v_parametros.id_escala_regla;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reglas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_escala_regla',v_parametros.id_escala_regla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_REGLA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		15-11-2017 18:38:10
	***********************************/

	elsif(p_transaccion='CD_REGLA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tescala_regla
            where id_escala_regla=v_parametros.id_escala_regla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reglas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_escala_regla',v_parametros.id_escala_regla::varchar);
              
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
ALTER FUNCTION "cd"."ft_escala_regla_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
