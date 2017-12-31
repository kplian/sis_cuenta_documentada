<?php
/**
*@package pXP
*@file gen-MODPagoSimple.php
*@author  (admin)
*@date 31-12-2017 12:33:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPagoSimple extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPagoSimple(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_pago_simple_sel';
		$this->transaccion='CD_PAGSIM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');		
		$this->setParametro('historico','historico','varchar');
		$this->setParametro('estado','estado','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_pago_simple','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('fecha','date');
		$this->captura('id_funcionario','int4');
		$this->captura('estado','varchar');
		$this->captura('id_estado_wf','int4');
		$this->captura('id_proceso_wf','int4');
		$this->captura('obs','varchar');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('id_depto_lb','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_depto_conta','varchar');
		$this->captura('desc_funcionario','text');
		$this->captura('desc_cuenta_bancaria','varchar');
		$this->captura('desc_depto_lb','varchar');
		$this->captura('id_moneda','integer');
		$this->captura('id_proveedor','integer');
		$this->captura('desc_moneda','varchar');
		$this->captura('desc_proveedor','varchar');
		$this->captura('id_tipo_pago_simple','integer');
		$this->captura('id_funcionario_pago','integer');
		$this->captura('desc_funcionario_pago','text');
		$this->captura('desc_tipo_pago_simple','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPagoSimple(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_ime';
		$this->transaccion='CD_PAGSIM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_funcionario_pago','id_funcionario_pago','int4');
		$this->setParametro('id_tipo_pago_simple','id_tipo_pago_simple','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPagoSimple(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_ime';
		$this->transaccion='CD_PAGSIM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pago_simple','id_pago_simple','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_funcionario_pago','id_funcionario_pago','int4');
		$this->setParametro('id_tipo_pago_simple','id_tipo_pago_simple','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPagoSimple(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_ime';
		$this->transaccion='CD_PAGSIM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pago_simple','id_pago_simple','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'cd.ft_pago_simple_ime';
        $this->transaccion = 'CD_SIGEPS_INS';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_pago_simple','id_pago_simple','int4');
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

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_pago_simple_ime';
        $this->transaccion='CD_ANTEPS_IME';
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

    function agregarDocumentos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_pago_simple_ime';
        $this->transaccion='CD_PSAGRDOC_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
        $this->setParametro('id_pago_simple','id_pago_simple','int4');
        $this->setParametro('id_usuario','id_usuario','int4');
		$this->setParametro('id_plantilla','id_plantilla','integer');
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	function listarDetallePago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_pago_simple_sel';
		$this->transaccion='CD_DETPAG_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion	
		//Definicion de la lista del resultado del query
		$this->captura('id_doc_compra_venta','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('desc_funcionario1','varchar');
		$this->captura('id_plantilla','int4');
		$this->captura('desc_plantilla','varchar');
		
		
		
		$this->captura('id_proveedor','int4');
		$this->captura('rotulo_comercial','varchar');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('importe_excento','numeric');
		$this->captura('fecha_compra_venta','date');
		$this->captura('fecha_pago_simple','date');
		$this->captura('sw_pgs','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>