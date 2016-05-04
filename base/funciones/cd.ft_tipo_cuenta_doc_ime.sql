--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_tipo_cuenta_doc_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_tipo_cuenta_doc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.ttipo_cuenta_doc'
 AUTOR: 		 (admin)
 FECHA:	        04-05-2016 20:13:26
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
	v_id_tipo_cuenta_doc	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_tipo_cuenta_doc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_TCD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2016 20:13:26
	***********************************/

	if(p_transaccion='CD_TCD_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.ttipo_cuenta_doc(
			codigo,
			estado_reg,
			descripcion,
			nombre,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.descripcion,
			v_parametros.nombre,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_tipo_cuenta_doc into v_id_tipo_cuenta_doc;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Cuenta Documentada almacenado(a) con exito (id_tipo_cuenta_doc'||v_id_tipo_cuenta_doc||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cuenta_doc',v_id_tipo_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_TCD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2016 20:13:26
	***********************************/

	elsif(p_transaccion='CD_TCD_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.ttipo_cuenta_doc set
			codigo = v_parametros.codigo,
			descripcion = v_parametros.descripcion,
			nombre = v_parametros.nombre,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_cuenta_doc=v_parametros.id_tipo_cuenta_doc;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Cuenta Documentada modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cuenta_doc',v_parametros.id_tipo_cuenta_doc::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_TCD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		04-05-2016 20:13:26
	***********************************/

	elsif(p_transaccion='CD_TCD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.ttipo_cuenta_doc
            where id_tipo_cuenta_doc=v_parametros.id_tipo_cuenta_doc;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Cuenta Documentada eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cuenta_doc',v_parametros.id_tipo_cuenta_doc::varchar);
              
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