
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



CREATE TABLE cd.tdeposito_cd (
  id_deposito_cd SERIAL, 
  id_cuenta_doc INTEGER, 
  id_libro_bancos INTEGER, 
  importe_contable_deposito NUMERIC(20,2), 
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

ALTER TABLE cd.tdestino
  ADD COLUMN id_escala INTEGER;
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_escala INTEGER;  

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

/***********************************I-SCP-CD-RCM-1-02/01/2018****************************************/
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

/***********************************I-SCP-CD-RCM-1-15/01/2018****************************************/
ALTER TABLE cd.tcuenta_doc_calculo
  ALTER COLUMN cobertura_aplicada TYPE NUMERIC(18,4);

ALTER TABLE cd.tcuenta_doc_calculo
  ALTER COLUMN cobertura_aplicada_hotel TYPE NUMERIC(18,4);

ALTER TABLE cd.tcuenta_doc_calculo
  ALTER COLUMN cobertura_hotel_sol TYPE NUMERIC(18,4);

ALTER TABLE cd.tcuenta_doc_calculo
  ALTER COLUMN cobertura_sol TYPE NUMERIC(18,4);      

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN aplicar_regla_15 VARCHAR(2) DEFAULT 'si' NOT NULL;   
/***********************************F-SCP-CD-RCM-1-15/01/2018****************************************/  

/***********************************I-SCP-CD-RCM-1-20/01/2018****************************************/  
alter table cd.tpago_simple
    add column id_caja integer;
alter table cd.tpago_simple
    add column id_solicitud_efectivo integer;    
/***********************************F-SCP-CD-RCM-1-20/01/2018****************************************/      


/***********************************I-SCP-CD-RCM-1-20/02/2018****************************************/
ALTER TABLE cd.ttipo_cuenta_doc
  ADD COLUMN codigo_plantilla_cbte_devrep VARCHAR(100);

COMMENT ON COLUMN cd.ttipo_cuenta_doc.codigo_plantilla_cbte_devrep
IS 'Código de la plantilla de comprobante para devolución o reposición de saldos por cheque o depósito';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_int_comprobante_devrep integer;

COMMENT ON COLUMN cd.tcuenta_doc.id_int_comprobante_devrep
IS 'Id del comprobante pode la devolución o reposición generado';
/***********************************F-SCP-CD-RCM-1-20/02/2018****************************************/

/***********************************I-SCP-CD-RCM-1-26/02/2018****************************************/
CREATE TABLE cd.tcuenta_doc_excepcion (
  id_cuenta_doc_excepcion SERIAL,
  id_cuenta_doc INTEGER,
  id_usuario INTEGER,
  PRIMARY KEY(id_cuenta_doc_excepcion)
) INHERITS (pxp.tbase)

WITH (oids = false);
/***********************************F-SCP-CD-RCM-1-26/02/2018****************************************/


/***********************************I-SCP-CD-RCM-1-12/04/2018****************************************/
ALTER TABLE cd.tcuenta_doc
  ADD COLUMN dev_saldo_original NUMERIC(18,2);

COMMENT ON COLUMN cd.tcuenta_doc.dev_saldo_original
IS 'Saldo en la moneda original';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_moneda_dev INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_moneda_dev
IS 'Moneda de la devolucion del campo dev_saldo';
/***********************************F-SCP-CD-RCM-1-12/04/2018****************************************/


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
  codigo VARCHAR(50)
) INHERITS (pxp.tbase)
;

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
  observaciones TEXT
) INHERITS (pxp.tbase)
;

/*
ALTER INDEX cd.pk_tdestino__id_escala_viatico1
  RENAME TO pk_tdestino__id_escala_viatico;
*/


ALTER TABLE cd.tpago_simple
  ADD COLUMN importe NUMERIC(18,2);

ALTER TABLE cd.tpago_simple_pro
  ALTER COLUMN id_centro_costo SET NOT NULL;


CREATE TABLE cd.tpago_simple_tmp (
  id SERIAL, 
  acreedor VARCHAR(20), 
  proveedor VARCHAR(1000), 
  monto NUMERIC, 
  moneda VARCHAR(50), 
  id_proveedor INTEGER, 
  migrado VARCHAR(2), 
  obs VARCHAR(8000), 
  id_pago_simple INTEGER
) ;

ALTER TABLE cd.tpago_simple_tmp
  ALTER COLUMN id SET STATISTICS 0;

ALTER TABLE cd.tpago_simple_tmp
  ALTER COLUMN acreedor SET STATISTICS 0;




