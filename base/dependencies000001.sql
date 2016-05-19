/***********************************I-DEP-RAC-CD-0-17/05/2016*****************************************/

CREATE OR REPLACE VIEW cd.vcuenta_doc(
    id_cuenta_doc,
    id_funcionario,
    id_depto_conta,
    fecha_cbte,
    id_moneda,
    id_gestion,
    id_cuenta_bancaria,
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

/***********************************F-DEP-RAC-CD-0-17/05/2016*****************************************/
