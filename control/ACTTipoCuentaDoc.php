<?php
/**
*@package pXP
*@file gen-ACTTipoCuentaDoc.php
*@author  (admin)
*@date 04-05-2016 20:13:26
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoCuentaDoc extends ACTbase{    
			
	function listarTipoCuentaDoc(){
		$this->objParam->defecto('ordenacion','id_tipo_cuenta_doc');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoCuentaDoc','listarTipoCuentaDoc');
		} else{
			$this->objFunc=$this->create('MODTipoCuentaDoc');
			
			$this->res=$this->objFunc->listarTipoCuentaDoc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoCuentaDoc(){
		$this->objFunc=$this->create('MODTipoCuentaDoc');	
		if($this->objParam->insertar('id_tipo_cuenta_doc')){
			$this->res=$this->objFunc->insertarTipoCuentaDoc($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoCuentaDoc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoCuentaDoc(){
			$this->objFunc=$this->create('MODTipoCuentaDoc');	
		$this->res=$this->objFunc->eliminarTipoCuentaDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>