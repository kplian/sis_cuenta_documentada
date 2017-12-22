<?php
/**
*@package pXP
*@file gen-MODCuentaDocItinerario.php
*@author  (admin)
*@date 05-09-2017 14:46:06
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaDocItinerario extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaDocItinerario(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_itinerario_sel';
		$this->transaccion='CD_CDITE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_doc_itinerario','int4');
		$this->captura('fecha_hasta','date');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_desde','date');
		$this->captura('id_destino','int4');
		$this->captura('cantidad_dias','int4');
		$this->captura('id_cuenta_doc','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_destino','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaDocItinerario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_itinerario_ime';
		$this->transaccion='CD_CDITE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('fecha_hasta','fecha_hasta','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_desde','fecha_desde','date');
		$this->setParametro('id_destino','id_destino','int4');
		$this->setParametro('cantidad_dias','cantidad_dias','int4');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaDocItinerario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_itinerario_ime';
		$this->transaccion='CD_CDITE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_itinerario','id_cuenta_doc_itinerario','int4');
		$this->setParametro('fecha_hasta','fecha_hasta','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_desde','fecha_desde','date');
		$this->setParametro('id_destino','id_destino','int4');
		$this->setParametro('cantidad_dias','cantidad_dias','int4');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaDocItinerario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_itinerario_ime';
		$this->transaccion='CD_CDITE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_itinerario','id_cuenta_doc_itinerario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>