<?php
/**
*@package pXP
*@file gen-MODTipoPagoSimple.php
*@author  (admin)
*@date 02-12-2017 02:49:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoPagoSimple extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoPagoSimple(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_tipo_pago_simple_sel';
		$this->transaccion='CD_TIPASI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_pago_simple','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('plantilla_cbte','varchar');
		$this->captura('plantilla_cbte_1','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoPagoSimple(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_tipo_pago_simple_ime';
		$this->transaccion='CD_TIPASI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('plantilla_cbte','plantilla_cbte','varchar');
		$this->setParametro('plantilla_cbte_1','plantilla_cbte_1','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoPagoSimple(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_tipo_pago_simple_ime';
		$this->transaccion='CD_TIPASI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_pago_simple','id_tipo_pago_simple','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('plantilla_cbte','plantilla_cbte','varchar');
		$this->setParametro('plantilla_cbte_1','plantilla_cbte_1','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoPagoSimple(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_tipo_pago_simple_ime';
		$this->transaccion='CD_TIPASI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_pago_simple','id_tipo_pago_simple','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>