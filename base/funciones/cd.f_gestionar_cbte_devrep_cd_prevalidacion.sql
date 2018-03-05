CREATE OR REPLACE FUNCTION cd.f_gestionar_cbte_devrep_cd_prevalidacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/*
Autor: RCM
Fecha: 26/02/2018
Descripcion: Función previa a la validación del comprobante
*/


DECLARE

    v_nombre_funcion   				text;
    v_resp	                        varchar;
    v_registros                     record;
    v_id_estado_actual  			integer;
    va_id_tipo_estado 				integer[];
    va_codigo_estado 				varchar[];
    va_disparador    				varchar[];
    va_regla        				varchar[]; 
    va_prioridad     				integer[];    
    v_tipo_sol   					varchar;    
    v_nro_cuota 					numeric;    
    v_id_proceso_wf 				integer;
    v_id_estado_wf 				    integer;
    v_codigo_estado 				varchar;
    v_id_plan_pago 				    integer;
    v_verficacion  				    boolean;
    v_verficacion2 				    varchar[];     
    v_id_tipo_estado  				integer;
    v_codigo_proceso_llave_wf   	varchar;
    v_cd_comprometer_presupuesto	varchar;
    
BEGIN

    v_nombre_funcion = 'tes.f_gestionar_cbte_devrep_cd_prevalidacion';
    v_cd_comprometer_presupuesto = pxp.f_get_variable_global('cd_comprometer_presupuesto');

    if v_cd_comprometer_presupuesto = 'si' then

        --1) Con el id_comprobante identificar la cuenta documentada de rendicion
        select 
        pc.id_cuenta_doc
        into
        v_registros
        from cd.tcuenta_doc pc
        where pc.id_int_comprobante_devrep = p_id_int_comprobante; 

        --2) Validar que tenga una cuenta documentada asociada
        if v_registros.id_cuenta_doc is null then
            raise exception 'El comprobante no está relacionado con ninguna cuenta documentada';
        end if;

        --Revertir el presupuesto de las facturas rendidas
        /*if not cd.f_gestionar_presupuesto_cd(
            v_registros.id_cuenta_doc,
            p_id_usuario, 
            'revertir',
            p_conexion) then

            raise exception 'Error al revertir presupuesto';

        end if;*/

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