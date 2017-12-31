<?php
// Extend the TCPDF class to create custom MultiRow
class RSolicitudCD extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $total;
	
	function datosHeader ($detalle,$dataProrrateo,$dataItinerario,$dataPresupuesto) {
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		//var_dump($this->datos_detalle);
		$this->datos_prorrateo = $dataProrrateo;
		$this->datos_itinerario = $dataItinerario;
		$this->datos_presupuesto = $dataPresupuesto;
		$this->SetMargins(25, 15, 5,10);
	}
	//
	function getDataSource(){
		return  $this->datos_detalle;		
	}
	function getDataSource_pro(){
		return  $this->datos_prorrateo;		
	}
	function getDataSource_iti(){
		return  $this->datos_itinerario;		
	}
	function getDataSource_pre(){
		return  $this->datos_presupuesto;		
	}
	//
	function Header() {				
	}
	//prorrateo
	function generarCabecera(){

		$conf_par_tablewidths=array(7,135,30);
		$conf_par_tablenumbers=array(0,0,0);
		$conf_par_tablealigns=array('C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$this->SetFont('','B',10);
		$this->ln(8);
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'CENTRO DE COSTO',
							's2' => 'PRORRATEO'
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//itinerario
	function generarCabecera1(){
		$conf_par_tablewidths=array(7,135,30);
		$conf_par_tablenumbers=array(0,0,0);
		$conf_par_tablealigns=array('C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$this->SetFont('','B',10);
		$this->ln(8);
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'DESTINO',
							's2' => 'CANTIDAD DE DIAS'
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//presupuesto
	function generarCabecera_pre(){
		$conf_par_tablewidths=array(7,135,30);
		$conf_par_tablenumbers=array(0,0,0);
		$conf_par_tablealigns=array('C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$this->SetFont('','B',10);
		$this->ln(8);
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'CONCEPTO DE GASTO',
							's2' => 'MONTO'
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//prorrateo
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->datos_detalle);
	}
	//
	function generarCuerpo($detalle){
		$this->cab();		
		$count = 1;
		$fill = 0;
		$this->total = count($detalle);						
		$this->imprimirLinea($val,$count,$fill);
	}
	//itinerario
	function generarReporte_iti() {
		$this->generarCuerpo_iti($this->datos_itinerario);
	}
	//
	function generarCuerpo_iti($detalle_iti){	
		$count = 1;
		$fill = 0;
		$this->total = count($detalle_iti);						
		$this->imprimirLinea_iti($val,$count,$fill);
	}
	//presupuesto
	function generarReporte_pre() {
		$this->generarCuerpo_pre($this->datos_presupuesto);
	}
	//
	function generarCuerpo_pre($detalle_pre){	
		$count = 1;
		$fill = 0;
		$this->total = count($detalle_pre);						
		$this->imprimirLinea_pre($val,$count,$fill);
	}
	//prorrateo
	function imprimirLinea($val,$count,$fill){
				
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',10);
		$this->tablenumbers=array(0,0,0);
		$this->tablealigns=array('C','L','C');			
		$this->tableborders=array('RLTB','RLTB','RLTB');
		$this->tabletextcolor=array();	
		$i=1;		
		foreach ($this->getDataSource_pro() as $datarow) {		
			$RowArray = array(
				's0' => $i,
				's1' => trim($datarow['descripcion_tcc']),
				's2' => trim($datarow['prorrateo'])
			);
			$fill = !$fill;					
			$this->total = $this->total -1;								
			$this-> MultiRow($RowArray,$fill,0);			
			$this->revisarfinPagina($datarow);							
			$i++;			
		}		
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;	
		$this->Ln(2);
		$this->generarCabecera1();
		$this->generarReporte_iti();
	}
	//linea itinerario
	function imprimirLinea_iti($val,$count,$fill){
				
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',10);
		$this->tablenumbers=array(0,0,0);
		$this->tablealigns=array('C','L','R');			
		$this->tableborders=array('RLTB','RLTB','RLTB');
		$this->tabletextcolor=array();	
		$i=1;
		foreach ($this->getDataSource_iti() as $datarow) {		
			$RowArray = array(
				's0' => $i,
				's1' => $datarow['desc_destino'],
				's2' => trim($datarow['cantidad_dias'])
			);
			$fill = !$fill;					
			$this->total = $this->total -1;								
			$this-> MultiRow($RowArray,$fill,0);			
			$this->revisarfinPagina($datarow);							
			$i++;			
		}		
		$this->cerrarCuadroTotalDias();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;	
		
		$this->generarCabecera_pre();
		$this->generarReporte_pre();
	}
	//linea presupuesto
	function imprimirLinea_pre($val,$count,$fill){
				
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',10);
		$this->tablenumbers=array(0,0,2);
		$this->tablealigns=array('C','L','R');			
		$this->tableborders=array('RLTB','RLTB','RLTB');
		$this->tabletextcolor=array();	
		$i=1;
		foreach ($this->getDataSource_pre() as $datarow) {		
			$RowArray = array(
				's0' => $i,
				's1' => trim($datarow['desc_ingas']),
				's2' => $datarow['monto_mo']				
			);
			$fill = !$fill;					
			$this->total = $this->total -1;								
			$this-> MultiRow($RowArray,$fill,0);			
			$this->revisarfinPagina($datarow);							
			$i++;			
		}	
		$this->cerrarCuadroTotal();	
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;	
	}
	//	
	function revisarfinPagina($a){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 90);
		$this->calcularMontos($a);
		$this->calcularMontosDias($a);			
		if ($startY > 237) {			
			if($this->total!= 0){
				$this->AddPage();
				$this->generarCabecera();
			}				
		}
	}
	//
	function calcularMontosDias($val){
		$this->t2 = $this->t2 + $val['cantidad_dias'];					
	}
	//
	function cerrarCuadroTotalDias(){
		//$conf_par_tablewidths=array(7,20,50,50,20);			
		$this->tablealigns=array('R','R','R');		
		$this->tablenumbers=array(0,0,0);
		$this->tableborders=array('','','LRTB');									
		$RowArray = array(
					't0' => '',
					'espacio' => 'TOTAL: ',
					't2' => $this->t2
				);
		$this-> MultiRow($RowArray,false,1);	
	}
	//
	function calcularMontos($val){
		$this->t2 = $this->t2 + $val['monto_mo'];					
	}
	//
	function cerrarCuadroTotal(){
		//$conf_par_tablewidths=array(7,20,50,50,20);			
		$this->tablealigns=array('R','R','R');		
		$this->tablenumbers=array(0,0,2);
		$this->tableborders=array('','','LRTB');									
		$RowArray = array(
					't0' => '',
					'espacio' => 'TOTAL: ',
					't2' => $this->t2
				);
		$this-> MultiRow($RowArray,false,1);	
	}
	//
	function cab() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(8);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,'FORMULARIO DE SOLICITUD DE FONDOS DE COMISION DE VIAJE',0,1,'C');					
		$this->Ln(3);
		
		$height = 2;
		$width1 = 5;
		$esp_width = 10;
		$width_c1= 55;
		$width_c2= 90;		
		$this->Ln(8);
		$fechaactual = date("d-m-Y H:i:s");
				
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'NRO TRAMITE', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, $this->datos_detalle[0]['nro_tramite'], 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'MOTIVO', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, $this->datos_detalle[0]['motivo'], 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'FUNCIONARIO RESPONSABLE CDV', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, $this->datos_detalle[0]['desc_funcionario'], 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'IMPORTE', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, number_format((float)$this->datos_detalle[0]['importe'], 2, '.', ','), 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'MONEDA', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, $this->datos_detalle[0]['desc_moneda'], 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'TIPO DE PAGO', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, $this->datos_detalle[0]['tipo_pago'], 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->SetFont('', 'B',10);
		$this->SetFillColor(192,192,192, true);	
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->Cell($width_c1, $height, 'FECHA ', 1, 0, 'L', false, '', 0, false, 'T', 'C');
		$this->SetFont('', '',10);				
		$this->Cell($width_c2, $height, $this->datos_detalle[0]['fecha'], 1, 0, 'L', true, '', 0, false, 'T', 'C');
		$this->Ln(6);
		
		$this->Ln(6);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}
}
?>