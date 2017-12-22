<?php
/**
*@package pXP
*@file gen-ACTEscala.php
*@author  (admin)
*@date 04-09-2017 16:10:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEscala extends ACTbase{    
			
	function listarEscala(){
		$this->objParam->defecto('ordenacion','id_escala');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEscala','listarEscala');
		} else{
			$this->objFunc=$this->create('MODEscala');
			
			$this->res=$this->objFunc->listarEscala($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEscala(){
		$this->objFunc=$this->create('MODEscala');	
		if($this->objParam->insertar('id_escala')){
			$this->res=$this->objFunc->insertarEscala($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEscala($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEscala(){
			$this->objFunc=$this->create('MODEscala');	
		$this->res=$this->objFunc->eliminarEscala($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>