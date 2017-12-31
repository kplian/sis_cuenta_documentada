<?php
/**
*@package pXP
*@file gen-MODCuentaDocProrrateo.php
*@author  (admin)
*@date 05-12-2017 19:08:39
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaDocProrrateo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaDocProrrateo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_prorrateo_sel';
		$this->transaccion='CD_CDPRO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//captura parametros adicionales para el count
		$this->capturaCount('total_prorrateo','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_doc_prorrateo','int4');
		$this->captura('id_cuenta_doc','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('prorrateo','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cc','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaDocProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_prorrateo_ime';
		$this->transaccion='CD_CDPRO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('prorrateo','prorrateo','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaDocProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_prorrateo_ime';
		$this->transaccion='CD_CDPRO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_prorrateo','id_cuenta_doc_prorrateo','int4');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('prorrateo','prorrateo','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaDocProrrateo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_prorrateo_ime';
		$this->transaccion='CD_CDPRO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_prorrateo','id_cuenta_doc_prorrateo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarCuentaDocProrrateoRes(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_prorrateo_sel';
		$this->transaccion='CD_CDPRORES_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);

		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_centro_costo','int4');
		$this->captura('desc_cc','varchar');
		$this->captura('factor','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>