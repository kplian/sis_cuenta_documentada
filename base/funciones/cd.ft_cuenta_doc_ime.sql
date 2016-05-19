--------------- SQL ---------------

CREATE OR REPLACE FUNCTION cd.ft_cuenta_doc_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Cuenta Documentada
 FUNCION: 		cd.ft_cuenta_doc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cd.tcuenta_doc'
 AUTOR: 		 (admin)
 FECHA:	        05-05-2016 16:41:21
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    			integer;
	v_parametros           			record;
	v_id_requerimiento     			integer;
	v_resp		            		varchar;
	v_nombre_funcion        		text;
	v_mensaje_error         		text;
	v_id_cuenta_doc					integer;
    v_codigo_proceso_macro     		varchar;
    va_id_funcionario_gerente		integer[];
    v_id_proceso_macro     			integer;
    v_codigo_tipo_proceso    		varchar;
    v_num_tramite					varchar;
    v_id_proceso_wf					integer;
    v_id_estado_wf					integer;
    v_codigo_estado					varchar;
    v_resp_doc 						boolean;
    v_id_gestion					integer;
    v_id_uo							integer;
    v_id_tipo_cuenta_doc			integer;
    v_id_tipo_estado				integer;
    v_codigo_estado_siguiente		varchar;
    v_id_depto 						integer;
    v_obs							varchar;
    v_id_estado_actual 				integer;
    v_registros_proc   				record;
    v_codigo_tipo_pro   			varchar;
    v_operacion 					varchar;
    v_registros_cd					record;
    v_id_funcionario				integer;
    v_id_usuario_reg				integer;
    v_id_estado_wf_ant				integer;
    v_acceso_directo			 	varchar;
    v_clase						 	varchar;
    v_parametros_ad				 	varchar;
    v_tipo_noti					 	varchar;
    v_titulo					  	varchar;
    v_id_depto_lb					integer;
    v_id_cuenta_bancaria			integer;
    v_id_depto_conta			    integer;
    v_contador 			            integer;
    v_codigo_tp						varchar;
    va_id_tipo_estado_pro 			integer[];
    va_codigo_estado_pro 			varchar[];
    va_disparador_pro 				varchar[];
    va_regla_pro 					varchar[];
    va_prioridad_pro 				integer[];
    v_importe_rendicion				numeric;
    v_fecha							date;
			    