ALTER TABLE cd.ttipo_categoria
  ADD COLUMN id_escala INTEGER;

COMMENT ON COLUMN cd.ttipo_categoria.id_escala
IS 'ID de la escala de viático';

COMMENT ON COLUMN cd.tcuenta_doc.hora_llegada
IS 'Viaticos: hora real en la que llego del viaje';

COMMENT ON COLUMN cd.tcuenta_doc.id_plantilla
IS 'Plantilla para el tipo de ''Recibo'' a generar para las rendiciones de viaticos';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN tipo_sol_sigema VARCHAR(20);

COMMENT ON COLUMN cd.tcuenta_doc.tipo_sol_sigema
IS 'Tipo de solicitud del sistema de mantemiento SIGEMA (orden_trabajo, sol_admin,sol_man_mihv, sol_man_event';

ALTER TABLE cd.tcuenta_doc
  ADD COLUMN id_sigema INTEGER;

COMMENT ON COLUMN cd.tcuenta_doc.id_sigema
IS 'ID del elemento correspondiente en funcion del tipo_sigema del sistema SIGEMA';

ALTER TABLE cd.tcuenta_doc_calculo
  ADD COLUMN dias_hotel INTEGER;


ALTER TABLE cd.tcuenta_doc_det
  ADD COLUMN id_partida_ejecucion INTEGER;

ALTER TABLE cd.tcuenta_doc_det
  ADD COLUMN generado VARCHAR(2) DEFAULT 'no'::character varying NOT NULL;

ALTER TABLE cd.ttipo_categoria
  DROP COLUMN id_escala_viatico;


--DROP TABLE cd.tescala_viatico;


