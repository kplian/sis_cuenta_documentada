<?php
/**
*@package pXP
*@file gen-ACTAgenciaDespachante.php
*@author  (jjimenez)
*@date 13-09-2018 17:45:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAgenciaDespachante extends ACTbase{
			
	function listarAgenciaDespachante(){
		$this->objParam->defecto('ordenacion','id_agencia_despachante');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAgenciaDespachante','listarAgenciaDespachante');
		} else{
			$this->objFunc=$this->create('MODAgenciaDespachante');
			
			$this->res=$this->objFunc->listarAgenciaDespachante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAgenciaDespachante(){
		$this->objFunc=$this->create('MODAgenciaDespachante');	
		if($this->objParam->insertar('id_agencia_despachante')){
			$this->res=$this->objFunc->insertarAgenciaDespachante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAgenciaDespachante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAgenciaDespachante(){
			$this->objFunc=$this->create('MODAgenciaDespachante');	
		$this->res=$this->objFunc->eliminarAgenciaDespachante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>