BEGIN

    v_nombre_funcion = 'cd.ft_cuenta_doc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'CD_CDOC_INS'
 	#DESCRIPCION:	Insercion de registros de fondos en avance
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/

	if(p_transaccion='CD_CDOC_INS')then
					
        begin
        
            v_codigo_proceso_macro = pxp.f_get_variable_global('cd_codigo_macro_fondo_avance');
            
            
            --si el funcionario que solicita es un gerente .... es el mimso encargado de aprobar
                
             IF exists(select 1 from orga.tuo_funcionario uof 
                       inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = 'activo'
                       inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional and no.numero_nivel in (1)
                       where  uof.estado_reg = 'activo' and  uof.id_funcionario = v_parametros.id_funcionario ) THEN
                  
                  va_id_funcionario_gerente[1] = v_parametros.id_funcionario;
                 
             ELSE
                --si tiene funcionario identificar el gerente correspondientes
                IF  v_parametros.id_funcionario is not NULL THEN
                    
                    SELECT  
                       pxp.aggarray(id_funcionario) 
                     into
                       va_id_funcionario_gerente
                     FROM orga.f_get_aprobadores_x_funcionario(v_parametros.fecha,  v_parametros.id_funcionario , 'todos', 'si', 'todos', 'ninguno') AS (id_funcionario integer);      
                    --NOTA el valor en la primera posicion del array es el genre de menor nivel
                END IF;  
            END IF;
            
            -- recupera la uo gerencia del funcionario
            v_id_uo =   orga.f_get_uo_gerencia_ope(NULL, v_parametros.id_funcionario, v_parametros.fecha::Date);
            
             --obtener id del proceso macro
        
             select 
               pm.id_proceso_macro
             into
               v_id_proceso_macro
             from wf.tproceso_macro pm
             where pm.codigo = v_codigo_proceso_macro;
              
              
             If v_id_proceso_macro is NULL THEN
               raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;  
             END IF;
              
             
             --   obtener el codigo del tipo_proceso
             select   tp.codigo 
                 into v_codigo_tipo_proceso
             from  wf.ttipo_proceso tp 
             where   tp.id_proceso_macro = v_id_proceso_macro
                      and tp.estado_reg = 'activo' and tp.inicio = 'si';
                  
               
             IF v_codigo_tipo_proceso is NULL THEN
                 raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
             END IF;
             
             select 
                per.id_gestion
             into 
                v_id_gestion
             from param.tperiodo per
             where per.fecha_ini <= v_parametros.fecha and per.fecha_fin >= v_parametros.fecha
             limit 1 offset 0;
        	
             
             -- inciar el tramite en el sistema de WF
            SELECT 
                   ps_num_tramite ,
                   ps_id_proceso_wf ,
                   ps_id_estado_wf ,
                   ps_codigo_estado 
                into
                   v_num_tramite,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado   
                    
            FROM wf.f_inicia_tramite(
                   p_id_usuario,
                   v_parametros._id_usuario_ai,
                   v_parametros._nombre_usuario_ai,
                   v_id_gestion, 
                   v_codigo_tipo_proceso, 
                   v_parametros.id_funcionario,
                   v_parametros.id_depto,
                   'Solicitu de efectivo por fondo en avance',
                   '' );
                   
                   
            --recupera el tipo de cuenta documentada, SOLFONAVA, para solicutd de fondo en avance
            
            select 
               tcd.id_tipo_cuenta_doc
            into 
              v_id_tipo_cuenta_doc
            from cd.ttipo_cuenta_doc tcd
            where tcd.codigo = 'SOLFONAVA'; 
            
            --Sentencia de la insercion
        	insert into cd.tcuenta_doc(
                id_tipo_cuenta_doc,
                id_proceso_wf,
                nombre_cheque,
                id_uo,
                id_funcionario,
                tipo_pago,
                id_depto,
                nro_tramite,
                motivo,
                fecha,
                id_moneda,
                estado,
                estado_reg,
                id_estado_wf,
                id_usuario_ai,
                usuario_ai,
                fecha_reg,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                id_funcionario_gerente,
                importe,
                id_funcionario_cuenta_bancaria,
                id_gestion
          	) values(
                v_id_tipo_cuenta_doc,
                v_id_proceso_wf,
                v_parametros.nombre_cheque,
                v_id_uo,
                v_parametros.id_funcionario,
                v_parametros.tipo_pago,
                v_parametros.id_depto,
                v_num_tramite,
                v_parametros.motivo,
                v_parametros.fecha,
                v_parametros.id_moneda,
                v_codigo_estado,
                'activo',
                v_id_estado_wf,
                v_parametros._id_usuario_ai,
                v_parametros._nombre_usuario_ai,
                now(),
                p_id_usuario,
                null,
                null,
                va_id_funcionario_gerente[1],
                v_parametros.importe,
                v_parametros.id_funcionario_cuenta_bancaria,
                v_id_gestion
							
			)RETURNING id_cuenta_doc into v_id_cuenta_doc;
            
            
             -- inserta documentos en estado borrador si estan configurados
            v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
            -- verificar documentos
            v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Documentada almacenado(a) con exito (id_cuenta_doc'||v_id_cuenta_doc||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc',v_id_cuenta_doc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/

	elsif(p_transaccion='CD_CDOC_MOD')then

		begin
        
            IF exists(select 1 from orga.tuo_funcionario uof 
                       inner join orga.tuo uo on uo.id_uo = uof.id_uo and uo.estado_reg = 'activo'
                       inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional and no.numero_nivel in (1)
                       where  uof.estado_reg = 'activo' and  uof.id_funcionario = v_parametros.id_funcionario ) THEN
                  
                  va_id_funcionario_gerente[1] = v_parametros.id_funcionario;
                 
             ELSE
                --si tiene funcionario identificar el gerente correspondientes
                IF  v_parametros.id_funcionario is not NULL THEN
                    
                    SELECT  
                       pxp.aggarray(id_funcionario) 
                     into
                       va_id_funcionario_gerente
                     FROM orga.f_get_aprobadores_x_funcionario(v_parametros.fecha,  v_parametros.id_funcionario , 'todos', 'si', 'todos', 'ninguno') AS (id_funcionario integer);      
                    --NOTA el valor en la primera posicion del array es el genre de menor nivel
                END IF;  
            END IF;
            
            -- recupera la uo gerencia del funcionario
            v_id_uo =   orga.f_get_uo_gerencia_ope(NULL, v_parametros.id_funcionario, v_parametros.fecha::Date);
            
             select 
                per.id_gestion
             into 
                v_id_gestion
             from param.tperiodo per
             where per.fecha_ini <= v_parametros.fecha and per.fecha_fin >= v_parametros.fecha
             limit 1 offset 0;
            
            
			--Sentencia de la modificacion
			update cd.tcuenta_doc set
                nombre_cheque = v_parametros.nombre_cheque,			
                id_funcionario = v_parametros.id_funcionario,
                tipo_pago = v_parametros.tipo_pago,
                id_depto = v_parametros.id_depto,			
                motivo = v_parametros.motivo,
                fecha = v_parametros.fecha,
                id_moneda = v_parametros.id_moneda,
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario,
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai = v_parametros._nombre_usuario_ai,
                importe = v_parametros.importe,
                id_funcionario_cuenta_bancaria =  v_parametros.id_funcionario_cuenta_bancaria,
                id_funcionario_gerente =  va_id_funcionario_gerente[1],
                id_uo = v_id_uo,
                id_gestion = v_id_gestion
            where id_cuenta_doc=v_parametros.id_cuenta_doc;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Documentada modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc',v_parametros.id_cuenta_doc::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'CD_CDOC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		05-05-2016 16:41:21
	***********************************/

	elsif(p_transaccion='CD_CDOC_ELI')then

		begin
			
             select 
                c.id_cuenta_doc,
                c.estado 
             into 
             v_registros_cd
             from cd.tcuenta_doc c
             where id_cuenta_doc=v_parametros.id_cuenta_doc; 
             
             
             IF v_registros_cd.estado != 'borrador' THEN  
                raise exception 'Solo puede eliminar regitros en borrador';
             END IF;
             
             --Sentencia de la modificacion
			 update cd.tcuenta_doc set
                estado_reg = 'inactivo'			
             where id_cuenta_doc=v_parametros.id_cuenta_doc;   
            
            
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuenta Documentada inactivada(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_doc',v_parametros.id_cuenta_doc::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
    
    /*********************************    
 	#TRANSACCION:  'CD_SIGESCD_IME'
 	#DESCRIPCION:  cambia al siguiente estado	
 	#AUTOR:		RAC	
 	#FECHA:		16-05-2016 12:12:51
	***********************************/

	elseif(p_transaccion='CD_SIGESCD_IME')then   
        begin
        
         /*   PARAMETROS
         
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        */
        
        
        
        --obtenermos datos basicos
          select
              c.id_proceso_wf,
              c.id_estado_wf,
              c.estado
              
             into
              v_id_proceso_wf,
              v_id_estado_wf,
              v_codigo_estado
              
          from cd.tcuenta_doc c
          where c.id_cuenta_doc = v_parametros.id_cuenta_doc;
          
         
         
          -- recupera datos del estado
         
           select 
            ew.id_tipo_estado ,
            te.codigo
           into 
            v_id_tipo_estado,
            v_codigo_estado
          from wf.testado_wf ew
          inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
          where ew.id_estado_wf = v_parametros.id_estado_wf_act;
        
         
           -- obtener datos tipo estado
           select
                 te.codigo
            into
                 v_codigo_estado_siguiente
           from wf.ttipo_estado te
           where te.id_tipo_estado = v_parametros.id_tipo_estado;
                
           IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
              v_id_depto = v_parametros.id_depto_wf;
           END IF;
                
           IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
                  v_obs=v_parametros.obs;
           ELSE
                  v_obs='---';
           END IF;
            
           ---------------------------------------
           -- REGISTA EL SIGUIENTE ESTADO DEL WF.
           ---------------------------------------
           
           
           --configurar acceso directo para la alarma   
            v_acceso_directo = '';
            v_clase = '';
            v_parametros_ad = '';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'Visto Bueno';
             
           
           IF   v_codigo_estado_siguiente not in('borrador','finalizado','anulado')   THEN
                  v_acceso_directo = '../../../sis_cuenta_documentada/vista/CuentaDoc/CuentaDocVb.php';
                 v_clase = 'CuentaDocVb';
                 v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                 v_tipo_noti = 'notificacion';
                 v_titulo  = 'Visto Bueno';
             
           END IF;
            
           v_id_estado_actual =  wf.f_registra_estado_wf(  v_parametros.id_tipo_estado, 
                                                           v_parametros.id_funcionario_wf, 
                                                           v_parametros.id_estado_wf_act, 
                                                           v_id_proceso_wf,
                                                           p_id_usuario,
                                                           v_parametros._id_usuario_ai,
                                                           v_parametros._nombre_usuario_ai,
                                                           v_id_depto,                       --depto del estado anterior
                                                           v_obs,
                                                           v_acceso_directo,
                                                           v_clase,
                                                           v_parametros_ad,
                                                           v_tipo_noti,
                                                           v_titulo);
                                                             
          --------------------------------------
          -- registra los procesos disparados
          --------------------------------------
         
          FOR v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) LOOP
    
               -- get cdigo tipo proceso
               select   
                  tp.codigo 
               into 
                  v_codigo_tipo_pro   
               from wf.ttipo_proceso tp 
               where  tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;
          
          
              -- disparar creacion de procesos seleccionados
              SELECT
                       ps_id_proceso_wf,
                       ps_id_estado_wf,
                       ps_codigo_estado
                 into
                       v_id_proceso_wf,
                       v_id_estado_wf,
                       v_codigo_estado
              FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario,
                       v_parametros._id_usuario_ai,
                       v_parametros._nombre_usuario_ai,
                       v_id_estado_actual, 
                       v_registros_proc.id_funcionario_wf_pro, 
                       v_registros_proc.id_depto_wf_pro,
                       v_registros_proc.obs_pro,
                       v_codigo_tipo_pro,    
                       v_codigo_tipo_pro);
                       
                       
           END LOOP; 
           
       
        
           
           IF  pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria') THEN
              v_id_cuenta_bancaria =  v_parametros.id_cuenta_bancaria;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'id_depto_lb') THEN
              v_id_depto_lb =  v_parametros.id_depto_lb;
           END IF;
           
           IF  pxp.f_existe_parametro(p_tabla,'id_depto_conta') THEN
              v_id_depto_conta =  v_parametros.id_depto_conta;
           END IF;
           
          
           
           
           
          --------------------------------------------------
          --  ACTUALIZA EL NUEVO ESTADO DEL PRESUPUESTO
          ----------------------------------------------------
               
           
          IF  cd.f_fun_inicio_cuenta_doc_wf(p_id_usuario, 
           									v_parametros._id_usuario_ai, 
                                            v_parametros._nombre_usuario_ai, 
                                            v_id_estado_actual, 
                                            v_id_proceso_wf, 
                                            v_codigo_estado_siguiente,
                                            v_id_depto_lb,
                                            v_id_cuenta_bancaria,
                                            v_id_depto_conta,
                                            v_codigo_estado
                                            ) THEN
          
                                              
          END IF;
          
         
             
          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del cuenta documentada id='||v_parametros.id_cuenta_doc); 
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          
          
          -- Devuelve la respuesta
          return v_resp;
        
     end;  


	/*********************************    
 	#TRANSACCION:  'CD_ANTECD_IME'
 	#DESCRIPCION: retrocede el estado de la cuenta documentada
 	#AUTOR:		RAC	
 	#FECHA:		16-05-2016 12:12:51
	***********************************/

	elseif(p_transaccion='CD_ANTECD_IME')then   
        begin
        
        v_operacion = 'anterior';
        
        IF  pxp.f_existe_parametro(p_tabla , 'estado_destino')  THEN
           v_operacion = v_parametros.estado_destino;
        END IF;
        
    
        
        --obtenermos datos basicos
        select
            c.id_cuenta_doc,
            c.id_proceso_wf,
            c.estado,
            pwf.id_tipo_proceso
        into 
            v_registros_cd
            
        from cd.tcuenta_doc  c
        inner  join wf.tproceso_wf pwf  on  pwf.id_proceso_wf = c.id_proceso_wf
        where c.id_proceso_wf  = v_parametros.id_proceso_wf;
        
        
        IF v_registros_cd.estado = 'aprobado' THEN
            raise exception 'El presupuesto ya se encuentra aprobado, solo puede modificar a traves de la interface de ajustes presupuestarios';
        END IF;
        
        
        v_id_proceso_wf = v_registros_cd.id_proceso_wf;
        
        IF  v_operacion = 'anterior' THEN
            --------------------------------------------------
            --Retrocede al estado inmediatamente anterior
            -------------------------------------------------
           --recuperaq estado anterior segun Log del WF
              SELECT  
             
                 ps_id_tipo_estado,
                 ps_id_funcionario,
                 ps_id_usuario_reg,
                 ps_id_depto,
                 ps_codigo_estado,
                 ps_id_estado_wf_ant
              into
                 v_id_tipo_estado,
                 v_id_funcionario,
                 v_id_usuario_reg,
                 v_id_depto,
                 v_codigo_estado,
                 v_id_estado_wf_ant 
              FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);
              
              
             
              
              
        ELSE
           --recupera el estado inicial
           -- recuperamos el estado inicial segun tipo_proceso
             
             SELECT  
               ps_id_tipo_estado,
               ps_codigo_estado
             into
               v_id_tipo_estado,
               v_codigo_estado
             FROM wf.f_obtener_tipo_estado_inicial_del_tipo_proceso(v_registros_cd.id_tipo_proceso);
             
             
             
             --busca en log e estado de wf que identificamos como el inicial
             SELECT 
               ps_id_funcionario,
               ps_id_depto
             into
               v_id_funcionario,
               v_id_depto
             FROM wf.f_obtener_estado_segun_log_wf(v_id_estado_wf, v_id_tipo_estado);
             
            
        
        
        END IF; 
          
          
          
         --configurar acceso directo para la alarma   
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';
             
           
           IF   v_codigo_estado_siguiente not in('borrador','finalizado','anulado')   THEN
                 v_acceso_directo = '../../../sis_cuenta_documentada/vista/CuentaDoc/CuentaDocVb.php';
                 v_clase = 'CuentaDocVb';
                 v_parametros_ad = '{filtro_directo:{campo:"cd.id_proceso_wf_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                 v_tipo_noti = 'notificacion';
                 v_titulo  = 'Visto Bueno';
             
           END IF;
             
          
          -- registra nuevo estado
                      
          v_id_estado_actual = wf.f_registra_estado_wf(
                v_id_tipo_estado,                --  id_tipo_estado al que retrocede
                v_id_funcionario,                --  funcionario del estado anterior
                v_parametros.id_estado_wf,       --  estado actual ...
                v_id_proceso_wf,                 --  id del proceso actual
                p_id_usuario,                    -- usuario que registra
                v_parametros._id_usuario_ai,
                v_parametros._nombre_usuario_ai,
                v_id_depto,                       --depto del estado anterior
                '[RETROCESO] '|| v_parametros.obs,
                v_acceso_directo,
                v_clase,
                v_parametros_ad,
                v_tipo_noti,
                v_titulo);
                      
              IF  not cd.f_fun_regreso_cuenta_doc_wf(p_id_usuario, 
                                                   v_parametros._id_usuario_ai, 
                                                   v_parametros._nombre_usuario_ai, 
                                                   v_id_estado_actual, 
                                                   v_parametros.id_proceso_wf, 
                                                   v_codigo_estado) THEN
            
               raise exception 'Error al retroceder estado';
            
            END IF;              
                         
                         
         -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la cuenta documentada)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
          --Devuelve la respuesta
            return v_resp;
                        
        
        end;     
	
    
	/*********************************    
 	#TRANSACCION:  'CD_INIREND_IME'
 	#DESCRIPCION: Inicia proceso de rendicion, solo incluye los documentos sin rendicion
 	#AUTOR:		RAC	
 	#FECHA:		16-05-2016 12:12:51
	***********************************/
     elseif(p_transaccion='CD_INIREND_IME')then   
        
        begin
        
            v_importe_rendicion = 0;
            
            --sumar las facturas a rendir
            select 
               sum(COALESCE(dcv.importe_pago_liquido,0))
            into 
               v_importe_rendicion
            from cd.trendicion_det r
            inner join conta.tdoc_compra_venta dcv on dcv.id_doc_compra_venta = r.id_doc_compra_venta
            where   r.id_cuenta_doc = v_parametros.id_cuenta_doc 
                     and r.id_cuenta_doc_rendicion is null
                     and r.estado_reg = 'activo' and dcv.estado_reg = 'activo';
                     
                     
            --TODO sumar los depositos         
                        
            IF v_importe_rendicion = 0 THEN
               raise exception 'No tiene ninguna factura o deposito para rendir';
            END IF;
            
            v_fecha = now();
            
            select 
                per.id_gestion
             into 
                v_id_gestion
             
            from param.tperiodo per
            where per.fecha_ini <= v_fecha and per.fecha_fin >= v_fecha
            limit 1 offset 0;
            
            
            -- recuperar datos de la solicitud
             
            select 
              c.id_estado_wf,
              c.id_proceso_wf,
              c.estado,
              c.id_funcionario,
              c.id_depto,
              c.id_moneda,
              c.id_uo,
              c.id_funcionario_gerente,
              c.nro_tramite,
              c.id_gestion
            into
              v_registros_cd
            from cd.tcuenta_doc c
            where c.id_cuenta_doc = v_parametros.id_cuenta_doc;
            
            -----------------------------------
            -- registra estado de cotizacion
            -- dispara el proceso de cotizacion
            ----------------------------------
          
               SELECT
                           ps_id_proceso_wf,
                           ps_id_estado_wf,
                           ps_codigo_estado
                  into
                           v_id_proceso_wf,
                           v_id_estado_wf,
                           v_codigo_estado
               FROM wf.f_registra_proceso_disparado_wf(
                          p_id_usuario,
                          v_parametros._id_usuario_ai,
                          v_parametros._nombre_usuario_ai,
                          v_registros_cd.id_estado_wf, 
                          v_registros_cd.id_funcionario, 
                          v_registros_cd.id_depto,
                          'Rendición de Cuentas',
                          '','');
        
                 
                 -- recuperar el tipo de cuenta doc para rendiciones
                 
                 select 
                   tcd.id_tipo_cuenta_doc,
                   tp.codigo
                 into
                    v_id_tipo_cuenta_doc,
                    v_codigo_tp
                 from wf.tproceso_wf pwf 
                 inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                 inner join cd.ttipo_cuenta_doc tcd on tcd.codigo_wf = tp.codigo
                 where pwf.id_proceso_wf = v_id_proceso_wf;
            
                 IF  v_id_tipo_cuenta_doc is null THEN
                 	raise exception 'No se encontro un tipo de cuenta doc para el proceso de WF %', v_codigo_tp;
                 END IF;
                
                 -- insertar  el registro cuenta doc para la rendicion 
                 
                 --Sentencia de la insercion
                insert into cd.tcuenta_doc(
                    id_tipo_cuenta_doc,
                    id_proceso_wf,
                    id_uo,
                    id_funcionario,
                    id_depto,
                    nro_tramite,
                    fecha,
                    id_moneda,
                    estado,
                    estado_reg,
                    id_estado_wf,
                    id_usuario_ai,
                    usuario_ai,
                    fecha_reg,
                    id_usuario_reg,
                    id_funcionario_gerente,
                    importe,
                    id_gestion,
                    id_cuenta_doc_fk,
                    motivo
                    
                ) values(
                    v_id_tipo_cuenta_doc,
                    v_id_proceso_wf,
                    v_registros_cd.id_uo,
                    v_registros_cd.id_funcionario,
                    v_registros_cd.id_depto,
                    v_registros_cd.nro_tramite,
                    v_fecha,
                    v_registros_cd.id_moneda,
                    v_codigo_estado,
                    'activo',
                    v_id_estado_wf,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    now(),
                    p_id_usuario,
                    v_registros_cd.id_funcionario_gerente,
                    v_importe_rendicion,  --suma de documentos (liquido pagable) y depositos
                    v_id_gestion,
                    v_parametros.id_cuenta_doc, -- referencia a cuenta de solicitud
    				'Rendición de cuentas'
                )RETURNING id_cuenta_doc into v_id_cuenta_doc;
                
                
                -- inserta documentos en estado borrador si estan configurados
                v_resp_doc =  wf.f_inserta_documento_wf(p_id_usuario, v_id_proceso_wf, v_id_estado_wf);
                -- verificar documentos
                v_resp_doc = wf.f_verifica_documento(p_id_usuario, v_id_estado_wf);
        
             
                -- asociar la los documentos sueltos a la rendición actual  
                update cd.trendicion_det rd set
                  id_cuenta_doc_rendicion =  v_id_cuenta_doc
                where rd.id_cuenta_doc = v_parametros.id_cuenta_doc
                      and rd.id_cuenta_doc_rendicion is null;
                   
                --TODO asociar los depositos a rendidos
             
             ------------------------------------------------------------------
             --cambiar al estado siguiente de cuenta doc de rendicion
             ------------------------------------------------------------------
             
                      SELECT 
                           ps_id_tipo_estado,
                           ps_codigo_estado,
                           ps_disparador,
                           ps_regla,
                           ps_prioridad
                        into
                          va_id_tipo_estado_pro,
                          va_codigo_estado_pro,
                          va_disparador_pro,
                          va_regla_pro,
                          va_prioridad_pro
                      
                      FROM wf.f_obtener_estado_wf(v_id_proceso_wf, v_id_estado_wf, NULL, 'siguiente');        
                    
                     IF  va_id_tipo_estado_pro[2] is not null  THEN
                       raise exception 'El proceso se encuentra mal parametrizado dentro de Work Flow,  el estado borador de rendición solo  admite un estado siguiente,  no admitido (%)',va_codigo_estado_pro[2];
                     END IF;
                      
                  
                  
                  
                    -- registra estado eactual en el WF para rl procesod e compra
                    v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado_pro[1], 
                                                                   NULL, --id_funcionario
                                                                   v_id_estado_wf, 
                                                                   v_id_proceso_wf,
                                                                   p_id_usuario,
                                                                   v_parametros._id_usuario_ai,
                    											   v_parametros._nombre_usuario_ai,                                                                   
                                                                   v_registros_cd.id_depto);
                     
                   
                    
                    -- actuliaza el stado en la rendicion
                     update cd.tcuenta_doc  p set 
                       id_estado_wf =  v_id_estado_actual,
                       estado = va_codigo_estado_pro[1],
                       id_usuario_mod=p_id_usuario,
                       fecha_mod=now()
                     where id_cuenta_doc = v_id_cuenta_doc;
                     
                     
                -- si hay mas de un estado disponible  preguntamos al usuario
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Inicio de rendición)'); 
                v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
                        
                              
               --Devuelve la respuesta
               return v_resp; 
        
        end;   
    
    else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION
				
	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;
				        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;