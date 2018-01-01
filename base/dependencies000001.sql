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


/***********************************I-DEP-RCM-CD-0-15/11/2017*****************************************/
ALTER TABLE cd.ttipo_categoria
  ADD CONSTRAINT fk_ttipo_categoria__id_escala_viatico FOREIGN KEY (id_escala_viatico)
    REFERENCES cd.tescala_viatico(id_escala_viatico)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE cd.tdestino
  ADD CONSTRAINT fk_tdestino__id_escala_viatico FOREIGN KEY (id_escala_viatico)
    REFERENCES cd.tescala_viatico(id_escala_viatico)
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

ALTER TABLE cd.tdestino
  ADD CONSTRAINT fk_tdestino__id_escala_viatico FOREIGN KEY (id_escala_viatico)
    REFERENCES cd.tescala_viatico(id_escala_viatico)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;     

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

ALTER TABLE cd.tescala_viatico
  RENAME TO tescala;  
ALTER TABLE cd.tescala
  RENAME COLUMN id_escala_viatico TO id_escala;  
ALTER TABLE cd.ttipo_categoria
  RENAME COLUMN id_escala_viatico TO id_escala;

ALTER TABLE cd.tcuenta_doc
  ADD CONSTRAINT fk_tcuenta_doc__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;      
      
/***********************************F-DEP-RCM-CD-0-15/11/2017*****************************************/

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
        
 
/***********************************I-DEP-RCM-CD-0-26/12/2017*****************************************/         
create or replace view cd.vrendicion_sigema
  as
select
cd.id_cuenta_doc,
cd.fecha as fecha_rendicion,
cc.codigo_tcc as centro_costo,
cd.nro_tramite,
cd.tipo_sol_sigema,
cd.id_sigema,
sum(dco.precio_total_final) as importe
from cd.tcuenta_doc cd
inner join cd.ttipo_cuenta_doc tcd
on tcd.id_tipo_cuenta_doc = cd.id_tipo_cuenta_doc
inner join cd.trendicion_det rde
on rde.id_cuenta_doc_rendicion = cd.id_cuenta_doc
inner join conta.tdoc_compra_venta cv
on cv.id_doc_compra_venta = rde.id_doc_compra_venta
inner join conta.tdoc_concepto dco
on dco.id_doc_compra_venta = cv.id_doc_compra_venta
inner join param.vcentro_costo cc
on cc.id_centro_costo = dco.id_centro_costo
where tcd.sw_solicitud = 'no'
and cd.estado = 'rendido'
group by cd.id_cuenta_doc,cd.fecha,cc.codigo_tcc,cd.nro_tramite,cd.tipo_sol_sigema,cd.id_sigema;

CREATE OR REPLACE VIEW cd.vsigema_mihv AS
 SELECT DISTINCT 
 idsolicitudplan,
 convert_from(nrosolicitud, 'LATIN1'::name)::varchar as nrosolicitud,
 convert_from(gestion, 'LATIN1'::name)::varchar as gestion,
 tipoactividadfinanciera,
 idactividadfinanciera,
 convert_from(codigo, 'LATIN1'::name)::varchar as codigo,
 convert_from(descripcion, 'LATIN1'::name)::varchar as descripcion,
 porcentajeasignado,
 convert_from(tipo, 'LATIN1'::name)::varchar as tipo
 from cd.sigema_mihv;

/***********************************I-DEP-RCM-CD-0-26/12/2017*****************************************/         

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
DROP VIEW cd.vrendicion_sigema;

create or replace view cd.vrendicion_sigema
  as
select
cd.id_cuenta_doc as id_rendicion,
cdsol.fecha as fecha_solicitud,
cd.fecha as fecha_rendicion,
cc.codigo_tcc as centro_costo,
cd.nro_tramite,
cdsol.tipo_sol_sigema,
cdsol.id_sigema,
extract('year' from cdsol.fecha)::integer as gestion,
cd.estado,
sum(dco.precio_total_final) as importe
from cd.tcuenta_doc cd
inner join cd.ttipo_cuenta_doc tcd
on tcd.id_tipo_cuenta_doc = cd.id_tipo_cuenta_doc
inner join cd.trendicion_det rde
on rde.id_cuenta_doc_rendicion = cd.id_cuenta_doc
inner join conta.tdoc_compra_venta cv
on cv.id_doc_compra_venta = rde.id_doc_compra_venta
inner join conta.tdoc_concepto dco
on dco.id_doc_compra_venta = cv.id_doc_compra_venta
inner join param.vcentro_costo cc
on cc.id_centro_costo = dco.id_centro_costo
inner join cd.tcuenta_doc cdsol
on cdsol.id_cuenta_doc = cd.id_cuenta_doc_fk
where tcd.sw_solicitud = 'no'
and coalesce(cdsol.tipo_sol_sigema,'')<>''
group by cd.id_cuenta_doc,cd.fecha,cc.codigo_tcc,cd.nro_tramite,cdsol.tipo_sol_sigema,cdsol.id_sigema,
cdsol.fecha,cd.estado,extract('year' from cdsol.fecha);
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