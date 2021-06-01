<?php
/**
*@package pXP
*@file gen-ACTPagoSimple.php
*@author  (admin)
*@date 31-12-2017 12:33:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

ISSUE          FECHA:		      AUTOR                 DESCRIPCION
#15			19/05/2020		manuel guerra           creacion de reportes en pdf, para pasajes

*/
require_once(dirname(__FILE__).'/../reportes/RDetallePago.php');

//agregado
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RLcv.php');
//require_once(dirname(__FILE__).'/../reportes/RLcvVentas.php');
require_once(dirname(__FILE__).'/../reportes/RepPasajes.php');
require_once(dirname(__FILE__).'/../reportes/RepPasajesPSim.php');

class ACTPagoSimple extends ACTbase{    
			
	function listarPagoSimple(){
		$this->objParam->defecto('ordenacion','id_pago_simple');

		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
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

	function reporteLCV(){
			
				
			$nombreArchivo = uniqid(md5(session_id()).'Egresos') . '.pdf'; 
			$dataSource = $this->recuperarDatosLCV();
			//$dataEntidad = $this->recuperarDatosEntidad();
			//$dataPeriodo = $this->recuperarDatosPeriodo();
			
			
			
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
		
	         
			$reporte->datosHeader($dataSource->getDatos(),'','','');
			//$reporte->datosHeader($dataSource->getDatos(),  $dataSource->extraData, $dataEntidad->getDatos() , $dataPeriodo->getDatos() );
			
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
			
		}
		function recuperarDatosLCV(){    	
			$this->objFunc = $this->create('MODPagoSimple');
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
			$cbteHeader = $this->objFunc->PM_GET_ENCAB($this->objParam);
			if($cbteHeader->getTipo() == 'EXITO'){				
				return $cbteHeader;
			}
	        else{
			    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
				exit;
			}              
			
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
	//#15
	function repAutorizacionPdf(){	
		
		if($this->objParam->getParametro('id_pago_simple')!=''){
			$this->objParam->addFiltro("paside.id_pago_simple =".$this->objParam->getParametro('id_pago_simple'));
		}
		if($this->objParam->getParametro('id_depto_conta')!=''){
			$this->objParam->addFiltro("dcv.id_depto_conta =".$this->objParam->getParametro('id_depto_conta'));
		}
		if($this->objParam->getParametro('id_periodo')!=''){
			$this->objParam->addFiltro("dcv.id_periodo =".$this->objParam->getParametro('id_periodo'));
		}
		$this->objFun=$this->create('MODPagoSimple');	
		$this->res = $this->objFun->repAutorizacionPdf();
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
			
		$nombreArchivo = uniqid(md5(session_id()).'-Pasajes') . '.pdf'; 		
		$tamano = 'LETTER';
		$orientacion = 'L';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		$reporte = new RepPasajes($this->objParam); 		
		$reporte->datosHeader($this->res->datos);
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
	//#15
	function RepRegPasaPdf(){	
		
		if($this->objParam->getParametro('id_pago_simple')!=''){
			$this->objParam->addFiltro("paside.id_pago_simple =".$this->objParam->getParametro('id_pago_simple'));
		}
		$this->objFun=$this->create('MODPagoSimple');	
		$this->res = $this->objFun->RepRegPasaPdf();
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
			
		$nombreArchivo = uniqid(md5(session_id()).'-Pasajes') . '.pdf'; 		
		$tamano = 'LETTER';
		$orientacion = 'L';
		$this->objParam->addParametro('orientacion',$orientacion);
		$this->objParam->addParametro('tamano',$tamano);		
		$this->objParam->addParametro('titulo_archivo',$titulo);        
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		$reporte = new RepPasajesPSim($this->objParam); 		
		$reporte->datosHeader($this->res->datos);
		$reporte->generarReporte();
		$reporte->output($reporte->url_archivo,'F');
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
	//
	function listarDocCompraVenta(){
		$this->objParam->defecto('ordenacion','id_doc_compra_venta');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_periodo')!=''){
			$this->objParam->addFiltro("dcv.id_periodo = ".$this->objParam->getParametro('id_periodo'));
		}
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
			$this->objParam->addFiltro("dcv.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));
		}
		
		if($this->objParam->getParametro('tipo')!=''){
			$this->objParam->addFiltro("dcv.tipo = ''".$this->objParam->getParametro('tipo')."''");
		}
		
		if($this->objParam->getParametro('sin_cbte')=='si'){
			$this->objParam->addFiltro("dcv.id_int_comprobante is NULL");
		}

		if($this->objParam->getParametro('filtro_usuario') == 'si'){
			$this->objParam->addFiltro("dcv.id_usuario_reg = ".$_SESSION["ss_id_usuario"]);
		}
		
		if($this->objParam->getParametro('id_depto')!=''){
			if($this->objParam->getParametro('id_depto')!=0)
				$this->objParam->addFiltro("dcv.id_depto_conta = ".$this->objParam->getParametro('id_depto'));    
		}
		
		if($this->objParam->getParametro('id_agrupador')!=''){
			$this->objParam->addFiltro("dcv.id_doc_compra_venta not in (select ad.id_doc_compra_venta from conta.tagrupador_doc ad where ad.id_agrupador = ".$this->objParam->getParametro('id_agrupador').") ");    
		}
		
		if($this->objParam->getParametro('fecha') !=''){
			$this->objParam->addFiltro("dcv.fecha <= ''".$this->objParam->getParametro('fecha')."''::date");
		}
		
		if($this->objParam->getParametro('nit') !=''){
			$this->objParam->addFiltro("dcv.nit = ''".$this->objParam->getParametro('nit')."''");
		}
		
		if($this->objParam->getParametro('tipo_informe') !=''){
			$this->objParam->addFiltro("pla.tipo_informe = ''".$this->objParam->getParametro('tipo_informe')."''");
		}

		if($this->objParam->getParametro('tipos_informes') !=''){
			$this->objParam->addFiltro("pla.tipo_informe in (".$this->objParam->getParametro('tipos_informes').")");
		}
		
		if($this->objParam->getParametro('nombre_vista') =='DocCompra' || $this->objParam->getParametro('nombre_vista') =='DocVenta'){
			$this->objParam->addFiltro("pla.tipo_informe not in (''ncd'')");
		}

		if($this->objParam->getParametro('id_funcionario')!=''){
			$this->objParam->addFiltro("dcv.id_funcionario = ".$this->objParam->getParametro('id_funcionario'));
		}

		if($this->objParam->getParametro('consumido') !=''){
			if($this->objParam->getParametro('consumido') =='todos'){
			}elseif ($this->objParam->getParametro('consumido') =='si' || $this->objParam->getParametro('consumido') =='no') {
				$this->objParam->addFiltro("dcv.consumido = ''".$this->objParam->getParametro('consumido')."''");
			}
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPagoSimple','listarDocCompraVenta');
		} else{
			$this->objFunc=$this->create('MODPagoSimple');
			$this->res=$this->objFunc->listarDocCompraVenta($this->objParam);
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
		$temp['importe_pago_liquido'] = $this->res->extraData['total_importe_pago_liquido'];	
		$temp['importe_aux_neto'] = $this->res->extraData['total_importe_aux_neto'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_doc_compra_venta'] = 0;
		
		$this->res->total++;
		$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//
	function cambiarRevision(){
		$this->objFunc=$this->create('MODPagoSimple');	
		$this->res=$this->objFunc->cambiarRevision($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
}

?>