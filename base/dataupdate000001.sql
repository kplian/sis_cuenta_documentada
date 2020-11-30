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