<?php
/**
*@package pXP
*@file FormRendicionPS.php
*@author  Rensi Arteaga 
*@date 16-02-2016
*@description Archivo con la interfaz de usuario que permite 
*ingresar el documento a rendir
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FormRendicionPS = {
	require: '../../../sis_contabilidad/vista/doc_compra_venta/FormCompraVenta.php',
	ActSave: '../../sis_cuenta_documentada/control/RendicionDet/insertarPSDocCompleto',
	requireclase: 'Phx.vista.FormCompraVenta',
	mostrarFormaPago : false,
	mostrarFuncionario: true,
	heightHeader: 245,
	autorizacion: 'fondo_avance',
	autorizacion_nulos: 'no',
	tipo_pres_gasto: 'gasto,administrativo',
		
	constructor: function(config) {	
		Phx.vista.FormRendicionPS.superclass.constructor.call(this,config);	   
    },
    
      extraAtributos:[
        {
				//configuracion del componente
				config:{
						labelSeparator:'',
						inputType:'hidden',
						name: 'sw_pgs'
				},
				type:'Field',
				form:true 
		}
     ],
    
    
	onNew: function(){    	
    	Phx.vista.FormRendicionPS.superclass.onNew.call(this);
    	this.Cmp.sw_pgs.setValue('reg');
       
	},
	
	onEdit: function(){    	
    	Phx.vista.FormRendicionPS.superclass.onEdit.call(this);	
    	if(this.Cmp.sw_pgs.getValue()!='proc'){
    		this.Cmp.sw_pgs.setValue('reg');
    	}	
       		
	},
	
	
};
</script>