-- Create a temporary table
/*
CREATE LOCAL TEMPORARY TABLE tcuenta_doc0janka (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE, 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE, 
  estado_reg VARCHAR(10), 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_cuenta_doc INTEGER, 
  id_tipo_cuenta_doc INTEGER, 
  id_funcionario INTEGER, 
  id_depto INTEGER, 
  id_uo INTEGER, 
  id_moneda INTEGER, 
  id_proceso_wf INTEGER, 
  id_estado_wf INTEGER, 
  id_caja INTEGER, 
  id_cuenta_doc_fk INTEGER, 
  tipo_pago VARCHAR, 
  fecha DATE, 
  nro_tramite VARCHAR(150), 
  estado VARCHAR(100), 
  sw_modo VARCHAR(40), 
  nombre_cheque VARCHAR(300), 
  motivo VARCHAR, 
  id_depto_lb INTEGER, 
  id_funcionario_cuenta_bancaria INTEGER, 
  importe NUMERIC(12,2), 
  id_funcionario_gerente INTEGER, 
  id_depto_conta INTEGER, 
  id_cuenta_bancaria INTEGER, 
  id_gestion INTEGER, 
  id_int_comprobante INTEGER, 
  id_cuenta_bancaria_mov INTEGER, 
  nro_correspondencia VARCHAR(300), 
  fecha_entrega DATE, 
  sw_max_doc_rend VARCHAR(10), 
  num_memo VARCHAR(200), 
  num_rendicion VARCHAR(20), 
  id_usuario_reg_ori INTEGER, 
  presu_comprometido VARCHAR(3), 
  importe_total_rendido NUMERIC(32,2), 
  id_funcionario_aprobador INTEGER, 
  id_periodo INTEGER, 
  fecha_salida DATE, 
  fecha_llegada DATE, 
  tipo_viaje VARCHAR(20), 
  medio_transporte VARCHAR(20), 
  cobertura VARCHAR(20), 
  hora_salida TIME(0) WITHOUT TIME ZONE, 
  hora_llegada TIME(0) WITHOUT TIME ZONE, 
  id_escala INTEGER, 
  id_centro_costo INTEGER, 
  id_solicitud_efectivo INTEGER, 
  id_plantilla INTEGER, 
  dev_tipo VARCHAR(15), 
  dev_a_favor_de VARCHAR(15), 
  dev_nombre_cheque VARCHAR(100), 
  id_caja_dev INTEGER, 
  dev_saldo NUMERIC(18,2), 
  tipo_sol_sigema VARCHAR(20), 
  id_sigema INTEGER, 
  tipo_contrato VARCHAR(30), 
  cantidad_personas INTEGER, 
  tipo_rendicion VARCHAR(15), 
  aplicar_regla_15 VARCHAR(2), 
  id_int_comprobante_devrep INTEGER, 
  dev_saldo_original NUMERIC(18,2), 
  id_moneda_dev INTEGER
) ;
*/
-- Copy the source table's data to the temporary table
/*
INSERT INTO tcuenta_doc0janka (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc, id_tipo_cuenta_doc, id_funcionario, id_depto, id_uo, id_moneda, id_proceso_wf, id_estado_wf, id_caja, id_cuenta_doc_fk, tipo_pago, fecha, nro_tramite, estado, sw_modo, nombre_cheque, motivo, id_depto_lb, id_funcionario_cuenta_bancaria, importe, id_funcionario_gerente, id_depto_conta, id_cuenta_bancaria, id_gestion, id_int_comprobante, id_cuenta_bancaria_mov, nro_correspondencia, fecha_entrega, sw_max_doc_rend, num_memo, num_rendicion, id_usuario_reg_ori, presu_comprometido, importe_total_rendido, id_funcionario_aprobador, id_periodo, fecha_salida, fecha_llegada, tipo_viaje, medio_transporte, cobertura, hora_salida, hora_llegada, id_escala, id_centro_costo, id_solicitud_efectivo, id_plantilla, dev_tipo, dev_a_favor_de, dev_nombre_cheque, id_caja_dev, dev_saldo, tipo_sol_sigema, id_sigema, tipo_contrato, cantidad_personas, tipo_rendicion, aplicar_regla_15, id_int_comprobante_devrep, dev_saldo_original, id_moneda_dev)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc, id_tipo_cuenta_doc, id_funcionario, id_depto, id_uo, id_moneda, id_proceso_wf, id_estado_wf, id_caja, id_cuenta_doc_fk, tipo_pago, fecha, nro_tramite, estado, sw_modo, nombre_cheque, motivo, id_depto_lb, id_funcionario_cuenta_bancaria, importe, id_funcionario_gerente, id_depto_conta, id_cuenta_bancaria, id_gestion, id_int_comprobante, id_cuenta_bancaria_mov, nro_correspondencia, fecha_entrega, sw_max_doc_rend, num_memo, num_rendicion, id_usuario_reg_ori, presu_comprometido, importe_total_rendido, id_funcionario_aprobador, id_periodo, fecha_salida, fecha_llegada, tipo_viaje, medio_transporte, cobertura, hora_salida, hora_llegada, id_escala, id_centro_costo, id_solicitud_efectivo, id_plantilla, dev_tipo, dev_a_favor_de, dev_nombre_cheque, id_caja_dev, dev_saldo, tipo_sol_sigema, id_sigema, tipo_contrato, cantidad_personas, tipo_rendicion, aplicar_regla_15, id_int_comprobante_devrep, dev_saldo_original, id_moneda_dev FROM cd.tcuenta_doc;
*/
-- Drop the source table

--DROP TABLE cd.tcuenta_doc;

