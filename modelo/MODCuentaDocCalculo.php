<?php
/**
*@package pXP
*@file gen-MODCuentaDocCalculo.php
*@author  (admin)
*@date 15-09-2017 13:16:03
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuentaDocCalculo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuentaDocCalculo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_cuenta_doc_calculo_sel';
		$this->transaccion='CD_CDOCCA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//captura parametros adicionales para el count
		$this->capturaCount('total_viatico','numeric');
		$this->capturaCount('parcial_viatico','numeric');
		$this->capturaCount('parcial_hotel','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_doc_calculo','int4');
		$this->captura('numero','int4');
		$this->captura('destino','varchar');
		$this->captura('dias_saldo_ant','int4');
		$this->captura('dias_destino','int4');
		$this->captura('cobertura_sol','numeric');
		$this->captura('cobertura_hotel_sol','numeric');
		$this->captura('dias_total_viaje','int4');
		$this->captura('dias_aplicacion_regla','int4');
		$this->captura('hora_salida','time');
		$this->captura('hora_llegada','time');
		$this->captura('escala_viatico','numeric');
		$this->captura('escala_hotel','numeric');
		$this->captura('regla_cobertura_dias_acum','numeric');
		$this->captura('regla_cobertura_hora_salida','numeric');
		$this->captura('regla_cobertura_hora_llegada','numeric');
		$this->captura('regla_cobertura_total_dias','numeric');
		$this->captura('cobertura_aplicada','numeric');
		$this->captura('cobertura_aplicada_hotel','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_cuenta_doc','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('parcial_viatico','numeric');
		$this->captura('parcial_hotel','numeric');
		$this->captura('total_viatico','numeric');
		$this->captura('dias_hotel','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('cantidad_personas','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCuentaDocCalculo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_calculo_ime';
		$this->transaccion='CD_CDOCCA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('numero','numero','int4');
		$this->setParametro('destino','destino','varchar');
		$this->setParametro('dias_saldo_ant','dias_saldo_ant','int4');
		$this->setParametro('dias_destino','dias_destino','int4');
		$this->setParametro('cobertura_sol','cobertura_sol','numeric');
		$this->setParametro('cobertura_hotel_sol','cobertura_hotel_sol','numeric');
		$this->setParametro('dias_total_viaje','dias_total_viaje','int4');
		$this->setParametro('dias_aplicacion_regla','dias_aplicacion_regla','int4');
		$this->setParametro('hora_salida','hora_salida','time');
		$this->setParametro('hora_llegada','hora_llegada','time');
		$this->setParametro('escala_viatico','escala_viatico','numeric');
		$this->setParametro('escala_hotel','escala_hotel','numeric');
		$this->setParametro('regla_cobertura_dias_acum','regla_cobertura_dias_acum','numeric');
		$this->setParametro('regla_cobertura_hora_salida','regla_cobertura_hora_salida','numeric');
		$this->setParametro('regla_cobertura_hora_llegada','regla_cobertura_hora_llegada','numeric');
		$this->setParametro('regla_cobertura_total_dias','regla_cobertura_total_dias','numeric');
		$this->setParametro('cobertura_aplicada','cobertura_aplicada','numeric');
		$this->setParametro('cobertura_aplicada_hotel','cobertura_aplicada_hotel','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuentaDocCalculo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_calculo_ime';
		$this->transaccion='CD_CDOCCA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_calculo','id_cuenta_doc_calculo','int4');
		$this->setParametro('numero','numero','int4');
		$this->setParametro('destino','destino','varchar');
		$this->setParametro('dias_saldo_ant','dias_saldo_ant','int4');
		$this->setParametro('dias_destino','dias_destino','int4');
		$this->setParametro('cobertura_sol','cobertura_sol','numeric');
		$this->setParametro('cobertura_hotel_sol','cobertura_hotel_sol','numeric');
		$this->setParametro('dias_total_viaje','dias_total_viaje','int4');
		$this->setParametro('dias_aplicacion_regla','dias_aplicacion_regla','int4');
		$this->setParametro('hora_salida','hora_salida','time');
		$this->setParametro('hora_llegada','hora_llegada','time');
		$this->setParametro('escala_viatico','escala_viatico','numeric');
		$this->setParametro('escala_hotel','escala_hotel','numeric');
		$this->setParametro('regla_cobertura_dias_acum','regla_cobertura_dias_acum','numeric');
		$this->setParametro('regla_cobertura_hora_salida','regla_cobertura_hora_salida','numeric');
		$this->setParametro('regla_cobertura_hora_llegada','regla_cobertura_hora_llegada','numeric');
		$this->setParametro('regla_cobertura_total_dias','regla_cobertura_total_dias','numeric');
		$this->setParametro('cobertura_aplicada','cobertura_aplicada','numeric');
		$this->setParametro('cobertura_aplicada_hotel','cobertura_aplicada_hotel','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuentaDocCalculo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_cuenta_doc_calculo_ime';
		$this->transaccion='CD_CDOCCA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_doc_calculo','id_cuenta_doc_calculo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>