<?php
/**
*@package pXP
*@file gen-MODCuentaDoc.php
*@author  (admin)
*@date 05-05-2016 16:41:21  
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
class MODCuentaDoc extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaDoc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_CDOC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');		
		$this->setParametro('historico','historico','varchar');
		$this->setParametro('estado','estado','varchar');		
				
		
		$this->captura('id_cuenta_doc','INTEGER');
		$this->captura('dias_para_rendir','INTEGER');
		
		$this->captura('id_tipo_cuenta_doc','INTEGER');
		$this->captura('id_proceso_wf','INTEGER');
		$this->captura('id_caja','INTEGER');
		$this->captura('nombre_cheque','VARCHAR');
		$this->captura('id_uo','INTEGER');
		$this->captura('id_funcionario','INTEGER');
		$this->captura('tipo_pago','VARCHAR');
		$this->captura('id_depto','INTEGER');
		$this->captura('id_cuenta_doc_fk','INTEGER');
		$this->captura('nro_tramite','VARCHAR');
		$this->captura('motivo','VARCHAR');
		$this->captura('fecha','DATE');
		$this->captura('fecha_entrega','DATE');
		$this->captura('id_moneda','INTEGER');
		$this->captura('estado','VARCHAR');
		$this->captura('estado_reg','VARCHAR');
		$this->captura('id_estado_wf','INTEGER');
		$this->captura('id_usuario_ai','INTEGER');
		$this->captura('usuario_ai','VARCHAR');
		$this->captura('fecha_reg','TIMESTAMP');
		$this->captura('id_usuario_reg','INTEGER');
		$this->captura('fecha_mod','TIMESTAMP');
		$this->captura('id_usuario_mod','INTEGER');
		$this->captura('usr_reg','VARCHAR');
		$this->captura('usr_mod','VARCHAR');
		$this->captura('desc_moneda','VARCHAR');
		$this->captura('desc_depto','VARCHAR');
		$this->captura('obs','TEXT');
		$this->captura('desc_funcionario','TEXT');
		$this->captura('importe','numeric');
		$this->captura('desc_funcionario_cuenta_bancaria','varchar');
		$this->captura('id_funcionario_cuenta_bancaria','integer');
		$this->captura('id_depto_lb','integer');
		$this->captura('id_depto_conta','integer');
		$this->captura('importe_documentos','numeric');
		$this->captura('importe_retenciones','numeric');		
		$this->captura('importe_depositos','numeric');
		$this->captura('tipo_cuenta_doc','VARCHAR');
		$this->captura('sw_solicitud','VARCHAR');
		$this->captura('sw_max_doc_rend','VARCHAR');
		$this->captura('num_rendicion','VARCHAR');
		$this->captura('importe_total_rendido','numeric');	
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function listarCuentaDocRendicion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_CDOCREN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');		
		$this->setParametro('historico','historico','varchar');
		$this->setParametro('estado','estado','varchar');		
				
		
		$this->captura('id_cuenta_doc','INTEGER');
		$this->captura('id_tipo_cuenta_doc','INTEGER');
		$this->captura('id_proceso_wf','INTEGER');
		$this->captura('id_caja','INTEGER');
		$this->captura('nombre_cheque','VARCHAR');
		$this->captura('id_uo','INTEGER');
		$this->captura('id_funcionario','INTEGER');
		$this->captura('tipo_pago','VARCHAR');
		$this->captura('id_depto','INTEGER');
		$this->captura('id_cuenta_doc_fk','INTEGER');
		$this->captura('nro_tramite','VARCHAR');
		$this->captura('motivo','VARCHAR');
		$this->captura('fecha','DATE');
		$this->captura('id_moneda','INTEGER');
		$this->captura('estado','VARCHAR');
		$this->captura('estado_reg','VARCHAR');
		$this->captura('id_estado_wf','INTEGER');
		$this->captura('id_usuario_ai','INTEGER');
		$this->captura('usuario_ai','VARCHAR');
		$this->captura('fecha_reg','TIMESTAMP');
		$this->captura('id_usuario_reg','INTEGER');
		$this->captura('fecha_mod','TIMESTAMP');
		$this->captura('id_usuario_mod','INTEGER');
		$this->captura('usr_reg','VARCHAR');
		$this->captura('usr_mod','VARCHAR');
		$this->captura('desc_moneda','VARCHAR');
		$this->captura('desc_depto','VARCHAR');
		$this->captura('obs','TEXT');
		$this->captura('desc_funcionario','TEXT');
		$this->captura('importe','numeric');
		$this->captura('desc_funcionario_cuenta_bancaria','varchar');
		$this->captura('id_funcionario_cuenta_bancaria','integer');
		$this->captura('id_depto_lb','integer');
		$this->captura('id_depto_conta','integer');
		$this->captura('importe_documentos','numeric');
		$this->captura('importe_retenciones','numeric');		
		$this->captura('importe_depositos','numeric');
		$this->captura('tipo_cuenta_doc','VARCHAR');
		$this->captura('sw_solicitud','VARCHAR');
		$this->captura('nro_correspondencia','VARCHAR');		
		$this->captura('num_rendicion','VARCHAR');
		
		$this->captura('importe_solicitado','numeric');	
		$this->captura('importe_total_rendido','numeric');	
		$this->captura('id_periodo','integer');
	    $this->captura('periodo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarReporteCuentaDoc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPCD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');


		$this->captura('fecha','DATE');
		$this->captura('fecha_entrega','DATE');
		$this->captura('desc_funcionario1','TEXT');
		$this->captura('nro_tramite','VARCHAR');
		$this->captura('motivo','VARCHAR');
		$this->captura('nro_cheque','INTEGER');
		$this->captura('importe_solicitado','NUMERIC');
		$this->captura('importe_cheque','NUMERIC');
		$this->captura('importe_documentos','NUMERIC');
		$this->captura('importe_depositos','NUMERIC');
		$this->captura('saldo','NUMERIC');
		$this->captura('estado','VARCHAR');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarCuentaDoc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('sw_modo','sw_modo','varchar');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('nombre_cheque','nombre_cheque','varchar');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('motivo','motivo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('id_funcionario_cuenta_bancaria','id_funcionario_cuenta_bancaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

     


			
	function modificarCuentaDoc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('sw_modo','sw_modo','varchar');
		$this->setParametro('id_caja','id_caja','int4');
		$this->setParametro('nombre_cheque','nombre_cheque','varchar');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('tipo_pago','tipo_pago','varchar');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('motivo','motivo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('id_funcionario_cuenta_bancaria','id_funcionario_cuenta_bancaria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaDoc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}


	function alertarFondosLimiteRendicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_LIMREN_INS';
		$this->tipo_procedimiento='IME';
		//definicion de variables
		$this->tipo_conexion='seguridad';
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	 function insertarCuentaDocRendicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOCREN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		
		$this->setParametro('motivo','motivo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('nro_correspondencia','nro_correspondencia','varchar');
		
		
		$this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','integer');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	 
	 
	 
	 function modificarCuentaDocRendicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOCREN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','int4');
		$this->setParametro('motivo','motivo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('nro_correspondencia','nro_correspondencia','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	 
	 function eliminarCuentaDocRendicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOCREN_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	 
	
	function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'cd.ft_cuenta_doc_ime';
        $this->transaccion = 'CD_SIGESCD_IME';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');		
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
		
		$this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_cuenta_bancaria_mov','id_cuenta_bancaria_mov','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_ANTECD_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');		
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function iniciarRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_INIREND_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');		
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function reporteCabeceraCuentaDoc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPCDOC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		
		
		$this->captura('id_cuenta_doc','INTEGER');
		$this->captura('id_tipo_cuenta_doc','INTEGER');
		$this->captura('id_proceso_wf','INTEGER');
		$this->captura('id_caja','INTEGER');
		$this->captura('nombre_cheque','VARCHAR');
		$this->captura('id_uo','INTEGER');
		$this->captura('id_funcionario','INTEGER');
		$this->captura('tipo_pago','VARCHAR');
		$this->captura('id_depto','INTEGER');
		$this->captura('id_cuenta_doc_fk','INTEGER');
		$this->captura('nro_tramite','VARCHAR');
		$this->captura('motivo','VARCHAR');
		$this->captura('fecha','DATE');
		$this->captura('id_moneda','INTEGER');
		$this->captura('estado','VARCHAR');
		$this->captura('estado_reg','VARCHAR');
		$this->captura('id_estado_wf','INTEGER');
		$this->captura('id_usuario_ai','INTEGER');
		$this->captura('usuario_ai','VARCHAR');
		$this->captura('fecha_reg','TIMESTAMP');
		$this->captura('id_usuario_reg','INTEGER');
		$this->captura('fecha_mod','TIMESTAMP');
		$this->captura('id_usuario_mod','INTEGER');
		$this->captura('usr_reg','VARCHAR');
		$this->captura('usr_mod','VARCHAR');
		$this->captura('desc_moneda','VARCHAR');
		$this->captura('desc_depto','VARCHAR');
		$this->captura('obs','TEXT');
		$this->captura('desc_funcionario','TEXT');
		$this->captura('importe','numeric');
		$this->captura('desc_funcionario_cuenta_bancaria','varchar');
		$this->captura('id_funcionario_cuenta_bancaria','integer');
		$this->captura('id_depto_lb','integer');
		$this->captura('id_depto_conta','integer');
		$this->captura('tipo_cuenta_doc','VARCHAR');
		$this->captura('sw_solicitud','VARCHAR');
		$this->captura('lugar','VARCHAR');
		$this->captura('cargo_funcionario','varchar');
		$this->captura('nombre_unidad','VARCHAR');
		$this->captura('importe_literal','VARCHAR');
		$this->captura('motivo_ori','VARCHAR');
		$this->captura('gerente_financiero','VARCHAR');
		$this->captura('cargo_gerente_financiero','VARCHAR');
		
		$this->captura('aprobador','TEXT');
		$this->captura('cargo_aprobador','TEXT');
		
		$this->captura('nro_cbte','VARCHAR');
		$this->captura('num_memo','VARCHAR');
		$this->captura('num_rendicion','VARCHAR');
		$this->captura('nro_cheque','integer');		
		$this->captura('importe_solicitado','numeric');		
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function recuperarRendicionFacturas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPRENDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		
		//Definicion de la lista del resultado del query
		$this->captura('id_doc_compra_venta','int8');
		$this->captura('revisado','varchar');
		$this->captura('movil','varchar');
		$this->captura('tipo','varchar');
		$this->captura('importe_excento','numeric');
		$this->captura('id_plantilla','int4');
		$this->captura('fecha','date');
		$this->captura('nro_documento','varchar');
		$this->captura('nit','varchar');
		$this->captura('importe_ice','numeric');
		$this->captura('nro_autorizacion','varchar');
		$this->captura('importe_iva','numeric');
		$this->captura('importe_descuento','numeric');
		$this->captura('importe_doc','numeric');
		$this->captura('sw_contabilizar','varchar');
		$this->captura('tabla_origen','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('id_origen','int4');
		$this->captura('obs','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo_control','varchar');
		$this->captura('importe_it','numeric');
		$this->captura('razon_social','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_depto','varchar');
		$this->captura('desc_plantilla','varchar');
		$this->captura('importe_descuento_ley','numeric');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('nro_dui','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('desc_comprobante','varchar');
		$this->captura('importe_pendiente','numeric');
		$this->captura('importe_anticipo','numeric');
		$this->captura('importe_retgar','numeric');
		$this->captura('importe_neto','numeric');
		$this->captura('id_auxiliar','integer');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('id_tipo_doc_compra_venta','integer');
		$this->captura('desc_tipo_doc_compra_venta','varchar');
		$this->captura('id_rendicion_det','integer');
		$this->captura('id_cuenta_doc','integer');
		$this->captura('id_cuenta_doc_rendicion','integer');
		$this->captura('detalle','text');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function recuperarRetenciones(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPRENRET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		
		//Definicion de la lista del resultado del query
		$this->captura('retenciones','numeric');	
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
   function recuperarRendicionDepositos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPDEPREN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setCount(false);	
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');

		
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('denominacion','varchar');
		$this->captura('nro_cuenta','varchar');
		$this->captura('fecha','date');
		$this->captura('tipo','varchar');
		$this->captura('importe_deposito','numeric');
		$this->captura('origen','varchar');
		$this->captura('nombre_finalidad','varchar');
		$this->captura('id_libro_bancos','int4');
		$this->captura('observaciones','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->consulta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
   
   function recuperarRendicionDepositosConsolidado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPDEPRENCO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setCount(false);	
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('denominacion','varchar');
		$this->captura('nro_cuenta','varchar');
		$this->captura('fecha','date');
		$this->captura('tipo','varchar');
		$this->captura('importe_deposito','numeric');
		$this->captura('origen','varchar');
		$this->captura('nombre_finalidad','varchar');
		$this->captura('id_libro_bancos','int4');
		$this->captura('observaciones','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->consulta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
   
   function recuperarDetalleConsolidado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPCONFA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setCount(false);	
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');

		//Definicion de la lista del resultado del query
		
		$this->captura('id_doc_concepto','INTEGER');
		$this->captura('codigo_cc','TEXT');
		$this->captura('desc_tipo_presupuesto','VARCHAR');
		$this->captura('desc_categoria_programatica','TEXT');
		$this->captura('codigo_categoria','VARCHAR');
		$this->captura('desc_ingas','VARCHAR');
		$this->captura('descripcion','TEXT');
		$this->captura('precio_total_final','NUMERIC');
		$this->captura('precio_total','NUMERIC');
		$this->captura('precio_unitario','NUMERIC');
		$this->captura('cantidad_sol','NUMERIC');
		$this->captura('fecha','DATE');
		$this->captura('razon_social','VARCHAR');
		$this->captura('nro_documento','VARCHAR');
		$this->captura('desc_plantilla','VARCHAR');
		$this->captura('partida','VARCHAR');
		$this->captura('id_int_comprobante','INTEGER');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->consulta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function recuperarConsolidado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_sel';
		$this->transaccion='CD_REPCON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setCount(false);
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');

		//Definicion de la lista del resultado del query

		$this->captura('codigo_categoria','VARCHAR');
		$this->captura('partida','VARCHAR');
		$this->captura('importe','NUMERIC');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->consulta); exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function ampliarRendicion(){
    	
		
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_AMPCDREN_IME';
		$this->tipo_procedimiento='IME';//tipo de transaccion
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('dias_ampliado','dias_ampliado','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function cambiarBloqueo(){
    	
		
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CAMBLOQ_IME';
		$this->tipo_procedimiento='IME';//tipo de transaccion
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function cambioUsuarioReg(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CAMBUSUREG_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_usuario_new','id_usuario_new','int4');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	
		


		
}  	
?>