-- Create the destination table
/*
CREATE TABLE cd.tcuenta_doc (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying, 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
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
  tipo_pago VARCHAR DEFAULT 'cheque'::character varying NOT NULL, 
  fecha DATE NOT NULL, 
  nro_tramite VARCHAR(150) NOT NULL, 
  estado VARCHAR(100) NOT NULL, 
  sw_modo VARCHAR(40) DEFAULT 'cheque'::character varying NOT NULL, 
  nombre_cheque VARCHAR(300), 
  motivo VARCHAR NOT NULL, 
  id_depto_lb INTEGER, 
  id_funcionario_cuenta_bancaria INTEGER, 
  importe NUMERIC(12,2) DEFAULT 0, 
  id_funcionario_gerente INTEGER NOT NULL, 
  id_depto_conta INTEGER, 
  id_cuenta_bancaria INTEGER, 
  id_gestion INTEGER, 
  id_int_comprobante INTEGER, 
  id_cuenta_bancaria_mov INTEGER, 
  nro_correspondencia VARCHAR(300), 
  fecha_entrega DATE DEFAULT now() NOT NULL, 
  sw_max_doc_rend VARCHAR(10) DEFAULT 'no'::character varying NOT NULL, 
  num_memo VARCHAR(200), 
  num_rendicion VARCHAR(20), 
  id_usuario_reg_ori INTEGER, 
  presu_comprometido VARCHAR(3) DEFAULT 'no'::character varying NOT NULL, 
  importe_total_rendido NUMERIC(32,2) DEFAULT 0 NOT NULL, 
  id_funcionario_aprobador INTEGER, 
  id_periodo INTEGER, 
  fecha_salida DATE, 
  fecha_llegada DATE, 
  tipo_viaje VARCHAR(20), 
  medio_transporte VARCHAR(20), 
  cobertura VARCHAR(20), 
  hora_salida TIME(0) WITHOUT TIME ZONE, 
  hora_llegada TIME(0) WITHOUT TIME ZONE, 
  id_escala INTEGER, 
  id_centro_costo INTEGER, 
  id_solicitud_efectivo INTEGER, 
  id_plantilla INTEGER, 
  dev_tipo VARCHAR(15), 
  dev_a_favor_de VARCHAR(15), 
  dev_nombre_cheque VARCHAR(100), 
  id_caja_dev INTEGER, 
  dev_saldo NUMERIC(18,2), 
  tipo_sol_sigema VARCHAR(20), 
  id_sigema INTEGER, 
  tipo_contrato VARCHAR(30), 
  cantidad_personas INTEGER DEFAULT 1 NOT NULL, 
  tipo_rendicion VARCHAR(15), 
  aplicar_regla_15 VARCHAR(2) DEFAULT 'si'::character varying NOT NULL, 
  id_int_comprobante_devrep INTEGER, 
  dev_saldo_original NUMERIC(18,2), 
  id_moneda_dev INTEGER, 
  CONSTRAINT tcuenta_doc_pkey PRIMARY KEY(id_cuenta_doc), 
  CONSTRAINT fk_tcuenta_doc__id_caja FOREIGN KEY (id_caja)
    REFERENCES tes.tcaja(id_caja)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_cuenta_bancaria FOREIGN KEY (id_cuenta_bancaria)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_cuenta_bancaria_mov FOREIGN KEY (id_cuenta_bancaria_mov)
    REFERENCES tes.tcuenta_bancaria(id_cuenta_bancaria)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_cuenta_doc_fk FOREIGN KEY (id_cuenta_doc_fk)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_depto_conta FOREIGN KEY (id_depto_conta)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_depto_lb FOREIGN KEY (id_depto_lb)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_escala FOREIGN KEY (id_escala)
    REFERENCES cd.tescala(id_escala)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf(id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_funcionario_aprobador FOREIGN KEY (id_funcionario_aprobador)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_funcionario_cuenta_bancaria FOREIGN KEY (id_funcionario_cuenta_bancaria)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_funcionario_gerente FOREIGN KEY (id_funcionario_gerente)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_int_comprobante FOREIGN KEY (id_int_comprobante)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_periodo FOREIGN KEY (id_periodo)
    REFERENCES param.tperiodo(id_periodo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_tipo_cuenta_doc FOREIGN KEY (id_tipo_cuenta_doc)
    REFERENCES cd.ttipo_cuenta_doc(id_tipo_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
;*/

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

/*
CREATE TRIGGER trig_tcuenta_doc
  AFTER UPDATE OF estado 
  ON cd.tcuenta_doc FOR EACH ROW 
  EXECUTE PROCEDURE cd.trig_tcuenta_doc();
*/

-- Copy the temporary table's data to the destination table
/*
INSERT INTO cd.tcuenta_doc (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc, id_tipo_cuenta_doc, id_funcionario, id_depto, id_uo, id_moneda, id_proceso_wf, id_estado_wf, id_caja, id_cuenta_doc_fk, tipo_pago, fecha, nro_tramite, estado, sw_modo, nombre_cheque, motivo, id_depto_lb, id_funcionario_cuenta_bancaria, importe, id_funcionario_gerente, id_depto_conta, id_cuenta_bancaria, id_gestion, id_int_comprobante, id_cuenta_bancaria_mov, nro_correspondencia, fecha_entrega, sw_max_doc_rend, num_memo, num_rendicion, id_usuario_reg_ori, presu_comprometido, importe_total_rendido, id_funcionario_aprobador, id_periodo, fecha_salida, fecha_llegada, tipo_viaje, medio_transporte, cobertura, hora_salida, hora_llegada, id_escala, id_centro_costo, id_solicitud_efectivo, id_plantilla, dev_tipo, dev_a_favor_de, dev_nombre_cheque, id_caja_dev, dev_saldo, tipo_sol_sigema, id_sigema, tipo_contrato, cantidad_personas, tipo_rendicion, aplicar_regla_15, id_int_comprobante_devrep, dev_saldo_original, id_moneda_dev)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc, id_tipo_cuenta_doc, id_funcionario, id_depto, id_uo, id_moneda, id_proceso_wf, id_estado_wf, id_caja, id_cuenta_doc_fk, tipo_pago, fecha, nro_tramite, estado, sw_modo, nombre_cheque, motivo, id_depto_lb, id_funcionario_cuenta_bancaria, importe, id_funcionario_gerente, id_depto_conta, id_cuenta_bancaria, id_gestion, id_int_comprobante, id_cuenta_bancaria_mov, nro_correspondencia, fecha_entrega, sw_max_doc_rend, num_memo, num_rendicion, id_usuario_reg_ori, presu_comprometido, importe_total_rendido, id_funcionario_aprobador, id_periodo, fecha_salida, fecha_llegada, tipo_viaje, medio_transporte, cobertura, hora_salida, hora_llegada, id_escala, id_centro_costo, id_solicitud_efectivo, id_plantilla, dev_tipo, dev_a_favor_de, dev_nombre_cheque, id_caja_dev, dev_saldo, tipo_sol_sigema, id_sigema, tipo_contrato, cantidad_personas, tipo_rendicion, aplicar_regla_15, id_int_comprobante_devrep, dev_saldo_original, id_moneda_dev FROM tcuenta_doc0janka;
*/
-- Restore table's permissions

