--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_bloqueo_cd_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_bloqueo_cd_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tbloqueo_cd'
 AUTOR: 		 (admin)
 FECHA:	        06-06-2016 16:40:35
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
    v_registros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_bloqueo_cd	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_bloqueo_cd_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	
	/*********************************    
 	#TRANSACCION:  'CD_BLOCD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		06-06-2016 16:40:35
	***********************************/

	if(p_transaccion='CD_BLOCD_ELI')then

		begin
			
            select 
              bcd.estado,
              bcd.id_bloqueo_cd
            into 
              v_registros
            from cd.tbloqueo_cd bcd
            where bcd.id_bloqueo_cd = v_parametros.id_bloqueo_cd;
            
            IF v_registros.estado =  'autorizado'  THEN
              raise exception 'El bloqueo ya se encuentra autorizado';
            END IF;
        
			--Sentencia de la modificacion
			update cd.tbloqueo_cd set			
			  estado = 'autorizado',
              id_usuario_mod = p_id_usuario,
              fecha_mod = now()		
			where id_bloqueo_cd = v_parametros.id_bloqueo_cd;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Bloqueo eliminado'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_bloqueo_cd',v_parametros.id_bloqueo_cd::varchar);
              
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