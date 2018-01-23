<?php
/**
*@package pXP
*@file PagoSimpleSol.php
*@author  RCM
*@date 20/01/2018
*@description Archivo con la interfaz de usuario
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PagoSimpleSol = {
	require:'../../../sis_cuenta_documentada/vista/pago_simple/PagoSimple.php',
	requireclase:'Phx.vista.PagoSimple',
	title:'Pagos',
	nombreVista: 'PagoSimpleSol',
	
	constructor: function(config) {
        //Historico
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                    this.getBoton('ant_estado').disable();
                    this.getBoton('sig_estado').disable();
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
	   
        Phx.vista.PagoSimpleSol.superclass.constructor.call(this,config);
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
   
    preparaMenu: function(n) {
        var data = this.getSelectedData();
        var tb = this.tbar;
        Phx.vista.PagoSimple.superclass.preparaMenu.call(this, n);

        this.getBoton('ant_estado').disable();
        this.getBoton('sig_estado').disable();

        //Si está en modo histórico,no habilita ninguno de los botones que generan transacciones
        if(this.historico=='no'){
            if(data.estado == 'borrador') {
                this.getBoton('sig_estado').enable();
            } else if(data.estado == 'finalizado'){
                this.getBoton('sig_estado').disable();
            } else if(data.estado == 'pendiente'||data.estado == 'vbtesoreria'||data.estado == 'pendiente_pago'){
                this.getBoton('sig_estado').disable();
                this.getBoton('ant_estado').disable();
            } else {
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
            }   

            //Lógica para habilitar o no los documentos (facturas/recibos)
            this.getBoton('btnAgregarDoc').disable();
            if(data.estado=='borrador'&&(data.codigo_tipo_pago_simple!='PAG_DEV'&&data.codigo_tipo_pago_simple!='ADU_GEST_ANT')){
                this.getBoton('btnAgregarDoc').enable();
            } else if(data.estado=='rendicion'&&(data.codigo_tipo_pago_simple=='PAG_DEV'||data.codigo_tipo_pago_simple=='ADU_GEST_ANT')){
                this.getBoton('btnAgregarDoc').enable();
            }

            if(data.estado=='borrador'&&data.codigo_tipo_pago_simple=='DVPGPR'){
                this.getBoton('btnAgregarDoc').enable();   
            }
        }

        //Habilita el resto de los botones
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('btnObs').enable();
        this.getBoton('btnChequeoDocumentosWf').enable();

        //Habilita/deshabilita los tabs
        this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(true);
        if(data.codigo_tipo_pago_simple=='ADU_GEST_ANT'||data.codigo_tipo_pago_simple!='PAG_DEV'&&data.codigo_tipo_pago_simple!='ADU_GEST_ANT'||data.codigo_tipo_pago_simple=='DVPGPR'){
            this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(false);
        }

        
        


        //agregado
        this.getBoton('btnDetalleDocumentoPagoSimple').enable();
        
        return tb
    },

        
    liberaMenu: function() {
        var tb = Phx.vista.PagoSimple.superclass.liberaMenu.call(this);
        if (tb) {
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('btnAgregarDoc').disable();
            
            this.getBoton('btnDetalleDocumentoPagoSimple').disable();
              
        }
        return tb
    }
        
};
</script>
