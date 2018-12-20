<?php
/**
*@package pXP
*@file gen-ACTControlDui.php
*@author  (jjimenez)
*@date 13-09-2018 15:32:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';
require_once(dirname(__FILE__).'/../reportes/RDuiXls.php');

class ACTControlDui extends ACTbase{    
			
	function listarControlDui(){
		
		$this->objParam->defecto('ordenacion','id_control_dui');

		$this->objParam->defecto('dir_ordenacion','asc');
		
        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro("cdui.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        } else {
            $this->objParam->addFiltro("cdui.id_gestion = 0");
        }
		
        if($this->objParam->getParametro('filtro')=='tram_comi_agencia'){
            $this->objParam->addFiltro("  (cdui.tramite_comision_agencia = '''' or cdui.tramite_comision_agencia is null)");
		}
		if($this->objParam->getParametro('filtro')=='comp_pago_comision'){
			$this->objParam->addFiltro("  (cdui.nro_comprobante_pago_comision = '''' or cdui.nro_comprobante_pago_comision is null)");
		}


		
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODControlDui','listarControlDui');
		} else{
			$this->objFunc=$this->create('MODControlDui');
			
			$this->res=$this->objFunc->listarControlDui($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarControlDui(){
		$this->objFunc=$this->create('MODControlDui');	
		if($this->objParam->insertar('id_control_dui')){
			$this->res=$this->objFunc->insertarControlDui($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarControlDui($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarControlDui(){
			$this->objFunc=$this->create('MODControlDui');	
		$this->res=$this->objFunc->eliminarControlDui($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function actualizarComprobantePagoComision(){
		$this->objFunc=$this->create('MODControlDui');	
		$this->res=$this->objFunc->actualizarComprobantePagoComision($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function listarControlDuiFiltro(){
		
		$this->objParam->defecto('ordenacion','id_control_dui');

		$this->objParam->defecto('dir_ordenacion','asc');
		


		
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODControlDui','listarControlDui');
		} else{
			$this->objFunc=$this->create('MODControlDui');
			
			$this->res=$this->objFunc->listarControlDui($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function reporteDui(){
		
	    $var='';
		

		//var_dump($this->objParam->getParametro('id_gestion'));
        if ($this->objParam->getParametro('id_gestion') != '') {
            $this->objParam->addFiltro(" cdui.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        } else {
            $this->objParam->addFiltro(" cdui.id_gestion = 0 ");
        }
		
        if($this->objParam->getParametro('filtro')=='pend_comi_agen'){
            $this->objParam->addFiltro("  (cdui.tramite_comision_agencia = '''' or cdui.tramite_comision_agencia is null)");
		}
		if($this->objParam->getParametro('filtro')=='pend_comp_pag_comi'){
			$this->objParam->addFiltro("  (cdui.nro_comprobante_pago_comision = '''' or cdui.nro_comprobante_pago_comision is null)");
		}
		if($this->objParam->getParametro('id_agencia_despachante')){
			$this->objParam->addFiltro("  cdui.id_agencia_despachante = ".$this->objParam->getParametro('id_agencia_despachante'));
		}
		
		
		if($this->objParam->getParametro('pedido_sap')){
			$this->objParam->addFiltro("  cdui.pedido_sap = ''".$this->objParam->getParametro('pedido_sap')."''");
		}
		if($this->objParam->getParametro('tramite_pedido_endesis')){
			$this->objParam->addFiltro("  cdui.tramite_pedido_endesis = ''".$this->objParam->getParametro('tramite_pedido_endesis')."''");
		}
		if($this->objParam->getParametro('tramite_comision_agencia')){
			$this->objParam->addFiltro("  cdui.tramite_comision_agencia = ''".$this->objParam->getParametro('tramite_comision_agencia')."''");
		}
				


	    $this->objFun=$this->create('MODControlDui');
		$this->res = $this->objFun->reporteDui();
		//$this->res=$this->objFunc->listarControlDui($this->objParam);


        if($this->res->getTipo()=='ERROR'){
            $this->res->imprimirRespuesta($this->res->generarJson());
            exit;
        }

		$var = 'Duis';
	 
        //obtener titulo de reporte
        $titulo ='Reporte Dui';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.xls';

        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $this->objParam->addParametro('datos',$this->res->datos);
		$this->objParam->addParametro('var',$var);
		$this->objParam->addParametro('gestion',$this->objParam->getParametro('gestion'));
        //Instancia la clase de excel
        $this->objReporteFormato=new RDuiXls($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		
	}
			
}

?>