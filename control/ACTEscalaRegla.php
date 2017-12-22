<?php
/**
*@package pXP
*@file gen-ACTEscalaRegla.php
*@author  (admin)
*@date 15-11-2017 18:38:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTEscalaRegla extends ACTbase{    
			
	function listarEscalaRegla(){
		$this->objParam->defecto('ordenacion','id_escala_regla');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_escala')!=''){
			$this->objParam->addFiltro("regla.id_escala = ".$this->objParam->getParametro('id_escala'));
		} 

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODEscalaRegla','listarEscalaRegla');
		} else{
			$this->objFunc=$this->create('MODEscalaRegla');
			
			$this->res=$this->objFunc->listarEscalaRegla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarEscalaRegla(){
		$this->objFunc=$this->create('MODEscalaRegla');	
		if($this->objParam->insertar('id_escala_regla')){
			$this->res=$this->objFunc->insertarEscalaRegla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarEscalaRegla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarEscalaRegla(){
			$this->objFunc=$this->create('MODEscalaRegla');	
		$this->res=$this->objFunc->eliminarEscalaRegla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>