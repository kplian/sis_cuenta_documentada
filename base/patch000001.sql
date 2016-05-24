
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
  PRIMARY KEY("id_tipo_Categoria")
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

/***********************************F-SCP-CD-RAC-1-24/05/2016****************************************/





