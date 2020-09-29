<?php
/**
*@package pXP
*@file gen-MODPagoSimpleDet.php
*@author  (admin)
*@date 01-01-2018 06:21:25
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

#ETR-779	29/09/2020		manuel guerra			mostrar nota de debitoe en grilla
*/

class MODPagoSimpleDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPagoSimpleDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_pago_simple_det_sel';
		$this->transaccion='CD_PASIDE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//captura parametros adicionales para el count
		$this->capturaCount('total_importe_ice','numeric');
		$this->capturaCount('total_importe_excento','numeric');
		$this->capturaCount('total_importe_it','numeric');
		$this->capturaCount('total_importe_iva','numeric');
		$this->capturaCount('total_importe_descuento','numeric');
		$this->capturaCount('total_importe_doc','numeric');
		$this->capturaCount('total_importe_retgar','numeric');
		$this->capturaCount('total_importe_anticipo','numeric');
		$this->capturaCount('tota_importe_pendiente','numeric');
		$this->capturaCount('total_importe_neto','numeric');
		$this->capturaCount('total_importe_descuento_ley','numeric');
		$this->capturaCount('total_importe_pago_liquido','numeric');
		$this->capturaCount('total_importe_aux_neto','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_pago_simple_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_pago_simple','int4');
		$this->captura('id_doc_compra_venta','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg_ps','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');



		$this->captura('revisado','varchar');
		$this->captura('movil','varchar');
		$this->captura('tipo','varchar');
		$this->captura('importe_excento','numeric');
		$this->captura('id_plantilla','int4');
		$this->captura('fecha','date');
		$this->captura('nro_documento','varchar');
		$this->captura('nit','varchar');
		$this->captura('importe_ice','numeric');
		$this->captura('nro_autorizacion','varchar');
		$this->captura('importe_iva','numeric');
		$this->captura('importe_descuento','numeric');
		$this->captura('importe_doc','numeric');
		$this->captura('sw_contabilizar','varchar');
		$this->captura('tabla_origen','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('id_origen','int4');
		$this->captura('obs','varchar');
		$this->captura('codigo_control','varchar');
		$this->captura('importe_it','numeric');
		$this->captura('razon_social','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usr_reg_dcv','varchar');
		
		$this->captura('desc_depto','varchar');
		$this->captura('desc_plantilla','varchar');
		$this->captura('importe_descuento_ley','numeric');
		$this->captura('importe_pago_liquido','numeric');
		$this->captura('nro_dui','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('desc_comprobante','varchar');
		
		
		$this->captura('importe_pendiente','numeric');
		$this->captura('importe_anticipo','numeric');
		$this->captura('importe_retgar','numeric');
		$this->captura('importe_neto','numeric');		
		$this->captura('id_auxiliar','integer');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');		
		$this->captura('id_tipo_doc_compra_venta','integer');
		$this->captura('desc_tipo_doc_compra_venta','varchar');		
		$this->captura('importe_aux_neto','numeric');
		
		$this->captura('id_funcionario','integer');		
		$this->captura('desc_funcionario2','varchar');
		
		$this->captura('sw_pgs','varchar');
		$this->captura('nota_debito_agencia','varchar');
		

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
		
			
	function insertarPagoSimpleDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_det_ime';
		$this->transaccion='CD_PASIDE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_pago_simple','id_pago_simple','int4');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPagoSimpleDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_det_ime';
		$this->transaccion='CD_PASIDE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pago_simple_det','id_pago_simple_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_pago_simple','id_pago_simple','int4');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPagoSimpleDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_pago_simple_det_ime';
		$this->transaccion='CD_PASIDE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pago_simple_det','id_pago_simple_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>