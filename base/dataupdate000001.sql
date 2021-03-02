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


/********************************************I-DAUP-MGM-CD-ETR-3115-02/03/2021********************************************/
--finalizado VI-000220-2021
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=358375;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=358375;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1211105;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1211105;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=358375 WHERE id_cuenta_doc=32531;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1211105 WHERE id_cuenta_doc=32531;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251419;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251419;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1244779;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1244779;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1251419,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=33122;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1244779,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=33122;




--finalizado   VI-000090-2021
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251332;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251332;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1208357;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1208357;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1251332 WHERE id_cuenta_doc=32359;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1208357 WHERE id_cuenta_doc=32359;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251331;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251331;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1248772;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1248772;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1251331,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=33046;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1248772,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=33046;




--finalizado  VI-000084-2021
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251379;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251379;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1208369;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1208369;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1251379 WHERE id_cuenta_doc=32353;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1208369 WHERE id_cuenta_doc=32353;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251378;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251378;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1248714;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1248714;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1251378,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=33098;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1248714,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=33098;



--finalizado   VI-000094-2021
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251274;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251274;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1208512;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1208512;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1251274 WHERE id_cuenta_doc=32365;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1208512 WHERE id_cuenta_doc=32365;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1251273;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1251273;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1217097;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1217097;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1251273,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=32766;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1217097,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=32766;



--rollback  VI-000036-2021
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1213247;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1213247;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1208684;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1208684;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1213247 WHERE id_cuenta_doc=32284;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1208684 WHERE id_cuenta_doc=32284;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1213246;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1213246;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1213127;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1213127;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1213246,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=32631;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1213127,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=32631;



--rollback  VI-000047-2021
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1227804;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1227804;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1208642;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1208642;


--rollback
--UPDATE cd.tcuenta_doc SET estado='finalizado',id_estado_wf=1227804 WHERE id_cuenta_doc=32300;
--commit
UPDATE cd.tcuenta_doc SET estado='contabilizado',id_estado_wf=1208642 WHERE id_cuenta_doc=32300;

--rendido
--rollback
--UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1227803;
--commit
UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1227803;

--rollback
--UPDATE wf.testado_wf SET estado_reg='inactivo' WHERE id_estado_wf=1221328;
--commit
UPDATE wf.testado_wf SET estado_reg='activo' WHERE id_estado_wf=1221328;


--rollback
--UPDATE cd.tcuenta_doc SET estado='rendido',id_estado_wf=1227803,id_moneda_dev= 1,dev_saldo_original=371,id_int_comprobante_devrep = 104079,dev_saldo=371,dev_tipo='deposito',dev_a_favor_de='empresa' WHERE id_cuenta_doc=32660;
--commit
UPDATE cd.tcuenta_doc SET estado='vbtesoreria',id_estado_wf=1221328,id_moneda_dev= NULL,dev_saldo_original=NULL,id_int_comprobante_devrep = NULL,dev_saldo=NULL,dev_tipo=NULL,dev_a_favor_de=NULL WHERE id_cuenta_doc=32660;



/********************************************F-DAUP-MGM-CD-ETR-3115-02/03/2021********************************************/