CREATE OR REPLACE FUNCTION cd.f_gestionar_cbte_devrep_cuenta_doc_eliminacion (
	p_id_usuario integer,
	p_id_usuario_ai integer,
	p_usuario_ai varchar,
	p_id_int_comprobante integer,
	p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/***************************************************************************
 SISTEMA:        Cuenta Documentada
 FUNCION:        cd.f_gestionar_cbte_devrep_cuenta_doc_eliminacion
 DESCRIPCION:    Retrocede el estado de cuenta documentada al eliminar el comprobante de devolución/reposición
 AUTOR:          RCM
 FECHA:          22/02/2018
 COMENTARIOS:   
***************************************************************************/

DECLARE
  
	v_nombre_funcion   		text;
	v_resp					varchar;
    v_registros 			record;
    v_id_estado_actual  	integer;
    va_id_tipo_estado 		integer[];
    va_codigo_estado 		varchar[];
    va_disparador    		varchar[];
    va_regla         		varchar[]; 
    va_prioridad     		integer[];
    v_tipo_sol   			varchar;
    v_nro_cuota 			numeric;
    v_id_proceso_wf 		integer;
    v_id_estado_wf 			integer;
    v_id_plan_pago 			integer;
    v_verficacion  			boolean;
    v_verficacion2  		varchar[];
    v_id_tipo_estado 		integer;
    v_id_funcionario  		integer;
    v_id_usuario_reg 		integer;
    v_id_depto 				integer;
    v_codigo_estado 		varchar;
    v_id_estado_wf_ant  	integer;
    v_rec_cbte_trans   		record;
    v_reg_cbte   			record;
    
BEGIN

	v_nombre_funcion = 'cd.f_gestionar_cbte_devrep_cuenta_doc_eliminacion';
    
	--1) Con el id_int_comprobante identificar la cuenta documentada
	select 
	cc.id_cuenta_doc,
	cc.id_estado_wf,
	cc.id_proceso_wf,
	tcd.id_tipo_cuenta_doc,
	tcd.codigo,
	cc.estado,
	c.id_int_comprobante,         
	c.estado_reg as estado_cbte
	into
	v_registros
	from cd.tcuenta_doc cc
	inner join cd.ttipo_cuenta_doc tcd on tcd.id_tipo_cuenta_doc = cc.id_tipo_cuenta_doc
	inner join conta.tint_comprobante c on c.id_int_comprobante = cc.id_int_comprobante_devrep
	where cc.id_int_comprobante_devrep = p_id_int_comprobante;
    
    --2) Validar que tenga una cuenta documentada
	if v_registros.id_cuenta_doc is null then
		raise exception 'El comprobante de Devolución/Reposición no esta relacionado a ninguna cuenta documentada';
	end if;
    

    if v_registros.estado_cbte = 'validado' then

		raise exception 'No puede eliminarse el comprobante porque está Validado';

    else
     
   		--Recupera estado anterior segun Log del WF
		select
		ps_id_tipo_estado,
		ps_id_funcionario,
		ps_id_usuario_reg,
		ps_id_depto,
		ps_codigo_estado,
		ps_id_estado_wf_ant
		into
		v_id_tipo_estado,
		v_id_funcionario,
		v_id_usuario_reg,
		v_id_depto,
		v_codigo_estado,
		v_id_estado_wf_ant 
		from wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf);
        
        --Obtiene el proceso wf
		select ew.id_proceso_wf 
		into v_id_proceso_wf
		from wf.testado_wf ew
		where ew.id_estado_wf= v_id_estado_wf_ant;
                      
		--Registra el nuevo estado
		v_id_estado_actual = wf.f_registra_estado_wf(
									v_id_tipo_estado, 
									v_id_funcionario, 
									v_registros.id_estado_wf, 
									v_id_proceso_wf, 
									p_id_usuario,
									p_id_usuario_ai,
									p_usuario_ai,
									v_id_depto,
									'Eliminación de comprobante de cuenta documentada: '|| COALESCE(p_id_int_comprobante::varchar,'(Vacío)'));
                      
		if v_codigo_estado != 'pendiente_tes' then

			--Actualiza estado de la cuenta documentada
			update cd.tcuenta_doc set 
			id_estado_wf 				= v_id_estado_actual,
			estado 						= v_codigo_estado,
			id_usuario_mod				= p_id_usuario,
			fecha_mod					= now(),
			id_int_comprobante_devrep 	= null,
			id_usuario_ai 				= p_id_usuario_ai,
			usuario_ai 					= p_usuario_ai
			where id_cuenta_doc = v_registros.id_cuenta_doc;

		else
			--Si el estado es pendiente conservamos el ID del cbte y actualiza estado dla cuenta documentada
			update cd.tcuenta_doc set 
			id_estado_wf 	= v_id_estado_actual,
			estado 			= v_codigo_estado,
			id_usuario_mod	= p_id_usuario,
			fecha_mod		= now(),
			id_usuario_ai 	= p_id_usuario_ai,
			usuario_ai 		= p_usuario_ai
			where id_cuenta_doc = v_registros.id_cuenta_doc;

		end if;
             
    end if;
    
    --Respuesta
	return true;

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