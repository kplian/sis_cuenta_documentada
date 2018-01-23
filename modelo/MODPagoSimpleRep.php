<?php
/**
*@package pXP
*@file gen-MODPagoSimpleRep.php
*@author  (admin)
*@date 31-12-2017 12:33:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPagoSimpleRep extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

    function listarRepLCV(){
		  //Definicion de variables para ejecucion del procedimientp
		  $this->procedimiento='cd.ft_pago_simple_sel';
		  $this->transaccion='CD_DEPASIMPLE_SEL';
		  $this->tipo_procedimiento='SEL';//tipo de transaccion
		  $this->setCount(false);	
		  //captura parametros adicionales para el count
		  $this->setParametro('id_pago_simple','id_pago_simple','int4');
		  //Definicion de la lista del resultado del query
		  
		  $this->captura('id_doc_compra_venta','int4');
		  $this->captura('tipo','VARCHAR');
		  $this->captura('fecha','DATE');
		  $this->captura('nit','VARCHAR');
		  $this->captura('razon_social','VARCHAR');
		  $this->captura('nro_documento','VARCHAR');
		  $this->captura('nro_dui','VARCHAR');
		  $this->captura('nro_autorizacion','VARCHAR');
		  $this->captura('importe_doc','NUMERIC');
		  $this->captura('total_excento','NUMERIC');
		  $this->captura('sujeto_cf','NUMERIC');
		  $this->captura('importe_descuento','NUMERIC');
		  $this->captura('subtotal','NUMERIC');
		  $this->captura('credito_fiscal','NUMERIC');
		  $this->captura('importe_iva','NUMERIC');
		  $this->captura('codigo_control','VARCHAR');
		  //$this->captura('tipo_doc','VARCHAR');
		  $this->captura('id_plantilla','INTEGER');
		  $this->captura('id_moneda','INTEGER');
		  $this->captura('codigo_moneda','VARCHAR');
		  $this->captura('id_periodo','INTEGER');
		  $this->captura('id_gestion','INTEGER');
		  $this->captura('periodo','INTEGER');
		  $this->captura('gestion','INTEGER');
		  $this->captura('venta_gravada_cero','NUMERIC');
          $this->captura('subtotal_venta','NUMERIC');
          $this->captura('sujeto_df','NUMERIC');
		  $this->captura('importe_ice','NUMERIC');
		  $this->captura('importe_excento','NUMERIC');
		  //Ejecuta la instruccion
		  $this->armarConsulta();
		  $this->ejecutarConsulta();
		
		  //Devuelve la respuesta
		  return $this->respuesta;
	}

			
}
?>