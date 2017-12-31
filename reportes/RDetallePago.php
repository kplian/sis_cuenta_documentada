<?php
// Extend the TCPDF class to create custom MultiRow
class RMemoriaCalculo extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $t1;
	var $tg1;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	var $ult_codigo_partida;
	var $ult_concepto;
	
	
	
	function datosHeader ( $detalle, $totales, $gestion,$dataEmpresa) {
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 12);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $dataEmpresa;
		//$this->datos_gestion = $gestion;
		$this->subtotal = 0;
		$this->SetMargins(7, 45, 5);

	}
	
	function Header() {
		
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
		
		$this->Ln(3);
		//formato de fecha
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,35,20);
		$this->ln(5);
		
		
	    $this->SetFont('','B',11);
		$this->Cell(0,5,"DETALLE PAGOS",0,1,'C');
		$this->Cell(0,5,mb_strtoupper($this->datos_entidad['nombre'],'UTF-8'),0,1,'C');
		//$this->Cell(0,5,"ANTEPROYECTO PRESUPUESTO GESTION ".$this->datos_gestion['anho'],0,1,'C');		

		$this->SetFont('','B',7);
		//$this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');		
		$this->Ln(2);
		
		$this->SetFont('','',9);
		
		$height = 5;
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 55;
		$width_c2= 92;
        $width3 = 40;
        $width4 = 75;
		

		
		$this->SetFont('','B',7);
		//$this->generarCabecera();
        //armca caecera de la tabla
        $conf_par_tablewidths=array(10,50,50,80,15,20,15,25);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0);
        $conf_tableborders=array();
        $conf_tabletextcolor=array();


        $this->Cell(10,3,"Nº","LT",0,'C');
        $this->Cell(50,3,"DEPARTAMENTO","LT",0,'C');
        $this->Cell(50,3,"CONCEPTO DE GASTO","LT",0,'C');
        $this->Cell(80,3,"JUSTIFICACION","LT",0,'C');
        $this->Cell(15,3,"UNIDAD DE","LT",0,'C');
        $this->Cell(20,3,"COSTO","LT",0,'C');
        $this->Cell(15,3,"CANT. REQ.","LT",0,'C');
        $this->Cell(25,3,"TOTAL","LTR",1,'C');

        $this->Cell(10,3,"","LB",0,'C');
        $this->Cell(50,3,"","LB",0,'C');
        $this->Cell(50,3,"","LB",0,'C');
        $this->Cell(80,3,"","LB",0,'C');
        $this->Cell(15,3,"MEDIDA","LB",0,'C');
        $this->Cell(20,3,"UNITARIO","LB",0,'C');
        $this->Cell(15,3,"","LB",0,'C');
        $this->Cell(25,3,"ESTACIONALIDAD","LBR",0,'C');


        /*$RowArray = array(
            's0'  => 'Nº',
            's1' => 'DEPARTAMENTO',
            's2' => 'CONCEPTO DE GASTO',
            's3' => 'JUSTIFICACION',
            's4' => 'UNIDAD DE MEDIDA',
            's5' => 'COSTO UNITARIO',
            's6' => 'CANT. REQ.',
            's7' => 'TOTAL ESTACIONALIDAD');*/

	     $RowArray = array(
	            's0'  => 'Nº',
	            's1' => 'FONDO',
	            's2' => 'TIPO PLANILLA',
	            's3' => 'MONTO',
	            's4' => 'EXENTO');
			
        //$this-> MultiRow($RowArray,false,1);
		
	}
   
   function generarReporte() {
		//$this->setFontSubsetting(false);
		$this->AddPage();
		
	    $sw = false;
		$concepto = '';
		
		$this->generarCuerpo($this->datos_detalle);
		
		
		$this->cerrarCuadro();
		$this->Ln(4);
		$this->cerrarConcepto();
		$this->Ln(4);
		$this->cerrarCuadroTotal();
		
		
		
		//$this->Ln(4);
		
		
	} 
    function generarCabecera(){
    	
		
		
		//armca caecera de la tabla
		$conf_par_tablewidths=array(10,50,50,80,15,20,15,25);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0);
        $conf_tableborders=array();
        $conf_tabletextcolor=array();
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
						
	     $RowArray = array(
	            's0'  => 'Nº',
	            's1' => 'FONDO',
	            's2' => 'TIPO PLANILLA',
	            's3' => 'MONTO',
	            's4' => 'EXENTO');

		
    }
	
	function generarCuerpo($detalle) {

		$count = 1;
		$sw = 0;
		$sw1 = 0;
		$this->ult_codigo_partida = '';
		$this->ult_concepto = '';
		$fill = 0;
		
		$this->total = count($detalle);
		
		$this->s1 = 0;
		$this->t1 = 0;
		$this->tg1 = 0;
		
		
		foreach ($detalle as $val) {
				
			if($sw == 1){
				if($this->ult_codigo_partida != $val["codigo_partida"]){
					$sw = 0;
					$count = 1;
					$this->cerrarCuadro();
					$this->Ln(4);
					//$this->revisarfinPagina();
				}				
			}	
				
			if($sw1 == 1){
				if($this->ult_concepto != $val["concepto"]){
					$sw1 = 0;
					$this->cerrarConcepto();
					$this->Ln(4);
					//$this->revisarfinPagina();
				}				
			}	
				
				
			

			if($sw1 == 0){
				$fill = 0;
				$this->imprimirConcepto($val["concepto"],$fill);
				$this->Ln(4);
				$fill = !$fill;
				$sw1 = 1;
				$this->ult_concepto = $val["concepto"];
			}
			
			if($sw == 0){
				$fill = 0;
				$this->imprimirPartida($val["codigo_partida"]." - ".$val["nombre_partida"],$fill);
				$fill = !$fill;
				$sw = 1;
				$this->ult_codigo_partida = $val["codigo_partida"];
			}

			
			
			
			$this->imprimirLinea($val,$count,$fill);
			$fill = !$fill;
			$count = $count + 1;
			$this->total = $this->total -1;
			//$this->revisarfinPagina();
			
		}
		
		
		
	}	
	
	function imprimirLinea($val,$count,$fill){
		
		$this->SetFillColor(224, 235, 255);
        $this->SetTextColor(0);
        $this->SetFont('','',8);
			
		$conf_par_tablewidths=array(10,50,50,80,15,20,15,25);
        $conf_par_tablealigns=array('C','L','L','L','R','R','R','R');
        $conf_par_tablenumbers=array(0,0,0,0,0,2,2,2);
		$conf_tableborders=array('T','T','T','T','T','T','T','T');
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$this->caclularMontos($val);
		
		$newDate = date("d/m/Y", strtotime( $val['fecha']));
		
		$RowArray = array(
            			's0' => $count,
						's1' => $val['descripcion_pres'],
                        's2' => $val['desc_ingas'],
                        's3' => $val['justificacion'],
                        's4' => $val['unidad_medida'],
                        's5' => $val['importe_unitario'],
						's6' => $val['cantidad_mem'],
                        's7' => $val['importe']);
						
		$this-> MultiRow($RowArray,$fill,1);
			
	}


    function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
		if ($startY > 180) {


			$k = 	($startY + 4 * 6) + $dimensions['bm'] - ($dimensions['hk']);
			/*
			for($i=0;$i<=k;$i++){
				$this->ln();
				$this->ln();
				$this->ln();
				$this->ln();
				$this->ln();
				$this->ln();
			}*/

			if($this->total!= 0){
				$this->AddPage();
			}



		}
		 
		
	}
	
	function imprimirPartida($titulo,$fill){
		
		$this->SetFont('','B',9);
		$this->tablewidths=array(10+50+50+80+15+20+15+25);
        $this->tablealigns=array('L');
        $this->tablenumbers=array(0);
        $this->tableborders=array('B');
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$RowArray = array(
            			'casa' => $titulo);
                         
        $this-> MultiRow($RowArray,$fill,1);
		
	}
	
	function imprimirConcepto($titulo,$fill){
		$conf_par_tablewidths=array(10+50+50+80+15+20+15+25);
        $conf_par_tablealigns=array('L');
        $conf_par_tablenumbers=array(0);
		$conf_tableborders=array('B');
		$this->SetFont('','B',11);
		
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$RowArray = array(
            			'casa' => $titulo);
                         
        $this-> MultiRow($RowArray,$fill,1);
		
	}
	
	
	
   function caclularMontos($val){
		
		$this->s1 = $this->s1 + $val['importe'];	
		$this->t1 = $this->t1 + $val['importe'];
		$this->tg1 = $this->tg1 + $val['importe'];
   }
   
   
 
  
  function cerrarCuadro(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
	   	   
			$this->tablewidths=array(10+50+50+80+15+20+15,25);
            $this->tablealigns=array('R','R');
	        $this->tablenumbers=array(0,2,);	
	        $this->tableborders=array('T','LRTB');
			$this->SetFont('','B',8);
	        
	        $RowArray = array( 
	                    'espacio' => 'TOTAL PARTIDA '.$this->ult_codigo_partida.':',
	                    's1' => $this->s1
	                  );     
	                     
	        $this-> MultiRow($RowArray,false,1);
			
			$this->s1 = 0;
	
  }
  
  function cerrarConcepto(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
	   	   
			$this->tablewidths=array(10+50+50+80+15+20+15,25);
            $this->tablealigns=array('R','R');
	        $this->tablenumbers=array(0,2,);	
	        $this->tableborders=array('T','LRTB');
			$this->SetFont('','B',8);
	        
	        $RowArray = array( 
	                    'espacio' => 'TOTAL '.$this->ult_concepto.':',
	                    's1' => $this->t1
	                  );     
	                     
	        $this-> MultiRow($RowArray,false,1);
			
			$this->t1 = 0;
	
  }

  function cerrarCuadroTotal(){
   	    	
   	    //si noes inicio termina el cuardro anterior	   	  
		$this->tablewidths=array(10+50+50+80+15+10+10,40);
		//$this->tablewidths=array(10+50+50+80+15+20+15,25);
        $this->tablealigns=array('C','R');
        $this->tablenumbers=array(0,2);	
        $this->tableborders=array('TB','LRTB');
        $this->SetFont('','B',9);
        $RowArray = array( 
                    'espacio' => 'TOTAL GENERAL: ',
                    'tg1' => $this->tg1
                  );     
                     
        $this-> MultiRow($RowArray,false,1);
	
  }
  
 
}
?>