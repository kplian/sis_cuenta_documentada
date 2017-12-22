<?php
/**
*@package pXP
*@file gen-MODCategoria.php
*@author  (admin)
*@date 05-05-2016 14:07:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCategoria extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCategoria(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_categoria_sel';
		$this->transaccion='CD_CAT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_categoria','int4');
		$this->captura('nombre','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('codigo','varchar');
		$this->captura('monto','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tipo_categoria','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_destino','int4');
		$this->captura('desc_destino','varchar');
		$this->captura('monto_sp','numeric');
		$this->captura('monto_hotel','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCategoria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_categoria_ime';
		$this->transaccion='CD_CAT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_categoria','id_tipo_categoria','int4');
		$this->setParametro('id_destino','id_destino','int4');
		$this->setParametro('monto_sp','monto_sp','numeric');
		$this->setParametro('monto_hotel','monto_hotel','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCategoria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_categoria_ime';
		$this->transaccion='CD_CAT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_categoria','id_categoria','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_categoria','id_tipo_categoria','int4');
		$this->setParametro('id_destino','id_destino','int4');
		$this->setParametro('monto_sp','monto_sp','numeric');
		$this->setParametro('monto_hotel','monto_hotel','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCategoria(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_categoria_ime';
		$this->transaccion='CD_CAT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_categoria','id_categoria','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>