/***********************************I-DEP-RAC-CD-0-17/05/2016*****************************************/
DROP VIEW IF EXISTS cd.vcuenta_doc;


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


/***********************************I-DEP-RCM-CD-0-15/11/2017*****************************************/

/*
ALTER TABLE cd.tdestino
  ADD CONSTRAINT fk_tdestino__id_escala_viatico FOREIGN KEY (id_escala_viatico)
    REFERENCES cd.tescala_viatico(id_escala_viatico)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;*/

ALTER TABLE cd.tdestino
  ADD CONSTRAINT tdestino_fk1 FOREIGN KEY (id_escala)
    REFERENCES cd.tescala(id_escala)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_cuenta_bancaria_mov FOREIGN KEY (id_cuenta_bancaria_mov)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_cuenta_doc_fk FOREIGN KEY (id_cuenta_doc_fk)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_depto_conta FOREIGN KEY (id_depto_conta)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_depto_lb FOREIGN KEY (id_depto_lb)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_funcionario_cuenta_bancaria FOREIGN KEY (id_funcionario_cuenta_bancaria)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_funcionario_gerente FOREIGN KEY (id_funcionario_gerente)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_tipo_cuenta_doc FOREIGN KEY (id_tipo_cuenta_doc)
    REFERENCES cd.ttipo_cuenta_doc(id_tipo_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_calculo
  ADD CONSTRAINT fk_tcuenta_doc_calculo__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_det
  ADD CONSTRAINT fk_tcuenta_doc_det__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_det
  ADD CONSTRAINT fk_tcuenta_doc_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_det
  ADD CONSTRAINT fk_tcuenta_doc_det__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_det
  ADD CONSTRAINT fk_tcuenta_doc_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_det
  ADD CONSTRAINT fk_tcuenta_doc_det__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_det
  ADD CONSTRAINT fk_tcuenta_doc_det__id_moneda_mb FOREIGN KEY (id_moneda_mb)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_itinerario
  ADD CONSTRAINT fk_tcuenta_doc_itinerario__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc_itinerario
  ADD CONSTRAINT fk_tcuenta_doc_itinerario__id_destino FOREIGN KEY (id_destino)
    REFERENCES cd.tdestino(id_destino)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/*
ALTER TABLE cd.tdestino
  ADD CONSTRAINT fk_tdestino__id_escala_viatico FOREIGN KEY (id_escala_viatico)
    REFERENCES cd.tescala_viatico(id_escala_viatico)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;  */

ALTER TABLE cd.trendicion_det
  ADD CONSTRAINT fk_trendicion_det__id_doc_compra_venta FOREIGN KEY (id_doc_compra_venta)
    REFERENCES conta.tdoc_compra_venta(id_doc_compra_venta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.trendicion_det
  ADD CONSTRAINT fk_trendicion_det__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.trendicion_det
  ADD CONSTRAINT fk_trendicion_det__id_cuenta_doc_rendicion FOREIGN KEY (id_cuenta_doc_rendicion)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_escala FOREIGN KEY (id_escala)
    REFERENCES cd.tescala(id_escala)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcategoria
  ADD CONSTRAINT fk_tcategoria__id_tipo_categoria FOREIGN KEY (id_tipo_categoria)
    REFERENCES cd.ttipo_categoria(id_tipo_categoria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcategoria
  ADD CONSTRAINT fk_tcategoria__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcategoria
  ADD CONSTRAINT fk_tcategoria__id_destino FOREIGN KEY (id_destino)
    REFERENCES cd.tdestino(id_destino)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/*
ALTER TABLE cd.tescala_viatico
  RENAME TO tescala;  */

/*
ALTER TABLE cd.tescala
  RENAME COLUMN id_escala_viatico TO id_escala;  */

/*
ALTER TABLE cd.ttipo_categoria
  RENAME COLUMN id_escala_viatico TO id_escala;
*/

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-CD-0-15/11/2017*****************************************/

/***********************************I-DEP-JUAN-CD-0-16/11/2017*****************************************/
ALTER TABLE cd.tdestino
  ADD CONSTRAINT tdestino_fk FOREIGN KEY (id_escala)
    REFERENCES cd.tescala(id_escala)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-JUAN-CD-0-16/11/2017*****************************************/

/***********************************I-DEP-RCM-CD-0-21/11/2017*****************************************/
ALTER TABLE cd.tcategoria
  ADD CONSTRAINT uq_tcategoria__id_tipo_categoria_id_moneda_id_destino
    UNIQUE (id_destino, id_moneda, id_tipo_categoria) NOT DEFERRABLE;
/***********************************F-DEP-RCM-CD-0-21/11/2017*****************************************/

/***********************************I-DEP-RCM-CD-0-05/12/2017*****************************************/
ALTER TABLE cd.tcuenta_doc_prorrateo
  ADD CONSTRAINT fk_tcuenta_doc_prorrateo__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
ALTER TABLE cd.tcuenta_doc_prorrateo
  ADD CONSTRAINT fk_tcuenta_doc_prorrateo__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-CD-0-05/12/2017*****************************************/

/***********************************I-DEP-RAC-CD-0-13/12/2017*****************************************/


CREATE OR REPLACE VIEW cd.vreposicion_por_caja(
    id_cuenta_doc,
    id_solicitud_efectivo,
    monto,
    id_funcionario_cajero)
AS
  SELECT dcd.id_cuenta_doc,
         se.id_solicitud_efectivo,
         se.monto,
         c.id_funcionario AS id_funcionario_cajero
  FROM cd.tdeposito_cd dcd
       JOIN tes.tsolicitud_efectivo se ON se.id_solicitud_efectivo =
         dcd.id_solicitud_efectivo
       JOIN tes.ttipo_solicitud ts ON ts.id_tipo_solicitud =
         se.id_tipo_solicitud
       JOIN tes.tcaja ca ON ca.id_caja = se.id_caja
       JOIN tes.tcajero c ON c.id_caja = ca.id_caja AND c.tipo::text =
         'responsable'::text
  WHERE ts.nombre::text = 'ingreso'::text AND
        se.estado_reg::text = 'activo'::text;


--------------- SQL ---------------

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
         COALESCE(dpcd.importe_contable_deposito, lb.importe_deposito, 0::
           numeric (20, 2)) AS importe_deposito,
         lb.id_cuenta_bancaria,
         cdr.id_funcionario,
         cdr.id_depto_lb,
         cdr.id_depto_conta,
         lb.id_libro_bancos
  FROM tes.tts_libro_bancos lb
       LEFT JOIN cd.tdeposito_cd dpcd ON dpcd.id_libro_bancos =
         lb.id_libro_bancos
       JOIN cd.tcuenta_doc cdr ON cdr.id_cuenta_doc = lb.columna_pk_valor AND
         lb.tabla::text = 'cd.tcuenta_doc'::text AND lb.columna_pk::text =
         'id_cuenta_doc'::text

  WHERE lb.tipo in ('deposito') ;


/***********************************F-DEP-RAC-CD-0-13/12/2017*****************************************/



/***********************************I-DEP-RCM-CD-0-14/12/2017*****************************************/
CREATE OR REPLACE VIEW cd.vcuenta_doc_dev_cheque(
    id_cuenta_doc,
    id_cuenta_bancaria,
    dev_nombre_cheque,
    dev_saldo,
    id_moneda,
    id_depto_lb)
AS
  SELECT cd.id_cuenta_doc,
         cd.id_cuenta_bancaria,
         cd.dev_nombre_cheque,
         cd.dev_saldo,
         cb.id_moneda,
         cd.id_depto_lb
  FROM cd.tcuenta_doc cd
       JOIN tes.tcuenta_bancaria cb ON cb.id_cuenta_bancaria =
         cd.id_cuenta_bancaria;
/***********************************F-DEP-RCM-CD-0-14/12/2017*****************************************/

/***********************************I-DEP-RCM-CD-0-15/12/2017*****************************************/
-- View: cd.vcuenta_doc_cbte_rend

CREATE OR REPLACE VIEW cd.vcuenta_doc_cbte_rend AS
 SELECT cdoc.id_cuenta_doc,
    cdoc.id_funcionario,
    cdoc.id_depto_conta,
    cdoc.fecha AS fecha_cbte,
    cdoc.id_moneda,
    cdoc.id_gestion,
    cdoc.id_cuenta_bancaria,
    cdoc.id_cuenta_bancaria_mov,
    cdoc.importe,
    cdoc.nro_tramite,
    f.desc_funcionario1 AS funcionario_solicitante,
    cdoc.id_depto_lb,
    fcb.nro_cuenta,
    fcb.id_institucion,
    cdoc.nombre_cheque,
    cdoc.motivo,
    cdoc.tipo_pago,
        CASE
            WHEN cdoc.tipo_pago::text = 'cheque'::text THEN cdoc.nombre_cheque
            ELSE f.desc_funcionario1::character varying
        END AS nombre_pago,
    de.prioridad,
    cdoc.id_proceso_wf,
    fu.email_empresa AS correo_solicitante,
    mo.codigo AS moneda,
    ( SELECT f_get_saldo_totales_cuenta_doc.o_total_rendido + f_get_saldo_totales_cuenta_doc.o_total_dev
           FROM cd.f_get_saldo_totales_cuenta_doc(cdoc.id_cuenta_doc, 'si'::character varying) f_get_saldo_totales_cuenta_doc(o_total_solicitado, o_total_rendido, o_saldo, o_a_favor_de, o_por_caja, o_tipo, o_total_dev)) AS total_rendido_dev,
    ( SELECT f_get_saldo_totales_cuenta_doc.o_a_favor_de
           FROM cd.f_get_saldo_totales_cuenta_doc(cdoc.id_cuenta_doc, 'si'::character varying) f_get_saldo_totales_cuenta_doc(o_total_solicitado, o_total_rendido, o_saldo, o_a_favor_de, o_por_caja, o_tipo, o_total_dev)) AS a_favor_de,
    ( SELECT f_get_saldo_totales_cuenta_doc.o_tipo
           FROM cd.f_get_saldo_totales_cuenta_doc(cdoc.id_cuenta_doc, 'si'::character varying) f_get_saldo_totales_cuenta_doc(o_total_solicitado, o_total_rendido, o_saldo, o_a_favor_de, o_por_caja, o_tipo, o_total_dev)) AS tipo,
    case
        when (select o_tipo from cd.f_get_saldo_totales_cuenta_doc(cdoc.id_cuenta_doc, 'si'::character varying)) = 'cheque' then 'PAGO'
        else 'DIARIO'
    end as tipo_cbte
   FROM cd.tcuenta_doc cdoc
     JOIN orga.vfuncionario f ON f.id_funcionario = cdoc.id_funcionario
     JOIN orga.tfuncionario fu ON fu.id_funcionario = cdoc.id_funcionario
     JOIN param.tdepto de ON de.id_depto = cdoc.id_depto
     JOIN param.tmoneda mo ON mo.id_moneda = cdoc.id_moneda
     LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
  WHERE cdoc.id_cuenta_doc_fk IS NOT NULL;

 /***********************************F-DEP-RCM-CD-0-15/12/2017*****************************************/




 /***********************************I-DEP-RAC-CD-0-18/12/2017*****************************************/


 CREATE OR REPLACE VIEW cd.vdevolucion_caja(
    id_cuenta_doc,
    id_solicitud_efectivo,
    monto,
    id_funcionario_cajero)
AS
  SELECT dcd.id_cuenta_doc,
         se.id_solicitud_efectivo,
         se.monto,
         c.id_funcionario AS id_funcionario_cajero
  FROM cd.tcuenta_doc dcd
       JOIN tes.tsolicitud_efectivo se ON se.id_solicitud_efectivo =
         dcd.id_solicitud_efectivo
       JOIN tes.ttipo_solicitud ts ON ts.id_tipo_solicitud =
         se.id_tipo_solicitud
       JOIN tes.tcaja ca ON ca.id_caja = se.id_caja
       JOIN tes.tcajero c ON c.id_caja = ca.id_caja AND c.tipo::text =
         'responsable'::text
  WHERE ts.nombre::text = 'ingreso'::text AND
        se.estado_reg::text = 'activo'::text;


/***********************************F-DEP-RAC-CD-0-18/12/2017*****************************************/

/***********************************I-DEP-RCM-CD-0-27/12/2017*****************************************/
  create or replace view cd.vcuenta_doc_calculo
    as
  select cdocca.id_cuenta_doc_calculo,
  cdocca.numero,
  cdocca.destino,
  cdocca.dias_saldo_ant,
  cdocca.dias_destino,
  cdocca.cobertura_sol,
  cdocca.cobertura_hotel_sol,
  cdocca.dias_total_viaje,
  cdocca.dias_aplicacion_regla,
  cdocca.hora_salida,
  cdocca.hora_llegada,
  cdocca.escala_viatico,
  cdocca.escala_hotel,
  cdocca.regla_cobertura_dias_acum,
  cdocca.regla_cobertura_hora_salida,
  cdocca.regla_cobertura_hora_llegada,
  cdocca.regla_cobertura_total_dias,
  cdocca.cobertura_aplicada,
  cdocca.cobertura_aplicada_hotel,
  cdocca.estado_reg,
  cdocca.id_cuenta_doc,
  cdocca.id_usuario_ai,
  cdocca.usuario_ai,
  cdocca.fecha_reg,
  cdocca.id_usuario_reg,
  cdocca.fecha_mod,
  cdocca.id_usuario_mod,
  cdocca.dias_destino * cdocca.cobertura_aplicada * cdocca.escala_viatico as parcial_viatico,
  (cdocca.dias_destino - 1) * cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel as parcial_hotel,
  (cdocca.dias_destino * cdocca.cobertura_aplicada * cdocca.escala_viatico) + ((cdocca.dias_destino-1) * cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel) as total_viatico
  from cd.tcuenta_doc_calculo cdocca;

/***********************************F-DEP-RCM-CD-0-27/12/2017*****************************************/

/***********************************I-DEP-RCM-CD-0-02/01/2018*****************************************/

  create or replace view cd.vcuenta_doc_calculo
    as
  select cdocca.id_cuenta_doc_calculo,
  cdocca.numero,
  cdocca.destino,
  cdocca.dias_saldo_ant,
  cdocca.dias_destino,
  cdocca.cobertura_sol,
  cdocca.cobertura_hotel_sol,
  cdocca.dias_total_viaje,
  cdocca.dias_aplicacion_regla,
  cdocca.hora_salida,
  cdocca.hora_llegada,
  cdocca.escala_viatico,
  cdocca.escala_hotel,
  cdocca.regla_cobertura_dias_acum,
  cdocca.regla_cobertura_hora_salida,
  cdocca.regla_cobertura_hora_llegada,
  cdocca.regla_cobertura_total_dias,
  cdocca.cobertura_aplicada,
  cdocca.cobertura_aplicada_hotel,
  cdocca.estado_reg,
  cdocca.id_cuenta_doc,
  cdocca.id_usuario_ai,
  cdocca.usuario_ai,
  cdocca.fecha_reg,
  cdocca.id_usuario_reg,
  cdocca.fecha_mod,
  cdocca.id_usuario_mod,
  cdocca.dias_destino * cdocca.cobertura_aplicada * cdocca.escala_viatico as parcial_viatico,
  (coalesce(cdocca.dias_hotel,cdocca.dias_destino - 1)) * cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel as parcial_hotel,
  (cdocca.dias_destino * cdocca.cobertura_aplicada * cdocca.escala_viatico) + (coalesce(cdocca.dias_hotel,cdocca.dias_destino - 1) * cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel) as total_viatico
  from cd.tcuenta_doc_calculo cdocca;

/***********************************F-DEP-RCM-CD-0-02/01/2018*****************************************/

/***********************************I-DEP-RCM-CD-0-03/01/2018*****************************************/

/***********************************F-DEP-RCM-CD-0-03/01/2018*****************************************/



/***********************************I-DEP-RAC-CD-0-05/01/2018*****************************************/


CREATE OR REPLACE VIEW cd.vpago_simple_cbte(
    id_pago_simple,
    id_moneda,
    id_depto_conta,
    id_depto_lb,
    id_cuenta_bancaria,
    total_liquido_pagado,
    total_documentos,
    desc_proveedor,
    id_funcionario,
    id_proveedor,
    id_proceso_wf,
    id_estado_wf,
    nro_tramite,
    obs,
    id_periodo,
    id_gestion,
    id_int_comprobante,
    id_int_comprobante_pago,
    fecha)
AS
  SELECT ps.id_pago_simple,
         ps.id_moneda,
         ps.id_depto_conta,
         ps.id_depto_lb,
         ps.id_cuenta_bancaria,
         (
           SELECT f_get_saldo_totales_pago_simple.o_liquido_pagado
           FROM cd.f_get_saldo_totales_pago_simple(ps.id_pago_simple)
             f_get_saldo_totales_pago_simple(p_monto, o_total_documentos,
             o_liquido_pagado)
         ) AS total_liquido_pagado,
         (
           SELECT f_get_saldo_totales_pago_simple.o_total_documentos
           FROM cd.f_get_saldo_totales_pago_simple(ps.id_pago_simple)
             f_get_saldo_totales_pago_simple(p_monto, o_total_documentos,
             o_liquido_pagado)
         ) AS total_documentos,
         pro.desc_proveedor,
         ps.id_funcionario,
         ps.id_proveedor,
         ps.id_proceso_wf,
         ps.id_estado_wf,
         ps.nro_tramite,
         ps.obs,
         per.id_periodo,
         per.id_gestion,
         ps.id_int_comprobante,
         ps.id_int_comprobante_pago,
         ps.fecha
  FROM cd.tpago_simple ps
       JOIN param.vproveedor pro ON pro.id_proveedor = ps.id_proveedor
       JOIN param.tperiodo per ON ps.fecha >= per.fecha_ini AND ps.fecha <= per.fecha_fin;



CREATE OR REPLACE VIEW cd.vps_doc_compra_venta_det(
    id_pago_simple_det,
    id_pago_simple,
    id_funcionario,
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
  SELECT psd.id_pago_simple_det,
         psd.id_pago_simple,
         dcv.id_funcionario,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
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
         (((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) ||
           ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE
           (dcv.nro_documento)::text AS descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dco.precio_total_final,
         (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice,
           0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
  FROM cd.tpago_simple_det psd
       JOIN conta.tdoc_compra_venta dcv ON psd.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tplantilla plt ON plt.id_plantilla = dcv.id_plantilla
       JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         dco.id_concepto_ingas
  WHERE btrim(upper(plt.desc_plantilla::text)) <> btrim(upper(
    'PASAJES (Prestamos Funcionario)'::text));




CREATE OR REPLACE VIEW cd.vps_doc_compra_venta_det_prestamos(
    id_pago_simple_det,
    id_pago_simple,
    id_funcionario,
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
  SELECT psd.id_pago_simple_det,
         psd.id_pago_simple,
         dcv.id_funcionario,
         dcv.id_moneda,
         dcv.id_int_comprobante,
         dcv.id_plantilla,
         dcv.importe_doc,
         dcv.importe_excento,
         COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0
           ::numeric) AS importe_total_excento,
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
         (((((dcv.razon_social::text || ' - '::text) || cig.desc_ingas::text) ||
           ' ( '::text) || dco.descripcion) || ' ) Nro Doc: '::text) || COALESCE
           (dcv.nro_documento)::text AS descripcion,
         dcv.importe_neto,
         dcv.importe_anticipo,
         dcv.importe_pendiente,
         dcv.importe_retgar,
         dco.precio_total_final,
         (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice,
           0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
  FROM cd.tpago_simple_det psd
       JOIN conta.tdoc_compra_venta dcv ON psd.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tplantilla plt ON plt.id_plantilla = dcv.id_plantilla
       JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       JOIN param.tconcepto_ingas cig ON cig.id_concepto_ingas =
         dco.id_concepto_ingas
  WHERE btrim(upper(plt.desc_plantilla::text)) = btrim(upper(
    'PASAJES (Prestamos Funcionario)'::text));



/***********************************F-DEP-RAC-CD-0-05/01/2018*****************************************/


/***********************************I-DEP-RAC-CD-0-10/01/2018*****************************************/

CREATE OR REPLACE VIEW cd.vpago_simple (
    id_usuario_reg,
    id_usuario_mod,
    fecha_reg,
    fecha_mod,
    estado_reg,
    id_usuario_ai,
    usuario_ai,
    id_pago_simple,
    id_depto_conta,
    nro_tramite,
    fecha,
    id_funcionario,
    estado,
    id_estado_wf,
    id_proceso_wf,
    obs,
    id_cuenta_bancaria,
    id_depto_lb,
    id_proveedor,
    id_moneda,
    id_int_comprobante,
    id_int_comprobante_pago,
    id_tipo_pago_simple,
    id_funcionario_pago,
    codigo,
    flujo_wf,
    desc_tipo_pago_simple,
    plantilla_cbte,
    plantilla_cbte_1)
AS
SELECT ps.id_usuario_reg,
    ps.id_usuario_mod,
    ps.fecha_reg,
    ps.fecha_mod,
    ps.estado_reg,
    ps.id_usuario_ai,
    ps.usuario_ai,
    ps.id_pago_simple,
    ps.id_depto_conta,
    ps.nro_tramite,
    ps.fecha,
    ps.id_funcionario,
    ps.estado,
    ps.id_estado_wf,
    ps.id_proceso_wf,
    ps.obs,
    ps.id_cuenta_bancaria,
    ps.id_depto_lb,
    ps.id_proveedor,
    ps.id_moneda,
    ps.id_int_comprobante,
    ps.id_int_comprobante_pago,
    ps.id_tipo_pago_simple,
    ps.id_funcionario_pago,
    tps.codigo,
    tps.flujo_wf,
    tps.nombre AS desc_tipo_pago_simple,
    tps.plantilla_cbte,
    tps.plantilla_cbte_1
FROM cd.tpago_simple ps
     JOIN cd.ttipo_pago_simple tps ON tps.id_tipo_pago_simple = ps.id_tipo_pago_simple;

/***********************************F-DEP-RAC-CD-0-10/01/2018*****************************************/

/***********************************I-DEP-RAC-CD-0-12/01/2018*****************************************/

 CREATE OR REPLACE VIEW cd.vpago_simple_det_prorrateado
AS
  SELECT psd.id_pago_simple,
         ps.id_moneda,
         ps.id_depto_conta,
         ps.id_depto_lb,
         ps.id_cuenta_bancaria,
         ps.id_funcionario,
         ps.id_proveedor,
         CASE COALESCE(ps.id_funcionario, 0)
           WHEN 0 THEN pro.desc_proveedor::text
           ELSE fun.desc_funcionario1
         END AS desc_proveedor,
         ps.id_proceso_wf,
         ps.id_estado_wf,
         ps.nro_tramite,
         ps.obs,
         psd.id_pago_simple_det,
         dcv.id_doc_compra_venta,
         dc.id_doc_concepto,
         opd.id_obligacion_det,
         op.id_obligacion_pago,
         opd.id_partida,
         opd.id_centro_costo,
         opd.monto_pago_mb / op.total_pago AS factor,
         dc.precio_total_final *(opd.monto_pago_mo / op.total_pago) AS
           importe_pro,
         ps.importe AS total_pagado,
         dc.id_concepto_ingas,
         dcv.id_plantilla,
         dc.descripcion
  FROM cd.tpago_simple ps
       JOIN cd.tpago_simple_det psd ON psd.id_pago_simple = ps.id_pago_simple
       JOIN conta.tdoc_compra_venta dcv ON dcv.id_doc_compra_venta =
         psd.id_doc_compra_venta
       JOIN conta.tdoc_concepto dc ON dc.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       LEFT JOIN tes.tobligacion_pago op ON op.id_obligacion_pago =
         ps.id_obligacion_pago
       LEFT JOIN tes.tobligacion_det opd ON opd.id_obligacion_pago =
         op.id_obligacion_pago
       LEFT JOIN param.vproveedor pro ON pro.id_proveedor = ps.id_proveedor
       LEFT JOIN orga.vfuncionario fun ON fun.id_funcionario = ps.id_funcionario
       JOIN param.tperiodo per ON ps.fecha >= per.fecha_ini AND ps.fecha <=
         per.fecha_fin;


CREATE OR REPLACE VIEW cd.vpago_simple_cbte_pago_pro
AS
SELECT ps.id_pago_simple,
    ps.id_moneda,
    ps.id_depto_conta,
    ps.id_depto_lb,
    ps.id_cuenta_bancaria,
    ps.importe AS total_liquido_pagado,
    ps.importe AS total_documentos,
    pro.desc_proveedor,
    ps.id_funcionario,
    ps.id_proveedor,
    ps.id_proceso_wf,
    ps.id_estado_wf,
    ps.nro_tramite,
    ps.obs,
    per.id_periodo,
    per.id_gestion,
    ps.id_int_comprobante,
    ps.id_int_comprobante_pago,
    ps.fecha
FROM cd.tpago_simple ps
     JOIN param.vproveedor pro ON pro.id_proveedor = ps.id_proveedor
     JOIN param.tperiodo per ON ps.fecha >= per.fecha_ini AND ps.fecha <= per.fecha_fin;
/***********************************F-DEP-RAC-CD-0-12/01/2018*****************************************/

/***********************************I-DEP-RAC-CD-0-14/01/2018*****************************************/
CREATE OR REPLACE VIEW cd.vpago_simple_det_prorrateado_directo as
  SELECT psd.id_pago_simple,
         ps.id_moneda,
         ps.id_depto_conta,
         ps.id_depto_lb,
         ps.id_cuenta_bancaria,
         ps.id_funcionario,
         ps.id_proveedor,
         CASE COALESCE(ps.id_funcionario, 0)
           WHEN 0 THEN pro.desc_proveedor::text
           ELSE fun.desc_funcionario1
         END AS desc_proveedor,
         ps.id_proceso_wf,
         ps.id_estado_wf,
         ps.nro_tramite,
         ps.obs,
         psd.id_pago_simple_det,
         dcv.id_doc_compra_venta,
         dc.id_doc_concepto,
         opd.id_pago_simple_pro,
         opd.id_partida,
         opd.id_centro_costo,
         opd.factor,
         dc.precio_total_final * opd.factor AS importe_pro,
         ps.importe AS total_pagado,
         dc.id_concepto_ingas,
         dcv.id_plantilla,
         dc.descripcion,
         (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice,
           0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
  FROM cd.tpago_simple ps
       JOIN cd.tpago_simple_det psd ON psd.id_pago_simple = ps.id_pago_simple
       JOIN conta.tdoc_compra_venta dcv ON dcv.id_doc_compra_venta =
         psd.id_doc_compra_venta
       JOIN conta.tdoc_concepto dc ON dc.id_doc_compra_venta =
         dcv.id_doc_compra_venta
       LEFT JOIN cd.tpago_simple_pro opd ON opd.id_pago_simple =
         ps.id_pago_simple
       LEFT JOIN param.vproveedor pro ON pro.id_proveedor = ps.id_proveedor
       LEFT JOIN orga.vfuncionario fun ON fun.id_funcionario = ps.id_funcionario
       JOIN param.tperiodo per ON ps.fecha >= per.fecha_ini AND ps.fecha <=
         per.fecha_fin;
/***********************************F-DEP-RAC-CD-0-14/01/2018*****************************************/

/***********************************I-DEP-RCM-CD-0-22/01/2018*****************************************/
CREATE OR REPLACE VIEW cd.vcuenta_doc_calculo(
    id_cuenta_doc_calculo,
    numero,
    destino,
    dias_saldo_ant,
    dias_destino,
    cobertura_sol,
    cobertura_hotel_sol,
    dias_total_viaje,
    dias_aplicacion_regla,
    hora_salida,
    hora_llegada,
    escala_viatico,
    escala_hotel,
    regla_cobertura_dias_acum,
    regla_cobertura_hora_salida,
    regla_cobertura_hora_llegada,
    regla_cobertura_total_dias,
    cobertura_aplicada,
    cobertura_aplicada_hotel,
    estado_reg,
    id_cuenta_doc,
    id_usuario_ai,
    usuario_ai,
    fecha_reg,
    id_usuario_reg,
    fecha_mod,
    id_usuario_mod,
    parcial_viatico,
    parcial_hotel,
    total_viatico,
    dias_hotel,
    cantidad_personas)
AS
  SELECT cdocca.id_cuenta_doc_calculo,
         cdocca.numero,
         cdocca.destino,
         cdocca.dias_saldo_ant,
         cdocca.dias_destino,
         cdocca.cobertura_sol,
         cdocca.cobertura_hotel_sol,
         cdocca.dias_total_viaje,
         cdocca.dias_aplicacion_regla,
         cdocca.hora_salida,
         cdocca.hora_llegada,
         cdocca.escala_viatico,
         cdocca.escala_hotel,
         cdocca.regla_cobertura_dias_acum,
         cdocca.regla_cobertura_hora_salida,
         cdocca.regla_cobertura_hora_llegada,
         cdocca.regla_cobertura_total_dias,
         cdocca.cobertura_aplicada,
         cdocca.cobertura_aplicada_hotel,
         cdocca.estado_reg,
         cdocca.id_cuenta_doc,
         cdocca.id_usuario_ai,
         cdocca.usuario_ai,
         cdocca.fecha_reg,
         cdocca.id_usuario_reg,
         cdocca.fecha_mod,
         cdocca.id_usuario_mod,
         round(cdocca.dias_destino::numeric * cdocca.cobertura_aplicada *
           cdocca.escala_viatico * cdocca.cantidad_personas::numeric, 0) AS
           parcial_viatico,
         COALESCE(cdocca.dias_hotel, cdocca.dias_destino - 1)::numeric *
           cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel *
           cdocca.cantidad_personas::numeric AS parcial_hotel,
         round(cdocca.dias_destino::numeric * cdocca.cobertura_aplicada *
           cdocca.escala_viatico * cdocca.cantidad_personas::numeric,0) + COALESCE(
           cdocca.dias_hotel, cdocca.dias_destino - 1)::numeric *
           cdocca.cobertura_aplicada_hotel * cdocca.escala_hotel *
           cdocca.cantidad_personas::numeric AS total_viatico,
         cdocca.dias_hotel,
         cdocca.cantidad_personas
  FROM cd.tcuenta_doc_calculo cdocca;
/***********************************F-DEP-RCM-CD-0-22/01/2018*****************************************/

/***********************************I-DEP-RCM-CD-0-22/02/2018*****************************************/
CREATE OR REPLACE VIEW cd.vcuenta_doc_cbte_devrep (
    id_cuenta_doc,
    id_funcionario,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    nro_tramite,
    dev_tipo,
    dev_a_favor_de,
    dev_nombre_cheque,
    dev_saldo_deposito,
    dev_saldo_cheque,
    dev_saldo,
    id_cuenta_bancaria,
    id_depto_lb,
    funcionario_solicitante,
    correo_solicitante,
    moneda,
    nro_cuenta,
    id_institucion,
    prioridad,
    tipo_cbte)
AS
 SELECT cdoc.id_cuenta_doc,
    cdoc.id_funcionario,
    cdoc.id_depto_conta,
    cdoc.fecha AS fecha_cbte,
    cdoc.id_moneda,
    cdoc.id_gestion,
    cdoc.nro_tramite,
    cdoc.dev_tipo,
    cdoc.dev_a_favor_de,
    cdoc.dev_nombre_cheque,
        CASE cdoc.dev_a_favor_de
            WHEN 'empresa'::text THEN cdoc.dev_saldo
            ELSE 0::numeric
        END AS dev_saldo_deposito,
        CASE cdoc.dev_a_favor_de
            WHEN 'funcionario'::text THEN cdoc.dev_saldo
            ELSE 0::numeric
        END AS dev_saldo_cheque,
    cdoc.dev_saldo,
    cdoc.id_cuenta_bancaria,
    cdoc.id_depto_lb,
    f.desc_funcionario1 AS funcionario_solicitante,
    fu.email_empresa AS correo_solicitante,
    mo.codigo AS moneda,
    fcb.nro_cuenta,
    fcb.id_institucion,
    de.prioridad,
    'PAGO'::text AS tipo_cbte
   FROM cd.tcuenta_doc cdoc
     JOIN orga.vfuncionario f ON f.id_funcionario = cdoc.id_funcionario
     JOIN orga.tfuncionario fu ON fu.id_funcionario = cdoc.id_funcionario
     JOIN param.tmoneda mo ON mo.id_moneda = cdoc.id_moneda
     JOIN param.tdepto de ON de.id_depto = cdoc.id_depto
     LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
  WHERE cdoc.id_cuenta_doc_fk IS NOT NULL AND (COALESCE(cdoc.dev_tipo, ''::character varying)::text = ANY (ARRAY['deposito'::character varying, 'cheque'::character varying]::text[]));
/***********************************F-DEP-RCM-CD-0-22/02/2018*****************************************/

/***********************************I-DEP-RCM-CD-0-12/03/2018*****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_solicitud_efectivo FOREIGN KEY (id_solicitud_efectivo)
    REFERENCES tes.tsolicitud_efectivo(id_solicitud_efectivo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_caja_dev FOREIGN KEY (id_caja_dev)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_plantilla FOREIGN KEY (id_plantilla)
    REFERENCES param.tplantilla(id_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_int_comprobante_devrep FOREIGN KEY (id_int_comprobante_devrep)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-CD-0-12/03/2018*****************************************/


/***********************************I-DEP-RCM-CD-0-10/05/2018*****************************************/
DROP VIEW cd.vcuenta_doc_cbte_devrep;

CREATE VIEW cd.vcuenta_doc_cbte_devrep (
    id_cuenta_doc,
    id_funcionario,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    nro_tramite,
    dev_tipo,
    dev_a_favor_de,
    dev_nombre_cheque,
    dev_saldo_deposito,
    dev_saldo_cheque,
    dev_saldo,
    id_cuenta_bancaria,
    id_depto_lb,
    funcionario_solicitante,
    correo_solicitante,
    moneda,
    nro_cuenta,
    id_institucion,
    prioridad,
    tipo_cbte)
AS
SELECT cdoc.id_cuenta_doc,
    cdoc.id_funcionario,
    cdoc.id_depto_conta,
    cdoc.fecha AS fecha_cbte,
    cdoc.id_moneda,
    cdoc.id_gestion,
    cdoc.nro_tramite,
    cdoc.dev_tipo,
    cdoc.dev_a_favor_de,
    cdoc.dev_nombre_cheque,
        CASE cdoc.dev_a_favor_de
            WHEN 'empresa'::text THEN cdoc.dev_saldo
            ELSE 0::numeric
        END AS dev_saldo_deposito,
        CASE cdoc.dev_a_favor_de
            WHEN 'funcionario'::text THEN cdoc.dev_saldo
            ELSE 0::numeric
        END AS dev_saldo_cheque,
    cdoc.dev_saldo,
    cdoc.id_cuenta_bancaria,
    cdoc.id_depto_lb,
    f.desc_funcionario1 AS funcionario_solicitante,
    fu.email_empresa AS correo_solicitante,
    mo.codigo AS moneda,
    fcb.nro_cuenta,
    fcb.id_institucion,
    de.prioridad,
        CASE cdoc.dev_a_favor_de
            WHEN 'empresa'::text THEN 'INGRESOCON'::text
            ELSE 'PAGOCON'::text
        END AS tipo_cbte
FROM cd.tcuenta_doc cdoc
     JOIN orga.vfuncionario f ON f.id_funcionario = cdoc.id_funcionario
     JOIN orga.tfuncionario fu ON fu.id_funcionario = cdoc.id_funcionario
     JOIN param.tmoneda mo ON mo.id_moneda = cdoc.id_moneda
     JOIN param.tdepto de ON de.id_depto = cdoc.id_depto
     LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON
         fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
WHERE cdoc.id_cuenta_doc_fk IS NOT NULL AND (COALESCE(cdoc.dev_tipo,
    ''::character varying)::text = ANY (ARRAY['deposito'::character varying::text, 'cheque'::character varying::text]));

/***********************************F-DEP-RCM-CD-0-10/05/2018*****************************************/

/***********************************I-DEP-JJA-CD-3-01/12/2018*****************************************/

DROP VIEW cd.vpago_simple_det_prorrateado_directo;

DROP VIEW cd.vpago_simple_det_prorrateado;

DROP VIEW cd.vpago_simple;

DROP VIEW cd.vcuenta_doc_cbte_devrep;

DROP VIEW cd.vcuenta_doc;

CREATE OR REPLACE VIEW cd.vpago_simple (
    id_usuario_reg,
    id_usuario_mod,
    fecha_reg,
    fecha_mod,
    estado_reg,
    id_usuario_ai,
    usuario_ai,
    id_pago_simple,
    id_depto_conta,
    nro_tramite,
    fecha,
    id_funcionario,
    estado,
    id_estado_wf,
    id_proceso_wf,
    obs,
    id_cuenta_bancaria,
    id_depto_lb,
    id_proveedor,
    id_moneda,
    id_int_comprobante,
    id_int_comprobante_pago,
    id_tipo_pago_simple,
    id_funcionario_pago,
    codigo_tipo_pago_simple,
    flujo_wf,
    desc_tipo_pago_simple,
    plantilla_cbte,
    plantilla_cbte_1)
AS
 SELECT ps.id_usuario_reg,
    ps.id_usuario_mod,
    ps.fecha_reg,
    ps.fecha_mod,
    ps.estado_reg,
    ps.id_usuario_ai,
    ps.usuario_ai,
    ps.id_pago_simple,
    ps.id_depto_conta,
    ps.nro_tramite,
    ps.fecha,
    ps.id_funcionario,
    ps.estado,
    ps.id_estado_wf,
    ps.id_proceso_wf,
    ps.obs,
    ps.id_cuenta_bancaria,
    ps.id_depto_lb,
    ps.id_proveedor,
    ps.id_moneda,
    ps.id_int_comprobante,
    ps.id_int_comprobante_pago,
    ps.id_tipo_pago_simple,
    ps.id_funcionario_pago,
    tps.codigo AS codigo_tipo_pago_simple,
    tps.flujo_wf,
    tps.nombre AS desc_tipo_pago_simple,
    tps.plantilla_cbte,
    tps.plantilla_cbte_1
   FROM cd.tpago_simple ps
     JOIN cd.ttipo_pago_simple tps ON tps.id_tipo_pago_simple = ps.id_tipo_pago_simple;

CREATE OR REPLACE VIEW cd.vpago_simple_det_prorrateado_directo (
    id_pago_simple,
    id_moneda,
    id_depto_conta,
    id_depto_lb,
    id_cuenta_bancaria,
    id_funcionario,
    id_proveedor,
    desc_proveedor,
    id_proceso_wf,
    id_estado_wf,
    nro_tramite,
    obs,
    id_pago_simple_det,
    id_doc_compra_venta,
    id_doc_concepto,
    id_pago_simple_pro,
    id_partida,
    id_centro_costo,
    factor,
    importe_pro,
    total_pagado,
    id_concepto_ingas,
    id_plantilla,
    descripcion,
    porc_monto_excento_var)
AS
 SELECT psd.id_pago_simple,
    ps.id_moneda,
    ps.id_depto_conta,
    ps.id_depto_lb,
    ps.id_cuenta_bancaria,
    ps.id_funcionario,
    ps.id_proveedor,
        CASE COALESCE(ps.id_funcionario, 0)
            WHEN 0 THEN pro.desc_proveedor::text
            ELSE fun.desc_funcionario1
        END AS desc_proveedor,
    ps.id_proceso_wf,
    ps.id_estado_wf,
    ps.nro_tramite,
    ps.obs,
    psd.id_pago_simple_det,
    dcv.id_doc_compra_venta,
    dc.id_doc_concepto,
    opd.id_pago_simple_pro,
    opd.id_partida,
    opd.id_centro_costo,
    opd.factor,
    dc.precio_total_final * opd.factor AS importe_pro,
    ps.importe AS total_pagado,
    dc.id_concepto_ingas,
    dcv.id_plantilla,
    dc.descripcion,
    (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
   FROM cd.tpago_simple ps
     JOIN cd.tpago_simple_det psd ON psd.id_pago_simple = ps.id_pago_simple
     JOIN conta.tdoc_compra_venta dcv ON dcv.id_doc_compra_venta = psd.id_doc_compra_venta
     JOIN conta.tdoc_concepto dc ON dc.id_doc_compra_venta = dcv.id_doc_compra_venta
     LEFT JOIN cd.tpago_simple_pro opd ON opd.id_pago_simple = ps.id_pago_simple AND opd.estado_reg::text = 'activo'::text
     LEFT JOIN param.vproveedor pro ON pro.id_proveedor = ps.id_proveedor
     LEFT JOIN orga.vfuncionario fun ON fun.id_funcionario = ps.id_funcionario
     JOIN param.tperiodo per ON ps.fecha >= per.fecha_ini AND ps.fecha <= per.fecha_fin;

CREATE OR REPLACE VIEW cd.vpago_simple_det_prorrateado (
    id_pago_simple,
    id_moneda,
    id_depto_conta,
    id_depto_lb,
    id_cuenta_bancaria,
    id_funcionario,
    id_proveedor,
    desc_proveedor,
    id_proceso_wf,
    id_estado_wf,
    nro_tramite,
    obs,
    id_pago_simple_det,
    id_doc_compra_venta,
    id_doc_concepto,
    id_obligacion_det,
    id_obligacion_pago,
    id_partida,
    id_centro_costo,
    factor,
    importe_pro,
    total_pagado,
    id_concepto_ingas,
    id_plantilla,
    descripcion,
    porc_monto_excento_var)
AS
 SELECT psd.id_pago_simple,
    ps.id_moneda,
    ps.id_depto_conta,
    ps.id_depto_lb,
    ps.id_cuenta_bancaria,
    ps.id_funcionario,
    ps.id_proveedor,
        CASE COALESCE(ps.id_funcionario, 0)
            WHEN 0 THEN pro.desc_proveedor::text
            ELSE fun.desc_funcionario1
        END AS desc_proveedor,
    ps.id_proceso_wf,
    ps.id_estado_wf,
    ps.nro_tramite,
    ps.obs,
    psd.id_pago_simple_det,
    dcv.id_doc_compra_venta,
    dc.id_doc_concepto,
    opd.id_obligacion_det,
    op.id_obligacion_pago,
    opd.id_partida,
    opd.id_centro_costo,
    opd.monto_pago_mb / op.total_pago AS factor,
    dc.precio_total_final * (opd.monto_pago_mo / op.total_pago) AS importe_pro,
    ps.importe AS total_pagado,
    dc.id_concepto_ingas,
    dcv.id_plantilla,
    dc.descripcion,
    (COALESCE(dcv.importe_excento, 0::numeric) + COALESCE(dcv.importe_ice, 0::numeric)) / dcv.importe_neto AS porc_monto_excento_var
   FROM cd.tpago_simple ps
     JOIN cd.tpago_simple_det psd ON psd.id_pago_simple = ps.id_pago_simple
     JOIN conta.tdoc_compra_venta dcv ON dcv.id_doc_compra_venta = psd.id_doc_compra_venta
     JOIN conta.tdoc_concepto dc ON dc.id_doc_compra_venta = dcv.id_doc_compra_venta
     LEFT JOIN tes.tobligacion_pago op ON op.id_obligacion_pago = ps.id_obligacion_pago
     LEFT JOIN tes.tobligacion_det opd ON opd.id_obligacion_pago = op.id_obligacion_pago
     LEFT JOIN param.vproveedor pro ON pro.id_proveedor = ps.id_proveedor
     LEFT JOIN orga.vfuncionario fun ON fun.id_funcionario = ps.id_funcionario
     JOIN param.tperiodo per ON ps.fecha >= per.fecha_ini AND ps.fecha <= per.fecha_fin;

CREATE OR REPLACE VIEW cd.vcuenta_doc (
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
     LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON fcb.id_funcionario_cuenta_bancaria = cd.id_funcionario_cuenta_bancaria;

CREATE OR REPLACE VIEW cd.vcuenta_doc_cbte_devrep (
    id_cuenta_doc,
    id_funcionario,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    nro_tramite,
    dev_tipo,
    dev_a_favor_de,
    dev_nombre_cheque,
    dev_saldo_deposito,
    dev_saldo_cheque,
    dev_saldo,
    id_cuenta_bancaria,
    id_depto_lb,
    funcionario_solicitante,
    correo_solicitante,
    moneda,
    nro_cuenta,
    id_institucion,
    prioridad,
    tipo_cbte)
AS
 SELECT cdoc.id_cuenta_doc,
    cdoc.id_funcionario,
    cdoc.id_depto_conta,
    cdoc.fecha AS fecha_cbte,
        CASE cdoc.id_cuenta_doc
            WHEN 10085 THEN 1
            ELSE cdoc.id_moneda
        END AS id_moneda,
    cdoc.id_gestion,
    cdoc.nro_tramite,
    cdoc.dev_tipo,
    cdoc.dev_a_favor_de,
    cdoc.dev_nombre_cheque,
        CASE cdoc.dev_a_favor_de
            WHEN 'empresa'::text THEN cdoc.dev_saldo
            ELSE 0::numeric
        END AS dev_saldo_deposito,
        CASE cdoc.dev_a_favor_de
            WHEN 'funcionario'::text THEN cdoc.dev_saldo
            ELSE 0::numeric
        END AS dev_saldo_cheque,
    cdoc.dev_saldo,
    cdoc.id_cuenta_bancaria,
    cdoc.id_depto_lb,
    f.desc_funcionario1 AS funcionario_solicitante,
    fu.email_empresa AS correo_solicitante,
        CASE cdoc.id_cuenta_doc
            WHEN 10085 THEN 'BS'::character varying(5)
            ELSE mo.codigo
        END AS moneda,
    fcb.nro_cuenta,
    fcb.id_institucion,
    de.prioridad,
        CASE cdoc.dev_a_favor_de
            WHEN 'empresa'::text THEN 'INGRESOCON'::text
            ELSE 'PAGOCON'::text
        END AS tipo_cbte
   FROM cd.tcuenta_doc cdoc
     JOIN orga.vfuncionario f ON f.id_funcionario = cdoc.id_funcionario
     JOIN orga.tfuncionario fu ON fu.id_funcionario = cdoc.id_funcionario
     JOIN param.tmoneda mo ON mo.id_moneda = cdoc.id_moneda
     JOIN param.tdepto de ON de.id_depto = cdoc.id_depto
     LEFT JOIN orga.tfuncionario_cuenta_bancaria fcb ON fcb.id_funcionario_cuenta_bancaria = cdoc.id_funcionario_cuenta_bancaria
  WHERE cdoc.id_cuenta_doc_fk IS NOT NULL AND (COALESCE(cdoc.dev_tipo, ''::character varying)::text = ANY (ARRAY['deposito'::character varying::text, 'cheque'::character varying::text]));
/***********************************F-DEP-JJA-CD-3-01/12/2018*****************************************/

/***********************************I-DEP-RCM-CD-0-03/12/2018*****************************************/
--Todo lo relacionado con el SIGEMA debe estar en esta transacción. TODO: poner lógica para quen función de alguna bandera cree las vistas o no
/*CREATE OR REPLACE VIEW cd.vsigema_administrativa (
    idsolicitudadm,
    nrosolicitud,
    gestion,
    tipoactividadfinanciera,
    idactividadfinanciera,
    codigo,
    descripcion,
    porcentajeasignado,
    ajuste)
AS
 SELECT DISTINCT sigema_administrativa.idsolicitudadm,
    convert_from(sigema_administrativa.nrosolicitud, 'LATIN1'::name)::character varying AS nrosolicitud,
    convert_from(sigema_administrativa.gestion, 'LATIN1'::name)::character varying AS gestion,
    sigema_administrativa.tipoactividadfinanciera,
    sigema_administrativa.idactividadfinanciera,
    convert_from(sigema_administrativa.codigo, 'LATIN1'::name)::character varying AS codigo,
    convert_from(sigema_administrativa.descripcion, 'LATIN1'::name)::character varying AS descripcion,
    sigema_administrativa.porcentajeasignado,
    sigema_administrativa.ajuste
   FROM cd.sigema_administrativa;

DROP VIEW cd.vcuenta_doc;

CREATE OR REPLACE VIEW cd.vsigema_mihv (
    idsolicitudplan,
    nrosolicitud,
    gestion,
    tipoactividadfinanciera,
    idactividadfinanciera,
    codigo,
    descripcion,
    porcentajeasignado,
    tipo)
AS
 SELECT DISTINCT sigema_mihv.idsolicitudplan,
    convert_from(sigema_mihv.nrosolicitud, 'LATIN1'::name)::character varying AS nrosolicitud,
    convert_from(sigema_mihv.gestion, 'LATIN1'::name)::character varying AS gestion,
    sigema_mihv.tipoactividadfinanciera,
    sigema_mihv.idactividadfinanciera,
    convert_from(sigema_mihv.codigo, 'LATIN1'::name)::character varying AS codigo,
    convert_from(sigema_mihv.descripcion, 'LATIN1'::name)::character varying AS descripcion,
    sigema_mihv.porcentajeasignado,
    convert_from(sigema_mihv.tipo, 'LATIN1'::name)::character varying AS tipo
   FROM cd.sigema_mihv;

CREATE OR REPLACE VIEW cd.vsigema_ot (
    idordentrabajo,
    nroot,
    gestion,
    tipoactividadfinanciera,
    idactividadfinanciera,
    codigo,
    descripcion,
    porcentajeasignado)
AS
 SELECT DISTINCT sigema_ot.idordentrabajo,
    convert_from(sigema_ot.nroot, 'LATIN1'::name)::character varying AS nroot,
    convert_from(sigema_ot.gestion, 'LATIN1'::name)::character varying AS gestion,
    sigema_ot.tipoactividadfinanciera,
    sigema_ot.idactividadfinanciera,
    convert_from(sigema_ot.codigo, 'LATIN1'::name)::character varying AS codigo,
    convert_from(sigema_ot.descripcion, 'LATIN1'::name)::character varying AS descripcion,
    sigema_ot.porcentajeasignado
   FROM cd.sigema_ot;

CREATE OR REPLACE VIEW cd.vsigema_sce (
    idsolicitud,
    nrosolicitud,
    gestion,
    tipoactividadfinanciera,
    idactividadfinanciera,
    codigo,
    descripcion,
    porcentajeasignado)
AS
 SELECT DISTINCT sigema_sce.idsolicitud,
    convert_from(sigema_sce.nrosolicitud, 'LATIN1'::name)::character varying AS nrosolicitud,
    convert_from(sigema_sce.gestion, 'LATIN1'::name)::character varying AS gestion,
    sigema_sce.tipoactividadfinanciera,
    sigema_sce.idactividadfinanciera,
    convert_from(sigema_sce.codigo, 'LATIN1'::name)::character varying AS codigo,
    convert_from(sigema_sce.descripcion, 'LATIN1'::name)::character varying AS descripcion,
    sigema_sce.porcentajeasignado
   FROM cd.sigema_sce;

CREATE OR REPLACE VIEW cd.vsigema_gral (
    tipo_sol_sigema,
    id_sigema,
    nro_solicitud,
    gestion,
    tipoactividadfinanciera,
    idactividadfinanciera,
    codigo_cc,
    descripcion_cc,
    porcentajeasignado,
    ajuste,
    tipo)
AS
 SELECT 'sol_admin'::character varying AS tipo_sol_sigema,
    vsigema_administrativa.idsolicitudadm AS id_sigema,
    vsigema_administrativa.nrosolicitud AS nro_solicitud,
    vsigema_administrativa.gestion,
    vsigema_administrativa.tipoactividadfinanciera,
    vsigema_administrativa.idactividadfinanciera,
    vsigema_administrativa.codigo AS codigo_cc,
    vsigema_administrativa.descripcion AS descripcion_cc,
    vsigema_administrativa.porcentajeasignado,
    vsigema_administrativa.ajuste,
    NULL::character varying AS tipo
   FROM cd.vsigema_administrativa
UNION
 SELECT 'sol_man_mihv'::character varying AS tipo_sol_sigema,
    vsigema_mihv.idsolicitudplan AS id_sigema,
    vsigema_mihv.nrosolicitud AS nro_solicitud,
    vsigema_mihv.gestion,
    vsigema_mihv.tipoactividadfinanciera,
    vsigema_mihv.idactividadfinanciera,
    vsigema_mihv.codigo AS codigo_cc,
    vsigema_mihv.descripcion AS descripcion_cc,
    vsigema_mihv.porcentajeasignado,
    0 AS ajuste,
    vsigema_mihv.tipo
   FROM cd.vsigema_mihv
UNION
 SELECT 'orden_trabajo'::character varying AS tipo_sol_sigema,
    vsigema_ot.idordentrabajo AS id_sigema,
    vsigema_ot.nroot AS nro_solicitud,
    vsigema_ot.gestion,
    vsigema_ot.tipoactividadfinanciera,
    vsigema_ot.idactividadfinanciera,
    vsigema_ot.codigo AS codigo_cc,
    vsigema_ot.descripcion AS descripcion_cc,
    vsigema_ot.porcentajeasignado,
    0 AS ajuste,
    NULL::character varying AS tipo
   FROM cd.vsigema_ot
UNION
 SELECT 'sol_man_event'::character varying AS tipo_sol_sigema,
    vsigema_sce.idsolicitud AS id_sigema,
    vsigema_sce.nrosolicitud AS nro_solicitud,
    vsigema_sce.gestion,
    vsigema_sce.tipoactividadfinanciera,
    vsigema_sce.idactividadfinanciera,
    vsigema_sce.codigo AS codigo_cc,
    vsigema_sce.descripcion AS descripcion_cc,
    vsigema_sce.porcentajeasignado,
    0 AS ajuste,
    NULL::character varying AS tipo
   FROM cd.vsigema_sce;

   CREATE OR REPLACE VIEW cd.vrendicion_sigema_ext (
    id_rendicion,
    fecha_solicitud,
    fecha_rendicion,
    centro_costo,
    nro_tramite,
    tipo_sol_sigema,
    id_sigema,
    gestion,
    estado,
    tipoactividadfinanciera,
    idactividadfinanciera,
    tipo,
    importe)
AS
 WITH sigema AS (
         SELECT vsigema_gral.tipo_sol_sigema,
            vsigema_gral.id_sigema,
            vsigema_gral.nro_solicitud,
            vsigema_gral.gestion,
            vsigema_gral.tipoactividadfinanciera,
            vsigema_gral.idactividadfinanciera,
            vsigema_gral.codigo_cc,
            vsigema_gral.descripcion_cc,
            vsigema_gral.porcentajeasignado,
            vsigema_gral.ajuste,
            vsigema_gral.tipo
           FROM cd.vsigema_gral
        )
 SELECT cd.id_cuenta_doc AS id_rendicion,
    cdsol.fecha AS fecha_solicitud,
    cd.fecha AS fecha_rendicion,
    cc.codigo_tcc AS centro_costo,
    cd.nro_tramite,
    cdsol.tipo_sol_sigema,
    cdsol.id_sigema,
    date_part('year'::text, cdsol.fecha)::integer AS gestion,
    cd.estado,
    sig.tipoactividadfinanciera,
    sig.idactividadfinanciera,
    sig.tipo,
    sum(dco.precio_total_final) AS importe
   FROM cd.tcuenta_doc cd
     JOIN cd.ttipo_cuenta_doc tcd ON tcd.id_tipo_cuenta_doc = cd.id_tipo_cuenta_doc
     JOIN cd.trendicion_det rde ON rde.id_cuenta_doc_rendicion = cd.id_cuenta_doc
     JOIN conta.tdoc_compra_venta cv ON cv.id_doc_compra_venta = rde.id_doc_compra_venta
     JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta = cv.id_doc_compra_venta
     JOIN param.vcentro_costo cc ON cc.id_centro_costo = dco.id_centro_costo
     JOIN cd.tcuenta_doc cdsol ON cdsol.id_cuenta_doc = cd.id_cuenta_doc_fk
     JOIN sigema sig ON sig.id_sigema = cdsol.id_sigema AND sig.gestion::text = date_part('year'::text, cdsol.fecha)::character varying::text
  WHERE tcd.sw_solicitud::text = 'no'::text AND COALESCE(cdsol.tipo_sol_sigema, ''::character varying)::text <> ''::text
  GROUP BY cd.id_cuenta_doc, cd.fecha, cc.codigo_tcc, cd.nro_tramite, cdsol.tipo_sol_sigema, cdsol.id_sigema, cdsol.fecha, cd.estado, (date_part('year'::text, cdsol.fecha)), sig.tipoactividadfinanciera, sig.idactividadfinanciera, sig.tipo;

DROP VIEW cd.vrendicion_sigema;

CREATE OR REPLACE VIEW cd.vrendicion_sigema (
    id_rendicion,
    fecha_solicitud,
    fecha_rendicion,
    centro_costo,
    nro_tramite,
    tipo_sol_sigema,
    id_sigema,
    gestion,
    estado,
    importe)
AS
 SELECT cd.id_cuenta_doc AS id_rendicion,
    cdsol.fecha AS fecha_solicitud,
    cd.fecha AS fecha_rendicion,
    cc.codigo_tcc AS centro_costo,
    cd.nro_tramite,
    cdsol.tipo_sol_sigema,
    cdsol.id_sigema,
    date_part('year'::text, cdsol.fecha)::integer AS gestion,
    cd.estado,
    sum(dco.precio_total_final) AS importe
   FROM cd.tcuenta_doc cd
     JOIN cd.ttipo_cuenta_doc tcd ON tcd.id_tipo_cuenta_doc = cd.id_tipo_cuenta_doc
     JOIN cd.trendicion_det rde ON rde.id_cuenta_doc_rendicion = cd.id_cuenta_doc
     JOIN conta.tdoc_compra_venta cv ON cv.id_doc_compra_venta = rde.id_doc_compra_venta
     JOIN conta.tdoc_concepto dco ON dco.id_doc_compra_venta = cv.id_doc_compra_venta
     JOIN param.vcentro_costo cc ON cc.id_centro_costo = dco.id_centro_costo
     JOIN cd.tcuenta_doc cdsol ON cdsol.id_cuenta_doc = cd.id_cuenta_doc_fk
  WHERE tcd.sw_solicitud::text = 'no'::text AND COALESCE(cdsol.tipo_sol_sigema, ''::character varying)::text <> ''::text AND cdsol.id_sigema IS NOT NULL
  GROUP BY cd.id_cuenta_doc, cd.fecha, cc.codigo_tcc, cd.nro_tramite, cdsol.tipo_sol_sigema, cdsol.id_sigema, cdsol.fecha, cd.estado, (date_part('year'::text, cdsol.fecha));*/

/***********************************F-DEP-RCM-CD-0-03/12/2018*****************************************/

