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
Phx.vista.CdDeposito = {    
	require:'../../../sis_tesoreria/vista/deposito/Deposito.php',
	requireclase:'Phx.vista.Deposito',
	title:'Depositos',
	nombreVista: 'CdDeposito',
	
	tablaOrigen: 'cd.tcuenta_doc',
	idOrigen: 'id_cuenta_doc',
	idOrigenValor : '',
	bnew: true,
	ActSave: '../../sis_cuenta_documentada/control/RendicionDet/insertarCdDeposito',
	ActDel: '../../sis_cuenta_documentada/control/RendicionDet/eliminarCdDeposito',
	ActList: '../../sis_tesoreria/control/ProcesoCaja/listarCajaDeposito',
	
	constructor: function(config) {
	   	Phx.vista.CdDeposito.superclass.constructor.call(this,config);
	  	this.init();
	    this.grid.getBottomToolbar().disable();
		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
		if(dataPadre){
			 this.onEnablePanel(this, dataPadre);
		}
		else{
			 this.bloquearMenus();
		}
        //Seteo del baseparams de la cuenta bancaria
        Ext.apply(this.Cmp.id_cuenta_bancaria.store.baseParams,{fondo_devolucion_retencion: 'si'});
   },
   
   onReloadPage:function(m){
		this.maestro=m;
		var me = this;
		this.maestro = m;
		this.idOrigenValor = me.maestro[me.idOrigen];
		this.store.baseParams={tabla : me.tablaOrigen,columna_pk: me.idOrigen,columna_pk_valor : me.maestro[me.idOrigen]};
		this.load({params : {start : 0,limit : me.tam_pag}});

		//Setea el baseparams de la cuenta bancaria en función de la moneda de la cuenta documentada
		Ext.apply(this.Cmp.id_cuenta_bancaria.store.baseParams,{id_moneda: this.maestro.id_moneda});
		this.Cmp.id_cuenta_bancaria.setValue('');
		this.Cmp.id_cuenta_bancaria.modificado = true;
	},
   
    liberaMenu:function(){
        var tb = Phx.vista.CdDeposito.superclass.liberaMenu.call(this);
        if(this.maestro.estado == 'vbrendicion'){
			this.getBoton('corregir_importe_contable').enable();
		}else{
			this.getBoton('corregir_importe_contable').disable();
		}
		/*
		if(Phx.CP.getPagina(this.idContenedorPadre).nombreVista == 'CuentaDocRen'){
        	if( this.maestro.estado == 'borrador'){     	            		
				this.getBoton('new').enable();  
			} 
			else{                              
				this.getBoton('new').disable();   
			} 
        	
        }
        else{
        	if( this.maestro.estado == 'vbrendicion'){     	            		
				this.getBoton('new').enable();  
			} 
			else{                              
				this.getBoton('new').disable();   
			} 
        }
        */
        return tb
    },
    
    preparaMenu : function(n) {
			var data = this.getSelectedData();
			var tb = this.tbar;
			Phx.vista.CdDeposito.superclass.preparaMenu.call(this, n);	    	 
			return tb
    	
    }
    
};
</script>