<?php

class RRendicionConXls
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $hoja;
	private $columnas=array();
	private $fila;
	private $equivalencias=array();
	
	private $indice, $m_fila, $titulo;
	private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
	private $objParam;
	public  $url_archivo;
	
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
	var $datos_depositos;
	
	
	
	function __construct(CTParametro $objParam){
		$this->objParam = $objParam;
		$this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
		//ini_set('memory_limit','512M');
		set_time_limit(400);
		$cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
		$cacheSettings = array('memoryCacheSize'  => '10MB');
		PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

		$this->docexcel = new PHPExcel();
		$this->docexcel->getProperties()->setCreator("PXP")
							 ->setLastModifiedBy("PXP")
							 ->setTitle($this->objParam->getParametro('titulo_archivo'))
							 ->setSubject($this->objParam->getParametro('titulo_archivo'))
							 ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
							 ->setKeywords("office 2007 openxml php")
							 ->setCategory("Report File");
							 
		$this->docexcel->setActiveSheetIndex(0);
		
		$this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('titulo_archivo'));
		
		$this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
								9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
								18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
								26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
								34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
								42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
								50=>'AY',51=>'AZ',
								52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
								60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
								68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
								76=>'BY',77=>'BZ');		
									
	}
	
	function datosHeader ( $detalle, $datos_titulo, $depositos) {
		
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $datos_titulo;
		$this->datos_depositos = $depositos;
		
		
	}
			
	function imprimeDatos(){
		$datos = $this->datos_detalle;
		
		$config = $this->objParam->getParametro('config');
		$columnas = 0;
		
		$inicio_listado = 9;
		
		
		$styleTitulos = array(
							      'font'  => array(
							          'bold'  => true,
							          'size'  => 8,
							          'name'  => 'Arial'
							      ),
							      'alignment' => array(
							          'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
							          'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
							      ),
								   'fill' => array(
								      'type' => PHPExcel_Style_Fill::FILL_SOLID,
								      'color' => array('rgb' => 'c5d9f1')
								   ),
								   'borders' => array(
								         'allborders' => array(
								             'style' => PHPExcel_Style_Border::BORDER_THIN
								         )
								     ));

       $this->docexcel->getActiveSheet()->getStyle('A'.$inicio_listado.':J'.$inicio_listado)->applyFromArray($styleTitulos);
	   
	   
	    /************************************** HEADER MAESTRO********************************/
	     $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,1,'RENDICION CONSOLIDADA');
	     $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,3,'NRO TRAMITE');
	     $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,3,$this->datos_titulo[0]['nro_tramite']);
		 $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,4,'SOLICITANTE');
	     $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,4,$this->datos_titulo[0]['desc_funcionario']);
		 $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,5,'CARGO');
	     $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,5,$this->datos_titulo[0]['cargo_funcionario']);
		 $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,6,'MONEDA');
	     $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,6,strtoupper($this->datos_titulo[0]['desc_moneda']));
	   
	   
		
		
		
		$this->docexcel->getActiveSheet()->getStyle('A'.($inicio_listado-1))->applyFromArray($styleTitulos);
	    $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$inicio_listado-1,'DOCUMENTOS');
		
		$this->docexcel->getActiveSheet()->getStyle('A'.$inicio_listado.':L'.$inicio_listado)->applyFromArray($styleTitulos);
	   
	   
		//*************************************Cabecera*****************************************
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[0])->setWidth(20);		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$inicio_listado,'Cod Cat Prog');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[2])->setWidth(40);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$inicio_listado,'Centro de Costo');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[1])->setWidth(40);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$inicio_listado,'Partida');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[3])->setWidth(40);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$inicio_listado,'Concepto de Gasto');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[4])->setWidth(40);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$inicio_listado,'Detalle');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5])->setWidth(15);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$inicio_listado,'Fecha Documento');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[6])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$inicio_listado,'Desc Plantilla');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[7])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$inicio_listado,'Razon Social');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[8])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,$inicio_listado,'Nro Documento');
		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[9])->setWidth(20);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(9,$inicio_listado,'Id Int Comprobante');
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[10])->setWidth(15);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,$inicio_listado,'Nro Cheque');
		
		$this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[11])->setWidth(30);
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,$inicio_listado,'Importe');
		//*************************************Fin Cabecera*****************************************
		
		$fila = $inicio_listado + 1;
		$contador = 1;
		$total = 0;
		
		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $value) {
			
			$newDate = date("d/m/Y", strtotime( $value['fecha']));	
							
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$value['codigo_categoria']);			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['codigo_cc']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,$value['partida']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,$value['desc_ingas']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$value['descripcion']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$newDate);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(6,$fila,$value['desc_plantilla']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(7,$fila,$value['razon_social']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(8,$fila,$value['nro_documento']);
			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(9,$fila,$value['id_int_comprobante']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,$fila,$value['nro_cheque']);
			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,$fila,$value['precio_total_final']);
			
			$total = $total + $value['precio_total_final'];
			
			$fila++;
			$contador++;
		}
		//************************************************Fin Detalle***********************************************
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(10,$fila,'TOTAL');
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(11,$fila,$total);
		
		
		
		$this->docexcel->getActiveSheet()->getStyle('A'.($inicio_listado-1))->applyFromArray($styleTitulos);
	    $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$inicio_listado-1,'DOCUMENTOS');
		
		$this->docexcel->getActiveSheet()->getStyle('A'.$inicio_listado.':J'.$inicio_listado)->applyFromArray($styleTitulos);
	   
		
		
		$inicio_listado=$inicio_listado + $contador + 2;
		
		
		//*************************************  DEPOSITOS  *****************************************
		
		
		$this->docexcel->getActiveSheet()->getStyle('A'.($inicio_listado-1))->applyFromArray($styleTitulos);
	    $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$inicio_listado-1,'DEPOSITOS');
		
		$this->docexcel->getActiveSheet()->getStyle('A'.$inicio_listado.':F'.$inicio_listado)->applyFromArray($styleTitulos);
		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$inicio_listado,'Tipo');		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$inicio_listado,'Finalidad');		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$inicio_listado,'Denominación');		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$inicio_listado,'Nro Cuenta');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$inicio_listado,'Fecha');
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$inicio_listado,'Importe');
		
		$total = 0;
		
		$fila = $inicio_listado + 1;
		$contador = 1;
		$total = 0;
		foreach($this->datos_depositos  as $value) {
			
			$newDate = date("d/m/Y", strtotime( $value['fecha']));	
							
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(0,$fila,$value['tipo']);			
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(1,$fila,$value['nombre_finalidad']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(2,$fila,$value['denominacion']);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(3,$fila,'"'.$value['nro_cuenta'].'"');
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,$newDate);
			$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$value['importe_deposito']);
			
			$total = $total + $value['importe_deposito'];
			
			$fila++;
			$contador++;
		}
		
		$this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(4,$fila,'TOTAL');
        $this->docexcel->setActiveSheetIndex(0)->setCellValueByColumnAndRow(5,$fila,$total);
		
		
		
	}

    

	
	
	function generarReporte(){
		
		$this->imprimeDatos();
		
		//echo $this->nombre_archivo; exit;
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);		
		
		
	}	
	

}

?>