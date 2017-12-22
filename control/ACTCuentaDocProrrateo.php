<?php
/**
*@package pXP
*@file gen-ACTCuentaDocProrrateo.php
*@author  (admin)
*@date 05-12-2017 19:08:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaDocProrrateo extends ACTbase{    
			
	function listarCuentaDocProrrateo(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc_prorrateo');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_cuenta_doc')!=''){
			$this->objParam->addFiltro("cdpro.id_cuenta_doc = ".$this->objParam->getParametro('id_cuenta_doc'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDocProrrateo','listarCuentaDocProrrateo');
		} else{
			$this->objFunc=$this->create('MODCuentaDocProrrateo');
			
			$this->res=$this->objFunc->listarCuentaDocProrrateo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaDocProrrateo(){
		$this->objFunc=$this->create('MODCuentaDocProrrateo');	
		if($this->objParam->insertar('id_cuenta_doc_prorrateo')){
			$this->res=$this->objFunc->insertarCuentaDocProrrateo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaDocProrrateo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaDocProrrateo(){
			$this->objFunc=$this->create('MODCuentaDocProrrateo');	
		$this->res=$this->objFunc->eliminarCuentaDocProrrateo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarCuentaDocProrrateoRes(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc_prorrateo');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDocProrrateo','listarCuentaDocProrrateoRes');
		} else{
			$this->objFunc=$this->create('MODCuentaDocProrrateo');
			
			$this->res=$this->objFunc->listarCuentaDocProrrateoRes($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>