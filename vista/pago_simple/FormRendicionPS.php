<?php
/**
*@package pXP
*@file FormRendicionPS.php
*@author  Rensi Arteaga 
*@date 16-02-2016
*@description Archivo con la interfaz de usuario que permite 
*ingresar el documento a rendir
*

ISSUE          FECHA:		      AUTOR                 DESCRIPCION
#13 		17/04/2020		manuel guerra	agrega los campos(nota_debito_agencia,nro_tramite) segun el doc seleccionado

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
		},//#13 
		{
			config:{
				name: 'nota_debito_agencia',
				fieldLabel: 'Nota de Debito Agencia',				
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextField',
			filters:{pfiltro:'dcv.nota_debito_agencia',type:'string'},
			id_grupo:1,			
			bottom_filter: true,
			form:true
		},//#13 
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Tramite FA/VI',				
				emptyText:'Elija una tramite...',
				store:new Ext.data.JsonStore(
				{
					url: '../../sis_contabilidad/control/DocCompraVenta/listarNroTramite',
					id: 'nro_tramite',
					root:'datos',
					sortInfo:{
						field:'nro_tramite',
						direction:'ASC'
					},
					totalProperty:'total',
					fields: ['nro_tramite'],
					remoteSort: true,
					//baseParams:{par_filtro:'plt.nro_tramite',sw_compro:'si',sw_tesoro:'si'}
				}),
				tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nro_tramite}</p></div></tpl>',
				valueField: 'nro_tramite',
				hiddenValue: 'nro_tramite',
				displayField: 'nro_tramite',
				gdisplayField:'nro_tramite',
				listWidth:'280',				
				typeAhead: false,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:20,
				queryDelay:500,				
				gwidth: 250,
				minChars:2,				
			},
			type:'ComboBox',
			//filters:{pfiltro:'pla.desc_plantilla',type:'string'},
			id_grupo: 2,
			bottom_filter: true,
			form: true
		},    
    ],
		
	onNew: function(){    	
		Phx.vista.FormRendicionPS.superclass.onNew.call(this);			
		//#13 
		this.Cmp.id_plantilla.on('select',function(cmb,rec,i){			
			if(rec.data.sw_nota_debito_agencia == 'si'){
				this.mostrarComponente(this.Cmp.nota_debito_agencia);	
			}
			else{
				this.ocultarComponente(this.Cmp.nota_debito_agencia);				
			}
			//
			if(rec.data.sw_cuenta_doc == 'si'){
				this.mostrarComponente(this.Cmp.nro_tramite);	
			}
			else{
				this.ocultarComponente(this.Cmp.nro_tramite);				
			}
		} ,this);					
    	this.Cmp.sw_pgs.setValue('reg');       
	},
	
	onEdit: function(){    	
		Phx.vista.FormRendicionPS.superclass.onEdit.call(this);
		//#13 
		this.Cmp.id_plantilla.on('select',function(cmb,rec,i){			
			if(rec.data.sw_nota_debito_agencia == 'si'){
				this.mostrarComponente(this.Cmp.nota_debito_agencia);	
			}
			else{
				this.ocultarComponente(this.Cmp.nota_debito_agencia);				
			}
		} ,this);		
    	if(this.Cmp.sw_pgs.getValue()!='proc'){
    		this.Cmp.sw_pgs.setValue('reg');
    	}	       		
	},	
	
};
</script>
