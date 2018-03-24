CREATE OR REPLACE FUNCTION cd.ft_cuenta_doc_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documenta
 FUNCION: 		cd.ft_cuenta_doc_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcuenta_doc_det'
 AUTOR: 		 (admin)
 FECHA:	        05-09-2017 17:54:29
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
	v_id_cuenta_doc_det		integer;
	v_id_moneda_base		integer;
	v_importe				numeric;
	v_fecha					date;
	v_id_partida			integer;
	v_rec 					record;
	v_codigo_tipo_cuenta_doc varchar;
	v_id_concepto_ingas		integer;
	v_id_concepto_ingas1	integer;
	v_resp1 				varchar;
	v_id_cuenta_doc 		integer;
	v_id_moneda				integer;
	v_permitir_mod			varchar;
    v_id_gestion			integer;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_cuenta_doc_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    v_permitir_mod = pxp.f_get_variable_global('cd_permitir_modificar_monto_sol');


	/*********************************    
 	#TRANSACCION:  'CD_CDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-09-2017 17:54:29
	***********************************/

	if(p_transaccion='CD_CDET_INS')then
					
        begin

        	--Obtención de datos de la solicitud
		    select codigo, fecha, id_moneda
		    into v_codigo_tipo_cuenta_doc, v_fecha, v_id_moneda
		    from cd.tcuenta_doc cdoc
		    inner join  cd.ttipo_cuenta_doc tcdoc
		    on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
		    where cdoc.id_cuenta_doc = v_parametros.id_cuenta_doc;
            
            --Obtiene la gestión en base a la fecha de la solicitud
            select id_gestion
            into v_id_gestion
            from param.tgestion
            where gestion = extract(year from v_fecha);
            
            if v_id_gestion is null then
            	raise exception 'Gestión no encontrada';
            end if;

        	--Verifica si se trata de de registrar concepto de gasto de Viático u Hotel
        	if v_permitir_mod = 'no' then
	        	if exists (select 1
						    from cd.tcuenta_doc cd
						    left join cd.tescala_regla escr
						    on escr.id_escala = cd.id_escala
						    where cd.id_cuenta_doc = v_parametros.id_cuenta_doc
						    and escr.codigo in ('CONGAS_VIA_PLA','CONGAS_VIA_SER','CONGAS_HOT_PLA','CONGAS_HOT_SER')
						    and escr.id_concepto_ingas = v_parametros.id_concepto_ingas) then

	        		raise exception 'Los Conceptos de gasto de Viáticos o de Hotel, no pueden registrarse manualmente. El sistema los calculará automáticamente después de registrar el Itinerario.';

	        	end if;
        	end if;

        	--Obtiene la moneda base
        	v_id_moneda_base  = param.f_get_moneda_base();

        	--Convierte el importe en moneda original a moneda base
        	v_importe = param.f_convertir_moneda(v_id_moneda, --moneda origen para conversion
												v_id_moneda_base,   --moneda a la que sera convertido
												v_parametros.monto_mo, --este monto siempre estara en moenda base
												v_fecha, 
												'O',-- tipo oficial, venta, compra 
												NULL);--defecto dos decimales 

        	--Obtención de la partida a partir del concepto de gasto
        	select cp.id_partida
        	into v_id_partida
        	from param.tconcepto_ingas conig
            inner join pre.tconcepto_partida cp
            on cp.id_concepto_ingas = conig.id_concepto_ingas
            inner join pre.tpartida par on par.id_partida = cp.id_partida
            where conig.id_concepto_ingas = v_parametros.id_concepto_ingas
            and par.id_gestion = v_id_gestion;
            
            if v_id_partida is null then
            	raise exception 'Partida no encontrada';
            end if;

            --Verifica si se usa el prorrateo o no
            if v_parametros.usar_prorrateo = 'no' then

            	--Sentencia de la insercion
	        	insert into cd.tcuenta_doc_det(
				id_cuenta_doc,
				monto_mb,
				id_centro_costo,
				id_concepto_ingas,
				id_partida,
				monto_mo,
				estado_reg,
				id_usuario_ai,
				usuario_ai,
				fecha_reg,
				id_usuario_reg,
				fecha_mod,
				id_usuario_mod,
				id_moneda,
				id_moneda_mb
	          	) values(
				v_parametros.id_cuenta_doc,
				v_importe,
				v_parametros.id_centro_costo,
				v_parametros.id_concepto_ingas,
				v_id_partida,
				v_parametros.monto_mo,
				'activo',
				v_parametros._id_usuario_ai,
				v_parametros._nombre_usuario_ai,
				now(),
				p_id_usuario,
				null,
				null,
				v_id_moneda,	
				v_id_moneda_base
				
				)RETURNING id_cuenta_doc_det into v_id_cuenta_doc_det;

            else

            	if not exists(select 1
				          	from cd.tcuenta_doc_prorrateo
				          	where id_cuenta_doc = v_parametros.id_cuenta_doc) then
            		raise exception 'Debe registrar el prorrateo previamente, o de lo contrario definir el centro de costo directamente';
            	end if;

            	insert into cd.tcuenta_doc_det(
				id_cuenta_doc,
				monto_mb,
				id_centro_costo,
				id_concepto_ingas,
				id_partida,
				monto_mo,
				estado_reg,
				id_usuario_ai,
				usuario_ai,
				fecha_reg,
				id_usuario_reg,
				fecha_mod,
				id_usuario_mod,
				id_moneda,
				id_moneda_mb
	          	)
	          	select
	          	v_parametros.id_cuenta_doc,
				v_importe * cdpro.prorrateo,
				cdpro.id_centro_costo,
				v_parametros.id_concepto_ingas,
				v_id_partida,
				v_parametros.monto_mo * cdpro.prorrateo,
				'activo',
				v_parametros._id_usuario_ai,
				v_parametros._nombre_usuario_ai,
				now(),
				p_id_usuario,
				null,
				null,
				v_id_moneda,	
				v_id_moneda_base
	          	from cd.tcuenta_doc_prorrateo cdpro
	          	where id_cuenta_doc = v_parametros.id_cuenta_doc;

            end if;

			--Actualizacion del importe total en la cabecera
			v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_parametros.id_cuenta_doc);
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuesto almacenado(a) con exito (id_cuenta_doc_det'||v_id_cuenta_doc_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_det',v_id_cuenta_doc_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-09-2017 17:54:29
	***********************************/

	elsif(p_transaccion='CD_CDET_MOD')then

		begin

			--Obtención de datos de la solicitud
		    select codigo, fecha, id_moneda
		    into v_codigo_tipo_cuenta_doc, v_fecha, v_id_moneda
		    from cd.tcuenta_doc cdoc
		    inner join  cd.ttipo_cuenta_doc tcdoc
		    on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
		    where cdoc.id_cuenta_doc = v_parametros.id_cuenta_doc;
            
             --Obtiene la gestión en base a la fecha de la solicitud
            select id_gestion
            into v_id_gestion
            from param.tgestion
            where gestion = extract(year from v_fecha);
            
            if v_id_gestion is null then
            	raise exception 'Gestión no encontrada';
            end if;

        	--Verifica si se trata de de registrar concepto de gasto de Viático u Hotel
        	if v_permitir_mod = 'no' then
	        	if exists (select 1
						    from cd.tcuenta_doc cd
						    left join cd.tescala_regla escr
						    on escr.id_escala = cd.id_escala
						    where cd.id_cuenta_doc = v_parametros.id_cuenta_doc
						    and escr.codigo in ('CONGAS_VIA_PLA','CONGAS_VIA_SER','CONGAS_HOT_PLA','CONGAS_HOT_SER')
						    and escr.id_concepto_ingas = v_parametros.id_concepto_ingas) then

	        		raise exception 'Los Conceptos de gasto de Viáticos o de Hotel, no pueden modificarse manualmente. El sistema los actualizará el total por cada cambio en el itinerario.';

	        	end if;
        	end if;

			--Obtiene la moneda base
        	v_id_moneda_base  = param.f_get_moneda_base();

        	--Convierte el importe en moneda original a moneda base
        	v_importe = param.f_convertir_moneda(v_id_moneda, --moneda origen para conversion
												v_id_moneda_base,   --moneda a la que sera convertido
												v_parametros.monto_mo, --este monto siempre estara en moenda base
												v_fecha, 
												'O',-- tipo oficial, venta, compra 
												NULL);--defecto dos decimales 

        	--Obtención de la partida a partir del concepto de gasto
        	select cp.id_partida
        	into v_id_partida
        	from param.tconcepto_ingas conig
            inner join pre.tconcepto_partida cp
            on cp.id_concepto_ingas = conig.id_concepto_ingas
            inner join pre.tpartida par on par.id_partida = cp.id_partida
            where conig.id_concepto_ingas = v_parametros.id_concepto_ingas
            and par.id_gestion = v_id_gestion;
            
            if v_id_partida is null then
            	raise exception 'Partida no encontrada';
            end if;

			--Sentencia de la modificacion
			update cd.tcuenta_doc_det set
			id_cuenta_doc = v_parametros.id_cuenta_doc,
			monto_mb = v_importe,
			id_centro_costo = v_parametros.id_centro_costo,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_partida = v_id_partida,
			monto_mo = v_parametros.monto_mo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_moneda = v_id_moneda,
			id_moneda_mb = v_id_moneda_base
			where id_cuenta_doc_det=v_parametros.id_cuenta_doc_det;

			--Actualizacion del importe total en la cabecera
			v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_parametros.id_cuenta_doc);
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuesto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_det',v_parametros.id_cuenta_doc_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDET_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-09-2017 17:54:29
	***********************************/

	elsif(p_transaccion='CD_CDET_ELI')then

		begin

			--Obtención de datos de la solicitud
		    select codigo, cdoc.id_cuenta_doc
		    into v_codigo_tipo_cuenta_doc, v_id_cuenta_doc
		    from cd.tcuenta_doc_det cdocd
		    inner join cd.tcuenta_doc cdoc
		    on cdoc.id_cuenta_doc = cdocd.id_cuenta_doc
		    inner join  cd.ttipo_cuenta_doc tcdoc
		    on tcdoc.id_tipo_cuenta_doc = cdoc.id_tipo_cuenta_doc
		    where cdocd.id_cuenta_doc_det = v_parametros.id_cuenta_doc_det;

        	--Verifica si se trata de de registrar concepto de gasto de Viático u Hotel
        	if v_permitir_mod = 'no' then
	        	if exists (select 1 from  cd.tcuenta_doc_det cdocd
					    	inner join cd.tcuenta_doc cd
					    	on cd.id_cuenta_doc = cdocd.id_cuenta_doc
						    left join cd.tescala_regla escr
						    on escr.id_escala = cd.id_escala
						    where cdocd.id_cuenta_doc_det = v_parametros.id_cuenta_doc_det
						    and escr.codigo in ('CONGAS_VIA_PLA','CONGAS_VIA_SER','CONGAS_HOT_PLA','CONGAS_HOT_SER')
						    and escr.id_concepto_ingas = cdocd.id_concepto_ingas) then

	        		raise exception 'Los Conceptos de gasto de Viáticos o de Hotel, no pueden eliminarse manualmente.';

	        	end if;
        	end if;

			--Sentencia de la eliminacion
			delete from cd.tcuenta_doc_det
            where id_cuenta_doc_det=v_parametros.id_cuenta_doc_det;

            --Actualizacion del importe total en la cabecera
			v_resp1 = cd.f_actualizar_cuenta_doc_total_cabecera(p_id_usuario, v_id_cuenta_doc);
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presupuesto eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc_det',v_parametros.id_cuenta_doc_det::varchar);
              
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