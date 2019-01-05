<?php
class RDuiXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    function __construct(CTParametro $objParam)
    {
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

        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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
    function imprimeCabecera() {
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Reporte Duis');
        $this->docexcel->setActiveSheetIndex(0);

        $datos = $this->objParam->getParametro('datos');

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );


        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            /*'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )*/
			);
        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),

        );


        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'REPORTE DUIS '.' GESTIÓN '.$this->objParam->getParametro('gestion') );
        $this->docexcel->getActiveSheet()->getStyle('A2:Q2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:Q2');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'(Expresados en bolivianos)');
        $this->docexcel->getActiveSheet()->getStyle('A3:Q3')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A3:Q3');

        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);

        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);
		$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(24);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(30);
		$this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(50);

        $this->docexcel->getActiveSheet()->getStyle('A5:Q5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:Q5')->applyFromArray($styleTitulos2);
        //////////////////////MERGE////////////////////////////
        $this->docexcel->getActiveSheet()->mergeCells('A5:A6');
		$this->docexcel->getActiveSheet()->mergeCells('B5:B6');
		$this->docexcel->getActiveSheet()->mergeCells('C5:C6');
		$this->docexcel->getActiveSheet()->mergeCells('D5:D6');
		$this->docexcel->getActiveSheet()->mergeCells('E5:E6');
		$this->docexcel->getActiveSheet()->mergeCells('F5:F6');
		$this->docexcel->getActiveSheet()->mergeCells('G5:G6');
		$this->docexcel->getActiveSheet()->mergeCells('H5:H6');
		$this->docexcel->getActiveSheet()->mergeCells('I5:I6');
		$this->docexcel->getActiveSheet()->mergeCells('J5:J6');
		$this->docexcel->getActiveSheet()->mergeCells('K5:K6');
		$this->docexcel->getActiveSheet()->mergeCells('L5:L6');
		$this->docexcel->getActiveSheet()->mergeCells('M5:M6');
		$this->docexcel->getActiveSheet()->mergeCells('N5:N6');
		$this->docexcel->getActiveSheet()->mergeCells('O5:O6');
		$this->docexcel->getActiveSheet()->mergeCells('P5:P6');
		$this->docexcel->getActiveSheet()->mergeCells('Q5:Q6');
		///////////////////////////////////////////////////////

        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A5','Nº');
		$this->docexcel->getActiveSheet()->setCellValue('B5','Dui');
		$this->docexcel->getActiveSheet()->setCellValue('C5','Agencia despachante');
		$this->docexcel->getActiveSheet()->setCellValue('D5','Nro factura proveedor');
		$this->docexcel->getActiveSheet()->setCellValue('E5','Pedido sap');
		$this->docexcel->getActiveSheet()->setCellValue('F5','Tramite pedido endesis');
        $this->docexcel->getActiveSheet()->setCellValue('G5','Tramite anticipo dui');
		$this->docexcel->getActiveSheet()->setCellValue('H5','Nro comprobante pago Dui');
		$this->docexcel->getActiveSheet()->setCellValue('I5','Nro comprobante diario Dui');
		$this->docexcel->getActiveSheet()->setCellValue('J5','Monto Dui');
		$this->docexcel->getActiveSheet()->setCellValue('K5','Tramite comision agencia');
        $this->docexcel->getActiveSheet()->setCellValue('L5','Nro comprobante diario comision');
		$this->docexcel->getActiveSheet()->setCellValue('M5','Nro comprobante pago comision');
		$this->docexcel->getActiveSheet()->setCellValue('N5','Monto comision/Alm/Otr'); //#2 endetr Juan 28/12/2018 cambio de nombre  
		$this->docexcel->getActiveSheet()->setCellValue('O5','Archivo Dui');
        $this->docexcel->getActiveSheet()->setCellValue('P5','Archivo comision');
		$this->docexcel->getActiveSheet()->setCellValue('Q5','Observaciones');
		

    }
    function generarDatos()
    {
    	
		$objDrawing = new PHPExcel_Worksheet_Drawing();
		$objDrawing->setName('Logo');
		$objDrawing->setDescription('Logo');
		$objDrawing->setPath(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO']);
		$objDrawing->setHeight(95);
		$objDrawing->setWorksheet($this->docexcel->setActiveSheetIndex(0));
		
		
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $this->numero = 1;
        $fila = 7;
        $datos = $this->objParam->getParametro('datos');
        $this->imprimeCabecera(0);
        //var_dump($datos);exit;
        $styleAlineado = array(
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			)
			);
			
        foreach ($datos as $value){
        	
	            $this->docexcel->getActiveSheet()->getStyle('A'.($fila).':Q'.($fila).'')->applyFromArray($styleAlineado);
                if(($this->numero%2) == 0){
			        $rggg = str_replace('#', '', $value['ruta_icono']);
			        $styleResultado = array(
			            'fill' => array(
			                'type' => PHPExcel_Style_Fill::FILL_SOLID,
			                'color' => array(
			                    'rgb' =>  'cce6ff'//'0066CC'
			                )
			            ),
						);
                	$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':Q'.($fila).'')->applyFromArray($styleResultado);	
                }
				
	
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['dui']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['agencia_despachante']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_factura_proveedor']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['pedido_sap']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['tramite_pedido_endesis']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['tramite_anticipo_dui']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['nro_comprobante_pago_dui']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['nro_comprobante_diario_dui']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['monto_dui']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['tramite_comision_agencia']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['nro_comprobante_diario_comision']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['nro_comprobante_pago_comision']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['monto_comision']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['archivo_dui']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $value['archivo_comision']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['observaciones']);

				
				$fila++;
                $this->numero++;
			
        }
    }
    function generarReporte(){

        //$this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        $this->imprimeCabecera(0);

    }

}
?>