ALTER TABLE cd.tcuenta_doc_id_cuenta_doc_seq
  OWNER TO postgres;

ALTER TABLE cd.tcuenta_doc
  OWNER TO postgres;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE
  ON cd.tcuenta_doc TO postgres;
GRANT SELECT
  ON cd.tcuenta_doc TO lectura;

-- Drop the temporary table

--DROP TABLE tcuenta_doc0janka;


-- Create a temporary table
/*
CREATE LOCAL TEMPORARY TABLE tcuenta_doc_calculo0evsbj (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE, 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE, 
  estado_reg VARCHAR(10), 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_cuenta_doc_calculo INTEGER, 
  id_cuenta_doc INTEGER, 
  numero INTEGER, 
  destino VARCHAR(200), 
  dias_saldo_ant INTEGER, 
  dias_destino INTEGER, 
  cobertura_sol NUMERIC(18,4), 
  cobertura_hotel_sol NUMERIC(18,4), 
  dias_total_viaje INTEGER, 
  dias_aplicacion_regla INTEGER, 
  hora_salida TIME(0) WITHOUT TIME ZONE, 
  hora_llegada TIME(0) WITHOUT TIME ZONE, 
  escala_viatico NUMERIC(18,2), 
  escala_hotel NUMERIC(18,2), 
  regla_cobertura_dias_acum NUMERIC(18,2), 
  regla_cobertura_hora_salida NUMERIC(18,2), 
  regla_cobertura_hora_llegada NUMERIC(18,2), 
  regla_cobertura_total_dias NUMERIC(18,2), 
  cobertura_aplicada NUMERIC(18,4), 
  cobertura_aplicada_hotel NUMERIC(18,4), 
  dias_hotel INTEGER, 
  cantidad_personas INTEGER
) ;*/

-- Copy the source table's data to the temporary table
/*
INSERT INTO tcuenta_doc_calculo0evsbj (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_calculo, id_cuenta_doc, numero, destino, dias_saldo_ant, dias_destino, cobertura_sol, cobertura_hotel_sol, dias_total_viaje, dias_aplicacion_regla, hora_salida, hora_llegada, escala_viatico, escala_hotel, regla_cobertura_dias_acum, regla_cobertura_hora_salida, regla_cobertura_hora_llegada, regla_cobertura_total_dias, cobertura_aplicada, cobertura_aplicada_hotel, dias_hotel, cantidad_personas)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_calculo, id_cuenta_doc, numero, destino, dias_saldo_ant, dias_destino, cobertura_sol, cobertura_hotel_sol, dias_total_viaje, dias_aplicacion_regla, hora_salida, hora_llegada, escala_viatico, escala_hotel, regla_cobertura_dias_acum, regla_cobertura_hora_salida, regla_cobertura_hora_llegada, regla_cobertura_total_dias, cobertura_aplicada, cobertura_aplicada_hotel, dias_hotel, cantidad_personas FROM cd.tcuenta_doc_calculo;
*/
-- Drop the source table

--DROP TABLE cd.tcuenta_doc_calculo;

