<?php
/**
*@package pXP
*@file gen-MODEscalaRegla.php
*@author  (admin)
*@date 15-11-2017 18:38:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEscalaRegla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEscalaRegla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_escala_regla_sel';
		$this->transaccion='CD_REGLA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_escala_regla','int4');
		$this->captura('valor','numeric');
		$this->captura('id_escala','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_unidad_medida','int4');
		$this->captura('codigo','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_unidad_medida','varchar');
		$this->captura('desc_ingas','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEscalaRegla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_escala_regla_ime';
		$this->transaccion='CD_REGLA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('id_escala','id_escala','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_unidad_medida','id_unidad_medida','int4');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEscalaRegla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_escala_regla_ime';
		$this->transaccion='CD_REGLA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_escala_regla','id_escala_regla','int4');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('id_escala','id_escala','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_unidad_medida','id_unidad_medida','int4');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEscalaRegla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_escala_regla_ime';
		$this->transaccion='CD_REGLA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_escala_regla','id_escala_regla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>