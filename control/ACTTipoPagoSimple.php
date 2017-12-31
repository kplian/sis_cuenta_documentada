<?php
/**
*@package pXP
*@file gen-ACTTipoPagoSimple.php
*@author  (admin)
*@date 02-12-2017 02:49:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoPagoSimple extends ACTbase{    
			
	function listarTipoPagoSimple(){
		$this->objParam->defecto('ordenacion','id_tipo_pago_simple');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoPagoSimple','listarTipoPagoSimple');
		} else{
			$this->objFunc=$this->create('MODTipoPagoSimple');
			
			$this->res=$this->objFunc->listarTipoPagoSimple($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoPagoSimple(){
		$this->objFunc=$this->create('MODTipoPagoSimple');	
		if($this->objParam->insertar('id_tipo_pago_simple')){
			$this->res=$this->objFunc->insertarTipoPagoSimple($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoPagoSimple($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoPagoSimple(){
			$this->objFunc=$this->create('MODTipoPagoSimple');	
		$this->res=$this->objFunc->eliminarTipoPagoSimple($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>