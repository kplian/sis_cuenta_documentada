<?php
/**
*@package pXP
*@file gen-ACTControlDui.php
*@author  (jjimenez)
*@date 13-09-2018 15:32:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTControlDui extends ACTbase{    
			
	function listarControlDui(){
		$this->objParam->defecto('ordenacion','id_control_dui');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODControlDui','listarControlDui');
		} else{
			$this->objFunc=$this->create('MODControlDui');
			
			$this->res=$this->objFunc->listarControlDui($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarControlDui(){
		$this->objFunc=$this->create('MODControlDui');	
		if($this->objParam->insertar('id_control_dui')){
			$this->res=$this->objFunc->insertarControlDui($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarControlDui($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarControlDui(){
			$this->objFunc=$this->create('MODControlDui');	
		$this->res=$this->objFunc->eliminarControlDui($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>