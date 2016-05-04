
/***********************************I-SCP-RAC-ADQ-1-04/05/2016****************************************/



--------------- SQL ---------------

CREATE TABLE cd.ttipo_cuenta_doc (
  id_tipo_cuenta_doc SERIAL NOT NULL,
  codigo VARCHAR(100),
  nombre VARCHAR(500),
  descripcion VARCHAR,
  PRIMARY KEY(id_tipo_cuenta_doc)
) INHERITS (pxp.tbase)

WITH (oids = false);


/***********************************F-SCP-RAC-ADQ-1-04/05/2016****************************************/

