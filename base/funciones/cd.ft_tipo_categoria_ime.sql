--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_tipo_categoria_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_tipo_categoria_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.ttipo_categoria'
 AUTOR: 		 (admin)
 FECHA:	        05-05-2016 13:22:15
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
	v_id_tipo_categoria	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_tipo_categoria_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_TCA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 13:22:15
	***********************************/

	if(p_transaccion='CD_TCA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into cd.ttipo_categoria(
			nombre,
			estado_reg,
			codigo,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod,
			id_escala
          	) values(
			v_parametros.nombre,
			'activo',
			v_parametros.codigo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null,
			v_parametros.id_escala
			)RETURNING id_tipo_categoria into v_id_tipo_categoria;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Categoria almacenado(a) con exito (id_tipo_Categoria'||v_id_tipo_categoria||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_categoria',v_id_tipo_categoria::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_TCA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 13:22:15
	***********************************/

	elsif(p_transaccion='CD_TCA_MOD')then

		begin
			--Sentencia de la modificacion
			update cd.ttipo_categoria set
			nombre = v_parametros.nombre,
			codigo = v_parametros.codigo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_escala = v_parametros.id_escala
			where id_tipo_categoria=v_parametros.id_tipo_categoria;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Categoria modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_categoria',v_parametros.id_tipo_categoria::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_TCA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 13:22:15
	***********************************/

	elsif(p_transaccion='CD_TCA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.ttipo_categoria
            where id_tipo_categoria=v_parametros.id_tipo_categoria;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Categoria eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_categoria',v_parametros.id_tipo_categoria::varchar);
              
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