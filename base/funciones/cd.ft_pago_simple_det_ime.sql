CREATE OR REPLACE FUNCTION cd.ft_pago_simple_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_pago_simple_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tpago_simple_det'
 AUTOR: 		 (admin)
 FECHA:	        01-01-2018 06:21:25
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				01-01-2018 06:21:25								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tpago_simple_det'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_pago_simple_det	integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_pago_simple_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_PASIDE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-01-2018 06:21:25
	***********************************/

	if(p_transaccion='CD_PASIDE_INS')then
					
        begin

        	--Elimina el documento solo si el pago esta en estado borrador
			if not exists(select 1 from cd.tpago_simple ps
							where ps.id_pago_simple = v_parametros.id_pago_simple
							and ps.estado = 'borrador') then
				raise exception 'No puede insertarse nuevos documentos porque el Pago no esta en Borrador';

			end if;

        	--Sentencia de la insercion
        	insert into cd.tpago_simple_det(
			estado_reg,
			id_pago_simple,
			id_doc_compra_venta,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_pago_simple,
			v_parametros.id_doc_compra_venta,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_pago_simple_det into v_id_pago_simple_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Facturas/Recibos almacenado(a) con exito (id_pago_simple_det'||v_id_pago_simple_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_pago_simple_det',v_id_pago_simple_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_PASIDE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-01-2018 06:21:25
	***********************************/

	elsif(p_transaccion='CD_PASIDE_MOD')then

		begin

			--Elimina el documento solo si el pago esta en estado borrador
			if not exists(select 1 from cd.tpago_simple ps
							where ps.id_pago_simple = v_parametros.id_pago_simple
							and ps.estado = 'borrador') then
				raise exception 'No puede modificarse el documento porque el Pago no esta en Borrador';

			end if;

			--Sentencia de la modificacion
			update cd.tpago_simple_det set
			id_pago_simple = v_parametros.id_pago_simple,
			id_doc_compra_venta = v_parametros.id_doc_compra_venta,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_pago_simple_det=v_parametros.id_pago_simple_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Facturas/Recibos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_pago_simple_det',v_parametros.id_pago_simple_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_PASIDE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		01-01-2018 06:21:25
	***********************************/

	elsif(p_transaccion='CD_PASIDE_ELI')then

		begin

			--Elimina el documento solo si el pago esta en estado borrador
			if not exists(select 1 from cd.tpago_simple_det psd
							inner join cd.tpago_simple ps
							on ps.id_pago_simple = psd.id_pago_simple
							where psd.id_pago_simple_det = v_parametros.id_pago_simple_det
							and ps.estado = 'borrador') then
				raise exception 'No puede quitarse el documento porque el Pago no esta en Borrador';

			end if;

			--Cambia el estado sw_pgs de la factura/recibo a eliminar
			update conta.tdoc_compra_venta set
			sw_pgs = 'reg'
			from cd.tpago_simple_det psd
			where psd.id_pago_simple_det = v_parametros.id_pago_simple_det
			and conta.tdoc_compra_venta.id_doc_compra_venta = psd.id_doc_compra_venta;

			--Sentencia de la eliminacion
			delete from cd.tpago_simple_det
            where id_pago_simple_det=v_parametros.id_pago_simple_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Facturas/Recibos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_pago_simple_det',v_parametros.id_pago_simple_det::varchar);
              
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