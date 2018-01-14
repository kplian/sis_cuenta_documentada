<?php
/**
*@package pXP
*@file gen-MODPagoSimplePro.php
*@author  (admin)
*@date 14-01-2018 21:26:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPagoSimplePro extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPagoSimplePro(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_pago_simple_pro_sel';
		$this->transaccion='CD_PASIPR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_pago_simple_pro','int4');
		$this->captura('factor','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_pago_simple','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cc','text');
		$this->captura('desc_partida','text');
		$this->captura('desc_ingas','varchar');
		$this->captura('gestion','integer');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPagoSimplePro(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_pro_ime';
		$this->transaccion='CD_PASIPR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('factor','factor','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_pago_simple','id_pago_simple','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPagoSimplePro(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_pro_ime';
		$this->transaccion='CD_PASIPR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pago_simple_pro','id_pago_simple_pro','int4');
		$this->setParametro('factor','factor','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_pago_simple','id_pago_simple','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPagoSimplePro(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_pro_ime';
		$this->transaccion='CD_PASIPR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pago_simple_pro','id_pago_simple_pro','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>