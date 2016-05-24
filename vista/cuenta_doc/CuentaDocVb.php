<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
	requireclase:'Phx.vista.CuentaDoc',
	title:'Cuenta Documentada',
	nombreVista: 'CuentaDocVb',
	
	constructor: function(config) {
	   
	    //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }];
	   
	   Phx.vista.CuentaDocVb.superclass.constructor.call(this,config);
       this.init();
       
		this.store.baseParams = { tipo_interfaz: this.nombreVista };
		
		if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
		//primera carga
		this.store.baseParams.pes_estado = 'borrador';
    	this.load({params:{start:0, limit:this.tam_pag}});
		
		this.finCons = true;
   },
   
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.CuentaDoc.superclass.preparaMenu.call(this,n);  
      if(this.historico == 'no'){
          
         if(data.estado == 'anulado' || data.estado == 'finalizado' || data.estado == 'pendiente'|| data.estado == 'contabilizado'|| data.estado == 'rendido'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
         }
            
         if(data.estado != 'borrador' && data.estado !='anulado' && data.estado !='finalizado'&& data.estado !='pendiente' && data.estado !='contabilizado'&&data.estado != 'rendido'){
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
         }
         
         this.getBoton('btnChequeoDocumentosWf').enable();
         this.getBoton('diagrama_gantt').enable();
         this.getBoton('btnObs').enable();
         
            
      }     
      else{
          this.desBotoneshistorico();
      }   
      return tb 
   },
    
   tabsouth:[
	     {
	          url:'../../../sis_cuenta_documentada/vista/rendicion_det/RendicionDetTes.php',
	          title:'Facturas', 
	          height:'50%',
	          cls: 'RendicionDetTes'
         },
         {
			  url: '../../../sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php',
			  title: 'Depositos',
			  height: '50%',
			  cls: 'CdDeposito'
		 }
	   ] 
    
    
   
    
};
</script>
