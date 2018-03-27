<?php
class RViaticosForm110Xls
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $fila;
	private $filaFirstBox;
	private $filaSecondBox;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;

	private $desc_moneda='Bolivianos';
	private $dataSet;
	private $tipo_reporte;
	private $titulo_reporte;

	private $tam_letra_titulo = 12;
	private $tam_letra_subtitulo = 10;
	private $tam_letra_cabecera = 10;
	private $tam_letra_detalle_cabecera = 8;
	private $tam_letra_detalle = 8;

	private $paramDepto;
	private $dataSetDet;
	
	
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

		$this->initializeColumnWidth($this->docexcel->getActiveSheet());
		$this->printerConfiguration();
									
	}
	
	function datosHeader ($detalle) {
		$this->datos_detalle = $detalle;
	}

	function generarReporte() {
		$sheet=$this->docexcel->setActiveSheetIndex(0);
		$this->imprimeTitulo($sheet);
		$this->mainBox($sheet);
		$this->detalleResumen($sheet);
		$this->detalle($sheet);
		$this->firmas($sheet);
		//Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);		
	}

	function imprimeTitulo($sheet) {
		$sheet->setCellValueByColumnAndRow(0,1,$this->objParam->getParametro('titulo_rep'));
		
		//Título Principal
		$titulo1 = "REPORTE LISTADO VIÁTICOS - FORM. 110";
		$this->cell($sheet,$titulo1,'A1',0,1,"center",true,$this->tam_letra_titulo,Arial);
		$sheet->mergeCells('A1:E1');

		//Título 1
		$titulo1 = $this->dataSet[0]['desc_periodo'];
		$this->cell($sheet,$titulo1,'A2',0,2,"center",true,$this->tam_letra_titulo,Arial);
		$sheet->mergeCells('A2:E2');
		
		//Título 2
		$fecha_hasta = date("d/m/Y",strtotime($this->objParam->getParametro('fecha_hasta')));
		$titulo2 = "Depto.: ";
		$this->cell($sheet,$titulo2.$this->paramDepto,'A3',0,3,"center",true,$this->tam_letra_subtitulo,Arial);
		$sheet->mergeCells('A3:E3');
		
		//Título 3
		$titulo3="";
		$this->cell($sheet,$titulo3,'A4',0,4,"center",true,$this->tam_letra_subtitulo,Arial);
		$sheet->mergeCells('A4:E4');

		//Logo
		$objDrawing = new PHPExcel_Worksheet_Drawing();
		$objDrawing->setName('Logo');
		$objDrawing->setDescription('Logo');
		$objDrawing->setPath(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO']);
		$objDrawing->setHeight(50);
		$objDrawing->setWorksheet($this->docexcel->setActiveSheetIndex(0));

		$this->fila = 5;
	}

	function cell($sheet,$texto,$cell,$x,$y,$align="left",$bold=true,$size=10,$name=Arial,$wrap=false,$border=false,$valign='center',$number=false){
		$sheet->getStyle($cell)->getFont()->applyFromArray(array('bold'=>$bold,'size'=>$size,'name'=>$name));
		//Alineación horizontal
		if($align=='left'){
			$sheet->getStyle($cell)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
		} else if($align=='right'){
			$sheet->getStyle($cell)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
		} else if($align=='center'){
			$sheet->getStyle($cell)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		}
		//Alineación vertical
		if($valign=='center'){
			$sheet->getStyle($cell)->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
		} else if($valign=='top'){
			$sheet->getStyle($cell)->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_TOP);
		} else if($valign=='bottom'){
			$sheet->getStyle($cell)->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_BOTTOM);
		}
		//Rendereo del texto
		$sheet->setCellValueByColumnAndRow($x,$y,$texto);

		//Wrap texto
		if($wrap==true){
			$sheet->getStyle($cell)->getAlignment()->setWrapText(true);
		}

		//Border
		if($border==true){
			$styleArray = array(
			    'borders' => array(
			        'outline' => array(
			            'style' => PHPExcel_Style_Border::BORDER_THIN//PHPExcel_Style_Border::BORDER_THICK
			        ),
			    ),
			);

			$sheet->getStyle($cell)->applyFromArray($styleArray);
		}

		if($number==true){
			$sheet->getStyle($cell)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_00); 
		}
	}

	function mainBox($sheet){
		//Cabecera caja
		$f = $this->fila;
		$this->cell($sheet,'NRO.',"A$f",0,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NOMBRE FUNCIONARIO',"B$f",1,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'CÓDIGO',"C$f",2,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'DOCUMENTO IDENTIDAD',"D$f",3,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'VIÁTICO Bs.',"E$f",4,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'PASAJE (EXCENTO) Bs.',"F$f",5,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'TOTAL Bs.',"G$f",6,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);

		//////////////////
		//Detalle de datos
		//////////////////
		//Array totalizador
		$arrayTotal = array(
		 	'total'=>0
		);

		for ($fil=0; $fil < count($this->dataSet); $fil++) {
			$f++;
			//Fecha
			$fecha='';
			if($this->dataSet[$fil]['fecha_ini_dep']!=''){
				$fecha=date("d/m/Y",strtotime($this->dataSet[$fil]['fecha_ini_dep']));
			}
			$this->cell($sheet,$fil+1,"A$f",0,$f,"right",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSet[$fil]['desc_funcionario2'],"B$f",1,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSet[$fil]['codigo'],"C$f",2,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSet[$fil]['ci'],"D$f",3,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSet[$fil]['total'],"E$f",4,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSet[$fil]['total_excento'],"F$f",5,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$range_sum='=E'.($f).'+F'.($f);
			//echo $range_sum;exit;
			$this->cell($sheet,$range_sum,"G$f",6,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);

			//Actualiza los totales
			$arrayTotal['total']+=$this->dataSet[$fil]['total'];

		}

		//Borde a la caja
		$this->cellBorder($sheet,"A".$this->fila.":E$f",'vertical');
		$this->cellBorder($sheet,"E".$this->fila.":E$f");

		//Totales
		$f++;
		$this->cell($sheet,'TOTAL BS.',"A$f",0,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$sheet->mergeCells("A$f:D$f");
		$this->cellBorder($sheet,"A$f:D$f");


		$range_sum='=SUM(E'.($this->fila+1).':E'.($f-1).')';
		$this->cell($sheet,$range_sum,"E$f",4,$f,"right",true,$this->tam_letra_detalle,Arial,true,true,'center',true);
		$range_sum='=SUM(F'.($this->fila+1).':F'.($f-1).')';
		$this->cell($sheet,$range_sum,"F$f",5,$f,"right",true,$this->tam_letra_detalle,Arial,true,true,'center',true);
		$range_sum='=SUM(G'.($this->fila+1).':G'.($f-1).')';
		$this->cell($sheet,$range_sum,"G$f",6,$f,"right",true,$this->tam_letra_detalle,Arial,true,true,'center',true);
		

		//Actualización variables
		$this->fila=$f+6;
	}

	function detalleResumen($sheet){
		$f = $this->fila;

		$arrayTotal = array(
		 	'sin_cbte'=>0,
		 	'sin_validar'=>0,
		 	'sin_funcionario'=>0
		);
		for($fil=0;$fil<count($this->dataSetDet);$fil++) {
			if($this->dataSetDet[$fil]['id_int_comprobante']==null){
				$arrayTotal['sin_cbte']++;
			}
			if($this->dataSetDet[$fil]['id_int_comprobante']!=null&&$this->dataSetDet[$fil]['estado_cbte']==""){
				$arrayTotal['sin_validar']++;
			}
			if($this->dataSetDet[$fil]['id_funcionario']==null){
				$arrayTotal['sin_funcionario']++;
			}
		}
		//var_dump($arrayTotal['sin_funcionario']);exit;
		if($arrayTotal['sin_cbte']>0||$arrayTotal['sin_validar']>0||$arrayTotal['sin_funcionario']>0){
			//Título que existen observados
			$sheet->setCellValueByColumnAndRow(1,$f,'EXISTEN OBSERVACIONES QUE DEBEN SER SUBSANADAS');
			$f++;

			//Despliegue de las cantidades
			$this->cell($sheet,"Recibos sin Comprobantes","B$f",1,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$arrayTotal['sin_cbte'],"C$f",2,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$f++;
			$this->cell($sheet,"Recibos con Comprobantes no Validados","B$f",1,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$arrayTotal['sin_validar'],"C$f",2,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$f++;
			$this->cell($sheet,"Recibos sin Funcionario","B$f",1,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$arrayTotal['sin_funcionario'],"C$f",2,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$f++;
		}

		/*for($fil=0;$fil<count($this->dataSetDet);$fil++) {
			$this->cell($sheet,$this->dataSetDet[$fil]['nro_documento'],"C$f",2,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$f++;
		}*/
	}

	function cellBorder($sheet,$range,$type='normal'){
		if($type=="normal"){
			$styleArray = array(
			    'borders' => array(
			        'outline' => array(
			            'style' => PHPExcel_Style_Border::BORDER_THIN //PHPExcel_Style_Border::BORDER_THICK,
			        ),
			    ),
			);
		} else if($type=='vertical'){
			$styleArray = array(
			    'borders' => array(
			        'vertical' => array(
			            'style' => PHPExcel_Style_Border::BORDER_THIN //PHPExcel_Style_Border::BORDER_THICK,
			        ),
			    ),
			);
		}

		$sheet->getStyle($range)->applyFromArray($styleArray);
	}

	function printerConfiguration(){
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_LETTER);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setFitToWidth(1);
		$this->docexcel->setActiveSheetIndex(0)->getPageSetup()->setFitToHeight(0);

	}

	function firmas($sheet){
		$f=$this->fila;
		$this->cell($sheet,'',"C$f",2,$f,"left",true,$this->tam_letra_cabecera,Arial,false,false);
		$f++;
		$this->cell($sheet,'',"C$f",2,$f,"left",true,$this->tam_letra_cabecera,Arial,false,false);
	}

	function setDataSet($dataset){
		$this->dataSet = $dataset;
	}

	function setParamDepto($depto){
		$this->paramDepto=$depto;
	}

	function setDataSetDet($dataset){
		$this->dataSetDet = $dataset;
	}

	function initializeColumnWidth($sheet){
		$sheet->getColumnDimension('A')->setWidth(5);
		$sheet->getColumnDimension('B')->setWidth(50);
		$sheet->getColumnDimension('C')->setWidth(15);
		$sheet->getColumnDimension('D')->setWidth(20);
		$sheet->getColumnDimension('E')->setWidth(15);
		$sheet->getColumnDimension('F')->setWidth(15);
		$sheet->getColumnDimension('G')->setWidth(15);
	}

	function initializeColumnWidthDetail($sheet){
		$sheet->getColumnDimension('A')->setWidth(5);
		$sheet->getColumnDimension('B')->setWidth(10);
		$sheet->getColumnDimension('C')->setWidth(15);
		$sheet->getColumnDimension('D')->setWidth(25);
		$sheet->getColumnDimension('E')->setWidth(35);
		$sheet->getColumnDimension('F')->setWidth(15);
		$sheet->getColumnDimension('G')->setWidth(10);
		$sheet->getColumnDimension('H')->setWidth(15);
		$sheet->getColumnDimension('I')->setWidth(20);
		$sheet->getColumnDimension('J')->setWidth(20);
		$sheet->getColumnDimension('K')->setWidth(15);
		$sheet->getColumnDimension('L')->setWidth(15);
		$sheet->getColumnDimension('M')->setWidth(50);
		$sheet->getColumnDimension('N')->setWidth(10);
		$sheet->getColumnDimension('O')->setWidth(20);
		$sheet->getColumnDimension('P')->setWidth(15);
		$sheet->getColumnDimension('Q')->setWidth(15);
		$sheet->getColumnDimension('R')->setWidth(10);
		$sheet->getColumnDimension('S')->setWidth(15);
		$sheet->getColumnDimension('T')->setWidth(20);
		$sheet->getColumnDimension('U')->setWidth(15);
		$sheet->getColumnDimension('V')->setWidth(20);
		$sheet->getColumnDimension('W')->setWidth(20);
		$sheet->getColumnDimension('X')->setWidth(10);
		$sheet->getColumnDimension('Y')->setWidth(15);
		$sheet->getColumnDimension('Z')->setWidth(15);
		$sheet->getColumnDimension('AA')->setWidth(50);
	}
	
	function setTipoReporte($val){
		$this->tipo_reporte = $val;
	}

	function setTituloReporte($val){
		$this->titulo_reporte = $val;
	}

	function setMoneda($val){
		if($val!=''){
			$this->desc_moneda = $val;
		}
	}

	function detalle($sheet){
		//Creación de nueva pestaña
		$sheet = $this->docexcel->createSheet();
        $sheet->setTitle("Detalle Recibos");

        //Título 
        $titulo = "DETALLE DE LOS RECIBOS SIN RETENCIÓN DE VIÁTICOS";
		$this->cell($sheet,$titulo,'A1',0,1,"center",true,$this->tam_letra_titulo,Arial);
		$sheet->mergeCells('A1:E1');

        //Ancho de columnas
        $this->initializeColumnWidthDetail($sheet);

        //Cabecera caja
        $inicio=3;
		$f = $inicio;
		$this->cell($sheet,'NRO.',"A$f",0,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'ID.DOC.',"B$f",1,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NRO.TRÁMITE',"C$f",2,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'TIPO DOCUMENTO',"D$f",3,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'SOLICITANTE',"E$f",4,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'IMPORTE BS.',"F$f",5,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'ID.CBTE',"G$f",6,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'ESTADO CBTE.',"H$f",7,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NIT',"I$f",8,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NRO. DOCUMENTO',"J$f",9,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NRO. AUTORIZACIÓN',"K$f",10,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'FECHA',"L$f",11,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'RAZÓN SOCIAL',"M$f",12,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'MONEDA',"N$f",13,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'IMPORTE DOC.',"O$f",14,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'EXCENTO',"P$f",15,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'DESCUENTO',"Q$f",16,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NETO',"R$f",17,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'CÓDIGO DE CONTROL',"S$f",18,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'IVA',"T$f",19,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'IT',"U$f",20,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'ICE',"V$f",21,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'LÍQUIDO PAGABLE',"W$f",22,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'DUI',"X$f",23,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'NRO.TRÁMITE VIÁTICOS',"Y$f",24,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'FECHA VIÁTICO',"Z$f",25,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$this->cell($sheet,'SOLICITANTE VIÁTICO',"AA$f",26,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);

		//////////////////
		//Detalle de datos
		//////////////////
		//Array totalizador
		$arrayTotal = array(
		 	'total'=>0
		);

		for ($fil=0; $fil < count($this->dataSetDet); $fil++) {
			$f++;
			$this->cell($sheet,$fil+1,"A$f",0,$f,"right",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['id_doc_compra_venta'],"B$f",1,$f,"right",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['nro_tramite'],"C$f",2,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['desc_plantilla'],"D$f",3,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['desc_funcionario'],"E$f",4,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_mb'],"F$f",5,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['id_int_comprobante'],"G$f",6,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['estado_cbte'],"H$f",7,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['nit'],"I$f",8,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['nro_documento'],"J$f",9,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['nro_autorizacion'],"K$f",10,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['fecha'],"L$f",11,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['razon_social'],"M$f",12,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['desc_moneda'],"N$f",13,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_doc'],"O$f",14,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_excento'],"P$f",15,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_descuento'],"Q$f",16,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_neto'],"R$f",17,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['codigo_control'],"S$f",18,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_iva'],"T$f",19,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_it'],"U$f",20,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_ice'],"V$f",21,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['importe_pago_liquido'],"W$f",22,$f,"right",false,$this->tam_letra_detalle,Arial,true,true,'center',true);
			$this->cell($sheet,$this->dataSetDet[$fil]['nro_dui'],"X$f",23,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['nro_tramite_viatico'],"Y$f",24,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['fecha_viatico'],"Z$f",25,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			$this->cell($sheet,$this->dataSetDet[$fil]['desc_funcionario_sol'],"AA$f",26,$f,"left",false,$this->tam_letra_detalle,Arial,true,true);
			

		}

		//Borde a la caja
		$this->cellBorder($sheet,"A".$this->fila.":E$f",'vertical');
		$this->cellBorder($sheet,"E".$this->fila.":E$f");

		//Totales
		$f++;
		$this->cell($sheet,'TOTAL',"A$f",0,$f,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$sheet->mergeCells("A$f:D$f");
		$this->cellBorder($sheet,"A$f:D$f");
		$this->cell($sheet,number_format($arrayTotal['total'],2),"E$f",4,$f,"right",true,$this->tam_letra_detalle,Arial,false,true);

		//$objPHPExcel->getActiveSheet()->setCellValue('E11', '=SUM(E4:E9)');
		$this->cell($sheet,'=SUM(F1:F170)',"A$f",0,$f+5,"center",true,$this->tam_letra_detalle,Arial,true,true);
		$range_sum='=SUM(F'.($inicio+1).':F'.($f-1).')';
		$this->cell($sheet,$range_sum,"F$f",5,$f,"right",true,$this->tam_letra_detalle,Arial,true,true,'center',true);


		//Actualización variables
		$this->fila=$f+6;
	}
	
}
?>