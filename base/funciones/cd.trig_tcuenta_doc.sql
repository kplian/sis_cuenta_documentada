--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.trig_tcuenta_doc (
)
RETURNS trigger AS
$body$
DECLARE
     v_reg_pres_par 			record;
     v_reg_pres_par_new			record;
     v_reg						record;
     v_id_partida_new			integer;
     v_id_partida_old			integer;
BEGIN
 
   
    IF TG_OP = 'UPDATE' THEN
   
           IF NEW.estado = 'contabiizado' THEN       
                  update cd.tcuenta_doc pp set      
                    fecha_entrega = now()::Date       
                  where id_cuenta_doc = NEW.id_cuenta_doc;          
          END IF;        
   
   END IF;   
 
   
   RETURN NULL;
   
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;