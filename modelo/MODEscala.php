<?php
/**
*@package pXP
*@file gen-MODEscala.php
*@author  (admin)
*@date 04-09-2017 16:10:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEscala extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEscala(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_escala_sel';
		$this->transaccion='CD_EVIA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_escala','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('desde','date');
		$this->captura('observaciones','varchar');
		$this->captura('hasta','date');
		$this->captura('codigo','varchar');
		$this->captura('tipo','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
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
			
	function insertarEscala(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_escala_ime';
		$this->transaccion='CD_EVIA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desde','desde','date');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo','tipo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEscala(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_escala_ime';
		$this->transaccion='CD_EVIA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_escala','id_escala','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('desde','desde','date');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo','tipo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEscala(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_escala_ime';
		$this->transaccion='CD_EVIA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_escala','id_escala','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>