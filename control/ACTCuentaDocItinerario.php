<?php
/**
*@package pXP
*@file gen-ACTCuentaDocItinerario.php
*@author  (admin)
*@date 05-09-2017 14:46:06
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaDocItinerario extends ACTbase{    
			
	function listarCuentaDocItinerario(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc_itinerario');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_cuenta_doc')!=''){
			$this->objParam->addFiltro("cdite.id_cuenta_doc = ".$this->objParam->getParametro('id_cuenta_doc'));	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDocItinerario','listarCuentaDocItinerario');
		} else{
			$this->objFunc=$this->create('MODCuentaDocItinerario');
			
			$this->res=$this->objFunc->listarCuentaDocItinerario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaDocItinerario(){
		$this->objFunc=$this->create('MODCuentaDocItinerario');	
		if($this->objParam->insertar('id_cuenta_doc_itinerario')){
			$this->res=$this->objFunc->insertarCuentaDocItinerario($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaDocItinerario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaDocItinerario(){
			$this->objFunc=$this->create('MODCuentaDocItinerario');	
		$this->res=$this->objFunc->eliminarCuentaDocItinerario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>