<?php
/**
*@package pXP
*@file gen-ACTRendicionDet.php
*@author  (admin)
*@date 17-05-2016 18:01:48
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRendicionDet extends ACTbase{    
			
	function listarRendicionDet(){
		$this->objParam->defecto('ordenacion','id_rendicion_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		
		if($this->objParam->getParametro('id_cuenta_doc_rendicion')!=''){
            $this->objParam->addFiltro("rd.id_cuenta_doc_rendicion = ".$this->objParam->getParametro('id_cuenta_doc_rendicion'));    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRendicionDet','listarRendicionDet');
		} else{
			$this->objFunc=$this->create('MODRendicionDet');
			
			$this->res=$this->objFunc->listarRendicionDet($this->objParam);
		}
		
		
		$temp = Array();
			$temp['importe_ice'] = $this->res->extraData['total_importe_ice'];
			$temp['importe_excento'] = $this->res->extraData['total_importe_excento'];
			$temp['importe_it'] = $this->res->extraData['total_importe_it'];
			$temp['importe_iva'] = $this->res->extraData['total_importe_iva'];
			$temp['importe_descuento'] = $this->res->extraData['total_importe_descuento'];
			$temp['importe_doc'] = $this->res->extraData['total_importe_doc'];			
			$temp['importe_retgar'] = $this->res->extraData['total_importe_retgar'];
			$temp['importe_anticipo'] = $this->res->extraData['total_importe_anticipo'];
			$temp['importe_pendiente'] = $this->res->extraData['tota_importe_pendiente'];
			$temp['importe_neto'] = $this->res->extraData['total_importe_neto'];
			$temp['importe_descuento_ley'] = $this->res->extraData['total_importe_descuento_ley'];
			$temp['importe_pago_liquido'] = $this->res->extraData['tota_importe_pago_liquido'];			
			$temp['tipo_reg'] = 'summary';
			$temp['id_doc_compra_venta'] = 0;
			$temp['id_rendicion_Det'] = 0;
			
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRendicionDet(){
		$this->objFunc=$this->create('MODRendicionDet');	
		if($this->objParam->insertar('id_rendicion_det')){
			$this->res=$this->objFunc->insertarRendicionDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRendicionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRendicionDet(){
			$this->objFunc=$this->create('MODRendicionDet');	
		$this->res=$this->objFunc->eliminarRendicionDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarRendicionDocCompleto(){
		
		$this->objParam->addParametro('tipo_solicitud','rendicion');
		
		$this->objFunc=$this->create('MODRendicionDet');	
		if($this->objParam->insertar('id_doc_compra_venta')){
			$this->res=$this->objFunc->insertarRendicionDocCompleto($this->objParam);			
		} else{
			$this->res=$this->objFunc->modificarRendicionDocCompleto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarCdDeposito(){
		$this->objFunc=$this->create('MODRendicionDet');
		if($this->objParam->insertar('id_libro_bancos')){
			$this->res=$this->objFunc->insertarCdDeposito($this->objParam);
		} else{
			$this->res=$this->objFunc->insertarCdDeposito($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function eliminarCdDeposito(){
		$this->objFunc=$this->create('MODRendicionDet');
		$this->res=$this->objFunc->eliminarCdDeposito($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	
			
}

?>