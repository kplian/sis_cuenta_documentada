<?php
/**
*@package pXP
*@file gen-ACTBloqueoCd.php
*@author  (admin)
*@date 06-06-2016 16:40:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTBloqueoCd extends ACTbase{    
			
	function listarBloqueoCd(){
		$this->objParam->defecto('ordenacion','id_bloqueo_cd');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODBloqueoCd','listarBloqueoCd');
		} else{
			$this->objFunc=$this->create('MODBloqueoCd');
			
			$this->res=$this->objFunc->listarBloqueoCd($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarBloqueoCd(){
		$this->objFunc=$this->create('MODBloqueoCd');	
		if($this->objParam->insertar('id_bloqueo_cd')){
			$this->res=$this->objFunc->insertarBloqueoCd($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarBloqueoCd($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarBloqueoCd(){
			$this->objFunc=$this->create('MODBloqueoCd');	
		$this->res=$this->objFunc->eliminarBloqueoCd($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>