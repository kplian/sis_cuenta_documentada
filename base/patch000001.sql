
/***********************************I-SCP-RAC-CD-1-04/05/2016****************************************/


CREATE TABLE cd.ttipo_cuenta_doc (
  id_tipo_cuenta_doc SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(500),
  descripcion VARCHAR,
  codigo_wf VARCHAR(100),
  codigo_plantilla_cbte VARCHAR(100),
  sw_solicitud VARCHAR(4) DEFAULT 'no' NOT NULL,
  codigo_plantilla_cbte_devrep VARCHAR(100),
  PRIMARY KEY(id_tipo_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_wf
IS 'codigo del proceso de wf correspondiente';

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_plantilla_cbte
IS 'codigo de la plantilla de comprobante';

COMMENT ON COLUMN cd.ttipo_cuenta_doc.sw_solicitud
IS 'marca los tipo que son solitud';

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_plantilla_cbte_devrep
IS 'Código de la plantilla de comprobante para devolución o reposición de saldos por cheque o depósito';

-------------------------------------

CREATE TABLE cd.ttipo_categoria (
  id_tipo_categoria SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(400),
  id_escala INTEGER,
  PRIMARY KEY("id_tipo_categoria")
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.ttipo_categoria.id_escala
IS 'ID de la escala de viático';

-----------------------------------
CREATE TABLE cd.tcategoria (
  id_categoria SERIAL NOT NULL,
  id_tipo_categoria INTEGER,
  id_moneda INTEGER,
  codigo VARCHAR(100) NOT NULL,
  nombre VARCHAR(400),
  monto NUMERIC(18,2),
  id_destino INTEGER,
  monto_sp numeric(18,2),
  monto_hotel numeric(18,2),
  PRIMARY KEY(id_categoria)
) INHERITS (pxp.tbase)

WITH (oids = false);



COMMENT ON COLUMN cd.tcategoria.id_destino
IS 'Destino para la Escala de viáticos';

COMMENT ON COLUMN cd.tcategoria.monto
IS 'En el caso de Viáticos, este monto corresponde al monto de viático con pernocte';

COMMENT ON COLUMN cd.tcategoria.monto_sp
IS 'Monto viático Sin Pernocte';

COMMENT ON COLUMN cd.tcategoria.monto_hotel
IS 'Monto permitido para el pago de Hotel';
-----------------------

CREATE TABLE cd.tcuenta_doc (
  id_cuenta_doc SERIAL NOT NULL,
  id_tipo_cuenta_doc INTEGER NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_depto INTEGER NOT NULL,
  id_uo INTEGER NOT NULL,
  id_moneda INTEGER NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_caja INTEGER,
  id_cuenta_doc_fk INTEGER,
  tipo_pago VARCHAR  NOT NULL DEFAULT 'cheque',
  fecha DATE NOT NULL,
  nro_tramite VARCHAR(150) NOT NULL,
  estado VARCHAR(100) NOT NULL,
  sw_modo VARCHAR(40) DEFAULT 'cheque'::character varying NOT NULL,
  nombre_cheque VARCHAR(300),
  motivo VARCHAR NOT NULL,
  id_depto_lb INTEGER,
  id_funcionario_cuenta_bancaria INTEGER,
  importe  NUMERIC(12,2) DEFAULT 0  NULL,
  id_funcionario_gerente INTEGER NOT NULL,
  id_depto_conta INTEGER,
  id_cuenta_bancaria INTEGER,
  id_gestion INTEGER,
  id_int_comprobante INTEGER,
  id_cuenta_bancaria_mov INTEGER,
  nro_correspondencia VARCHAR(300),
  fecha_entrega DATE DEFAULT now() NOT NULL,
  sw_max_doc_rend VARCHAR(10) DEFAULT 'no' NOT NULL,
  num_memo VARCHAR(200),
  num_rendicion VARCHAR(20),
  id_usuario_reg_ori INTEGER,
  presu_comprometido VARCHAR(3) DEFAULT 'no' NOT NULL,
  importe_total_rendido NUMERIC(32,2) DEFAULT 0 NOT NULL,
  id_funcionario_aprobador INTEGER,
  id_periodo INTEGER,
  fecha_salida DATE,
  fecha_llegada DATE,
  tipo_viaje varchar(20),
  medio_transporte varchar(20),
  cobertura VARCHAR(20),
  hora_salida TIME(0) WITHOUT TIME ZONE,
  hora_llegada TIME(0) WITHOUT TIME ZONE,
  id_escala INTEGER,
  id_centro_costo INTEGER,
  id_solicitud_efectivo INTEGER,
  id_plantilla INTEGER,
  dev_tipo varchar(15),
  dev_a_favor_de varchar(15),
  dev_nombre_cheque varchar(100),
  id_caja_dev integer,
  dev_saldo numeric(18,2),
  tipo_sol_sigema VARCHAR(20),
  id_sigema INTEGER,
  tipo_contrato varchar(30),
  cantidad_personas INTEGER DEFAULT 1 NOT NULL,
  tipo_rendicion varchar(15),
  aplicar_regla_15 VARCHAR(2) DEFAULT 'si' NOT NULL,
  id_int_comprobante_devrep integer,
  dev_saldo_original NUMERIC(18,2),
  id_moneda_dev INTEGER,
  id_funcionarios INTEGER [],
  CONSTRAINT tcuenta_doc_pkey PRIMARY KEY(id_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.tcuenta_doc.sw_modo
IS 'Deshabilitado...';


COMMENT ON COLUMN cd.tcuenta_doc.id_depto
IS 'depato de obligacion de pago';


COMMENT ON COLUMN cd.tcuenta_doc.id_depto_lb
IS 'depto de libro de bancos de donde se ara la tranaferencia o cheque';


COMMENT ON COLUMN cd.tcuenta_doc.tipo_pago
IS 'cheque, transferencia, caja, define de que forma de ara el pago';  

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_cuenta_bancaria
IS 'en caso de transferencia describe la cuenta bancaria destino';

COMMENT ON COLUMN cd.tcuenta_doc.importe
IS 'importe para ser entregado';

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_gerente
IS 'funcionario encargado de aprobar';

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_conta
IS 'idnetifica el depatamento de conta donde se contabiliza';

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria
IS 'cuenta bancaria  con la que se paga';

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante
IS 'cbte asociado';

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria_mov
IS 'hace referencia en pago de regionales, (depto LB con prioridad = 2),  al deposito de libro de bancos de donde se originan los fondos';

COMMENT ON COLUMN cd.tcuenta_doc.fecha_entrega
IS 'fecha a partir de la cual corren los dias para hacer la rendicion';

COMMENT ON COLUMN cd.tcuenta_doc.sw_max_doc_rend
IS 'por defecto no permite que se sobre pase el maximo valor configurador en variable globarl para el registro de documentos en rendicion';

COMMENT ON COLUMN cd.tcuenta_doc.num_memo
IS 'nro de memo de asignacion de fondos se creea al validar el cbte contable';

COMMENT ON COLUMN cd.tcuenta_doc.num_rendicion
IS 'numera el correlativo';

COMMENT ON COLUMN cd.tcuenta_doc.id_usuario_reg_ori
IS 'almacena el usuario que registro originalmente, solo en caso de que sea cambio el usuaario que debe regitrar la rendiciones';

COMMENT ON COLUMN cd.tcuenta_doc.presu_comprometido
IS 'indica si el presupeusto ya se encuentra comprometido';

COMMENT ON COLUMN cd.tcuenta_doc.importe_total_rendido
IS 'importe rendido, solo en solicitudesse llena cuando las rendiciones son finalizadas, peude llegar a ser negativo si se rinde mas de lo solicitado';

COMMENT ON COLUMN cd.tcuenta_doc.fecha_salida
IS 'Fecha de salida del viaje para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.fecha_llegada
IS 'Fecha de llegada del viaje para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.tipo_viaje
IS 'Tipo de viaje (nacional, internacional) para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.medio_transporte
IS 'Medio de transporte (aereo, terrestre) del viaje para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.cobertura
IS 'Porcentaje de cobertura para aplicación al viático';

COMMENT ON COLUMN cd.tcuenta_doc.hora_salida
IS 'Viáticos: hora real en la que partió en el viaje';

COMMENT ON COLUMN cd.tcuenta_doc.hora_llegada
IS 'Viáticos: hora real en la que llego del viaje';

COMMENT ON COLUMN cd.tcuenta_doc.id_centro_costo
IS 'Aplicable para viáticos para asociar al concepto de gasto por viático';

COMMENT ON COLUMN cd.tcuenta_doc.dev_tipo
IS 'Tipo de la devolucion/reposicion. tipo in (''deposito'',''cheque'',''caja'')';  

COMMENT ON COLUMN cd.tcuenta_doc.dev_a_favor_de
IS 'Devolucion/reposicion a favor de (''empresa'',''funcionario'')';  

COMMENT ON COLUMN cd.tcuenta_doc.dev_nombre_cheque
IS 'Devolucion/reposicion nombre para emitir cheque, cuando dev_tipo es cheque';  

COMMENT ON COLUMN cd.tcuenta_doc.id_caja_dev
IS 'Devolucion/reposicion ID de la caja para generar la solicitud de efectivo, cuando dev_tipo es caja';  

COMMENT ON COLUMN cd.tcuenta_doc.dev_saldo
IS 'Devolucion/reposicion saldo total de la cuenta documentada'; 

COMMENT ON COLUMN cd.tcuenta_doc.cantidad_personas
IS 'Cantidad de personas que formaran parte del viaje'; 

COMMENT ON COLUMN cd.tcuenta_doc.tipo_rendicion
IS 'Define si la rendición es parcial o final';

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante_devrep
IS 'Id del comprobante pode la devolución o reposición generado';

COMMENT ON COLUMN cd.tcuenta_doc.dev_saldo_original
IS 'Saldo en la moneda original';

COMMENT ON COLUMN cd.tcuenta_doc.id_moneda_dev
IS 'Moneda de la devolucion del campo dev_saldo';

COMMENT ON COLUMN cd.tcuenta_doc.hora_llegada
IS 'Viaticos: hora real en la que llego del viaje';

COMMENT ON COLUMN cd.tcuenta_doc.id_plantilla
IS 'Plantilla para el tipo de ''Recibo'' a generar para las rendiciones de viaticos';

COMMENT ON COLUMN cd.tcuenta_doc.tipo_sol_sigema
IS 'Tipo de solicitud del sistema de mantemiento SIGEMA (orden_trabajo, sol_admin,sol_man_mihv, sol_man_event';

COMMENT ON COLUMN cd.tcuenta_doc.id_sigema
IS 'ID del elemento correspondiente en funcion del tipo_sigema del sistema SIGEMA';

COMMENT ON COLUMN cd.tcuenta_doc.id_depto
IS 'depato de obligacion de pago';

COMMENT ON COLUMN cd.tcuenta_doc.tipo_pago
IS 'cheque, transferencia, caja, define de que forma de ara el pago';

COMMENT ON COLUMN cd.tcuenta_doc.sw_modo
IS 'Deshabilitado...';

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_lb
IS 'depto de libro de bancos de donde se ara la tranaferencia o cheque';

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_cuenta_bancaria
IS 'en caso de transferencia describe la cuenta bancaria destino';

COMMENT ON COLUMN cd.tcuenta_doc.importe
IS 'importe para ser entregado';

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_gerente
IS 'funcionario encargado de aprobar';

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_conta
IS 'idnetifica el depatamento de conta donde se contabiliza';

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria
IS 'cuenta bancaria  con la que se paga';

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante
IS 'cbte asociado';

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria_mov
IS 'hace referencia en pago de regionales, (depto LB con prioridad = 2),  al deposito de libro de bancos de donde se originan los fondos';

COMMENT ON COLUMN cd.tcuenta_doc.fecha_entrega
IS 'fecha a partir de la cual corren los dias para hacer la rendicion';

COMMENT ON COLUMN cd.tcuenta_doc.sw_max_doc_rend
IS 'por defecto no permite que se sobre pase el maximo valor configurador en variable globarl para el registro de documentos en rendicion';

COMMENT ON COLUMN cd.tcuenta_doc.num_memo
IS 'nro de memo de asignacion de fondos se creea al validar el cbte contable';

COMMENT ON COLUMN cd.tcuenta_doc.num_rendicion
IS 'numera el correlativo';

COMMENT ON COLUMN cd.tcuenta_doc.id_usuario_reg_ori
IS 'almacena el usuario que registro originalmente, solo en caso de que sea cambio el usuaario que debe regitrar la rendiciones';

COMMENT ON COLUMN cd.tcuenta_doc.presu_comprometido
IS 'indica si el presupeusto ya se encuentra comprometido';

COMMENT ON COLUMN cd.tcuenta_doc.importe_total_rendido
IS 'importe rendido, solo en solicitudesse llena cuando las rendiciones son finalizadas, peude llegar a ser negativo si se rinde mas de lo solicitado';

COMMENT ON COLUMN cd.tcuenta_doc.fecha_salida
IS 'Fecha de salida del viaje para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.fecha_llegada
IS 'Fecha de llegada del viaje para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.tipo_viaje
IS 'Tipo de viaje (nacional, internacional) para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.medio_transporte
IS 'Medio de transporte (aereo, terrestre) del viaje para Solicitud de Viáticos';

COMMENT ON COLUMN cd.tcuenta_doc.cobertura
IS 'Porcentaje de cobertura para aplicación al viático';

COMMENT ON COLUMN cd.tcuenta_doc.hora_salida
IS 'Viáticos: hora real en la que partió en el viaje';

COMMENT ON COLUMN cd.tcuenta_doc.hora_llegada
IS 'Viaticos: hora real en la que llego del viaje';

COMMENT ON COLUMN cd.tcuenta_doc.id_centro_costo
IS 'Aplicable para viáticos para asociar al concepto de gasto por viático';

COMMENT ON COLUMN cd.tcuenta_doc.id_solicitud_efectivo
IS 'Solicitud efectivo para entrega del monto de solicitud y para la devolución de saldos (a favor o en contra)';

COMMENT ON COLUMN cd.tcuenta_doc.id_plantilla
IS 'Plantilla para el tipo de ''Recibo'' a generar para las rendiciones de viaticos';

COMMENT ON COLUMN cd.tcuenta_doc.dev_tipo
IS 'Tipo de la devolucion/reposicion. tipo in (''deposito'',''cheque'',''caja'')';

COMMENT ON COLUMN cd.tcuenta_doc.dev_a_favor_de
IS 'Devolucion/reposicion a favor de (''empresa'',''funcionario'')';

COMMENT ON COLUMN cd.tcuenta_doc.dev_nombre_cheque
IS 'Devolucion/reposicion nombre para emitir cheque, cuando dev_tipo es cheque';

COMMENT ON COLUMN cd.tcuenta_doc.id_caja_dev
IS 'Devolucion/reposicion ID de la caja para generar la solicitud de efectivo, cuando dev_tipo es caja';

COMMENT ON COLUMN cd.tcuenta_doc.dev_saldo
IS 'Devolucion/reposicion saldo total de la cuenta documentada';

COMMENT ON COLUMN cd.tcuenta_doc.tipo_sol_sigema
IS 'Tipo de solicitud del sistema de mantemiento SIGEMA (orden_trabajo, sol_admin,sol_man_mihv, sol_man_event';

COMMENT ON COLUMN cd.tcuenta_doc.id_sigema
IS 'ID del elemento correspondiente en funcion del tipo_sigema del sistema SIGEMA';

COMMENT ON COLUMN cd.tcuenta_doc.cantidad_personas
IS 'Cantidad de personas que formaran parte del viaje';

COMMENT ON COLUMN cd.tcuenta_doc.tipo_rendicion
IS 'Define si la rendición es parcial o final';

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante_devrep
IS 'Id del comprobante pode la devolución o reposición generado';

COMMENT ON COLUMN cd.tcuenta_doc.dev_saldo_original
IS 'Saldo en la moneda original';

COMMENT ON COLUMN cd.tcuenta_doc.id_moneda_dev
IS 'Moneda de la devolucion del campo dev_saldo';

COMMENT ON COLUMN cd.tcuenta_doc.id_solicitud_efectivo
IS 'Solicitud efectivo para entrega del monto de solicitud y para la devolución de saldos (a favor o en contra)';


--------------- SQL ---------------



--------------- SQL ---------------

CREATE TABLE cd.trendicion_det (
  id_rendicion_det SERIAL NOT NULL,
  id_doc_compra_venta INTEGER NOT NULL,
  id_cuenta_doc INTEGER NOT NULL,
  id_cuenta_doc_rendicion INTEGER,
  generado varchar(15) DEFAULT 'no',
  PRIMARY KEY(id_rendicion_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc
IS 'cuenta doc a la que pertenece la factura rendicida';

COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc_rendicion
IS 'agrupador de la rendicion';


COMMENT ON COLUMN cd.trendicion_det.generado
IS 'Bandera (''si'',''no'') que marca al documento generado automáticamente';
--------------- SQL ---------------



/***********************************F-SCP-CD-ADQ-1-04/05/2016****************************************/


/***********************************I-SCP-CD-RAC-1-24/05/2016****************************************/

CREATE TABLE cd.tbloqueo_cd (
  id_bloqueo_cd SERIAL NOT NULL,
  id_tipo_cuenta_doc INTEGER,
  id_funcionario INTEGER,
  estado VARCHAR(40) DEFAULT 'bloqueado' NOT NULL,
  PRIMARY KEY(id_bloqueo_cd)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.tbloqueo_cd.estado
IS 'bloqueado o autorizado';

-----------------

CREATE TABLE cd.tdeposito_cd (
  id_deposito_cd SERIAL, 
  id_cuenta_doc INTEGER, 
  id_libro_bancos INTEGER, 
  importe_contable_deposito NUMERIC(20,2), 
  id_solicitud_efectivo INTEGER,
  CONSTRAINT tdeposito_cd_pkey PRIMARY KEY(id_deposito_cd), 
  CONSTRAINT fk_tdeposito_cd__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tdeposito_cd__id_libro_bancos FOREIGN KEY (id_libro_bancos)
    REFERENCES tes.tts_libro_bancos(id_libro_bancos)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)

WITH (oids = false);
COMMENT ON COLUMN cd.tdeposito_cd.id_solicitud_efectivo
IS 'Id del recibo de caja para devolución generado. Puede ser de Ingreso o Egreso';

/***********************************F-SCP-CD-RAC-1-24/05/2016****************************************/


/***********************************I-SCP-CD-RCM-1-04/09/2017****************************************/
create table cd.tdestino(
  id_destino serial,
  codigo varchar(30),
  nombre varchar(100),
  descripcion varchar(1000),
  tipo varchar(15), --nacional, internacional
  id_escala INTEGER,
  CONSTRAINT pk_tdestino__id_destino PRIMARY KEY(id_destino)
) inherits (pxp.tbase)
without oids;

COMMENT ON COLUMN cd.tdestino.tipo
IS 'Nacional o Internacional (nacional, internacional)';

-----------------------
/*
create table cd.tescala_viatico(
  id_escala_viatico serial,
  codigo varchar(30),
  desde date,
  hasta date,
  observaciones varchar(1000),
  CONSTRAINT pk_tdestino__id_escala_viatico PRIMARY KEY(id_escala_viatico)
) inherits (pxp.tbase)
without oids;*/




create table cd.tcuenta_doc_det(
  id_cuenta_doc_det serial,
  id_cuenta_doc integer,
  id_centro_costo integer,
  id_partida integer,
  id_concepto_ingas integer,
  monto_mo numeric(18,2),
  monto_mb numeric(18,2),
  id_moneda integer,
  id_moneda_mb integer,
  id_partida_ejecucion INTEGER,
  generado VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  CONSTRAINT pk_tcuenta_doc_det__id_cuenta_doc_det PRIMARY KEY(id_cuenta_doc_det)
) inherits (pxp.tbase)
without oids;

COMMENT ON COLUMN cd.tcuenta_doc_det.id_moneda_mb
IS 'Id de la moneda base';

COMMENT ON COLUMN cd.tcuenta_doc_det.id_moneda_mb
IS 'Id de la moneda base';

--------------------------

create table cd.tcuenta_doc_itinerario(
  id_cuenta_doc_itinerario serial,
  id_cuenta_doc integer,
  id_destino integer,
  cantidad_dias integer,
  fecha_desde date,
  fecha_hasta date,
  CONSTRAINT pk_tcuenta_doc_itinerario__id_cuenta_doc_itinerario PRIMARY KEY(id_cuenta_doc_itinerario)
) inherits (pxp.tbase)
without oids;
/***********************************F-SCP-CD-RCM-1-04/09/2017****************************************/

/***********************************I-SCP-CD-RCM-1-13/09/2017****************************************/


create table cd.tcuenta_doc_calculo (
  id_cuenta_doc_calculo serial,
  id_cuenta_doc integer not null,
  numero integer,
  destino varchar(200),
  dias_saldo_ant integer,
  dias_destino integer,
  cobertura_sol numeric(18,4),
  cobertura_hotel_sol numeric(18,4),
  dias_total_viaje integer,
  dias_aplicacion_regla integer,
  hora_salida time(0) WITHOUT TIME ZONE,
  hora_llegada time(0) WITHOUT TIME ZONE,
  escala_viatico numeric(18,2),
  escala_hotel numeric(18,2),
  regla_cobertura_dias_acum numeric(18,2),
  regla_cobertura_hora_salida numeric(18,2),
  regla_cobertura_hora_llegada numeric(18,2),
  regla_cobertura_total_dias numeric(18,2),
  cobertura_aplicada numeric(18,4),
  cobertura_aplicada_hotel numeric(18,4),
  dias_hotel INTEGER,
  cantidad_personas int4 NOT NULL DEFAULT 1,
  constraint pk_tcuenta_doc_calculo__id_cuenta_doc_calculo PRIMARY KEY(id_cuenta_doc_calculo)
) inherits (pxp.tbase)
with (oids = false);

COMMENT ON COLUMN cd.tcuenta_doc_calculo.cantidad_personas
IS 'Cantidad de personas que formarán del viaje';

COMMENT ON COLUMN cd.tcuenta_doc_calculo.cantidad_personas
IS 'Cantidad de personas que formarán del viaje';
/***********************************F-SCP-CD-RCM-1-13/09/2017****************************************/

/***********************************I-SCP-CD-RCM-1-15/11/2017****************************************/
CREATE TABLE cd.tescala (
  id_escala SERIAL,
  codigo VARCHAR(30),
  desde DATE,
  hasta DATE,
  observaciones VARCHAR(1000),
  tipo VARCHAR(15),
  CONSTRAINT pk_tdestino__id_escala_viatico1 PRIMARY KEY(id_escala)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.tescala.tipo
IS 'Tipo de cuenta documentada: ''viatico'',''fondo_avance''';

COMMENT ON COLUMN cd.tescala.tipo
IS 'Tipo de cuenta documentada: ''viatico'',''fondo_avance''';  
-------------
create table cd.tescala_regla (
  id_escala_regla serial,
  id_escala integer not null,
  id_unidad_medida integer,
  id_concepto_ingas integer,
  codigo varchar(30),
  nombre varchar(200),
  valor numeric(18,2),
  constraint pk_tescala_regla__id_escala_regla PRIMARY KEY(id_escala_regla)
) inherits (pxp.tbase)
with (oids = false);


/***********************************F-SCP-CD-RCM-1-15/11/2017****************************************/



/***********************************I-SCP-CD-RCM-1-04/12/2017****************************************/


create table cd.tcuenta_doc_prorrateo (
  id_cuenta_doc_prorrateo serial,
  id_cuenta_doc integer not null,
  id_centro_costo integer not null,
  prorrateo numeric(18,2) not null,
  constraint pk_tcuenta_doc_prorrateo__id_cuenta_doc_prorrateo PRIMARY KEY(id_cuenta_doc_prorrateo)
) inherits (pxp.tbase)
with (oids = false);


/***********************************F-SCP-CD-RCM-1-04/12/2017****************************************/


/***********************************I-SCP-CD-RCM-1-05/01/2018****************************************/  


CREATE TABLE cd.tpago_simple
(
    id_pago_simple SERIAL NOT NULL,
    id_depto_conta integer,
    nro_tramite character varying(100) COLLATE pg_catalog."default",
    fecha date,
    id_funcionario integer,
    estado character varying(30) COLLATE pg_catalog."default",
    id_estado_wf integer,
    id_proceso_wf integer,
    obs character varying(500) COLLATE pg_catalog."default",
    id_cuenta_bancaria integer,
    id_depto_lb integer,
    id_proveedor integer,
    id_moneda integer,
    id_int_comprobante integer,
    id_int_comprobante_pago integer,
    id_tipo_pago_simple integer,
    id_funcionario_pago integer,
    nro_tramite_asociado varchar(150),
    importe NUMERIC(18,2),
    id_obligacion_pago INTEGER,
    id_caja integer,
    id_solicitud_efectivo integer,
    CONSTRAINT tpago_simple_pkey PRIMARY KEY (id_pago_simple)
)
    INHERITS (pxp.tbase)
WITH (
    OIDS = FALSE
);
COMMENT ON COLUMN cd.tpago_simple.nro_tramite_asociado
IS 'Número del trámite asociado al pago a realizar, puede ser del proceso de compra';

COMMENT ON COLUMN cd.tpago_simple.id_obligacion_pago
IS 'ID de la obligacion de pago para relizar el prorrateo por partida en el comprobante diario';

COMMENT ON COLUMN cd.tpago_simple.nro_tramite_asociado
IS 'Número del trámite asociado al pago a realizar, puede ser del proceso de compra';

COMMENT ON COLUMN cd.tpago_simple.id_obligacion_pago
IS 'ID de la obligacion de pago para relizar el prorrateo por partida en el comprobante diario';

-------------------


CREATE TABLE cd.tpago_simple_det
(
    id_pago_simple_det serial NOT NULL,
    id_pago_simple integer NOT NULL,
    id_doc_compra_venta integer,
    CONSTRAINT tpago_simple_det_pkey PRIMARY KEY (id_pago_simple_det)
)
    INHERITS (pxp.tbase)
WITH (
    OIDS = FALSE
);
-----------------

CREATE TABLE cd.ttipo_pago_simple (
    id_tipo_pago_simple serial NOT NULL,
    codigo varchar(30),
    nombre varchar(150),
    plantilla_cbte varchar(50),
    plantilla_cbte_1 varchar(50),
    flujo_wf VARCHAR(50),
    CONSTRAINT ttipo_pago_simple_pkey PRIMARY KEY (id_tipo_pago_simple)
)
    INHERITS (pxp.tbase)
WITH (
    OIDS = FALSE
);

COMMENT ON COLUMN cd.ttipo_pago_simple.flujo_wf
IS 'Código del workflow por tipo de pago simple';


/***********************************F-SCP-CD-RCM-1-05/01/2018****************************************/  


/***********************************I-SCP-CD-RCM-1-14/01/2018****************************************/
CREATE TABLE cd.tpago_simple_pro (
  id_pago_simple_pro SERIAL NOT NULL,
  id_pago_simple integer,
  id_concepto_ingas integer,
  id_centro_costo integer NOT NULL,
  id_partida integer,
  factor numeric(18,2),
  PRIMARY KEY(id_pago_simple_pro)
) INHERITS (pxp.tbase);

/***********************************F-SCP-CD-RCM-1-14/01/2018****************************************/
    


/***********************************I-SCP-CD-RCM-1-26/02/2018****************************************/
CREATE TABLE cd.tcuenta_doc_excepcion (
  id_cuenta_doc_excepcion SERIAL,
  id_cuenta_doc INTEGER,
  id_usuario INTEGER,
  PRIMARY KEY(id_cuenta_doc_excepcion)
) INHERITS (pxp.tbase)

WITH (oids = false);
/***********************************F-SCP-CD-RCM-1-26/02/2018****************************************/


/***********************************I-SCP-CD-JJA-1-01/12/2018****************************************/


CREATE TABLE cd.tagencia_despachante (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying, 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_agencia_despachante SERIAL, 
  nombre VARCHAR(50), 
  codigo VARCHAR(50),
  id_proveedor int4 NULL,
  CONSTRAINT tagencia_despachante_pkey PRIMARY KEY (id_agencia_despachante)
) INHERITS (pxp.tbase)
;
------------

CREATE TABLE cd.tcontrol_dui (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying, 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_control_dui SERIAL, 
  dui VARCHAR(100) NOT NULL, 
  nro_factura_proveedor VARCHAR(50), 
  pedido_sap VARCHAR(50), 
  tramite_pedido_endesis VARCHAR(50), 
  tramite_anticipo_dui VARCHAR(50), 
  nro_comprobante_pago_dui VARCHAR(50), 
  nro_comprobante_diario_dui VARCHAR(50), 
  tramite_comision_agencia VARCHAR(50), 
  nro_comprobante_diario_comision VARCHAR(50), 
  nro_comprobante_pago_comision VARCHAR(50), 
  archivo_dui VARCHAR(50), 
  archivo_comision VARCHAR(50), 
  monto_comision NUMERIC(18,2), 
  monto_dui NUMERIC(18,2), 
  id_agencia_despachante INTEGER, 
  observaciones TEXT,
  id_gestion INTEGER,
	CONSTRAINT tcontrol_dui_pkey PRIMARY KEY (id_control_dui)
) INHERITS (pxp.tbase)
;

ALTER TABLE cd.tcontrol_dui
  ALTER COLUMN id_control_dui SET STATISTICS 0;

ALTER TABLE cd.tcontrol_dui
  ALTER COLUMN dui SET STATISTICS 0;

ALTER TABLE cd.tcontrol_dui
  ALTER COLUMN nro_factura_proveedor SET STATISTICS 0;

/*
ALTER INDEX cd.pk_tdestino__id_escala_viatico1
  RENAME TO pk_tdestino__id_escala_viatico;
*/



---------------------

CREATE TABLE cd.tpago_simple_tmp (
  id SERIAL, 
  acreedor VARCHAR(20), 
  proveedor VARCHAR(1000), 
  monto NUMERIC, 
  moneda VARCHAR(50), 
  id_proveedor INTEGER, 
  migrado VARCHAR(2), 
  obs VARCHAR(8000), 
  id_pago_simple INTEGER,
  CONSTRAINT tpago_simple_tmp_pkey PRIMARY KEY (id)
) ;
ALTER TABLE cd.tpago_simple_tmp
  ALTER COLUMN id SET STATISTICS 0;

ALTER TABLE cd.tpago_simple_tmp
  ALTER COLUMN acreedor SET STATISTICS 0;

/***********************************F-SCP-CD-JJA-1-01/12/2018****************************************/
