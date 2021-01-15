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
require_once(dirname(__FILE__).'/../reportes/RRendicionCD_Fondo.php');
require_once(dirname(__FILE__).'/../reportes/RCuentaDoc.php');
require_once(dirname(__FILE__).'/../reportes/RRendicionConXls.php');
require_once(dirname(__FILE__).'/../reportes/RMemoAsignacion.php');
require_once(dirname(__FILE__).'/../reportes/RViaticosForm110Xls.php');
require_once(dirname(__FILE__).'/../reportes/RPasajesFuncionariosXls.php');

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
	
	
	function listarCuentaDocConsulta(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if(strtolower($this->objParam->getParametro('estado'))=='borrador'){
             $this->objParam->addFiltro("(cdoc.estado in (''borrador'')) and tcd.sw_solicitud = ''si''");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='validacion'){
             $this->objParam->addFiltro("(cdoc.estado not in (''borrador'',''contabilizado'',''finalizado'',''anulado'') and tcd.sw_solicitud = ''si'')");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='entregados'){
             $this->objParam->addFiltro("(cdoc.estado in (''contabilizado'') and tcd.sw_solicitud = ''si'')");
        }

        if(strtolower($this->objParam->getParametro('estado'))=='rendiciones'){
             $this->objParam->addFiltro("(cdoc.estado not in (''rendido'') and tcd.sw_solicitud = ''no'')");
        }


		if(strtolower($this->objParam->getParametro('estado'))=='finalizados'){
             $this->objParam->addFiltro("(cdoc.estado in (''finalizado'',''anulado'',''rendido''))");
        }
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("cdoc.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }

		if($this->objParam->getParametro('id_tipo_cuenta_doc')!=''){
            $this->objParam->addFiltro("cdoc.id_tipo_cuenta_doc = ".$this->objParam->getParametro('id_tipo_cuenta_doc'));
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
	//
	function recuperarDatosProrrateo(){	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarDatosProrrateo($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	//
	function recuperarDatosItinerario(){	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarDatosItinerario($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	//
	function recuperarDatosPresupuesto(){	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarDatosPresupuesto($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}
	}
	//
	function reporteSolicitudFondos(){
		//$id=$this->objParam->getParametro('id_cuenta_doc');			
		$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
		
		$dataSource = $this->recuperarSolicitudFondos();			
		$dataProrrateo = $this->recuperarDatosProrrateo();
		$dataItinerario = $this->recuperarDatosItinerario();
		$dataPresupuesto = $this->recuperarDatosPresupuesto();		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'p';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		//Instancia la clase de pdf
		$v=$this->objParam->getParametro('tipo');

		if(strpos($v,'Viáticos') === false){
			//Fondos en Avance
			$reporte = new RSolicitudCD_Fondo($this->objParam); 			
		}else{
			//Viáticos
			$reporte = new RSolicitudCD($this->objParam); 
		}
				
		$reporte->datosHeader($dataSource->getDatos(), $dataProrrateo->getDatos(), $dataItinerario->getDatos(),$dataPresupuesto->getDatos());
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

	function reporteSolicitudViaticos(){
		//$id=$this->objParam->getParametro('id_cuenta_doc');			
		$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
		
		$dataSource = $this->recuperarSolicitudFondos();			
		$dataProrrateo = $this->recuperarDatosProrrateo();
		$dataItinerario = $this->recuperarDatosItinerario();
		$dataPresupuesto = $this->recuperarDatosPresupuesto();		
		
		//parametros basicos
		$tamano = 'LETTER';
		$orientacion = 'p';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);

		$reporte = new RSolicitudCD($this->objParam); 

				
		$reporte->datosHeader($dataSource->getDatos(), $dataProrrateo->getDatos(), $dataItinerario->getDatos(),$dataPresupuesto->getDatos());
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
	
	function recuperarRetenciones(){
    	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarRetenciones($this->objParam);
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
   
    function recuperarRendicionDepositosConsolidado(){
    	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarRendicionDepositosConsolidado($this->objParam);
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
		$dataSourceRetenciones = $this->recuperarRetenciones();
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
		
		$reporte->datosHeader($dataSource->getDatos(),  $dataSourceDet->getDatos(), $dataSourceDetDepositos->getDatos(),$dataSourceRetenciones->getDatos());
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

    function recuperarDetalleConsolidado(){    	
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarDetalleConsolidado($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }

	function recuperarConsolidado(){
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->recuperarConsolidado($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}

	}

    function reporteRendicionCon(){
		
			    if($this->objParam->getParametro('formato_reporte')=='pdf'){
					$nombreArchivo = uniqid(md5(session_id()).'Programacion').'.pdf'; 
				}
				else{
					$nombreArchivo = uniqid(md5(session_id()).'Programacion').'.xls'; 
				}
				
				$dataSourceHeader = $this->recuperarSolicitudFondos();				
				$dataSource = $this->recuperarDetalleConsolidado();
				$dataSourceCon = $this->recuperarConsolidado();
				$dataSourceDep = $this->recuperarRendicionDepositosConsolidado();
				
				
				
				//parametros basicos
				$tamano = 'LETTER';
				$orientacion = 'L';
				$titulo = 'Consolidado';
				
				
				$this->objParam->addParametro('orientacion',$orientacion);
				$this->objParam->addParametro('tamano',$tamano);		
				$this->objParam->addParametro('titulo_archivo',$titulo);        
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				
				
				$reporte = new RRendicionConXls($this->objParam); 
				$reporte->datosHeader($dataSource->getDatos(),  $dataSourceHeader->getDatos(), $dataSourceDep->getDatos(), $dataSourceCon->getDatos());
				$reporte->generarReporte(); 
				
		         
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}

   function ampliarRendicion(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->ampliarRendicion($this->objParam);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
   
   function cambiarBloqueo(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->cambiarBloqueo($this->objParam);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function reporteMemoDesignacion(){
    	
	            $dataSource = $this->recuperarSolicitudFondos();				
				$nombreArchivo = uniqid(md5(session_id()).'MemoAsignación').'.docx'; 
				$reporte = new RMemoAsignacion($this->objParam); 
				
				
				$reporte->datosHeader($dataSource->getDatos());
				
				$reporte->write(dirname(__FILE__).'/../../reportes_generados/'.$nombreArchivo);
				
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
				
    }
	
	function cambioUsuarioReg(){
        $this->objFunc=$this->create('MODCuentaDoc');  
        $this->res=$this->objFunc->cambioUsuarioReg($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function recuperarReporteCuentaDoc(){
		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->listarReporteCuentaDoc($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){
			return $cbteHeader;
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}

	}

	function listarReporteCuentaDoc(){

		$this->objParam->addParametro('tipo','detalle');
		$this->objFunc=$this->create('MODCuentaDoc');
		$this->res=$this->recuperarReporteCuentaDoc();
		
		$this->objParam->addParametro('datos',$this->res->datos);

		//obtener titulo del reporte
		$titulo = 'RepCuentaDoc';

		//Genera el nombre del archivo (aleatorio + titulo)
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);

		$this->objReporteFormato=new RCuentaDoc($this->objParam);
		$this->objReporteFormato->imprimeDetalle();

		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
				'Se generó con éxito el reporte: '.$nombreArchivo,'control');

		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
	
	function listarCuentaDocReporte(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if(strtolower($this->objParam->getParametro('estado'))=='borrador'){
             $this->objParam->addFiltro("(cdoc.estado in (''borrador'')) and tcd.sw_solicitud = ''si''");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='validacion'){
             $this->objParam->addFiltro("(cdoc.estado not in (''borrador'',''contabilizado'',''finalizado'',''anulado'') and tcd.sw_solicitud = ''si'')");
        }
		if(strtolower($this->objParam->getParametro('estado'))=='entregados'){
             $this->objParam->addFiltro("(cdoc.estado in (''contabilizado'') and tcd.sw_solicitud = ''si'')");
        }

        if(strtolower($this->objParam->getParametro('estado'))=='rendiciones'){
             $this->objParam->addFiltro("(cdoc.estado not in (''rendido'') and tcd.sw_solicitud = ''no'')");
        }


		if(strtolower($this->objParam->getParametro('estado'))=='finalizados'){
             $this->objParam->addFiltro("(cdoc.estado in (''finalizado'',''anulado'',''rendido''))");
        }
		
		if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("cdoc.id_gestion = ".$this->objParam->getParametro('id_gestion'));    
        }
		
		
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarCuentaDocReporte');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarCuentaDocReporte($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	
	function listarCuentaDocConsulta2(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarCuentaDocConsulta2');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarCuentaDocConsulta2($this->objParam);
		}
		
		if($this->objParam->getParametro('resumen')!='no'){
			//adicionar una fila al resultado con el summario
			$temp = Array();
			$temp['importe_solicitado'] = $this->res->extraData['importe_solicitado'];
			$temp['importe_cheque'] = $this->res->extraData['importe_cheque'];
			$temp['importe_documentos'] = $this->res->extraData['importe_documentos'];
			$temp['importe_depositos'] = $this->res->extraData['importe_depositos'];
			$temp['saldo'] = $this->res->extraData['saldo'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_cuenta_doc'] = 0;
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		}
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function cuentaDocumentosRendicion(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->cuentaDocumentosRendicion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	

	function cuentaItinerarioRendicion(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->cuentaItinerarioRendicion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	

	function obtenerSaldoCuentaDoc(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->obtenerSaldoCuentaDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function generarDevolucionCuentaDoc(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->generarDevolucionCuentaDoc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarDepositoCuentaDoc(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarDepositoCuentaDoc');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			$this->res=$this->objFunc->listarDepositoCuentaDoc($this->objParam);
		}
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarElementoSigema(){
		$this->objParam->defecto('ordenacion','id_cuenta_doc');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('gestion')!=''){
             $this->objParam->addFiltro("sigra.gestion=''".$this->objParam->getParametro('gestion')."''");
        }

        if($this->objParam->getParametro('tipo_sol_sigema')!=''){
             $this->objParam->addFiltro("sigra.tipo_sol_sigema = ''".$this->objParam->getParametro('tipo_sol_sigema')."''");
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarElementoSigema');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarElementoSigema($this->objParam);
		}
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarDatosCDSIGEMA(){
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarDatosCDSIGEMA');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarDatosCDSIGEMA($this->objParam);
		}
		
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function guardarSIGEMA(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->guardarSIGEMA($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarViaticosForm110(){
		$this->objParam->defecto('ordenacion','dcv.id_funcionario');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }

        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarViaticosForm110');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarViaticosForm110($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarViaticosForm110Det(){
		$this->objParam->defecto('ordenacion','dcv.fecha');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }

        if($this->objParam->getParametro('id_funcionario')!=''){
            $this->objParam->addFiltro("dcv.id_funcionario = ".$this->objParam->getParametro('id_funcionario'));
        } else {
        	$this->objParam->addFiltro("dcv.id_funcionario is null");
        }

        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarViaticosForm110Det');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarViaticosForm110Det($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function reporteViaticosForm110(){
		//Obtención Descripción Depto
		$paramDepto="Todos";
		if($this->objParam->getParametro('id_depto')!=0){
			$this->objFunc = $this->create('sis_parametros/MODDepto');
			$datosDepto = $this->objFunc->recuperarDescripcionDepto($this->objParam);
			$aux=$datosDepto->getDatos();
			$paramDepto = $aux[0]['nombre'];
		}

		//Obtención totales viáticos
		$dataSource = $this->recuperarViaticoForm110();

		//Obtención detalle de documentos
		$dataSourceDet = $this->recuperarViaticoForm110Det();
		
		//Parámetros básicos
		$tamano = 'LETTER';
		$orientacion = 'L';
		$titulo = 'Listado Viáticos';
		$nombreArchivo = uniqid('RepViaticosForm110-'.session_id()).'.xls';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);
		$this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		//Generación del Reporte
		$reporte = new RViaticosForm110Xls($this->objParam);
		$reporte->setParamDepto($paramDepto);
		$reporte->datosHeader($dataSource->getDatos());
		$reporte->setDataSet($dataSource->getDatos());
		$reporte->setDataSetDet($dataSourceDet->getDatos());
		$reporte->generarReporte();
		
		//Salida del reporte
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}

	function recuperarViaticoForm110(){
        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0){
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
			}
        }

		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->reporteViaticosForm110($this->objParam);

		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		} else {
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		} 
    }

    function recuperarViaticoForm110Det(){
        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0){
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
			}
        }

		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->listarViaticosForm110Det($this->objParam);

		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		} else {
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		} 
    }

    function modificarViaticosForm110Det(){
		$this->objFunc=$this->create('MODCuentaDoc');	
		$this->res=$this->objFunc->modificarViaticosForm110Det($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarPasajesFuncionario(){
		$this->objParam->defecto('ordenacion','dcv.id_funcionario');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }

        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarPasajesFuncionario');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarPasajesFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function reportePasajesFuncionarios(){
		//Obtención Descripción Depto
		$paramDepto="Todos";
		if($this->objParam->getParametro('id_depto')!=0){
			$this->objFunc = $this->create('sis_parametros/MODDepto');
			$datosDepto = $this->objFunc->recuperarDescripcionDepto($this->objParam);
			$aux=$datosDepto->getDatos();
			$paramDepto = $aux[0]['nombre'];
		}

		//Obtención totales viáticos
		$dataSource = $this->recuperarPasajesFuncionarios();

		//Obtención detalle de documentos
		$dataSourceDet = $this->recuperarPasajesFuncionariosDet();
		
		//Parámetros básicos
		$tamano = 'LETTER';
		$orientacion = 'L';
		$titulo = 'Pasajes funcionarios';
		$nombreArchivo = uniqid('RepPasajesFuncionarios-'.session_id()).'.xls';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);
		$this->objParam->addParametro('titulo_archivo',$titulo);
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		//Generación del Reporte
		$reporte = new RPasajesFuncionariosXls($this->objParam);
		$reporte->setParamDepto($paramDepto);
		$reporte->datosHeader($dataSource->getDatos());
		$reporte->setDataSet($dataSource->getDatos());
		$reporte->setDataSetDet($dataSourceDet->getDatos());
		$reporte->generarReporte();
		
		//Salida del reporte
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}

	function recuperarPasajesFuncionarios(){
        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0){
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
			}
        }

		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->reportePasajesFuncionarios($this->objParam);

		//var_dump($cbteHeader);exit;

		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		} else {
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		} 
    }

    function listarPasajesFuncionariosDet(){
		$this->objParam->defecto('ordenacion','dcv.fecha');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_periodo')!=''){
            $this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));    
        }

        if($this->objParam->getParametro('id_funcionario')!=''){
            $this->objParam->addFiltro("dcv.id_funcionario = ".$this->objParam->getParametro('id_funcionario'));
        } else {
        	$this->objParam->addFiltro("dcv.id_funcionario is null");
        }

        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaDoc','listarPasajesFuncionariosDet');
		} else{
			$this->objFunc=$this->create('MODCuentaDoc');
			
			$this->res=$this->objFunc->listarPasajesFuncionariosDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function recuperarPasajesFuncionariosDet(){
        if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0){
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
			}
        }

		$this->objFunc = $this->create('MODCuentaDoc');
		$cbteHeader = $this->objFunc->listarPasajesFuncionariosDet($this->objParam);

		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		} else {
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		} 
    }

}
?>