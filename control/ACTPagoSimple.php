<?php
/**
*@package pXP
*@file gen-ACTPagoSimple.php
*@author  (admin)
*@date 31-12-2017 12:33:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RDetallePago.php');
class ACTPagoSimple extends ACTbase{    
			
	function listarPagoSimple(){
		$this->objParam->defecto('ordenacion','id_pago_simple');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPagoSimple','listarPagoSimple');
		} else{
			$this->objFunc=$this->create('MODPagoSimple');
			
			$this->res=$this->objFunc->listarPagoSimple($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPagoSimple(){
		$this->objFunc=$this->create('MODPagoSimple');	
		if($this->objParam->insertar('id_pago_simple')){
			$this->res=$this->objFunc->insertarPagoSimple($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPagoSimple($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPagoSimple(){
			$this->objFunc=$this->create('MODPagoSimple');	
		$this->res=$this->objFunc->eliminarPagoSimple($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function siguienteEstado(){
        $this->objFunc=$this->create('MODPagoSimple');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstado(){
        $this->objFunc=$this->create('MODPagoSimple');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	function reporteDetallePagos(){

		$this->objParam->defecto('ordenacion','cv.id_doc_compra_venta::integer');

		$this->objParam->defecto('dir_ordenacion','asc');

		if ($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!='' && $this->objParam->getParametro('id_plantilla')) {
            //$id_plantilla=" and cv.id_plantilla = ".$this->objParam->getParametro('id_plantilla');
            $fechaDesde=$this->objParam->getParametro('desde');
			$fechaHasta=$this->objParam->getParametro('hasta');
            if($this->objParam->getParametro('id_funcionario')=='' || $this->objParam->getParametro('id_funcionario') == null){
				$this->objParam->addFiltro("cv.fecha BETWEEN ''".$fechaDesde."'' and ''".$fechaHasta."'' and cv.id_plantilla=".$this->objParam->getParametro('id_plantilla'));
			
			}
			else{
				$this->objParam->addFiltro("cv.fecha BETWEEN ''".$fechaDesde."'' and ''".$fechaHasta."'' and cv.id_funcionario = ".$this->objParam->getParametro('id_funcionario')." and cv.id_plantilla=".$this->objParam->getParametro('id_plantilla'));
			}
			
        }


		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPagoSimple','listarDetallePago');
		} else{
			$this->objFunc=$this->create('MODPagoSimple');
			
			$this->res=$this->objFunc->listarDetallePago($this->objParam);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());

	}

    function agregarDocumentos(){
        $this->objFunc=$this->create('MODPagoSimple');  
        $this->res=$this->objFunc->agregarDocumentos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }


	/*function recuperarDetallePagos(){    	
		$this->objFunc = $this->create('MODMemoriaCalculo');
		$cbteHeader = $this->objFunc->listarRepMemoriaCalculo($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	function recuperarDatosEmpresa(){    	
		$this->objFunc = $this->create('sis_parametros/MODEmpresa');
		$cbteHeader = $this->objFunc->getEmpresa($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
	}*/
	
			
}

?>