/********************************************I-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
/********************************************F-DAUP-AUTOR-SCHEMA-0-31/02/2019********************************************/




/********************************************I-DAUP-MANU-CD-0-30/11/2020********************************************/
--SHEMA : Esquema (CONTA) contabilidad         AUTHOR:Siglas del autor de los scripts' dataupdate000001.txt
--rollback
--begin;
--UPDATE cd.tcuenta_doc SET estado='rendido' and tipo_rendicion='parcial' WHERE id_cuenta_doc=30764;
--commit;

BEGIN;
UPDATE cd.tcuenta_doc SET estado='vbtesoreria', tipo_rendicion='final' WHERE id_cuenta_doc=30764;
COMMIT;

--rollback
--begin;
--UPDATE wf.testado_wf SET id_tipo_estado=664 WHERE id_estado_wf=1162541;
--commit;

BEGIN;
UPDATE wf.testado_wf SET id_tipo_estado=695 WHERE id_estado_wf=1162541;
COMMIT;
/********************************************F-DAUP-MANU-CD-0-30/11/2020********************************************/



/********************************************I-DAUP-MANU-CD-0-30/12/2020********************************************/
--rollback
--begin;
--UPDATE cd.tcuenta_doc SET id_sigema='15495' WHERE id_cuenta_doc=31776;
--commit;
BEGIN;
UPDATE cd.tcuenta_doc SET id_sigema='16600' WHERE id_cuenta_doc=31776;
COMMIT;

--rollback
--begin;
--UPDATE cd.tcuenta_doc_prorrateo SET id_centro_costo='7784' WHERE id_cuenta_doc=31776;
--commit;

BEGIN;
UPDATE cd.tcuenta_doc_prorrateo SET id_centro_costo='2632' WHERE id_cuenta_doc=31776;
COMMIT;
/********************************************F-DAUP-MANU-CD-0-30/12/2020********************************************/


/********************************************I-DAUP-MANU-CD-0-29/01/2021********************************************/
--rollback
--begin;
--UPDATE cd.tcuenta_doc SET id_gestion=4 WHERE id_cuenta_doc=32812;
--commit;

BEGIN;
UPDATE cd.tcuenta_doc SET id_gestion=5 WHERE id_cuenta_doc=32812;
COMMIT;

/********************************************F-DAUP-MANU-CD-0-29/01/2021********************************************/
/********************************************I-DAUP-EGS-CD-ETR-2825-03/02/2021********************************************/
--rollback
--begin;
--UPDATE cd.tcuenta_doc SET id_depto=6 WHERE id_cuenta_doc=32757;
--commit;

BEGIN;
UPDATE cd.tcuenta_doc SET id_depto=27 WHERE id_cuenta_doc=32757;
COMMIT;

/********************************************F-DAUP-EGS-CD-ETR-2825-03/02/2021********************************************/

/********************************************I-DAUP-EGS-CD-ETR-3022-03/02/2021********************************************/
--rollback
--begin;
--UPDATE cd.tcuenta_doc SET
-- motivo = 'Servicio Desarmado de Mampara de Aluminio Oficina Central Piso 2'
-- WHERE id_cuenta_doc=33204;
--commit;

BEGIN;
UPDATE cd.tcuenta_doc SET
    motivo = 'Servicio Desarmado de Mampara de Aluminio Oficina Central Piso 1'
WHERE id_cuenta_doc=33204;
COMMIT;

/********************************************F-DAUP-EGS-CD-ETR-3022-03/02/2021********************************************/