-- Create the destination table
/*
CREATE TABLE cd.tcuenta_doc_calculo (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying, 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_cuenta_doc_calculo SERIAL NOT NULL, 
  id_cuenta_doc INTEGER NOT NULL, 
  numero INTEGER, 
  destino VARCHAR(200), 
  dias_saldo_ant INTEGER, 
  dias_destino INTEGER, 
  cobertura_sol NUMERIC(18,4), 
  cobertura_hotel_sol NUMERIC(18,4), 
  dias_total_viaje INTEGER, 
  dias_aplicacion_regla INTEGER, 
  hora_salida TIME(0) WITHOUT TIME ZONE, 
  hora_llegada TIME(0) WITHOUT TIME ZONE, 
  escala_viatico NUMERIC(18,2), 
  escala_hotel NUMERIC(18,2), 
  regla_cobertura_dias_acum NUMERIC(18,2), 
  regla_cobertura_hora_salida NUMERIC(18,2), 
  regla_cobertura_hora_llegada NUMERIC(18,2), 
  regla_cobertura_total_dias NUMERIC(18,2), 
  cobertura_aplicada NUMERIC(18,4), 
  cobertura_aplicada_hotel NUMERIC(18,4), 
  dias_hotel INTEGER, 
  cantidad_personas INTEGER DEFAULT 1 NOT NULL, 
  CONSTRAINT pk_tcuenta_doc_calculo__id_cuenta_doc_calculo PRIMARY KEY(id_cuenta_doc_calculo), 
  CONSTRAINT fk_tcuenta_doc_calculo__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
;*/

COMMENT ON COLUMN cd.tcuenta_doc_calculo.cantidad_personas
IS 'Cantidad de personas que formarán del viaje';


-- Copy the temporary table's data to the destination table
/*
INSERT INTO cd.tcuenta_doc_calculo (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_calculo, id_cuenta_doc, numero, destino, dias_saldo_ant, dias_destino, cobertura_sol, cobertura_hotel_sol, dias_total_viaje, dias_aplicacion_regla, hora_salida, hora_llegada, escala_viatico, escala_hotel, regla_cobertura_dias_acum, regla_cobertura_hora_salida, regla_cobertura_hora_llegada, regla_cobertura_total_dias, cobertura_aplicada, cobertura_aplicada_hotel, dias_hotel, cantidad_personas)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_calculo, id_cuenta_doc, numero, destino, dias_saldo_ant, dias_destino, cobertura_sol, cobertura_hotel_sol, dias_total_viaje, dias_aplicacion_regla, hora_salida, hora_llegada, escala_viatico, escala_hotel, regla_cobertura_dias_acum, regla_cobertura_hora_salida, regla_cobertura_hora_llegada, regla_cobertura_total_dias, cobertura_aplicada, cobertura_aplicada_hotel, dias_hotel, cantidad_personas FROM tcuenta_doc_calculo0evsbj;
*/
-- Restore table's permissions

ALTER TABLE cd.tcuenta_doc_calculo_id_cuenta_doc_calculo_seq
  OWNER TO postgres;

ALTER TABLE cd.tcuenta_doc_calculo
  OWNER TO postgres;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE
  ON cd.tcuenta_doc_calculo TO postgres;
GRANT SELECT
  ON cd.tcuenta_doc_calculo TO lectura;

-- Drop the temporary table

--DROP TABLE tcuenta_doc_calculo0evsbj;

-- Create a temporary table
/*
CREATE LOCAL TEMPORARY TABLE tcuenta_doc_det0yfkvf (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE, 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE, 
  estado_reg VARCHAR(10), 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_cuenta_doc_det INTEGER, 
  id_cuenta_doc INTEGER, 
  id_centro_costo INTEGER, 
  id_partida INTEGER, 
  id_concepto_ingas INTEGER, 
  monto_mo NUMERIC(18,2), 
  monto_mb NUMERIC(18,2), 
  id_moneda INTEGER, 
  id_moneda_mb INTEGER, 
  id_partida_ejecucion INTEGER, 
  generado VARCHAR(2)
) ;*/

-- Copy the source table's data to the temporary table
/*
INSERT INTO tcuenta_doc_det0yfkvf (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_det, id_cuenta_doc, id_centro_costo, id_partida, id_concepto_ingas, monto_mo, monto_mb, id_moneda, id_moneda_mb, id_partida_ejecucion, generado)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_det, id_cuenta_doc, id_centro_costo, id_partida, id_concepto_ingas, monto_mo, monto_mb, id_moneda, id_moneda_mb, id_partida_ejecucion, generado FROM cd.tcuenta_doc_det;
*/
-- Drop the source table

