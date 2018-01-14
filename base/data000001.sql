

/***********************************I-DAT-RAC-CD-0-05/05/2016*****************************************/


/* Data for the 'segu.tsubsistema' table  (Records 1 - 1) */

INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta")
VALUES 
  (E'CD', E'Cuenta Documenta', E'2016-05-04', E'CD', E'activo', E'cuenta_documentada');
  

/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_codigo_macro_fondo_avance', E'FA', E'codigo de proceso marcro para fondos en avance');  


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_limite_fondos', E'3', E'numero de solicitudes de fondo en avances donde se bloquea la solicitud');



/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_dias_entrega', E'15', E'numero de dias donde esta permitida la rendición');



/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_monto_factura_maximo', E'20000', E'monto de factura maximo permitido en la rendiciones  en moneda base');
  
  
/* Data for the 'pxp.variable_global' table  (Records 1 - 1) */

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_tipo_pago', E'cheque', E'opciones cheuqe, transferencia, caja, todos  (como la instacia permite realizar pagos de cuenta documentada)');  


select param.f_import_tdocumento ('insert','MEMOFA','Memorándum de ASignación de Fondos','CD','depto','gestion','','OB.AA.AT.depto.correlativo.gestion');
  


INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES 
  (E'cd_comprometer_presupuesto', E'si', E'si compromete presupuesto en las rendiciones');
  
  

