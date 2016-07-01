

/***********************************I-DAT-RAC-ADQ-0-05/05/2016*****************************************/


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



/* Data for the 'cd.ttipo_cuenta_doc' table  (Records 1 - 2) */

INSERT INTO cd.ttipo_cuenta_doc ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "codigo", "nombre", "descripcion", "codigo_wf", "codigo_plantilla_cbte", "sw_solicitud", "id_tipo_cuenta_doc")
VALUES 
  (1, 1, E'2016-05-04 16:23:47.525', E'2016-05-18 16:29:16.449', E'activo', NULL, E'NULL', E'SOLFONAVA', E'Solicitud', E'Solicitud de Fondo en avance', E'SFA', E'SOLFONDAV', E'si', 1),
  (1, 1, E'2016-05-18 12:38:43.915', E'2016-05-20 09:11:11.344', E'activo', NULL, E'NULL', E'RFA', E'Rendición', E'Rendición de fondo en avance', E'RFA', E'RENDICIONFONDO', E'no', 4);
  
/***********************************F-DAT-RAC-ADQ-0-05/05/2016*****************************************/








