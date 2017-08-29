/***********************************I-DEP-RAC-CD-0-17/05/2016*****************************************/
CREATE OR REPLACE VIEW cd.vcuenta_doc(
    id_cuenta_doc,
    id_funcionario,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    importe,
    nro_tramite,
    funcionario_solicitante,
    id_depto_lb,
    nro_cuenta,
    id_institucion,
    nombre_cheque,
    motivo,
    tipo_pago,
    nombre_pago)
AS
  SELECT cd.id_cuenta_doc,
         cd.id_funcionario,
         cd.id_depto_conta,
         cd.fecha AS fecha_cbte,
         cd.id_moneda,
         cd.id_gestion,
         cd.id_cuenta_bancaria,
         cd.id_cuenta_bancaria_mov,
         cd.importe,
         cd.nro_tramite,
         f.desc_funcionario1 AS funcionario_solicitante,
         cd.id_depto_lb,
         fcb.nro_cuenta,
         fcb.id_institucion,
         cd.nombre_cheque,
         cd.motivo,
         cd.tipo_pago,
         CASE
           WHEN cd.tipo_pago::text = 'cheque'::text THEN cd.nombre_cheque
           ELSE f.desc_funcionario1::character varying
         END AS nombre_pago
  FROM cd.tcuenta_doc cd
       JOIN orga.vfuncionario f ON f.id_funcionario = cd.id_funcionario
       LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON
         fcb.id_funcionario_cuenta_bancaria = cd.id_funcionario_cuenta_bancaria;


CREATE OR REPLACE VIEW cd.vrd_doc_compra_venta_det (
    id_rendicion_det,
    id_cuenta_doc_rendicion,
    id_cuenta_doc_solicitud,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_doc_compra_venta,
    id_concepto_ingas,
    id_centro_costo,
    id_orden_trabajo,
    precio_total,
    id_doc_concepto,
    desc_ingas,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    precio_total_final,
    porc_monto_excento_var)
