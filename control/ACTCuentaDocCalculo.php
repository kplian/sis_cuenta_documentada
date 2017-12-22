<?php
/**
*@package pXP
*@file gen-ACTCuentaDocCalculo.php
*@author  (admin)
*@date 15-09-2017 13:16:03
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaDocCalculo extends ACTbase{    
			
	function listarCuentaDocCalculo(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc_calculo');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_cuenta_doc')!=''){
			$this->objParam->addFiltro("cdocca.id_cuenta_doc = ".$this->objParam->getParametro('id_cuenta_doc'));	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDocCalculo','listarCuentaDocCalculo');
		} else{
			$this->objFunc=$this->create('MODCuentaDocCalculo');
			
			$this->res=$this->objFunc->listarCuentaDocCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaDocCalculo(){
		$this->objFunc=$this->create('MODCuentaDocCalculo');	
		if($this->objParam->insertar('id_cuenta_doc_calculo')){
			$this->res=$this->objFunc->insertarCuentaDocCalculo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaDocCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaDocCalculo(){
			$this->objFunc=$this->create('MODCuentaDocCalculo');	
		$this->res=$this->objFunc->eliminarCuentaDocCalculo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>