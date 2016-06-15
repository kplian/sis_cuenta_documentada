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
     v_num						varchar;
BEGIN
 
   
    IF TG_OP = 'UPDATE' THEN
    
     
   
           IF NEW.estado = 'contabilizado' THEN  
           
             
                  
                  --genera numero correlativo de memo de asginacion de fondos
                 
                   v_num =   param.f_obtener_correlativo(
                          'MEMOFA', 
                           NEW.id_gestion,-- par_id, 
                           NULL, --id_uo 
                           NEW.id_depto,    -- id_depto
                           NEW.id_usuario_reg, 
                           'CD', 
                           NULL);
                  
                  
                  update cd.tcuenta_doc pp set
                    num_memo = v_num ,
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