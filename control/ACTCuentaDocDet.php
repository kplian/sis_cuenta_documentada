<?php
/**
*@package pXP
*@file gen-ACTCuentaDocDet.php
*@author  (admin)
*@date 05-09-2017 17:54:29
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTCuentaDocDet extends ACTbase{    
			
	function listarCuentaDocDet(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc_det');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_cuenta_doc')!=''){
			$this->objParam->addFiltro("cdet.id_cuenta_doc = ".$this->objParam->getParametro('id_cuenta_doc'));	
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDocDet','listarCuentaDocDet');
		} else{
			$this->objFunc=$this->create('MODCuentaDocDet');
			
			$this->res=$this->objFunc->listarCuentaDocDet($this->objParam);
		}

		//Se agrega fila del total al final del store
		$temp = Array();
		$temp['moneda'] = 'TOTAL';
		$temp['monto_mo'] = $this->res->extraData['total_monto_mo'];
		$temp['monto_mb'] = $this->res->extraData['total_monto_mb'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_cuenta_doc_det'] = 0;
		$this->res->total++;
		$this->res->addLastRecDatos($temp);

		//Respuesta
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaDocDet(){
		$this->objFunc=$this->create('MODCuentaDocDet');	
		if($this->objParam->insertar('id_cuenta_doc_det')){
			$this->res=$this->objFunc->insertarCuentaDocDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaDocDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaDocDet(){
			$this->objFunc=$this->create('MODCuentaDocDet');	
		$this->res=$this->objFunc->eliminarCuentaDocDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>