<?php
// Extend the TCPDF class to create custom MultiRow
class RRendicionCD extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $datos_depositos;
	var $facturas;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $total;
	
	function datosHeader ( $detalle, $facturas, $datos_depositos, $retenciones) {
		
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_depositos = $datos_depositos;		
		$this->facturas = $facturas;
		$this->retenciones = $retenciones[0]['retenciones'];
		$this->subtotal = 0;
		$this->SetMargins(15, 35, 5);
	}
	
	function Header() {
			
		$titulo1='<b>RENDICION DE FONDOS</b>';
		$titulo2='Cuenta Documentada';
		$newDate = date("d/m/Y", strtotime( $this->datos_detalle[0]['fecha']));		
		$dataSource = $this->datos_detalle; 
	    ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/cabeceraRen.php');
        $content = ob_get_clean();
		$this->writeHTML($content, true, false, true, false, '');
		
	}
	
	function Firmas() {
			
		
		$newDate = date("d/m/Y", strtotime( $this->cabecera[0]['fecha']));		
		$dataSource = $this->datos_detalle; 
	    ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/firmas.php');
        $content = ob_get_clean();
		$this->writeHTML($content, true, false, true, false, '');
		
		
		
	}
   
   function generarReporte() {
		// get the HTML
		$dataSource = $this->datos_detalle; 
	    ob_start();		
	    include(dirname(__FILE__).'/../reportes/tpl/rendicionCD.php');
        $content = ob_get_clean();
		
		$this->AddPage();
	    $this->writeHTML($content, true, false, true, false, '');
		$this->revisarfinPagina();
		$this->Firmas();	
		
	} 
	
	
   function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
		if (($startY + 10 * 6) + $dimensions['bm'] > ($dimensions['hk'])) {		    
			$this->AddPage();
		    
		} 
		 
		
	}
}
?>