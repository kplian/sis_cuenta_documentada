<?php
/**
*@package pXP
*@file gen-MODCuentaDocDet.php
*@author  (admin)
*@date 05-09-2017 17:54:29
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaDocDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaDocDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_det_sel';
		$this->transaccion='CD_CDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//captura parametros adicionales para el count
		$this->capturaCount('total_monto_mo','numeric');
		$this->capturaCount('total_monto_mb','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_doc_det','int4');
		$this->captura('id_cuenta_doc','int4');
		$this->captura('monto_mb','numeric');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_partida','int4');
		$this->captura('monto_mo','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('id_moneda_mb','int4');
		$this->captura('moneda','varchar');
		$this->captura('moneda_mb','varchar');
		$this->captura('descripcion_tcc','varchar');
		$this->captura('desc_ingas','varchar');
		$this->captura('desc_partida','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaDocDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_det_ime';
		$this->transaccion='CD_CDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('monto_mb','monto_mb','numeric');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('monto_mo','monto_mo','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_moneda_mb','id_moneda_mb','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaDocDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_det_ime';
		$this->transaccion='CD_CDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_det','id_cuenta_doc_det','int4');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('monto_mb','monto_mb','numeric');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('monto_mo','monto_mo','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_moneda_mb','id_moneda_mb','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaDocDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_det_ime';
		$this->transaccion='CD_CDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_det','id_cuenta_doc_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>