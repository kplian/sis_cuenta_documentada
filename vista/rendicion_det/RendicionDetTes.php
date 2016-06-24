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
Phx.vista.RendicionDetTes = {
   
	require:'../../../sis_cuenta_documentada/vista/rendicion_det/RendicionDet.php',
	requireclase:'Phx.vista.RendicionDet',
	title:'Cuenta Documentada',
	nombreVista: 'RendicionDetTes',
	
	constructor: function(config) {
	   Phx.vista.RendicionDetTes.superclass.constructor.call(this,config);
	   this.obtenerVariableGlobal();
    },
    
    onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_cuenta_doc_rendicion: this.maestro.id_cuenta_doc};
		this.load({params:{start:0, limit:50}});
		
		 if(this.maestro.estado == 'vbrendicion' && this.maestro.sw_solicitud == 'no' && this.bloquearDocumento == 'no'){
	          this.getBoton('new').enable();
	     }
	     else{
	        this.getBoton('new').disable();
	     }   
	      
	
	},
		
    
    preparaMenu:function(n){
    	
    	
		var me = this;
	      var data = this.getSelectedData();
	      var tb =this.tbar;
	      Phx.vista.RendicionDetTes.superclass.preparaMenu.call(this,n);  
	      if(me.maestro.estado == 'vbrendicion' && me.maestro.sw_solicitud == 'no' && this.bloquearDocumento == 'no'){
	          this.getBoton('new').enable();
	          this.getBoton('edit').enable();
	          this.getBoton('del').enable();
	      }
	      else{
	         
	         this.getBoton('new').disable();
	         this.getBoton('edit').disable();
	         this.getBoton('del').disable();
	      }
	      
	      this.getBoton('btnShowDoc').enable();
	            
	      return tb;
 },
 
   liberaMenu:function(){
        var tb = Phx.vista.RendicionDetTes.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('btnShowDoc').disable();
            
            if(this.maestro.estado == 'vbrendicion' && this.maestro.sw_solicitud == 'no' && this.bloquearDocumento == 'no'){
	             this.getBoton('new').enable();
		    }
		    else{
		         this.getBoton('new').disable();
		   }
        }
        return tb
   },
   
   obtenerVariableGlobal: function(config){
     	var me = this;
		//Verifica que la fecha y la moneda hayan sido elegidos
		Phx.CP.loadingShow();
		Ext.Ajax.request({
				url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
				params:{
					codigo: 'cd_comprometer_presupuesto'  
				},
				success: function(resp){
					Phx.CP.loadingHide();
					var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					
					if (reg.ROOT.error) {
						Ext.Msg.alert('Error','Error a recuperar la variable global')
					} else {
						if(reg.ROOT.datos.valor == 'si'){
						    //bloquear edicion de facturas, edicion y eliminacion
						    this.bloquearDocumento = 'si';
					    }
					    else{
					    	this.bloquearDocumento = 'no';
					    }
					   
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope:this
			});
	}
};
</script>