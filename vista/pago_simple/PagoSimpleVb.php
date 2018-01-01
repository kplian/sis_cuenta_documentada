<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  RCM
*@date 06/01/2018
*@description Archivo con la interfaz de usuario
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PagoSimpleVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_cuenta_documentada/vista/pago_simple/PagoSimple.php',
	requireclase:'Phx.vista.PagoSimple',
	title:'Pagos',
	nombreVista: 'PagoSimpleVb',
	
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
	   
	   Phx.vista.PagoSimpleVb.superclass.constructor.call(this,config);
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
        Phx.vista.PagoSimple.superclass.preparaMenu.call(this,n); 
        this.getBoton('btnChequeoDocumentosWf').enable();
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('btnObs').enable();

        if(this.historico == 'no'){
         
            /*if(data.estado=='borrador'||data.estado=='pendiente'||data.estado=='pendiente_pago'||data.estado=='finalizado'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
            } else if(data.estado=='vbtesoreria'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').enable();
            } */



            this.getBoton('ant_estado').enable();
            this.getBoton('sig_estado').enable();



            //Lógica para habilitar o no los documentos (facturas/recibos)
            this.getBoton('btnAgregarDoc').disable();
            if(data.estado=='borrador'&&data.codigo_tipo_pago_simple!='PAG_DEV'){
                this.getBoton('btnAgregarDoc').enable();
            } else if(data.estado=='rendicion'&&data.codigo_tipo_pago_simple=='PAG_DEV'){
                this.getBoton('btnAgregarDoc').enable();
            }
            
         
        } else{
            this.desBotoneshistorico();
        }   
        return tb;
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.PagoSimple.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
        }
        return tb
    },
    desBotoneshistorico: function(){
        this.getBoton('ant_estado').disable();
        this.getBoton('sig_estado').disable();
   }
        
};
</script>
