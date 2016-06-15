<?php
include_once(dirname(__FILE__).'/../../lib/PHPWord/src/PhpWord/Autoloader.php');
\PhpOffice\PhpWord\Autoloader::register();
Class RMemoAsignacion {
	
	private $dataSource;
    
    public function datosHeader( $dataSource) {
        $this->dataSource = $dataSource;
    }
    
   

    function write($fileName) {
    	
		$phpWord = new \PhpOffice\PhpWord\PhpWord();
		$document = $phpWord->loadTemplate(dirname(__FILE__).'/plantilla_memo_fa.docx');
		setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
		
		
		$document->setValue('NOMBRE_SOLICITANTE', $this->dataSource[0]['desc_funcionario']); // On section/content
		$document->setValue('CARGO_SOLICITANTE', $this->dataSource[0]['cargo_funcionario']); // On section/content
		$document->setValue('ASUNTO', $this->dataSource[0]['motivo']); // On section/content
		$document->setValue('FECHA', strftime("%d de %B de %Y", strtotime($this->dataSource[0]['fecha']))); // On section/content
        
        $document->setValue('NRO_TRAMITE', $this->dataSource[0]['nro_tramite']); // On section/content
		$document->setValue('IMPORTE', $this->dataSource[0]['importe']); // On section/content
		$document->setValue('CODIGO_MONEDA', $this->dataSource[0]['desc_moneda']); // On section/content
		
		$document->setValue('IMPORTE_LITERAL', $this->dataSource[0]['importe_literal']); // On section/content
		$document->setValue('NUMDOC', $this->dataSource[0]['nro_tramite']); // On section/content
		$document->setValue('NOMBRE_GERENTE', $this->dataSource[0]['gerente_financiero']); // On section/content
		$document->setValue('CARGO_GERENTE', $this->dataSource[0]['cargo_gerente_financiero']); // On section/content
		
		$document->setValue('NRO_DOC', $this->dataSource[0]['num_memo']); // On section/content
		$document->setValue('NUM_CBTE', $this->dataSource[0]['nro_cbte']); // On section/content
		
		
		
		
		$document->saveAs($fileName);
		
		
		        
    }
    
        
}
?>