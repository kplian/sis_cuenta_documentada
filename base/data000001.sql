

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
  
/***********************************F-DAT-RAC-ADQ-0-05/05/2016*****************************************/

