<?php
/**
*@package pXP
*@file gen-ACTTipoCategoria.php
*@author  (admin)
*@date 05-05-2016 13:22:15
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoCategoria extends ACTbase{    
			
	function listarTipoCategoria(){
		$this->objParam->defecto('ordenacion','id_tipo_Categoria');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoCategoria','listarTipoCategoria');
		} else{
			$this->objFunc=$this->create('MODTipoCategoria');
			
			$this->res=$this->objFunc->listarTipoCategoria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoCategoria(){
		$this->objFunc=$this->create('MODTipoCategoria');	
		if($this->objParam->insertar('id_tipo_categoria')){
			$this->res=$this->objFunc->insertarTipoCategoria($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoCategoria($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoCategoria(){
		$this->objFunc=$this->create('MODTipoCategoria');	
		$this->res=$this->objFunc->eliminarTipoCategoria($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>