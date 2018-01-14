<?php
/**
*@package pXP
*@file gen-ACTPagoSimplePro.php
*@author  (admin)
*@date 14-01-2018 21:26:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPagoSimplePro extends ACTbase{    
			
	function listarPagoSimplePro(){
		$this->objParam->defecto('ordenacion','id_pago_simple_pro');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_pago_simple')!=''){
			$this->objParam->addFiltro("pasipr.id_pago_simple = ".$this->objParam->getParametro('id_pago_simple'));	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPagoSimplePro','listarPagoSimplePro');
		} else{
			$this->objFunc=$this->create('MODPagoSimplePro');
			
			$this->res=$this->objFunc->listarPagoSimplePro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPagoSimplePro(){
		$this->objFunc=$this->create('MODPagoSimplePro');	
		if($this->objParam->insertar('id_pago_simple_pro')){
			$this->res=$this->objFunc->insertarPagoSimplePro($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPagoSimplePro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPagoSimplePro(){
			$this->objFunc=$this->create('MODPagoSimplePro');	
		$this->res=$this->objFunc->eliminarPagoSimplePro($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>