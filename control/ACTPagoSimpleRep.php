<?php
/**
*@package pXP
*@file gen-ACTPagoSimple.php
*@author  (admin)
*@date 31-12-2017 12:33:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RDetallePago.php');

//agregado
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RLcv.php');
//require_once(dirname(__FILE__).'/../reportes/RLcvVentas.php');


class ACTPagoSimpleRep extends ACTbase{    
			



	function reporteLCV(){
			
				
			$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
			$dataSource = $this->recuperarDatosLCV();
			//$dataEntidad = $this->recuperarDatosEntidad();
			$dataPeriodo = $this->recuperarDatosPeriodo();
			
			
			//parametros basicos
			$tamano = 'LETTER';
			$orientacion = 'L';
			$titulo = 'Consolidado';
			
			
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);		
			$this->objParam->addParametro('titulo_archivo',$titulo);        
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			
			//Instancia la clase de pdf
			$reporte = new RLcv($this->objParam);  
		
	         
			$reporte->datosHeader($dataSource->getDatos(),$dataPeriodo->getDatos(),'','');
			//$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData, $dataEntidad->getDatos() , $dataPeriodo->getDatos() );
			
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
			
		}
		function recuperarDatosLCV(){    	
			$this->objFunc = $this->create('MODPagoSimpleRep');
			$cbteHeader = $this->objFunc->listarRepLCV($this->objParam);
			if($cbteHeader->getTipo() == 'EXITO'){				
				return $cbteHeader;
			}
	        else{
			    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
				exit;
			}              
			
	    }
		function recuperarDatosEntidad(){    	
			$this->objFunc = $this->create('sis_parametros/MODEntidad');
			$cbteHeader = $this->objFunc->getEntidadByDepto($this->objParam);
			if($cbteHeader->getTipo() == 'EXITO'){				
				return $cbteHeader;
			}
	        else{
			    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
				exit;
			}              
			
	    }
		function recuperarDatosPeriodo(){    	
			$this->objFunc = $this->create('sis_parametros/MODPeriodo');
			$cbteHeader = $this->objFunc->getDetalleEncabezado($this->objParam);
			if($cbteHeader->getTipo() == 'EXITO'){				
				return $cbteHeader;
			}
	        else{
			    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
				exit;
			}              
			
	    }

	
			
}

?>