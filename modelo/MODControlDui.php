<?php
/**
*@package pXP
*@file gen-MODControlDui.php
*@author  (jjimenez)
*@date 13-09-2018 15:32:16
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODControlDui extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarControlDui(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_control_dui_sel';
		$this->transaccion='CD_CDUI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_control_dui','int4');
		$this->captura('tramite_anticipo_dui','varchar');
		$this->captura('dui','varchar');
		$this->captura('archivo_comision','varchar');
		$this->captura('nro_comprobante_diario_dui','varchar');
		$this->captura('archivo_dui','varchar');
		$this->captura('nro_comprobante_diario_comision','varchar');
		$this->captura('nro_comprobante_pago_dui','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('monto_comision','numeric');
		$this->captura('tramite_pedido_endesis','varchar');
		$this->captura('monto_dui','numeric');
		$this->captura('nro_factura_proveedor','varchar');
		$this->captura('tramite_comision_agencia','varchar');
		$this->captura('pedido_sap','varchar');
		$this->captura('agencia_despachante','varchar');
		$this->captura('nro_comprobante_pago_comision','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('id_agencia_despachante','int4');
		
		$this->captura('observaciones','text');
		//$this->captura('nombre_agencia_despachante','varchar');
	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarControlDui(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_control_dui_ime';
		$this->transaccion='CD_CDUI_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('tramite_anticipo_dui','tramite_anticipo_dui','varchar');
		$this->setParametro('dui','dui','int4');
		$this->setParametro('archivo_comision','archivo_comision','varchar');
		$this->setParametro('nro_comprobante_diario_dui','nro_comprobante_diario_dui','varchar');
		$this->setParametro('archivo_dui','archivo_dui','varchar');
		$this->setParametro('nro_comprobante_diario_comision','nro_comprobante_diario_comision','varchar');
		$this->setParametro('nro_comprobante_pago_dui','nro_comprobante_pago_dui','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('monto_comision','monto_comision','numeric');
		$this->setParametro('tramite_pedido_endesis','tramite_pedido_endesis','varchar');
		$this->setParametro('monto_dui','monto_dui','numeric');
		$this->setParametro('nro_factura_proveedor','nro_factura_proveedor','varchar');
		$this->setParametro('tramite_comision_agencia','tramite_comision_agencia','varchar');
		$this->setParametro('pedido_sap','pedido_sap','varchar');
		$this->setParametro('id_agencia_despachante','id_agencia_despachante','int4');
		$this->setParametro('nro_comprobante_pago_comision','nro_comprobante_pago_comision','varchar');

        $this->setParametro('observaciones','observaciones','text');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarControlDui(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_control_dui_ime';
		$this->transaccion='CD_CDUI_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_control_dui','id_control_dui','int4');
		$this->setParametro('tramite_anticipo_dui','tramite_anticipo_dui','varchar');
		$this->setParametro('dui','dui','int4');
		$this->setParametro('archivo_comision','archivo_comision','varchar');
		$this->setParametro('nro_comprobante_diario_dui','nro_comprobante_diario_dui','varchar');
		$this->setParametro('archivo_dui','archivo_dui','varchar');
		$this->setParametro('nro_comprobante_diario_comision','nro_comprobante_diario_comision','varchar');
		$this->setParametro('nro_comprobante_pago_dui','nro_comprobante_pago_dui','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('monto_comision','monto_comision','numeric');
		$this->setParametro('tramite_pedido_endesis','tramite_pedido_endesis','varchar');
		$this->setParametro('monto_dui','monto_dui','numeric');
		$this->setParametro('nro_factura_proveedor','nro_factura_proveedor','varchar');
		$this->setParametro('tramite_comision_agencia','tramite_comision_agencia','varchar');
		$this->setParametro('pedido_sap','pedido_sap','varchar');
		$this->setParametro('id_agencia_despachante','id_agencia_despachante','int4');
		$this->setParametro('nro_comprobante_pago_comision','nro_comprobante_pago_comision','varchar');

        $this->setParametro('observaciones','observaciones','text');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarControlDui(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_control_dui_ime';
		$this->transaccion='CD_CDUI_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_control_dui','id_control_dui','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>