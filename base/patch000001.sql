
/***********************************I-SCP-RAC-CD-1-04/05/2016****************************************/


CREATE TABLE cd.ttipo_cuenta_doc (
  id_tipo_cuenta_doc SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(500),
  descripcion VARCHAR,
  PRIMARY KEY(id_tipo_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);


CREATE TABLE cd.ttipo_categoria (
  id_tipo_categoria SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(400),
  PRIMARY KEY("id_tipo_categoria")
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE cd.tcategoria (
  id_categoria SERIAL NOT NULL,
  id_tipo_categoria INTEGER,
  id_moneda INTEGER,
  codigo VARCHAR(100) NOT NULL,
  nombre VARCHAR(400),
  monto NUMERIC(18,2),
  PRIMARY KEY(id_categoria)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE cd.tcuenta_doc (
  id_cuenta_doc SERIAL,
  id_tipo_cuenta_doc INTEGER NOT NULL,
  id_funcionario INTEGER NOT NULL,
  id_depto INTEGER NOT NULL,
  id_uo INTEGER NOT NULL,
  id_moneda INTEGER NOT NULL,
  id_proceso_wf INTEGER NOT NULL,
  id_estado_wf INTEGER NOT NULL,
  id_caja INTEGER,
  id_cuenta_doc_fk INTEGER,
  tipo_pago VARCHAR,
  fecha DATE NOT NULL,
  nro_tramite VARCHAR(150) NOT NULL,
  estado VARCHAR(100) NOT NULL,
  sw_modo VARCHAR(40) DEFAULT 'cheque'::character varying NOT NULL,
  nombre_cheque VARCHAR(300),
  motivo VARCHAR NOT NULL,
  CONSTRAINT tcuenta_doc_pkey PRIMARY KEY(id_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.tcuenta_doc.sw_modo
IS 'Deshabilitado...';


ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN tipo_pago SET DEFAULT 'cheque';

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN tipo_pago SET NOT NULL;
  

COMMENT ON COLUMN cd.tcuenta_doc.id_depto
IS 'depato de obligacion de pago';


ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_depto_lb INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_lb
IS 'depto de libro de bancos de donde se ara la tranaferencia o cheque';


COMMENT ON COLUMN cd.tcuenta_doc.tipo_pago
IS 'cheque, transferencia, caja, define de que forma de ara el pago';  


ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_funcionario_cuenta_bancaria INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_cuenta_bancaria
IS 'en caso de transferencia describe la cuenta bancaria destino';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN importe NUMERIC(2,0) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.importe
IS 'importe para ser entregado';


ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_funcionario_gerente INTEGER NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.id_funcionario_gerente
IS 'funcionario encargado de aprobar';


ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe DROP DEFAULT;

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe TYPE NUMERIC(12,2);

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe SET DEFAULT 0;

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_depto_conta INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_depto_conta
IS 'idnetifica el depatamento de conta donde se contabiliza';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_cuenta_bancaria INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria
IS 'cuenta bancaria  con la que se paga';


ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN codigo_wf VARCHAR(100);

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_wf
IS 'codigo del proceso de wf correspondiente';


ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN codigo_plantilla_cbte VARCHAR(100);

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_plantilla_cbte
IS 'codigo de la plantilla de comprobante';

--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_gestion INTEGER;

--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_int_comprobante INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante
IS 'cbte asociado';

--------------- SQL ---------------

CREATE TABLE cd.trendicion_det (
  id_rendicion_det SERIAL NOT NULL,
  id_doc_compra_venta INTEGER NOT NULL,
  id_cuenta_doc INTEGER NOT NULL,
  id_cuenta_doc_rendicion INTEGER,
  PRIMARY KEY(id_rendicion_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc
IS 'cuenta doc a la que pertenece la factura rendicida';

COMMENT ON COLUMN cd.trendicion_det.id_cuenta_doc_rendicion
IS 'agrupador de la rendicion';


--------------- SQL ---------------

ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN sw_solicitud VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN cd.ttipo_cuenta_doc.sw_solicitud
IS 'marca los tipo que son solitud';

/***********************************F-SCP-CD-ADQ-1-04/05/2016****************************************/


/***********************************I-SCP-CD-RAC-1-24/05/2016****************************************/


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_cuenta_bancaria_mov INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_cuenta_bancaria_mov
IS 'hace referencia en pago de regionales, (depto LB con prioridad = 2),  al deposito de libro de bancos de donde se originan los fondos';

--------------- SQL ---------------

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


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN nro_correspondencia VARCHAR(300);
  
  --------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN fecha_entrega DATE DEFAULT now() NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.fecha_entrega
IS 'fecha a partir de la cual corren los dias para hacer la rendicion';

--------------- SQL ---------------



ALTER TABLE cd.tcuenta_doc
  ADD COLUMN sw_max_doc_rend VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.sw_max_doc_rend
IS 'por defecto no permite que se sobre pase el maximo valor configurador en variable globarl para el registro de documentos en rendicion';



--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN num_memo VARCHAR(200);

COMMENT ON COLUMN cd.tcuenta_doc.num_memo
IS 'nro de memo de asignacion de fondos se creea al validar el cbte contable';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN num_rendicion VARCHAR(20);

COMMENT ON COLUMN cd.tcuenta_doc.num_rendicion
IS 'numera el correlativo';

--------------- SQL ---------------



ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_usuario_reg_ori INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_usuario_reg_ori
IS 'almacena el usuario que registro originalmente, solo en caso de que sea cambio el usuaario que debe regitrar la rendiciones';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN presu_comprometido VARCHAR(3) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.presu_comprometido
IS 'indica si el presupeusto ya se encuentra comprometido';


--------------- SQL ---------------

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN importe_total_rendido NUMERIC(32,2) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.importe_total_rendido
IS 'importe rendido, solo en solicitudesse llena cuando las rendiciones son finalizadas, peude llegar a ser negativo si se rinde mas de lo solicitado';


/***********************************F-SCP-CD-RAC-1-24/05/2016****************************************/






/***********************************I-SCP-CD-GSS-1-14/06/2017****************************************/

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_funcionario_aprobador INTEGER;
   

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_periodo INTEGER;

/***********************************F-SCP-CD-GSS-1-14/06/2017****************************************/

/***********************************I-SCP-CD-RCM-1-04/09/2017****************************************/
create table cd.tdestino(
  id_destino serial,
  codigo varchar(30),
  nombre varchar(100),
  descripcion varchar(1000),
  tipo varchar(15), --nacional, internacional
  CONSTRAINT pk_tdestino__id_destino PRIMARY KEY(id_destino)
) inherits (pxp.tbase)
without oids;

create table cd.tescala_viatico(
  id_escala_viatico serial,
  codigo varchar(30),
  desde date,
  hasta date,
  observaciones varchar(1000),
  CONSTRAINT pk_tdestino__id_escala_viatico PRIMARY KEY(id_escala_viatico)
) inherits (pxp.tbase)
without oids;

ALTER TABLE cd.ttipo_categoria
  ADD COLUMN id_escala_viatico INTEGER;

COMMENT ON COLUMN cd.ttipo_categoria.id_escala_viatico
IS 'ID de la escala de viático';

ALTER TABLE cd.tcategoria
  ADD COLUMN id_destino INTEGER;

COMMENT ON COLUMN cd.tcategoria.id_destino
IS 'Destino para la Escala de viáticos';

COMMENT ON COLUMN cd.tcategoria.monto
IS 'En el caso de Viáticos, este monto corresponde al monto de viático con pernocte';

ALTER TABLE cd.tcategoria
  ADD COLUMN monto_sp numeric(18,2);

COMMENT ON COLUMN cd.tcategoria.monto_sp
IS 'Monto viático Sin Pernocte';

ALTER TABLE cd.tcategoria
  ADD COLUMN monto_hotel numeric(18,2);

COMMENT ON COLUMN cd.tcategoria.monto_hotel
IS 'Monto permitido para el pago de Hotel';

COMMENT ON COLUMN cd.tdestino.tipo
IS 'Nacional o Internacional (nacional, internacional)';

create table cd.tcuenta_doc_det(
  id_cuenta_doc_det serial,
  id_cuenta_doc integer,
  id_centro_costo integer,
  id_partida integer,
  id_concepto_ingas integer,
  id_moneda integer,
  id_moneda_mb integer,
  monto_mo numeric(18,2),
  monto_mb numeric(18,2),
  CONSTRAINT pk_tcuenta_doc_det__id_cuenta_doc_det PRIMARY KEY(id_cuenta_doc_det)
) inherits (pxp.tbase)
without oids;

COMMENT ON COLUMN cd.tcuenta_doc_det.id_moneda_mb
IS 'Id de la moneda base';

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

/***********************************I-SCP-CD-RCM-1-05/09/2017****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN fecha_salida DATE;

COMMENT ON COLUMN cd.tcuenta_doc.fecha_salida
IS 'Fecha de salida del viaje para Solicitud de Viáticos';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN fecha_llegada DATE;

COMMENT ON COLUMN cd.tcuenta_doc.fecha_llegada
IS 'Fecha de llegada del viaje para Solicitud de Viáticos';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN tipo_viaje varchar(20);

COMMENT ON COLUMN cd.tcuenta_doc.tipo_viaje
IS 'Tipo de viaje (nacional, internacional) para Solicitud de Viáticos';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN medio_transporte varchar(20);

COMMENT ON COLUMN cd.tcuenta_doc.medio_transporte
IS 'Medio de transporte (aereo, terrestre) del viaje para Solicitud de Viáticos';

ALTER TABLE cd.tcuenta_doc
  ALTER COLUMN importe DROP NOT NULL;
/***********************************F-SCP-CD-RCM-1-05/09/2017****************************************/

/***********************************I-SCP-CD-RCM-1-06/09/2017****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN cobertura VARCHAR(20);

COMMENT ON COLUMN cd.tcuenta_doc.cobertura
IS 'Porcentaje de cobertura para aplicación al viático';
/***********************************F-SCP-CD-RCM-1-06/09/2017****************************************/

/***********************************I-SCP-CD-RCM-1-13/09/2017****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN hora_salida TIME(0) WITHOUT TIME ZONE;

COMMENT ON COLUMN cd.tcuenta_doc.hora_salida
IS 'Viáticos: hora real en la que partió en el viaje';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN hora_llegada TIME(0) WITHOUT TIME ZONE;

COMMENT ON COLUMN cd.tcuenta_doc.hora_llegada
IS 'Viáticos: hora real en la que llego del viaje';

create table cd.tcuenta_doc_calculo (
  id_cuenta_doc_calculo serial,
  id_cuenta_doc integer not null,
  numero integer,
  destino varchar(50),
  dias_saldo_ant integer,
  dias_destino integer,
  cobertura_sol numeric(18,2),
  cobertura_hotel_sol numeric(18,2),
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
  cobertura_aplicada numeric(18,2),
  cobertura_aplicada_hotel numeric(18,2),
  constraint pk_tcuenta_doc_calculo__id_cuenta_doc_calculo PRIMARY KEY(id_cuenta_doc_calculo)
) inherits (pxp.tbase)
with (oids = false);
/***********************************F-SCP-CD-RCM-1-13/09/2017****************************************/

/***********************************I-SCP-CD-RCM-1-15/11/2017****************************************/
ALTER TABLE cd.tdestino
  ADD COLUMN id_escala INTEGER;
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_escala INTEGER;  
ALTER TABLE cd.tescala
  ADD COLUMN tipo VARCHAR(15);
COMMENT ON COLUMN cd.tescala.tipo
IS 'Tipo de cuenta documentada: ''viatico'',''fondo_avance''';  

create table cd.tescala_regla (
  id_escala_regla serial,
  id_escala integer not null,
  id_unidad_medida integer,
  id_concepto_ingas integer,
  codigo varchar(30),
  nombre varchar(50),
  valor numeric(18,2),
  constraint pk_tescala_regla__id_escala_regla PRIMARY KEY(id_escala_regla)
) inherits (pxp.tbase)
with (oids = false);

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_centro_costo INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_centro_costo
IS 'Aplicable para viáticos para asociar al concepto de gasto por viático';
/***********************************F-SCP-CD-RCM-1-15/11/2017****************************************/

/***********************************I-SCP-CD-RCM-1-22/11/2017****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_solicitud_efectivo INTEGER;
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_plantilla INTEGER;
/***********************************F-SCP-CD-RCM-1-22/11/2017****************************************/

/***********************************I-SCP-CD-RCM-1-04/12/2017****************************************/
ALTER TABLE cd.trendicion_det
  ADD COLUMN generado varchar(15) DEFAULT 'no';

COMMENT ON COLUMN cd.trendicion_det.generado
IS 'Bandera (''si'',''no'') que marca al documento generado automáticamente';

create table cd.tcuenta_doc_prorrateo (
  id_cuenta_doc_prorrateo serial,
  id_cuenta_doc integer not null,
  id_centro_costo integer not null,
  prorrateo numeric(18,2) not null,
  constraint pk_tcuenta_doc_prorrateo__id_cuenta_doc_prorrateo PRIMARY KEY(id_cuenta_doc_prorrateo)
) inherits (pxp.tbase)
with (oids = false);

COMMENT ON COLUMN cd.tcuenta_doc.id_solicitud_efectivo
IS 'Solicitud efectivo para entrega del monto de solicitud y para la devolución de saldos (a favor o en contra)';
/***********************************F-SCP-CD-RCM-1-04/12/2017****************************************/

/***********************************I-SCP-CD-RCM-1-13/12/2017****************************************/
ALTER TABLE cd.tdeposito_cd
  ADD COLUMN id_solicitud_efectivo INTEGER;

COMMENT ON COLUMN cd.tdeposito_cd.id_solicitud_efectivo
IS 'Id del recibo de caja para devolución generado. Puede ser de Ingreso o Egreso';
/***********************************F-SCP-CD-RCM-1-13/12/2017****************************************/

/***********************************I-SCP-CD-RCM-1-14/12/2017****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN dev_tipo varchar(15);
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN dev_a_favor_de varchar(15);  
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN dev_nombre_cheque varchar(100);  
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_caja_dev integer;  
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN dev_saldo numeric(18,2);

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
/***********************************F-SCP-CD-RCM-1-14/12/2017****************************************/

/***********************************F-SCP-CD-RCM-1-02/01/2018****************************************/
ALTER TABLE cd.tcuenta_doc_calculo
  ALTER COLUMN destino TYPE VARCHAR(200) COLLATE pg_catalog."default";
/***********************************F-SCP-CD-RCM-1-02/01/2018****************************************/  

/***********************************I-SCP-CD-RCM-1-05/01/2018****************************************/  
alter table cd.tcuenta_doc
add column tipo_contrato varchar(30);

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
    CONSTRAINT tpago_simple_pkey PRIMARY KEY (id_pago_simple)
)
    INHERITS (pxp.tbase)
WITH (
    OIDS = FALSE
);

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

alter table cd.tpago_simple
add column id_int_comprobante integer;

alter table cd.tpago_simple
add column id_int_comprobante_pago integer;

CREATE TABLE cd.ttipo_pago_simple (
    id_tipo_pago_simple serial NOT NULL,
    codigo varchar(30),
    nombre varchar(150),
    plantilla_cbte varchar(50),
    plantilla_cbte_1 varchar(50),
    CONSTRAINT ttipo_pago_simple_pkey PRIMARY KEY (id_tipo_pago_simple)
)
    INHERITS (pxp.tbase)
WITH (
    OIDS = FALSE
);

alter table cd.tpago_simple
add column id_tipo_pago_simple integer;

alter table cd.tpago_simple
add column id_funcionario_pago integer;

/***********************************F-SCP-CD-RCM-1-05/01/2018****************************************/  

/***********************************I-SCP-CD-RCM-1-09/01/2018****************************************/
ALTER TABLE cd.tescala_regla
  ALTER COLUMN nombre TYPE VARCHAR(200) COLLATE pg_catalog."default";

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN cantidad_personas INTEGER DEFAULT 1 NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc.cantidad_personas
IS 'Cantidad de personas que formaran parte del viaje';  
/***********************************F-SCP-CD-RCM-1-09/01/2018****************************************/

/***********************************I-SCP-CD-RCM-1-10/01/2018****************************************/
ALTER TABLE cd.ttipo_pago_simple
  ADD COLUMN flujo_wf VARCHAR(50);

COMMENT ON COLUMN cd.ttipo_pago_simple.flujo_wf
IS 'Código del workflow por tipo de pago simple';

ALTER TABLE cd.tcuenta_doc_calculo
  ADD COLUMN cantidad_personas INTEGER DEFAULT 1 NOT NULL;

COMMENT ON COLUMN cd.tcuenta_doc_calculo.cantidad_personas
IS 'Cantidad de personas que formarán del viaje';
/***********************************F-SCP-CD-RCM-1-10/01/2018****************************************/

/***********************************I-SCP-CD-RCM-1-11/01/2018****************************************/
ALTER TABLE cd.tpago_simple
  ADD COLUMN nro_tramite_asociado varchar(150);

COMMENT ON COLUMN cd.tpago_simple.nro_tramite_asociado
IS 'Número del trámite asociado al pago a realizar, puede ser del proceso de compra';
/***********************************F-SCP-CD-RCM-1-11/01/2018****************************************/

/***********************************I-SCP-CD-RCM-1-12/01/2018****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN tipo_rendicion varchar(15);

COMMENT ON COLUMN cd.tcuenta_doc.tipo_rendicion
IS 'Define si la rendición es parcial o final';

ALTER TABLE cd.tpago_simple
  ADD COLUMN id_obligacion_pago INTEGER;

COMMENT ON COLUMN cd.tpago_simple.id_obligacion_pago
IS 'ID de la obligacion de pago para relizar el prorrateo por partida en el comprobante diario';
/***********************************F-SCP-CD-RCM-1-12/01/2018****************************************/

/***********************************I-SCP-CD-RCM-1-14/01/2018****************************************/
CREATE TABLE cd.tpago_simple_pro (
  id_pago_simple_pro SERIAL NOT NULL,
  id_pago_simple integer,
  id_concepto_ingas integer,
  id_centro_costo integer,
  id_partida integer,
  factor numeric(18,2),
  PRIMARY KEY(id_pago_simple_pro)
) INHERITS (pxp.tbase);

/***********************************F-SCP-CD-RCM-1-14/01/2018****************************************/