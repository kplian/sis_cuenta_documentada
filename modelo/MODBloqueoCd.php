<?php
/**
*@package pXP
*@file gen-MODBloqueoCd.php
*@author  (admin)
*@date 06-06-2016 16:40:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODBloqueoCd extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarBloqueoCd(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_bloqueo_cd_sel';
		$this->transaccion='CD_BLOCD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_bloqueo_cd','int4');
		$this->captura('id_tipo_cuenta_doc','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');		
		$this->captura('desc_funcionario','text');
		$this->captura('desc_tipo_cuenta_doc','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarBloqueoCd(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_bloqueo_cd_ime';
		$this->transaccion='CD_BLOCD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarBloqueoCd(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_bloqueo_cd_ime';
		$this->transaccion='CD_BLOCD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_bloqueo_cd','id_bloqueo_cd','int4');
		$this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarBloqueoCd(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_bloqueo_cd_ime';
		$this->transaccion='CD_BLOCD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_bloqueo_cd','id_bloqueo_cd','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>