--DROP TABLE cd.tcuenta_doc_det;

-- Create the destination table
/*
CREATE TABLE cd.tcuenta_doc_det (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying, 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_cuenta_doc_det SERIAL NOT NULL, 
  id_cuenta_doc INTEGER, 
  id_centro_costo INTEGER, 
  id_partida INTEGER, 
  id_concepto_ingas INTEGER, 
  monto_mo NUMERIC(18,2), 
  monto_mb NUMERIC(18,2), 
  id_moneda INTEGER, 
  id_moneda_mb INTEGER, 
  id_partida_ejecucion INTEGER, 
  generado VARCHAR(2) DEFAULT 'no'::character varying NOT NULL, 
  CONSTRAINT pk_tcuenta_doc_det__id_cuenta_doc_det PRIMARY KEY(id_cuenta_doc_det), 
  CONSTRAINT fk_tcuenta_doc_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc_det__id_cuenta_doc FOREIGN KEY (id_cuenta_doc)
    REFERENCES cd.tcuenta_doc(id_cuenta_doc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc_det__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc_det__id_moneda_mb FOREIGN KEY (id_moneda_mb)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT fk_tcuenta_doc_det__id_partida FOREIGN KEY (id_partida)
    REFERENCES pre.tpartida(id_partida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
;*/

COMMENT ON COLUMN cd.tcuenta_doc_det.id_moneda_mb
IS 'Id de la moneda base';


-- Copy the temporary table's data to the destination table
/*
INSERT INTO cd.tcuenta_doc_det (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_det, id_cuenta_doc, id_centro_costo, id_partida, id_concepto_ingas, monto_mo, monto_mb, id_moneda, id_moneda_mb, id_partida_ejecucion, generado)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_cuenta_doc_det, id_cuenta_doc, id_centro_costo, id_partida, id_concepto_ingas, monto_mo, monto_mb, id_moneda, id_moneda_mb, id_partida_ejecucion, generado FROM tcuenta_doc_det0yfkvf;
*/
-- Restore table's permissions

ALTER TABLE cd.tcuenta_doc_det_id_cuenta_doc_det_seq
  OWNER TO postgres;

ALTER TABLE cd.tcuenta_doc_det
  OWNER TO postgres;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE
  ON cd.tcuenta_doc_det TO postgres;
GRANT SELECT
  ON cd.tcuenta_doc_det TO lectura;

-- Drop the temporary table

--DROP TABLE tcuenta_doc_det0yfkvf;

-- Create a temporary table
/*
CREATE LOCAL TEMPORARY TABLE tpago_simple0tclgc (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE, 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE, 
  estado_reg VARCHAR(10), 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_pago_simple INTEGER, 
  id_depto_conta INTEGER, 
  nro_tramite VARCHAR(100), 
  fecha DATE, 
  id_funcionario INTEGER, 
  estado VARCHAR(30), 
  id_estado_wf INTEGER, 
  id_proceso_wf INTEGER, 
  obs VARCHAR(500), 
  id_cuenta_bancaria INTEGER, 
  id_depto_lb INTEGER, 
  id_proveedor INTEGER, 
  id_moneda INTEGER, 
  id_int_comprobante INTEGER, 
  id_int_comprobante_pago INTEGER, 
  id_tipo_pago_simple INTEGER, 
  id_funcionario_pago INTEGER, 
  nro_tramite_asociado VARCHAR(150), 
  importe NUMERIC(18,2), 
  id_obligacion_pago INTEGER, 
  id_caja INTEGER, 
  id_solicitud_efectivo INTEGER
) ;*/

-- Copy the source table's data to the temporary table
/*
INSERT INTO tpago_simple0tclgc (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_pago_simple, id_depto_conta, nro_tramite, fecha, id_funcionario, estado, id_estado_wf, id_proceso_wf, obs, id_cuenta_bancaria, id_depto_lb, id_proveedor, id_moneda, id_int_comprobante, id_int_comprobante_pago, id_tipo_pago_simple, id_funcionario_pago, nro_tramite_asociado, importe, id_obligacion_pago, id_caja, id_solicitud_efectivo)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_pago_simple, id_depto_conta, nro_tramite, fecha, id_funcionario, estado, id_estado_wf, id_proceso_wf, obs, id_cuenta_bancaria, id_depto_lb, id_proveedor, id_moneda, id_int_comprobante, id_int_comprobante_pago, id_tipo_pago_simple, id_funcionario_pago, nro_tramite_asociado, importe, id_obligacion_pago, id_caja, id_solicitud_efectivo FROM cd.tpago_simple;
*/
-- Drop the source table

