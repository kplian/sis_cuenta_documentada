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
    },
    
    preparaMenu:function(n){
		var me = this;
	      var data = this.getSelectedData();
	      var tb =this.tbar;
	      Phx.vista.RendicionDetTes.superclass.preparaMenu.call(this,n);  
	      
	      if(me.maestro.estado == 'vbtesoreria' && me.maestro.sw_solicitud == 'no'){
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
        }
        return tb
   },
   
   
    
};
</script>
