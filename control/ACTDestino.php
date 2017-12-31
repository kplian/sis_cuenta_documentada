<?php
/**
*@package pXP
*@file gen-ACTDestino.php
*@author  (admin)
*@date 04-09-2017 15:10:59
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDestino extends ACTbase{    
			
	function listarDestino(){
		$this->objParam->defecto('ordenacion','id_destino');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_escala')!=''){
			$this->objParam->addFiltro("dest.id_escala = ".$this->objParam->getParametro('id_escala'));
		}

		if($this->objParam->getParametro('tipo_viaje')!=''){
			$this->objParam->addFiltro("dest.tipo = ''".$this->objParam->getParametro('tipo_viaje')."''");	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDestino','listarDestino');
		} else{
			$this->objFunc=$this->create('MODDestino');
			
			$this->res=$this->objFunc->listarDestino($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDestino(){
		$this->objFunc=$this->create('MODDestino');	
		if($this->objParam->insertar('id_destino')){
			$this->res=$this->objFunc->insertarDestino($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDestino($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarDestino(){
		$this->objFunc=$this->create('MODDestino');	
		$this->res=$this->objFunc->eliminarDestino($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>