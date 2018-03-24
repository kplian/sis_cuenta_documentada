<?php
// Extend the TCPDF class to create custom MultiRow
class RSolicitudCD_Fondo extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $total;
	
	function datosHeader ( $detalle, $totales) {
		
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->subtotal = 0;
		$this->SetMargins(15, 35, 5);
	}
	
	function Header() {
			
		$titulo1='<b>SOLICITUD DE FONDOS</b>';
		$titulo2='Cuenta Documentada';

		$newDate = date("d/m/Y", strtotime( $this->datos_detalle[0]['fecha']));		
		$dataSource = $this->datos_detalle; 
	    ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/cabeceraSol.php');
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
		
	    include(dirname(__FILE__).'/../reportes/tpl/solicitudCD.php');
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