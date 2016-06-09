<?php
/**
*@package pXP
*@file gen-ACTCuentaDoc.php
*@author  (admin)
*@date 05-05-2016 16:41:21
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/RSolicitudCD.php');
require_once(dirname(__FILE__).'/../reportes/RRendicionCD.php');
class ACTCuentaDoc extends ACTbase{    
			
	function listarCuentaDoc(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if(strtolower($this->objParam->getParametro('estado'))=='borrador'){
             $this->objParam->addFiltro("(cdoc.estado in (''borrador''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='validacion'){
             $this->objParam->addFiltro("(cdoc.estado not in (''borrador'',''contabilizado'',''finalizado'',''anulado''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='entregados'){
             $this->objParam->addFiltro("(cdoc.estado in (''contabilizado''))");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='finalizados'){
             $this->objParam->addFiltro("(cdoc.estado in (''finalizado'',''anulado''))");
        }
		
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarCuentaDoc');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarCuentaDoc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function listarCuentaDocRendicion(){
			
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_cuenta_doc')!=''){
            $this->objParam->addFiltro("cdoc.id_cuenta_doc_fk = ".$this->objParam->getParametro('id_cuenta_doc'));    
        }
		
		if(strtolower($this->objParam->getParametro('estado'))=='borrador'){
             $this->objParam->addFiltro("(cdoc.estado in (''borrador''))");
        }
		
		if(strtolower($this->objParam->getParametro('estado'))=='validacion'){
             $this->objParam->addFiltro("(cdoc.estado not in (''borrador'',''contabilizado'',''rendido'',''anulado''))");
        }
		
		if(strtolower($this->objParam->getParametro('estado'))=='finalizados'){
             $this->objParam->addFiltro("(cdoc.estado in (''rendido'',''anulado''))");
        }
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarCuentaDocRendicion');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarCuentaDocRendicion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCuentaDoc(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		if($this->objParam->insertar('id_cuenta_doc')){
			$this->res=$this->objFunc->insertarCuentaDoc($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaDoc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function insertarCuentaDocRendicion(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		if($this->objParam->insertar('id_cuenta_doc')){
			$this->res=$this->objFunc->insertarCuentaDocRendicion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCuentaDocRendicion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCuentaDoc(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->eliminarCuentaDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function eliminarCuentaDocRendicion(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->eliminarCuentaDocRendicion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function siguienteEstado(){
        $this->objFunc=$this->create('MODCuentaDoc');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   function anteriorEstado(){
        $this->objFunc=$this->create('MODCuentaDoc');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
   
   function iniciarRendicion(){
        $this->objFunc=$this->create('MODCuentaDoc');  
        $this->res=$this->objFunc->iniciarRendicion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
   
   function recuperarSolicitudFondos(){
    	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->reporteCabeceraCuentaDoc($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
   function reporteSolicitudFondos(){
			
		$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
		$dataSource = $this->recuperarSolicitudFondos();	
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'p';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		
		$reporte = new RSolicitudCD($this->objParam); 
		
		$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData);
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}
   
   function recuperarRendicionFacturas(){
    	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarRendicionFacturas($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
   
   function recuperarRendicionDepositos(){
    	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarRendicionDepositos($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	
   function reporteRendicionFondos(){
			
		$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
		$dataSource = $this->recuperarSolicitudFondos();
		$dataSourceDet = $this->recuperarRendicionFacturas();
		$dataSourceDetDepositos = $this->recuperarRendicionDepositos();	
		//$dataSourceDetDepositos = $this->recuperarRendicionFacturas();		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'p';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		
		$reporte = new RRendicionCD($this->objParam); 
		
		$reporte->datosHeader($dataSource->getDatos(),  $dataSourceDet->getDatos(), $dataSourceDetDepositos->getDatos());
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

    

			
}

?>