----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select conta.f_import_tplantilla_comprobante ('insert','RENDICIONFONDO','cd.f_gestionar_cbte_cuenta_doc_eliminacion','id_cuenta_doc','CD','Rendición de Gastos','cd.f_gestionar_cbte_cuenta_doc','{$tabla.fecha_cbte}','activo','','{$tabla.id_depto_conta}','presupuestario','','cd.vcuenta_doc','DIARIO','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{$tabla.id_cuenta_doc},{$tabla.id_cuenta_bancaria},{$tabla.id_funcionario},{$tabla.importe},{$tabla.nombre_pago},{$tabla.tipo_pago},{$tabla.nro_cuenta}','si','si','si','','','','','{$tabla.nro_tramite}','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','RENDICIONFONDO','RENDICIONFONDO.1','debe','si','si','','{$tabla.descripcion}','CUECOMP','','{$tabla.precio_total_final}','{$tabla.id_concepto_ingas}','{$tabla.id_plantilla}','si','{$tabla.id_centro_costo}','','','si','','id_cuenta_doc_rendicion','','Concepto de Gasto','{$tabla.precio_total_final}',NULL,'simple','','{$tabla.id_doc_concepto}','no','','','','','','{$tabla.porc_monto_excento_var}','','2','{$tabla.id_orden_trabajo}','cd.vrd_doc_compra_venta_det',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','RENDICIONFONDO','RENDICIONFONDO.3','debe','no','si','','','CUEBANCING','','{$tabla.importe_deposito}','{$tabla.id_cuenta_bancaria}','','no','','','','si','','id_cuenta_doc','','depósitos de devocuciòn','{$tabla.importe_deposito}',NULL,'simple','','{$tabla.id_libro_bancos}','no','','','','','','','','2','','cd.vlibro_bancos_deposito',NULL,'');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','RENDICIONFONDO','RENDICIONFONDO.2','haber','no','si','','','CUEXREND','','{$tabla_padre.importe}','{$tabla_padre.id_funcionario}','','no','','','','si','','','','cuenta para caja','{$tabla_padre.importe}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'');

  ----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select conta.f_import_tplantilla_comprobante ('insert','SOLFONDAV','cd.f_gestionar_cbte_cuenta_doc_eliminacion','id_cuenta_doc','CD','{$tabla.motivo}','cd.f_gestionar_cbte_cuenta_doc','{$tabla.fecha_cbte}','activo','{$tabla.funcionario_solicitante}','{$tabla.id_depto_conta}','contable','','cd.vcuenta_doc','PAGOCON','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_moneda},{$tabla.id_gestion},{$tabla.id_depto_conta},{$tabla.id_cuenta_doc},{$tabla.id_cuenta_bancaria},{$tabla.id_funcionario},{$tabla.importe},{$tabla.nombre_pago},{$tabla.tipo_pago},{$tabla.nro_cuenta},{$tabla.id_cuenta_bancaria_mov}','no','no','no','','','','','{$tabla.nro_tramite}','','{$tabla.id_depto_lb}','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','SOLFONDAV','SOLFONDAV.2','haber','no','si','','','CUEBANCEGRE','','{$tabla_padre.importe}','{$tabla_padre.id_cuenta_bancaria}','','no','','','','si','','','','origen de fondos,','{$tabla_padre.importe}',NULL,'simple','','','no','','','{$tabla_padre.id_cuenta_bancaria_mov}','','{$tabla_padre.nro_cuenta}','','{$tabla_padre.nombre_pago}','2','','',NULL,'{$tabla_padre.tipo_pago}');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','SOLFONDAV','SOLFONDAV.1','debe','si','si','','Entrega de dinero por rendir','EDINXRENDIR','','{$tabla_padre.importe}','{$tabla_padre.id_funcionario}','','no','','','','si','','','','Entrega de dinero por rendir','{$tabla_padre.importe}',NULL,'simple','','','no','','','','','','','','2','','',NULL,'');
  


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select wf.f_import_tproceso_macro ('insert','FA', 'CD', 'Fondo en Avance','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','SFA',NULL,NULL,'FA','Solicitud de Fondo en Avance','cd.tcuenta_doc','id_cuenta_doc','si','','','Solicitud de Fondos en Avance','SFA',NULL);
select wf.f_import_ttipo_proceso ('insert','RFA','contabilizado','SFA','FA','Rendición de Fondo en Avance','cd.tcuenta_doc','id_cuenta_doc','','','opcional','Para el control de estados de la Rendición de fondos en avance','RFA',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','SFA','Borrador','si','no','no','ninguno','','ninguno','','','no','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','cd.f_fun_regreso_cuenta_doc_wf','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbgerencia','SFA','VoBo Gerencia','no','no','no','funcion_listado','cd.f_lista_funcionario_gerente_cd_wf_sel','anterior','','','si','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','si','cd.f_fun_inicio_cuenta_doc_wf','cd.f_fun_regreso_cuenta_doc_wf','../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVb.php','CuentaDocVb','notificacion','Visto Bueno','cd.id_proceso_wf','borrador');
select wf.f_import_ttipo_estado ('delete','vbtesoreria','SFA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','SFA','Pendiente de Contabilización','no','si','no','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','contabilizado','SFA','Contabilizado','no','si','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','SFA','Finalizado','no','no','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','RFA','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbrendicion','RFA','VoBo Rendición','no','no','no','ninguno','','depto_func_list','cd.f_lista_depto_conta_wf_sel','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','RFA','pendiente','no','si','no','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','rendido','RFA','Rendido','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','anulado','RFA','Anulado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbtesoreria','SFA','VoBo Tesoreria','no','no','no','ninguno','','anterior','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','cd.f_fun_inicio_cuenta_doc_wf','','','','','','','borrador');
select wf.f_import_ttipo_estado ('insert','vbgaf','SFA','VoBo GAF','no','no','no','listado','','anterior','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','si','cd.f_fun_inicio_cuenta_doc_wf','cd.f_fun_regreso_cuenta_doc_wf','','','','','',NULL);
select wf.f_import_ttipo_documento ('insert','SOLFA','SFA','Solicitud de Fondos','Solicitud de fondos en avance','sis_cuenta_documentada/control/CuentaDoc/reporteSolicitudFondos/','generado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','REDFA','RFA','Rendición de Fondos','Rendición de fondos en Avance','sis_cuenta_documentada/control/CuentaDoc/reporteRendicionFondos/','generado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','MEMOFA','SFA','Memorándum de Asignación de Fondos','Memorándum de Asignación de Fondos','sis_cuenta_documentada/control/CuentaDoc/reporteMemoDesignacion/','generado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','C31','RFA','Comprobante SIGEP','Comprobante SIGEP','','escaneado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','OTR','RFA','Otros Documentos','Otros Documentos','','escaneado',1.00,'{}');
select wf.f_import_testructura_estado ('insert','borrador','vbgerencia','SFA',1,'');
select wf.f_import_testructura_estado ('delete','vbgerencia','vbtesoreria','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('delete','vbtesoreria','pendiente','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('insert','pendiente','contabilizado','SFA',1,'');
select wf.f_import_testructura_estado ('insert','contabilizado','finalizado','SFA',1,'');
select wf.f_import_testructura_estado ('insert','borrador','vbrendicion','RFA',1,'');
select wf.f_import_testructura_estado ('insert','vbrendicion','pendiente','RFA',1,'');
select wf.f_import_testructura_estado ('insert','pendiente','rendido','RFA',1,'');
select wf.f_import_testructura_estado ('delete','vbgerencia','vbtesoreria','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbtesoreria','pendiente','SFA',1,'');
select wf.f_import_testructura_estado ('delete','vbgerencia','vbgaf','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbgaf','vbtesoreria','SFA',1,'');
select wf.f_import_testructura_estado ('insert','borrador','vbgaf','SFA',1,'');
select wf.f_import_testructura_estado ('insert','vbgerencia','vbtesoreria','SFA',1,'');
select wf.f_import_tfuncionario_tipo_estado ('insert','vbgaf','SFA','3027798',NULL,'');
----------------------------------
--COPY LINES TO SUBSYSTEM dependencies.sql FILE  
---------------------------------

select wf.f_import_ttipo_documento_estado ('insert','SOLFA','SFA','borrador','SFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','SOLFA','SFA','borrador','SFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','borrador','RFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','borrador','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','MEMOFA','SFA','contabilizado','SFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','MEMOFA','SFA','contabilizado','SFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','OTR','RFA','borrador','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('delete','C31','RFA','borrador','RFA',NULL,NULL,NULL);
select wf.f_import_ttipo_documento_estado ('insert','OTR','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','C31','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','C31','RFA','borrador','RFA','insertar','superior','');
 


----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select wf.f_import_tproceso_macro ('insert','FA', 'CD', 'Fondo en Avance','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','SFA',NULL,NULL,'FA','Solicitud de Fondo en Avance','cd.tcuenta_doc','id_cuenta_doc','si','','','Solicitud de Fondos en Avance','SFA',NULL);
select wf.f_import_ttipo_proceso ('insert','RFA','contabilizado','SFA','FA','Rendición de Fondo en Avance','cd.tcuenta_doc','id_cuenta_doc','','','opcional','Para el control de estados de la Rendición de fondos en avance','RFA',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','SFA','Borrador','si','no','no','ninguno','','ninguno','','','no','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','cd.f_fun_regreso_cuenta_doc_wf','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbgerencia','SFA','VoBo Gerencia','no','no','no','funcion_listado','cd.f_lista_funcionario_gerente_cd_wf_sel','anterior','','','si','si',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','si','cd.f_fun_inicio_cuenta_doc_wf','cd.f_fun_regreso_cuenta_doc_wf','../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVb.php','CuentaDocVb','notificacion','Visto Bueno','cd.id_proceso_wf','borrador');
select wf.f_import_ttipo_estado ('delete','vbtesoreria','SFA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','SFA','Pendiente de Contabilización','no','si','no','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','contabilizado','SFA','Contabilizado','no','si','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','SFA','Finalizado','no','no','no','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','RFA','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbrendicion','RFA','VoBo Rendición','no','no','no','ninguno','','depto_func_list','cd.f_lista_depto_conta_wf_sel','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','pendiente','RFA','pendiente','no','si','no','ninguno','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','rendido','RFA','Rendido','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','anulado','RFA','Anulado','no','no','si','anterior','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vbtesoreria','SFA','VoBo Tesoreria','no','no','no','ninguno','','anterior','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','cd.f_fun_inicio_cuenta_doc_wf','','','','','','','borrador');
select wf.f_import_ttipo_estado ('insert','vbgaf','SFA','VoBo GAF','no','no','no','listado','','anterior','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','si','cd.f_fun_inicio_cuenta_doc_wf','cd.f_fun_regreso_cuenta_doc_wf','','','','','',NULL);
select wf.f_import_ttipo_documento ('insert','SOLFA','SFA','Solicitud de Fondos','Solicitud de fondos en avance','sis_cuenta_documentada/control/CuentaDoc/reporteSolicitudFondos/','generado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','REDFA','RFA','Rendición de Fondos','Rendición de fondos en Avance','sis_cuenta_documentada/control/CuentaDoc/reporteRendicionFondos/','generado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','MEMOFA','SFA','Memorándum de Asignación de Fondos','Memorándum de Asignación de Fondos','sis_cuenta_documentada/control/CuentaDoc/reporteMemoDesignacion/','generado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','C31','RFA','Comprobante SIGEP','Comprobante SIGEP','','escaneado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','OTR','RFA','Otros Documentos','Otros Documentos','','escaneado',1.00,'{}');
select wf.f_import_testructura_estado ('insert','borrador','vbgerencia','SFA',1,'');
select wf.f_import_testructura_estado ('delete','vbgerencia','vbtesoreria','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('delete','vbtesoreria','pendiente','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('insert','pendiente','contabilizado','SFA',1,'');
select wf.f_import_testructura_estado ('insert','contabilizado','finalizado','SFA',1,'');
select wf.f_import_testructura_estado ('insert','borrador','vbrendicion','RFA',1,'');
select wf.f_import_testructura_estado ('insert','vbrendicion','pendiente','RFA',1,'');
select wf.f_import_testructura_estado ('insert','pendiente','rendido','RFA',1,'');
select wf.f_import_testructura_estado ('delete','vbgerencia','vbtesoreria','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbtesoreria','pendiente','SFA',1,'');
select wf.f_import_testructura_estado ('delete','vbgerencia','vbgaf','SFA',NULL,NULL);
select wf.f_import_testructura_estado ('insert','vbgaf','vbtesoreria','SFA',1,'');
select wf.f_import_testructura_estado ('insert','borrador','vbgaf','SFA',1,'');
select wf.f_import_testructura_estado ('insert','vbgerencia','vbtesoreria','SFA',1,'');
select wf.f_import_tfuncionario_tipo_estado ('insert','vbgaf','SFA','3027798',NULL,'');
--------------------------------------
--COPY LINES TO SUBSYSTEM dependencies.sql FILE  
------------------------------------

select wf.f_import_ttipo_documento_estado ('insert','SOLFA','SFA','borrador','SFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','SOLFA','SFA','borrador','SFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','borrador','RFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','borrador','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REDFA','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','MEMOFA','SFA','contabilizado','SFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','MEMOFA','SFA','contabilizado','SFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','OTR','RFA','borrador','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('delete','C31','RFA','borrador','RFA',NULL,NULL,NULL);
select wf.f_import_ttipo_documento_estado ('insert','OTR','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','C31','RFA','rendido','RFA','insertar','superior','');
select wf.f_import_ttipo_documento_estado ('insert','C31','RFA','borrador','RFA','insertar','superior','');



/* Data for the 'cd.ttipo_cuenta_doc' table  (Records 1 - 2) */

INSERT INTO cd.ttipo_cuenta_doc ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre", "descripcion", "codigo_wf", "codigo_plantilla_cbte", "sw_solicitud", "id_tipo_cuenta_doc")
VALUES 
  (1, 1, E'2016-05-04 16:23:47.525', E'2016-05-18 16:29:16.449', E'activo', NULL, E'NULL', E'SOLFONAVA', E'Solicitud', E'Solicitud de Fondo en avance', E'SFA', E'SOLFONDAV', E'si', 1),
  (1, 1, E'2016-05-18 12:38:43.915', E'2016-05-20 09:11:11.344', E'activo', NULL, E'NULL', E'RFA', E'Rendición', E'Rendición de fondo en avance', E'RFA', E'RENDICIONFONDO', E'no', 4);
  



--------------------------------
--COPY LINES TO data.sql FILE  
---------------------------------

select pxp.f_insert_tgui ('FONDOS EN AVANCE', '', 'CD', 'si', 1, '', 1, '', '', 'CD');
select pxp.f_insert_tgui ('Configuraciones', 'Configuraciones', 'CBCONF', 'si', 1, '', 2, '', '', 'CD');
select pxp.f_insert_tgui ('Tipo de cuenta documentada', 'Tipo de cuenta documentada', 'TCUD', 'si', 1, 'sis_cuenta_documentada/vista/tipo_cuenta_doc/TipoCuentaDoc.php', 3, '', 'TipoCuentaDoc', 'CD');
select pxp.f_insert_tgui ('Tipo de categoría', 'tipo de categoría', 'TIPCAT', 'si', 2, 'sis_cuenta_documentada/vista/tipo_categoria/TipoCategoria.php', 3, '', 'TipoCategoria', 'CD');
select pxp.f_insert_tgui ('Solicitud de Fondos', 'Solicitud de fondos', 'SOLFND', 'si', 3, 'sis_cuenta_documentada/vista/cuenta_doc/CuentaDocReg.php', 3, '', 'CuentaDocReg', 'CD');
select pxp.f_insert_tgui ('VoBo Fondos en Avance', 'VoBo Fondoe en Avance', 'VBCUDOC', 'si', 4, 'sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVb.php', 3, '', 'CuentaDocVb', 'CD');
select pxp.f_insert_tgui ('Lista de Bloqueos', 'Lista de Bloqueos', 'LISBLO', 'si', 3, 'sis_cuenta_documentada/vista/bloqueo_cd/BloqueoCd.php', 3, '', 'BloqueoCd', 'CD');
select pxp.f_insert_tgui ('Categorías', 'Categorías', 'TIPCAT.1', 'no', 0, 'sis_cuenta_documentada/vista/categoria/Categoria.php', 4, '', '60%', 'CD');
select pxp.f_insert_tgui ('Rendicion', 'Rendicion', 'SOLFND.1', 'no', 0, 'sis_cuenta_documentada/vista/cuenta_doc/CuentaDocRen.php', 4, '', '95%', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLFND.2', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLFND.3', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLFND.4', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'CD');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLFND.5', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'CD');
select pxp.f_insert_tgui ('Facturas', 'Facturas', 'SOLFND.1.1', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/RendicionDetReg.php', 5, '', '50%', 'CD');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'SOLFND.1.2', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php', 5, '', '50%', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLFND.1.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 5, '', 'AntFormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'SOLFND.1.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 5, '', 'FormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLFND.1.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'CD');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'SOLFND.1.6', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 5, '', '80%', 'CD');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'SOLFND.1.1.1', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/FormRendicionCD.php', 6, '', '95%', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'SOLFND.1.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'CD');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'SOLFND.1.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 7, '', 'SubirArchivoWf', 'CD');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'SOLFND.1.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'CD');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'SOLFND.1.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 7, '', '30%', 'CD');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'SOLFND.1.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 7, '', '40%', 'CD');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'SOLFND.1.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 7, '', '90%', 'CD');
select pxp.f_insert_tgui ('73%', '73%', 'SOLFND.1.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 8, '', 'RepPlanPago', 'CD');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'SOLFND.1.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 9, '', '90%', 'CD');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'SOLFND.1.6.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 6, '', 'funcionario', 'CD');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'SOLFND.1.6.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 7, '', 'FuncionarioCuentaBancaria', 'CD');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'SOLFND.1.6.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 7, '', 'FuncionarioEspecialidad', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLFND.1.6.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'SOLFND.1.6.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 8, '', 'Institucion', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'SOLFND.1.6.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 9, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'SOLFND.1.6.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 10, '', 'subirFotoPersona', 'CD');
select pxp.f_insert_tgui ('Facturas', 'Facturas', 'VBCUDOC.1', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/RendicionDetTes.php', 4, '', '50%', 'CD');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'VBCUDOC.2', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php', 4, '', '50%', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCUDOC.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBCUDOC.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBCUDOC.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'CD');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBCUDOC.6', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'CD');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'VBCUDOC.1.1', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/FormRendicionCD.php', 5, '', '95%', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBCUDOC.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'CD');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBCUDOC.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'CD');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBCUDOC.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'CD');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBCUDOC.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'CD');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBCUDOC.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'CD');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBCUDOC.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'CD');
select pxp.f_insert_tgui ('73%', '73%', 'VBCUDOC.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'CD');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBCUDOC.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'CD');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBCUDOC.6.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'CD');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBCUDOC.6.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'CD');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBCUDOC.6.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCUDOC.6.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBCUDOC.6.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBCUDOC.6.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBCUDOC.6.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'CD');
select pxp.f_insert_tgui ('Consulta Fondos en Avance', 'Consulta de fondos en Avance', 'CONFA', 'si', 5, 'sis_cuenta_documentada/vista/cuenta_doc/CuentaDocConsulta.php', 3, '', 'CuentaDocConsulta', 'CD');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLFND.6', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'CD');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'SOLFND.1.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 5, '', 'ChkPresupuesto', 'CD');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBCUDOC.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONFA.1', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 4, '', 'AntFormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONFA.2', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 4, '', 'FormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CONFA.3', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'CD');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'CONFA.4', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 4, '', '80%', 'CD');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'CONFA.5', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 4, '', 'ChkPresupuesto', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'CONFA.2.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'CD');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'CONFA.2.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 6, '', 'SubirArchivoWf', 'CD');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'CONFA.2.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 6, '', '90%', 'CD');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'CONFA.2.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 6, '', '30%', 'CD');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'CONFA.2.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 6, '', '40%', 'CD');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'CONFA.2.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 6, '', '90%', 'CD');
select pxp.f_insert_tgui ('73%', '73%', 'CONFA.2.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 7, '', 'RepPlanPago', 'CD');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'CONFA.2.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 8, '', '90%', 'CD');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'CONFA.4.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 5, '', 'funcionario', 'CD');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'CONFA.4.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 6, '', 'FuncionarioCuentaBancaria', 'CD');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'CONFA.4.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 6, '', 'FuncionarioEspecialidad', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONFA.4.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 6, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'CONFA.4.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 7, '', 'Institucion', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'CONFA.4.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 8, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'CONFA.4.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 9, '', 'subirFotoPersona', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'CONFA.6', 'no', 0, 'sis_seguridad/vista/usuario/FormUsuario.php', 4, '', 'FormUsuario', 'CD');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'SOLFND.1.2.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 6, '', 'FormRelacionarDeposito', 'CD');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'VBCUDOC.2.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 5, '', 'FormRelacionarDeposito', 'CD');
select pxp.f_insert_tgui ('VoBo Fondos en Avance Conta Central', 'VoBo Fondos en Avance Conta Central', 'VBFACC', 'si', 4, 'sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVbContaCentral.php', 2, '', 'CuentaDocVbContaCentral', 'CD');
select pxp.f_insert_tgui ('Facturas', 'Facturas', 'VBFACC.1', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/RendicionDetTes.php', 3, '', '50%', 'CD');
select pxp.f_insert_tgui ('Depositos', 'Depositos', 'VBFACC.2', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php', 3, '', '50%', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBFACC.3', 'no', 0, 'sis_workflow/vista/estado_wf/AntFormEstadoWf.php', 3, '', 'AntFormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Estado de Wf', 'Estado de Wf', 'VBFACC.4', 'no', 0, 'sis_workflow/vista/estado_wf/FormEstadoWf.php', 3, '', 'FormEstadoWf', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBFACC.5', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 3, '', '90%', 'CD');
select pxp.f_insert_tgui ('Observaciones del WF', 'Observaciones del WF', 'VBFACC.6', 'no', 0, 'sis_workflow/vista/obs/Obs.php', 3, '', '80%', 'CD');
select pxp.f_insert_tgui ('Estado del Presupuesto', 'Estado del Presupuesto', 'VBFACC.7', 'no', 0, 'sis_presupuestos/vista/presup_partida/ChkPresupuesto.php', 3, '', 'ChkPresupuesto', 'CD');
select pxp.f_insert_tgui ('Formulario de rendicion', 'Formulario de rendicion', 'VBFACC.1.1', 'no', 0, 'sis_cuenta_documentada/vista/rendicion_det/FormRendicionCD.php', 4, '', '95%', 'CD');
select pxp.f_insert_tgui ('Relacionar Deposito', 'Relacionar Deposito', 'VBFACC.2.1', 'no', 0, 'sis_tesoreria/vista/deposito/FormRelacionarDeposito.php', 4, '', 'FormRelacionarDeposito', 'CD');
select pxp.f_insert_tgui ('Documentos del Proceso', 'Documentos del Proceso', 'VBFACC.4.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 4, '', '90%', 'CD');
select pxp.f_insert_tgui ('Subir ', 'Subir ', 'VBFACC.4.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/SubirArchivoWf.php', 5, '', 'SubirArchivoWf', 'CD');
select pxp.f_insert_tgui ('Documentos de Origen', 'Documentos de Origen', 'VBFACC.4.1.2', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 5, '', '90%', 'CD');
select pxp.f_insert_tgui ('Histórico', 'Histórico', 'VBFACC.4.1.3', 'no', 0, 'sis_workflow/vista/documento_historico_wf/DocumentoHistoricoWf.php', 5, '', '30%', 'CD');
select pxp.f_insert_tgui ('Estados por momento', 'Estados por momento', 'VBFACC.4.1.4', 'no', 0, 'sis_workflow/vista/tipo_documento_estado/TipoDocumentoEstadoWF.php', 5, '', '40%', 'CD');
select pxp.f_insert_tgui ('Pagos similares', 'Pagos similares', 'VBFACC.4.1.5', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepFilPlanPago.php', 5, '', '90%', 'CD');
select pxp.f_insert_tgui ('73%', '73%', 'VBFACC.4.1.5.1', 'no', 0, 'sis_tesoreria/vista/plan_pago/RepPlanPago.php', 6, '', 'RepPlanPago', 'CD');
select pxp.f_insert_tgui ('Chequear documento del WF', 'Chequear documento del WF', 'VBFACC.4.1.5.1.1', 'no', 0, 'sis_workflow/vista/documento_wf/DocumentoWf.php', 7, '', '90%', 'CD');
select pxp.f_insert_tgui ('Funcionarios', 'Funcionarios', 'VBFACC.6.1', 'no', 0, 'sis_organigrama/vista/funcionario/Funcionario.php', 4, '', 'funcionario', 'CD');
select pxp.f_insert_tgui ('Cuenta Bancaria del Empleado', 'Cuenta Bancaria del Empleado', 'VBFACC.6.1.1', 'no', 0, 'sis_organigrama/vista/funcionario_cuenta_bancaria/FuncionarioCuentaBancaria.php', 5, '', 'FuncionarioCuentaBancaria', 'CD');
select pxp.f_insert_tgui ('Especialidad del Empleado', 'Especialidad del Empleado', 'VBFACC.6.1.2', 'no', 0, 'sis_organigrama/vista/funcionario_especialidad/FuncionarioEspecialidad.php', 5, '', 'FuncionarioEspecialidad', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBFACC.6.1.3', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 5, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Instituciones', 'Instituciones', 'VBFACC.6.1.1.1', 'no', 0, 'sis_parametros/vista/institucion/Institucion.php', 6, '', 'Institucion', 'CD');
select pxp.f_insert_tgui ('Personas', 'Personas', 'VBFACC.6.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 7, '', 'persona', 'CD');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'VBFACC.6.1.1.1.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 8, '', 'subirFotoPersona', 'CD');
select pxp.f_insert_tfuncion ('cd.f_fun_inicio_cuenta_doc_wf', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_fun_regreso_cuenta_doc_wf', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_gestionar_cbte_cd_prevalidacion', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_gestionar_cbte_cuenta_doc', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_gestionar_cbte_cuenta_doc_eliminacion', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_gestionar_presupuesto_cd', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_lista_depto_conta_wf_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_lista_funcionario_gerente_cd_wf_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.f_validar_documentos', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_bloqueo_cd_ime', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_bloqueo_cd_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_categoria_ime', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_categoria_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_cuenta_doc_ime', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_cuenta_doc_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_rendicion_det_ime', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_rendicion_det_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_tipo_categoria_ime', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_tipo_categoria_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_tipo_cuenta_doc_ime', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.ft_tipo_cuenta_doc_sel', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tfuncion ('cd.trig_tcuenta_doc', 'Funcion para tabla     ', 'CD');
select pxp.f_insert_tprocedimiento ('CD_BLOCD_ELI', 'Modificacion de registros', 'si', '', '', 'cd.ft_bloqueo_cd_ime');
select pxp.f_insert_tprocedimiento ('CD_BLOCD_SEL', 'Consulta de datos', 'si', '', '', 'cd.ft_bloqueo_cd_sel');
select pxp.f_insert_tprocedimiento ('CD_BLOCD_CONT', 'Conteo de registros', 'si', '', '', 'cd.ft_bloqueo_cd_sel');
select pxp.f_insert_tprocedimiento ('CD_CAT_INS', 'Insercion de registros', 'si', '', '', 'cd.ft_categoria_ime');
select pxp.f_insert_tprocedimiento ('CD_CAT_MOD', 'Modificacion de registros', 'si', '', '', 'cd.ft_categoria_ime');
select pxp.f_insert_tprocedimiento ('CD_CAT_ELI', 'Eliminacion de registros', 'si', '', '', 'cd.ft_categoria_ime');
select pxp.f_insert_tprocedimiento ('CD_CAT_SEL', 'Consulta de datos', 'si', '', '', 'cd.ft_categoria_sel');
select pxp.f_insert_tprocedimiento ('CD_CAT_CONT', 'Conteo de registros', 'si', '', '', 'cd.ft_categoria_sel');
select pxp.f_insert_tprocedimiento ('CD_CDOC_INS', 'Insercion de registros de fondos en avance', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CDOC_MOD', 'Modificacion de registros', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CDOC_ELI', 'Eliminacion de registros', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_SIGESCD_IME', 'cambia al siguiente estado', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_ANTECD_IME', 'retrocede el estado de la cuenta documentada', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CDOCREN_INS', 'Insercion de registros de  rendicon para  fondos en avance', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CDOCREN_MOD', 'Modificacion de rendiciones de FA', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CDOCREN_ELI', 'Eliminacion de de cuento documentada de rendicion', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_AMPCDREN_IME', 'Ampliar dias para rendir cuenta documentada', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CAMBLOQ_IME', 'cambia el estado de bloqueo de facturas grandes', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CAMBUSUREG_IME', 'Cambia el usuario responsable red registro', 'si', '', '', 'cd.ft_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_CDOC_SEL', 'Consulta de datos', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_CDOC_CONT', 'Conteo de registros', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_CDOCREN_SEL', 'Consulta de datos  rendicion', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_CDOCREN_CONT', 'Conteo de registros de rendicion', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REPCDOC_SEL', 'Cabecera de reporte de solicitud de fondos', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REPRENDET_SEL', 'recupera las facturas de la rendicion', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REPDEPREN_SEL', 'listado de depositos para el reporte de rendicion', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REPDEPRENCO_SEL', 'listado de depositos para el reporte de rendicion consolidado', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REPCONFA_SEL', 'listado para reporte consolidado de fondo en avance', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REND_INS', 'Insercion de registros', 'si', '', '', 'cd.ft_rendicion_det_ime');
select pxp.f_insert_tprocedimiento ('CD_VALEDI_MOD', 'Valida la edicion de facturas', 'si', '', '', 'cd.ft_rendicion_det_ime');
select pxp.f_insert_tprocedimiento ('CD_RENDET_ELI', 'Eliminacion de registros', 'si', '', '', 'cd.ft_rendicion_det_ime');
select pxp.f_insert_tprocedimiento ('CD_VALINDDEPREN_VAL', 'validar registro de depositos en la rendicion', 'si', '', '', 'cd.ft_rendicion_det_ime');
select pxp.f_insert_tprocedimiento ('CD_VALDELDDEPREN_VAL', 'validar la eliminacion de depositos en rendicion', 'si', '', '', 'cd.ft_rendicion_det_ime');
select pxp.f_insert_tprocedimiento ('CD_RENDET_SEL', 'Consulta de datos', 'si', '', '', 'cd.ft_rendicion_det_sel');
select pxp.f_insert_tprocedimiento ('CD_RENDET_CONT', 'Conteo de registros', 'si', '', '', 'cd.ft_rendicion_det_sel');
select pxp.f_insert_tprocedimiento ('CD_TCA_INS', 'Insercion de registros', 'si', '', '', 'cd.ft_tipo_categoria_ime');
select pxp.f_insert_tprocedimiento ('CD_TCA_MOD', 'Modificacion de registros', 'si', '', '', 'cd.ft_tipo_categoria_ime');
select pxp.f_insert_tprocedimiento ('CD_TCA_ELI', 'Eliminacion de registros', 'si', '', '', 'cd.ft_tipo_categoria_ime');
select pxp.f_insert_tprocedimiento ('CD_TCA_SEL', 'Consulta de datos', 'si', '', '', 'cd.ft_tipo_categoria_sel');
select pxp.f_insert_tprocedimiento ('CD_TCA_CONT', 'Conteo de registros', 'si', '', '', 'cd.ft_tipo_categoria_sel');
select pxp.f_insert_tprocedimiento ('CD_TCD_INS', 'Insercion de registros', 'si', '', '', 'cd.ft_tipo_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_TCD_MOD', 'Modificacion de registros', 'si', '', '', 'cd.ft_tipo_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_TCD_ELI', 'Eliminacion de registros', 'si', '', '', 'cd.ft_tipo_cuenta_doc_ime');
select pxp.f_insert_tprocedimiento ('CD_TCD_SEL', 'Consulta de datos', 'si', '', '', 'cd.ft_tipo_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_TCD_CONT', 'Conteo de registros', 'si', '', '', 'cd.ft_tipo_cuenta_doc_sel');
select pxp.f_insert_tprocedimiento ('CD_REPRENRET_SEL', 'recupera el importe total de las rendiciones', 'si', '', '', 'cd.ft_cuenta_doc_sel');
select pxp.f_insert_trol ('CD - Solicitud de Fondos en Avance', 'CD - Solicitud de Fondos en Avance', 'CD');
select pxp.f_insert_trol ('CD - VoBo Tesoreria', 'CD - VoBo Tesoreria', 'CD');
select pxp.f_insert_trol ('CD - VoBo Cuenta Documentada', 'CD - VoBo Cuenta Documentada', 'CD');
select pxp.f_insert_trol ('CD - Consulta Fondos en Avance', 'CD - Consulta Fondos en Avance', 'CD');
select pxp.f_insert_trol ('CD - VoBo Cuenta Documentada Central', 'CD - VoBo Cuenta Documentada Central', 'CD');
----------------------------------
--COPY LINES TO dependencies.sql FILE  
---------------------------------

select pxp.f_insert_testructura_gui ('CD', 'SISTEMA');
select pxp.f_insert_testructura_gui ('CBCONF', 'CD');
select pxp.f_insert_testructura_gui ('TCUD', 'CBCONF');
select pxp.f_insert_testructura_gui ('TIPCAT', 'CBCONF');
select pxp.f_insert_testructura_gui ('LISBLO', 'CBCONF');
select pxp.f_insert_testructura_gui ('TIPCAT.1', 'TIPCAT');
select pxp.f_insert_testructura_gui ('SOLFND.1', 'SOLFND');
select pxp.f_insert_testructura_gui ('SOLFND.2', 'SOLFND');
select pxp.f_insert_testructura_gui ('SOLFND.3', 'SOLFND');
select pxp.f_insert_testructura_gui ('SOLFND.4', 'SOLFND');
select pxp.f_insert_testructura_gui ('SOLFND.5', 'SOLFND');
select pxp.f_insert_testructura_gui ('SOLFND.1.1', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.2', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.3', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.5', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.1.1', 'SOLFND.1.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1', 'SOLFND.1.4');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.1', 'SOLFND.1.4.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.2', 'SOLFND.1.4.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.3', 'SOLFND.1.4.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.4', 'SOLFND.1.4.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.5', 'SOLFND.1.4.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.5.1', 'SOLFND.1.4.1.5');
select pxp.f_insert_testructura_gui ('SOLFND.1.4.1.5.1.1', 'SOLFND.1.4.1.5.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1', 'SOLFND.1.6');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1.1', 'SOLFND.1.6.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1.2', 'SOLFND.1.6.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1.3', 'SOLFND.1.6.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1.1.1', 'SOLFND.1.6.1.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1.1.1.1', 'SOLFND.1.6.1.1.1');
select pxp.f_insert_testructura_gui ('SOLFND.1.6.1.1.1.1.1', 'SOLFND.1.6.1.1.1.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.1', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('VBCUDOC.2', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('VBCUDOC.3', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('VBCUDOC.4', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('VBCUDOC.5', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('VBCUDOC.6', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('VBCUDOC.1.1', 'VBCUDOC.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1', 'VBCUDOC.4');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.1', 'VBCUDOC.4.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.2', 'VBCUDOC.4.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.3', 'VBCUDOC.4.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.4', 'VBCUDOC.4.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.5', 'VBCUDOC.4.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.5.1', 'VBCUDOC.4.1.5');
select pxp.f_insert_testructura_gui ('VBCUDOC.4.1.5.1.1', 'VBCUDOC.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1', 'VBCUDOC.6');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1.1', 'VBCUDOC.6.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1.2', 'VBCUDOC.6.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1.3', 'VBCUDOC.6.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1.1.1', 'VBCUDOC.6.1.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1.1.1.1', 'VBCUDOC.6.1.1.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.6.1.1.1.1.1', 'VBCUDOC.6.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLFND.6', 'SOLFND');
select pxp.f_insert_testructura_gui ('SOLFND.1.7', 'SOLFND.1');
select pxp.f_insert_testructura_gui ('VBCUDOC.7', 'VBCUDOC');
select pxp.f_insert_testructura_gui ('CONFA.1', 'CONFA');
select pxp.f_insert_testructura_gui ('CONFA.2', 'CONFA');
select pxp.f_insert_testructura_gui ('CONFA.3', 'CONFA');
select pxp.f_insert_testructura_gui ('CONFA.4', 'CONFA');
select pxp.f_insert_testructura_gui ('CONFA.5', 'CONFA');
select pxp.f_insert_testructura_gui ('CONFA.2.1', 'CONFA.2');
select pxp.f_insert_testructura_gui ('CONFA.2.1.1', 'CONFA.2.1');
select pxp.f_insert_testructura_gui ('CONFA.2.1.2', 'CONFA.2.1');
select pxp.f_insert_testructura_gui ('CONFA.2.1.3', 'CONFA.2.1');
select pxp.f_insert_testructura_gui ('CONFA.2.1.4', 'CONFA.2.1');
select pxp.f_insert_testructura_gui ('CONFA.2.1.5', 'CONFA.2.1');
select pxp.f_insert_testructura_gui ('CONFA.2.1.5.1', 'CONFA.2.1.5');
select pxp.f_insert_testructura_gui ('CONFA.2.1.5.1.1', 'CONFA.2.1.5.1');
select pxp.f_insert_testructura_gui ('CONFA.4.1', 'CONFA.4');
select pxp.f_insert_testructura_gui ('CONFA.4.1.1', 'CONFA.4.1');
select pxp.f_insert_testructura_gui ('CONFA.4.1.2', 'CONFA.4.1');
select pxp.f_insert_testructura_gui ('CONFA.4.1.3', 'CONFA.4.1');
select pxp.f_insert_testructura_gui ('CONFA.4.1.1.1', 'CONFA.4.1.1');
select pxp.f_insert_testructura_gui ('CONFA.4.1.1.1.1', 'CONFA.4.1.1.1');
select pxp.f_insert_testructura_gui ('CONFA.4.1.1.1.1.1', 'CONFA.4.1.1.1.1');
select pxp.f_insert_testructura_gui ('SOLFND', 'CD');
select pxp.f_insert_testructura_gui ('VBCUDOC', 'CD');
select pxp.f_insert_testructura_gui ('CONFA', 'CD');
select pxp.f_insert_testructura_gui ('CONFA.6', 'CONFA');
select pxp.f_insert_testructura_gui ('SOLFND.1.2.1', 'SOLFND.1.2');
select pxp.f_insert_testructura_gui ('VBCUDOC.2.1', 'VBCUDOC.2');
select pxp.f_insert_testructura_gui ('VBFACC', 'CD');
select pxp.f_insert_testructura_gui ('VBFACC.1', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.2', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.3', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.4', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.5', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.6', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.7', 'VBFACC');
select pxp.f_insert_testructura_gui ('VBFACC.1.1', 'VBFACC.1');
select pxp.f_insert_testructura_gui ('VBFACC.2.1', 'VBFACC.2');
select pxp.f_insert_testructura_gui ('VBFACC.4.1', 'VBFACC.4');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.1', 'VBFACC.4.1');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.2', 'VBFACC.4.1');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.3', 'VBFACC.4.1');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.4', 'VBFACC.4.1');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.5', 'VBFACC.4.1');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.5.1', 'VBFACC.4.1.5');
select pxp.f_insert_testructura_gui ('VBFACC.4.1.5.1.1', 'VBFACC.4.1.5.1');
select pxp.f_insert_testructura_gui ('VBFACC.6.1', 'VBFACC.6');
select pxp.f_insert_testructura_gui ('VBFACC.6.1.1', 'VBFACC.6.1');
select pxp.f_insert_testructura_gui ('VBFACC.6.1.2', 'VBFACC.6.1');
select pxp.f_insert_testructura_gui ('VBFACC.6.1.3', 'VBFACC.6.1');
select pxp.f_insert_testructura_gui ('VBFACC.6.1.1.1', 'VBFACC.6.1.1');
select pxp.f_insert_testructura_gui ('VBFACC.6.1.1.1.1', 'VBFACC.6.1.1.1');
select pxp.f_insert_testructura_gui ('VBFACC.6.1.1.1.1.1', 'VBFACC.6.1.1.1.1');


/***********************************F-DAT-RAC-CD-0-05/05/2016*****************************************/




/***********************************I-DAT-RAC-CD-0-05/08/2017*****************************************/





----------------------------------
--COPY LINES TO SUBSYSTEM data.sql FILE  
---------------------------------

select param.f_import_tcatalogo_tipo ('insert','tcuenta_doc','CD','tcuenta_doc');
select param.f_import_tcatalogo ('insert','CD','Contabilizado','contabilizado','tcuenta_doc');
select param.f_import_tcatalogo ('insert','CD','Finalizado','finalizado','tcuenta_doc');



select pxp.f_insert_tgui ('Consulta de Cuentas Documentas', 'Conslta de Cuentas Documentadas', 'CONCD', 'si', 6, 'sis_cuenta_documentada/vista/reporte_cuenta_doc/FormConsultaCd.php', 2, '', 'FormConsultaCd', 'CD');
select pxp.f_insert_testructura_gui ('CONCD', 'CD');

select pxp.f_insert_tgui ('Reporte Fondo Avance', 'Reporte Fondo Avance', 'REPFA', 'si', 5, 'sis_cuenta_documentada/vista/reporte_cuenta_doc/ReporteCuentaDoc.php', 2, '', 'ReporteCuentaDoc', 'CD');
select pxp.f_insert_testructura_gui ('REPFA', 'CD');






/***********************************F-DAT-RAC-CD-0-05/08/2017*****************************************/



/***********************************I-DAT-RCM-CD-0-04/09/2017*****************************************/
select pxp.f_insert_tgui ('Destinos', 'Destinos para cálculo de viáticos', 'VIAT', 'si', 5, 'sis_cuenta_documentada/vista/destino/Destino.php', 3, '', 'Destino', 'CD');
select pxp.f_insert_tgui ('Escala de Viáticos', 'Escala de viáticos', 'EVIAT', 'si', 4, 'sis_cuenta_documentada/vista/escala_viatico/EscalaViatico.php', 3, '', 'EscalaViatico', 'CD');
select pxp.f_insert_testructura_gui ('VIAT', 'CBCONF');
select pxp.f_insert_testructura_gui ('EVIAT', 'CBCONF');

select pxp.f_insert_tgui ('Tipo de categoría', 'tipo de categoría', 'TIPCAT', 'si', 2, 'sis_cuenta_documentada/vista/tipo_categoria/TipoCategoriaMain.php', 3, '', 'TipoCategoriaMain', 'CD');

select pxp.f_add_catalog('CD','tdestino__tipo','Nacional','nacional','');
select pxp.f_add_catalog('CD','tdestino__tipo','Internacional','internacional','');

/***********************************F-DAT-RCM-CD-0-04/09/2017*****************************************/

/***********************************I-DAT-RCM-CD-0-05/09/2017*****************************************/
select pxp.f_add_catalog('CD','tcuenta_doc__medio_transporte','Aéreo','aereo','');
select pxp.f_add_catalog('CD','tcuenta_doc__medio_transporte','Terrestre','terrestre','');

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion") VALUES (E'cd_codigo_macro_viatico', E'VI', E'Código de proceso marcro para Viáticos');  
/***********************************F-DAT-RCM-CD-0-05/09/2017*****************************************/

/***********************************I-DAT-RCM-CD-0-06/09/2017*****************************************/
select pxp.f_add_catalog('CD','tcuenta_doc__cobertura','(Viático 100%) Hospedaje y Alimentación cubierto por el Solicitante','viatico_100','');
select pxp.f_add_catalog('CD','tcuenta_doc__cobertura','(Viático 70% y 100%) Hospedaje cubierto por la empresa o patrocinador','viatico_70','');
/***********************************F-DAT-RCM-CD-0-06/09/2017*****************************************/

/***********************************I-DAT-RCM-CD-0-15/11/2017*****************************************/
select pxp.f_add_catalog('CD','tescala__tipo','Viático','viatico','');
select pxp.f_add_catalog('CD','tescala__tipo','Fondo en Avance','fondo_avance','');
/***********************************F-DAT-RCM-CD-0-15/11/2017*****************************************/

/***********************************I-DAT-RCM-CD-0-24/11/2017*****************************************/
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'cd_importe_maximo_cajas', E'2000', E'Importe máximo en Cuenta documentada para desembolsar con recibo de caja');
/***********************************F-DAT-RCM-CD-0-24/11/2017*****************************************/

/***********************************I-DAT-RCM-CD-0-14/12/2017*****************************************/
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES (E'cd_solo_una_rendicion_mes', E'no', E'Habilita o no más de una rendición de cuenta documentada al mes');
/***********************************F-DAT-RCM-CD-0-14/12/2017*****************************************/

/***********************************I-DAT-RCM-CD-0-06/01/2018*****************************************/
select pxp.f_insert_tgui ('VoBo Pagos', 'Visto bueno de Pagos', 'PGSVOBO', 'si', 3, 'sis_cuenta_documentada/vista/pago_simple/PagoSimpleVb.php', 3, '', 'PagoSimpleVb', 'CD');
select pxp.f_insert_testructura_gui ('PGSVOBO', 'PAGSIM');
select pxp.f_insert_tgui ('Tipo de Pago', 'Tipo de Pago Simple', 'PGSTIPPA', 'si', 0, 'sis_cuenta_documentada/vista/tipo_pago_simple/TipoPagoSimple.php', 3, '', 'TipoPagoSimple', 'CD');
select pxp.f_insert_testructura_gui ('PGSTIPPA', 'PAGSIM');
/***********************************F-DAT-RCM-CD-0-06/01/2018*****************************************/

/***********************************I-DAT-RCM-CD-0-12/01/2018*****************************************/
select pxp.f_add_catalog('CD','tcuenta_doc__tipo_rendicion','Parcial','parcial','');
select pxp.f_add_catalog('CD','tcuenta_doc__tipo_rendicion','Final','final','');
/***********************************F-DAT-RCM-CD-0-12/01/2018*****************************************/