AS
 SELECT rd.id_rendicion_det,
    rd.id_cuenta_doc_rendicion,
    rd.id_cuenta_doc AS id_cuenta_doc_solicitud,
    dcv.id_moneda,
    dcv.id_int_comprobante,
    dcv.id_plantilla,
    dcv.importe_doc,
    dcv.importe_excento,
    COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric) AS importe_total_excento,
    dcv.importe_descuento,
    dcv.importe_descuento_ley,
    dcv.importe_ice,
    dcv.importe_it,
    dcv.importe_iva,
    dcv.importe_pago_liquido,
    dcv.nro_documento,
    dcv.nro_dui,
    dcv.nro_autorizacion,
    dcv.razon_social,
    dcv.revisado,
    dcv.manual,
    dcv.obs,
    dcv.nit,
    dcv.fecha,
    dcv.codigo_control,
    dcv.sw_contabilizar,
    dcv.tipo,
    dcv.id_doc_compra_venta,
    dco.id_concepto_ingas,
    dco.id_centro_costo,
    dco.id_orden_trabajo,
    dco.precio_total,
    dco.id_doc_concepto,
    cig.desc_ingas,
    (((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) || ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS descripcion,
    dcv.importe_neto,
    dcv.importe_anticipo,
    dcv.importe_pendiente,
    dcv.importe_retgar,
    dco.precio_total_final,
    (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
   FROM cd.trendicion_det rd
   JOIN conta.tdoc_compra_venta dcv ON rd.id_doc_compra_venta = dcv.id_doc_compra_venta
   JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta = dcv.id_doc_compra_venta
   JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas = dco.id_concepto_ingas;
   
 --------------- SQL ---------------

CREATE OR REPLACE VIEW cd.vrd_doc_compra_venta(
    id_rendicion_det,
    id_cuenta_doc_rendicion,
    id_cuenta_doc_solicitud,
    id_moneda,
    id_int_comprobante,
    id_plantilla,
    importe_doc,
    importe_excento,
    importe_total_excento,
    importe_descuento,
    importe_descuento_ley,
    importe_ice,
    importe_it,
    importe_iva,
    importe_pago_liquido,
    nro_documento,
    nro_dui,
    nro_autorizacion,
    razon_social,
    revisado,
    manual,
    obs,
    nit,
    fecha,
    codigo_control,
    sw_contabilizar,
    tipo,
    id_doc_compra_venta,
    descripcion,
    importe_neto,
    importe_anticipo,
    importe_pendiente,
    importe_retgar,
    id_auxiliar)
AS
  SELECT rd.id_rendicion_det,
         rd.id_cuenta_doc_rendicion,
         rd.id_cuenta_doc AS id_cuenta_doc_solicitud,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric) AS importe_total_excento,
         dcv.importe_descuento,
         dcv.importe_descuento_ley,
         dcv.importe_ice,
         dcv.importe_it,
         dcv.importe_iva,
         dcv.importe_pago_liquido,
         dcv.nro_documento,
         dcv.nro_dui,
         dcv.nro_autorizacion,
         dcv.razon_social,
         dcv.revisado,
         dcv.manual,
         dcv.obs,
         dcv.nit,
         dcv.fecha,
         dcv.codigo_control,
         dcv.sw_contabilizar,
         dcv.tipo,
         dcv.id_doc_compra_venta,
         (((dcv.razon_social::text || ' - '::text) || ' ( '::text) ||
           ' ) Nro Doc: '::text) || COALESCE(dcv.nro_documento)::text AS
           descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dcv.id_auxiliar
  FROM cd.trendicion_det rd
       JOIN conta.tdoc_compra_venta dcv ON rd.id_doc_compra_venta =
         dcv.id_doc_compra_venta;
         

CREATE OR REPLACE VIEW cd.vlibro_bancos_deposito(
    id_cuenta_doc,
    importe_deposito,
    id_cuenta_bancaria,
    id_funcionario,
    id_depto_lb,
    id_depto_conta,
    id_libro_bancos)
AS
  SELECT cdr.id_cuenta_doc,
         COALESCE(dpcd.importe_contable_deposito, lb.importe_deposito, 0::numeric(20,2)) AS importe_deposito,
         lb.id_cuenta_bancaria,
         cdr.id_funcionario,
         cdr.id_depto_lb,
         cdr.id_depto_conta,
         lb.id_libro_bancos
  FROM tes.tts_libro_bancos lb
     LEFT JOIN cd.tdeposito_cd dpcd ON dpcd.id_libro_bancos = lb.id_libro_bancos
       JOIN cd.tcuenta_doc cdr ON cdr.id_cuenta_doc = lb.columna_pk_valor AND
         lb.tabla::text = 'cd.tcuenta_doc'::text AND lb.columna_pk::text =
         'id_cuenta_doc'::text; 
         

CREATE TRIGGER trig_tcuenta_doc
  AFTER UPDATE OF estado 
  ON cd.tcuenta_doc FOR EACH ROW 
  EXECUTE PROCEDURE cd.trig_tcuenta_doc();   
  

  
select wf.f_import_ttipo_documento_estado ('insert','SOLFA','SFA','borrador','SFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','SOLFA','SFA','borrador','SFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','borrador','RFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','borrador','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','MEMOFA','SFA','contabilizado','SFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','MEMOFA','SFA','contabilizado','SFA','insertar','superior','');      
         
/***********************************F-DEP-RAC-CD-0-17/05/2016*****************************************/



/***********************************I-DEP-RAC-CD-0-08/08/2016*****************************************/
CREATE OR REPLACE VIEW cd.vcuenta_doc(
    id_cuenta_doc,
    id_funcionario,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    id_cuenta_bancaria,
    id_cuenta_bancaria_mov,
    importe,
    nro_tramite,
    funcionario_solicitante,
    id_depto_lb,
    nro_cuenta,
    id_institucion,
    nombre_cheque,
    motivo,
    tipo_pago,
    nombre_pago,
    prioridad,
    id_proceso_wf,
    correo_solicitante,
    moneda)
AS
  SELECT cd.id_cuenta_doc,
         cd.id_funcionario,
         cd.id_depto_conta,
         cd.fecha AS fecha_cbte,
         cd.id_moneda,
         cd.id_gestion,
         cd.id_cuenta_bancaria,
         cd.id_cuenta_bancaria_mov,
         cd.importe,
         cd.nro_tramite,
         f.desc_funcionario1 AS funcionario_solicitante,
         cd.id_depto_lb,
         fcb.nro_cuenta,
         fcb.id_institucion,
         cd.nombre_cheque,
         cd.motivo,
         cd.tipo_pago,
         CASE
           WHEN cd.tipo_pago::text = 'cheque'::text THEN cd.nombre_cheque
           ELSE f.desc_funcionario1::character varying
         END AS nombre_pago,
         de.prioridad,
         cd.id_proceso_wf,
         fu.email_empresa AS correo_solicitante,
         mo.codigo AS moneda
  FROM cd.tcuenta_doc cd
       JOIN orga.vfuncionario f ON f.id_funcionario = cd.id_funcionario
       JOIN orga.tfuncionario fu ON fu.id_funcionario = cd.id_funcionario
       JOIN param.tdepto de ON de.id_depto = cd.id_depto
       JOIN param.tmoneda mo ON mo.id_moneda = cd.id_moneda
       LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON
         fcb.id_funcionario_cuenta_bancaria = cd.id_funcionario_cuenta_bancaria;
/***********************************F-DEP-RAC-CD-0-08/08/2016*****************************************/



/***********************************I-DEP-GSS-CD-0-14/06/2017*****************************************/

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


/***********************************F-DEP-GSS-CD-0-14/06/2017*****************************************/


/***********************************I-DEP-RAC-CD-0-24/08/2017*****************************************/

CREATE OR REPLACE VIEW cd.vcuenta_doc_revision(
    fecha,
    fecha_entrega,
    desc_funcionario1,
    nro_tramite,
    motivo,
    nro_cheque,
    importe_solicitado,
    importe_cheque,
    importe_documentos,
    importe_depositos,
    estado,
    id_funcionario,
    id_cuenta_doc,
    id_tipo_cuenta_doc,
    id_int_comprobante,
    id_proceso_wf,
    id_estado_wf)
AS
  SELECT cdoc.fecha,
         cdoc.fecha_entrega,
         fun.desc_funcionario1,
         cdoc.nro_tramite,
         cdoc.motivo,
         lb.nro_cheque,
         cdoc.importe AS importe_solicitado,
         lb.importe_cheque,
         CASE
           WHEN tcd.sw_solicitud::text = 'si'::text THEN COALESCE((
                                                                    SELECT sum(
                                                                      COALESCE(
                                                                      
                                                                      dcv.importe_pago_liquido,
                                                                      0::numeric
                                                                      )) AS sum
                                                                    FROM
                                                                      cd.trendicion_det
                                                                      rd
                                                                         JOIN
                                                                           conta.tdoc_compra_venta
                                                                           dcv
                                                                           ON
                                                                           dcv.id_doc_compra_venta
                                                                           =
                                                                           rd.id_doc_compra_venta
                                                                    WHERE
                                                                      dcv.estado_reg
                                                                      ::text =
                                                                      'activo'::
                                                                      text AND
                                                                          rd.id_cuenta_doc
                                                                            =
                                                                            cdoc.id_cuenta_doc
         ), 0::numeric)
           ELSE 0::numeric
         END AS importe_documentos,
         CASE
           WHEN tcd.sw_solicitud::text = 'si'::text THEN COALESCE((
                                                                    SELECT sum(
                                                                      COALESCE(
                                                                      
                                                                      lb_1.importe_deposito,
                                                                      0::numeric
                                                                      )) AS sum
                                                                    FROM
                                                                      tes.tts_libro_bancos
                                                                      lb_1
                                                                         JOIN
                                                                           cd.tcuenta_doc
                                                                           c ON
                                                                           c.id_cuenta_doc
                                                                           =
                                                                           lb_1.columna_pk_valor
                                                                           AND
                                                                           lb_1.columna_pk
                                                                           ::
                                                                           text
                                                                           =
                                                                           'id_cuenta_doc'
                                                                           ::
                                                                           text
                                                                           AND
                                                                           lb_1.tabla
                                                                           ::
                                                                           text
                                                                           =
                                                                           'cd.tcuenta_doc'
                                                                           ::
                                                                           text
                                                                    WHERE
                                                                      c.estado_reg
                                                                      ::text =
                                                                      'activo'::
                                                                      text AND
                                                                          c.id_cuenta_doc_fk
                                                                            =
                                                                            cdoc.id_cuenta_doc
         ), 0::numeric)
           ELSE 0::numeric
         END AS importe_depositos,
         cdoc.estado,
         fun.id_funcionario,
         cdoc.id_cuenta_doc,
         tcd.id_tipo_cuenta_doc,
         lb.id_int_comprobante,
         cdoc.id_proceso_wf,
         cdoc.id_estado_wf
  FROM cd.tcuenta_doc cdoc
       JOIN cd.ttipo_cuenta_doc tcd ON tcd.id_tipo_cuenta_doc =
         cdoc.id_tipo_cuenta_doc
       JOIN orga.vfuncionario fun ON fun.id_funcionario = cdoc.id_funcionario
       JOIN tes.tts_libro_bancos lb ON lb.id_int_comprobante =
         cdoc.id_int_comprobante;



/***********************************F-DEP-RAC-CD-0-24/08/2017*****************************************/