--DROP TABLE cd.tpago_simple;

-- Create the destination table
/*
CREATE TABLE cd.tpago_simple (
  id_usuario_reg INTEGER, 
  id_usuario_mod INTEGER, 
  fecha_reg TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  fecha_mod TIMESTAMP WITHOUT TIME ZONE DEFAULT now(), 
  estado_reg VARCHAR(10) DEFAULT 'activo'::character varying, 
  id_usuario_ai INTEGER, 
  usuario_ai VARCHAR(300), 
  id_pago_simple SERIAL NOT NULL, 
  id_depto_conta INTEGER, 
  nro_tramite VARCHAR(100), 
  fecha DATE, 
  id_funcionario INTEGER, 
  estado VARCHAR(30), 
  id_estado_wf INTEGER, 
  id_proceso_wf INTEGER, 
  obs VARCHAR(500), 
  id_cuenta_bancaria INTEGER, 
  id_depto_lb INTEGER, 
  id_proveedor INTEGER, 
  id_moneda INTEGER, 
  id_int_comprobante INTEGER, 
  id_int_comprobante_pago INTEGER, 
  id_tipo_pago_simple INTEGER, 
  id_funcionario_pago INTEGER, 
  nro_tramite_asociado VARCHAR(150), 
  importe NUMERIC(18,2), 
  id_obligacion_pago INTEGER, 
  id_caja INTEGER, 
  id_solicitud_efectivo INTEGER, 
  CONSTRAINT tpago_simple_pkey PRIMARY KEY(id_pago_simple), 
  CONSTRAINT tpago_simple_fk FOREIGN KEY (id_proveedor)
    REFERENCES param.tproveedor(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE, 
  CONSTRAINT tpago_simple_fk1 FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
;*/

COMMENT ON COLUMN cd.tpago_simple.nro_tramite_asociado
IS 'Número del trámite asociado al pago a realizar, puede ser del proceso de compra';

COMMENT ON COLUMN cd.tpago_simple.id_obligacion_pago
IS 'ID de la obligacion de pago para relizar el prorrateo por partida en el comprobante diario';


-- Copy the temporary table's data to the destination table
/*
INSERT INTO cd.tpago_simple (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_pago_simple, id_depto_conta, nro_tramite, fecha, id_funcionario, estado, id_estado_wf, id_proceso_wf, obs, id_cuenta_bancaria, id_depto_lb, id_proveedor, id_moneda, id_int_comprobante, id_int_comprobante_pago, id_tipo_pago_simple, id_funcionario_pago, nro_tramite_asociado, importe, id_obligacion_pago, id_caja, id_solicitud_efectivo)
SELECT id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, id_usuario_ai, usuario_ai, id_pago_simple, id_depto_conta, nro_tramite, fecha, id_funcionario, estado, id_estado_wf, id_proceso_wf, obs, id_cuenta_bancaria, id_depto_lb, id_proveedor, id_moneda, id_int_comprobante, id_int_comprobante_pago, id_tipo_pago_simple, id_funcionario_pago, nro_tramite_asociado, importe, id_obligacion_pago, id_caja, id_solicitud_efectivo FROM tpago_simple0tclgc;
*/
-- Restore table's permissions

ALTER TABLE cd.tpago_simple_id_pago_simple_seq
  OWNER TO postgres;

ALTER TABLE cd.tpago_simple
  OWNER TO postgres;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE
  ON cd.tpago_simple TO postgres;
GRANT SELECT
  ON cd.tpago_simple TO lectura;

-- Drop the temporary table

--DROP TABLE tpago_simple0tclgc;


/***********************************F-SCP-CD-JJA-1-01/12/2018****************************************/

/***********************************I-SCP-CD-CAP-0-05/12/2018****************************************/

ALTER TABLE cd.tpago_simple_tmp
  ADD CONSTRAINT tpago_simple_tmp_pkey 
    PRIMARY KEY (id) NOT DEFERRABLE;


ALTER TABLE cd.tcontrol_dui
  ALTER COLUMN id_control_dui SET STATISTICS 0;

ALTER TABLE cd.tcontrol_dui
  ALTER COLUMN dui SET STATISTICS 0;

ALTER TABLE cd.tcontrol_dui
  ALTER COLUMN nro_factura_proveedor SET STATISTICS 0;



/***********************************F-SCP-CD-CAP-0-05/12/2018****************************************/