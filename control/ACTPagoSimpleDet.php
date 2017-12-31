<?php
/**
*@package pXP
*@file gen-ACTPagoSimpleDet.php
*@author  (admin)
*@date 01-01-2018 06:21:25
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPagoSimpleDet extends ACTbase{    
			
	function listarPagoSimpleDet(){
		$this->objParam->defecto('ordenacion','id_pago_simple_det');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_pago_simple')!=''){
			$this->objParam->addFiltro("paside.id_pago_simple = ".$this->objParam->getParametro('id_pago_simple'));	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPagoSimpleDet','listarPagoSimpleDet');
		} else{
			$this->objFunc=$this->create('MODPagoSimpleDet');
			
			$this->res=$this->objFunc->listarPagoSimpleDet($this->objParam);
		}

		$temp = Array();
		$temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
		$temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
		$temp['importe_it'] = $this->res->extraData['total_importe_it'];
		$temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
		$temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
		$temp['importe_doc'] = $this->res->extraData['total_importe_doc'];			
		$temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
		$temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
		$temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
		$temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
		$temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
		$temp['importe_pago_liquido'] = $this->res->extraData['total_importe_pago_liquido'];	
		$temp['importe_aux_neto'] = $this->res->extraData['total_importe_aux_neto'];	
				
		$temp['tipo_reg'] = 'summary';
		$temp['id_doc_compra_venta'] = 0;

		$this->res->total++;
		$this->res->addLastRecDatos($temp);

		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPagoSimpleDet(){
		$this->objFunc=$this->create('MODPagoSimpleDet');	
		if($this->objParam->insertar('id_pago_simple_det')){
			$this->res=$this->objFunc->insertarPagoSimpleDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPagoSimpleDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPagoSimpleDet(){
			$this->objFunc=$this->create('MODPagoSimpleDet');	
		$this->res=$this->objFunc->eliminarPagoSimpleDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>