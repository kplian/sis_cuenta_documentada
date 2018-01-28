CREATE OR REPLACE FUNCTION "cd"."ft_pago_simple_pro_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_pago_simple_pro_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tpago_simple_pro'
 AUTOR: 		 (admin)
 FECHA:	        14-01-2018 21:26:07
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				14-01-2018 21:26:07								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tpago_simple_pro'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_pago_simple_pro	integer;
	v_id_partida			integer;
	v_id_gestion 			integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_pago_simple_pro_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_PASIPR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2018 21:26:07
	***********************************/

	if(p_transaccion='CD_PASIPR_INS')then
					
        begin

        	--Obtencion de la gestion a partir del centro de costo
        	select id_gestion
        	into v_id_gestion
        	from param.vcentro_costo
        	where id_centro_costo = v_parametros.id_centro_costo;

        	--Obtención de la partida a partir del concepto de gasto
        	select par.id_partida
        	into v_id_partida
        	from param.tconcepto_ingas conig
            inner join pre.tconcepto_partida cp
            on cp.id_concepto_ingas = conig.id_concepto_ingas
            inner join pre.tpartida par on par.id_partida = cp.id_partida
            where conig.id_concepto_ingas = v_parametros.id_concepto_ingas
            and par.id_gestion = v_id_gestion;

            --Verifica el estado de la solicitud
            if not exists(select 1 from cd.tpago_simple
            			where id_pago_simple = v_parametros.id_pago_simple
            			and estado in ('rendicion','vbconta','borrador')
            			) then
            	raise exception 'La Solicitud del pago debe estar en estado Rendicion, VbConta, Borrador';
            end if;

        	--Sentencia de la insercion
        	insert into cd.tpago_simple_pro(
			factor,
			estado_reg,
			id_centro_costo,
			id_partida,
			id_concepto_ingas,
			id_pago_simple,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.factor,
			'activo',
			v_parametros.id_centro_costo,
			v_id_partida,
			v_parametros.id_concepto_ingas,
			v_parametros.id_pago_simple,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_pago_simple_pro into v_id_pago_simple_pro;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo almacenado(a) con exito (id_pago_simple_pro'||v_id_pago_simple_pro||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_pago_simple_pro',v_id_pago_simple_pro::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_PASIPR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2018 21:26:07
	***********************************/

	elsif(p_transaccion='CD_PASIPR_MOD')then

		begin

			--Obtencion de la gestion a partir del centro de costo
        	select id_gestion
        	into v_id_gestion
        	from param.vcentro_costo
        	where id_centro_costo = v_parametros.id_centro_costo;

			--Obtención de la partida a partir del concepto de gasto
            select par.id_partida
        	into v_id_partida
        	from param.tconcepto_ingas conig
            inner join pre.tconcepto_partida cp
            on cp.id_concepto_ingas = conig.id_concepto_ingas
            inner join pre.tpartida par on par.id_partida = cp.id_partida
            where conig.id_concepto_ingas = v_parametros.id_concepto_ingas
            and par.id_gestion = v_id_gestion;

            --Verifica el estado de la solicitud
            if not exists(select 1 from cd.tpago_simple
            			where id_pago_simple = v_parametros.id_pago_simple
            			and estado in ('rendicion','vbconta','borrador')
            			) then
            	raise exception 'La Solicitud del pago debe estar en estado Rendicion, VbConta, Borrador';
            end if;

			--Sentencia de la modificacion
			update cd.tpago_simple_pro set
			factor = v_parametros.factor,
			id_centro_costo = v_parametros.id_centro_costo,
			id_partida = v_id_partida,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_pago_simple = v_parametros.id_pago_simple,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_pago_simple_pro=v_parametros.id_pago_simple_pro;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_pago_simple_pro',v_parametros.id_pago_simple_pro::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_PASIPR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		14-01-2018 21:26:07
	***********************************/

	elsif(p_transaccion='CD_PASIPR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from cd.tpago_simple_pro
            where id_pago_simple_pro=v_parametros.id_pago_simple_pro;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Prorrateo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_pago_simple_pro',v_parametros.id_pago_simple_pro::varchar);
              
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
ALTER FUNCTION "cd"."ft_pago_simple_pro_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
