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
           
        var me = this;
		this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
			    
				if (record.data.estado == 'vbrendicion') {
					var  saldo = me.roundTwo(record.data.importe_documentos) + me.roundTwo(record.data.importe_depositos) -  me.roundTwo(record.data.importe_retenciones);
			        saldo = me.roundTwo(saldo);
					return String.format("<b><font color = 'red'>Monto a Rendir: {0}</font></b><br>"+
										 "<b><font color = 'green' >En Documentos:{1}</font></b><br>"+
										 "<b><font color = 'green' >En Depositos:{2}</font></b><br>"+
										 "<b><font color = 'orange' >Retenciones de Ley:{3}</font></b>", saldo, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones );
				} 
				else {
					return String.format('<font>Solicitado: {0}</font>', value);
				}
				
				

		};
	   
	   Phx.vista.CuentaDocVb.superclass.constructor.call(this,config);
       this.init();
       
       this.addButton('onBtnRepSol', {
				grupo : [0,1,2,3],
				text : 'Reporte Sol.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepSol,
				tooltip : '<b>Reporte de solicitud de fondos</b>'
		});
		
		this.addButton('onBtnMemo', {
				grupo : [0,1,2,3],
				text : 'Memo',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onButtonMemoDesignacion,
				tooltip : '<b>Reporte de designación</b>'
		});
		
		
       
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
      this.getBoton('btnChequeoDocumentosWf').enable();
      this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnObs').enable();
      this.getBoton('chkpresupuesto').enable(); 

      if(data.sw_solicitud == 'si'){
        this.getBoton('onBtnRepSol').enable(); 
      }
      else{
      	this.getBoton('onBtnRepSol').disable(); 
      }
      if(this.historico == 'no'){
          
         if(data.estado == 'anulado' || data.estado == 'finalizado' || data.estado == 'pendiente'|| data.estado == 'contabilizado'|| data.estado == 'rendido'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
         }
            
         if(data.estado != 'borrador' && data.estado !='anulado' && data.estado !='finalizado'&& data.estado !='pendiente' && data.estado !='contabilizado'&&data.estado != 'rendido'){
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
         }

        if(data.estado == 'vbrendicion'){
            this.getBoton('ant_estado').disable();
            this.getBoton('sig_estado').disable();
        }
      }     
      else{
          this.desBotoneshistorico();
      }   
      return tb 
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.CuentaDoc.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('onBtnRepSol').disable(); 
        }
        return tb
    },
    
    onButtonMemoDesignacion: function(){
                var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_cuenta_documentada/control/CuentaDoc/reporteMemoDesignacion',
                    params: {'id_proceso_wf':rec.data.id_proceso_wf},
                    success: this.successExport,
                    failure: function() {
                        alert("fail");
                    },
                    timeout: function() {
                        alert("timeout");
                    },
                    scope:this
                });
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
