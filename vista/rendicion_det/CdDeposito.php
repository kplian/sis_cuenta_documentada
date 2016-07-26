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
        
   },
   
   onReloadPage:function(m){
		this.maestro=m;
		var me = this;
		this.maestro = m;
		this.idOrigenValor = me.maestro[me.idOrigen];
		this.store.baseParams={tabla : me.tablaOrigen,columna_pk: me.idOrigen,columna_pk_valor : me.maestro[me.idOrigen]};
		this.load({params : {start : 0,limit : me.tam_pag}});
		
		
	
	},
   
    liberaMenu:function(){
        var tb = Phx.vista.CdDeposito.superclass.liberaMenu.call(this);
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
        
        return tb
    },
    
    preparaMenu : function(n) {
			var data = this.getSelectedData();
			var tb = this.tbar;
			Phx.vista.CdDeposito.superclass.preparaMenu.call(this, n);
	    	if(Phx.CP.getPagina(this.idContenedorPadre).nombreVista == 'CuentaDocRen'){	
		        if( this.maestro.estado == 'borrador'){     	            		
					this.getBoton('del').enable();  
				} 
				else{                              
					this.getBoton('del').disable();   
				} 
		    }
		    else{
		    	if( this.maestro.estado == 'vbrendicion'){     	            		
					this.getBoton('del').enable();  
				} 
				else{                              
					this.getBoton('del').disable();   
				}
		    }  
			return tb
    	
    }
    
};
</script>