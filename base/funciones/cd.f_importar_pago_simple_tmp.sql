CREATE OR REPLACE FUNCTION cd.f_importar_pago_simple_tmp (
)
RETURNS boolean AS
$body$
DECLARE
  v_r record;
  v_id_pago_simple integer;
  v_id_proceso_macro integer;
  v_codigo_tipo_proceso varchar;
  v_num_tramite           varchar;
  v_id_proceso_wf         integer;
  v_id_estado_wf          integer;
  v_codigo_estado         varchar;
BEGIN
  --raise exception 'REVISAR PROVEEDORES QUE EXISTAN TODOS Y QUE NO ESTÉN DUPLICADOS';
  --actualizamos el id del proveedor de endesis
  --UPDATE cd.tpago_simple_tmp
  --SET id_proveedor=t.id_proveedor
  --FROM (SELECT id_proveedor, rotulo_comercial FROM param.tproveedor) AS t
  --WHERE proveedor=t.rotulo_comercial;

  FOR v_r in (
    select id,
    t.monto,
    case when t.moneda='Bolivianos' then 1 else 2 end as id_moneda,
    t.id_proveedor
    from cd.tpago_simple_tmp t
    where t.migrado = 'no' and t.id_proveedor is not null)
  LOOP

    select pm.id_proceso_macro
    into v_id_proceso_macro
    from wf.tproceso_macro pm
    where pm.codigo = 'CD_PAGSIM';
    if v_id_proceso_macro is NULL THEN
      raise exception 'El proceso macro de codigo CD_PAGSIM no esta configurado en el sistema WF';
    END IF;
    select tp.codigo
    into v_codigo_tipo_proceso
    from wf.ttipo_proceso tp
    where tp.id_proceso_macro = v_id_proceso_macro and tp.estado_reg = 'activo' and tp.inicio = 'si';
    if v_codigo_tipo_proceso is NULL THEN
      raise exception 'No existe un proceso inicial para el proceso macro indicado CD_PAGSIM (Revise la configuración)';
    end if;

    select ps_num_tramite, ps_id_proceso_wf, ps_id_estado_wf, ps_codigo_estado
    into v_num_tramite, v_id_proceso_wf, v_id_estado_wf, v_codigo_estado
    from wf.f_inicia_tramite(1,null,'',2, v_codigo_tipo_proceso,292,3,'Solicitud de Pago simple','');
                       
    insert into cd.tpago_simple(id_usuario_reg, estado_reg,
      id_depto_conta,fecha,id_funcionario,obs,id_proveedor,id_moneda,id_tipo_pago_simple,importe,
      nro_tramite,estado,id_estado_wf,id_proceso_wf)
    values (1,'activo',
      3,'15/01/2018', 292, 'MIGRADO', v_r.id_proveedor, v_r.id_moneda, 5, v_r.monto,
      v_num_tramite,v_codigo_estado,v_id_estado_wf,v_id_proceso_wf)
    RETURNING id_pago_simple into v_id_pago_simple;
    
    --actualizamos migrado
    update cd.tpago_simple_tmp set migrado='si', id_pago_simple=v_id_pago_simple where id=v_r.id;
  
  END LOOP;
  raise exception 'TERMINÓ-comentar esta línea para producción';
  RETURN TRUE;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;