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
		$this->captura('desc_tipo_cuenta_doc','VARCHAR');
		$this->captura('sw_solicitud','VARCHAR');
		
		
		
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
		$this->captura('desc_tipo_cuenta_doc','VARCHAR');
		$this->captura('sw_solicitud','VARCHAR');
		
		
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
	
	
	 function insertarCuentaDocRendicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_ime';
		$this->transaccion='CD_CDOCREN_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		
		$this->setParametro('motivo','motivo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('importe','importe','numeric');
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
	
	
	
			
}
?>