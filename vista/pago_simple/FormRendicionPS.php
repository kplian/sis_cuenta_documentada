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
#13 		17/04/2020		manuel guerra			agrega los campos(nota_debito_agencia,nro_tramite) segun el doc seleccionado
#14 		29/04/2020		manuel guerra	    	ocultar campos si cbte validado, agregar filtro de busqueda en nrotramite
#15			19/05/2020		manuel guerra           filtro segun fecha para nro_tramite
#16			30/05/2020		manuel guerra           filtrado por gestion para el nro_tramite refactorizacion
#ETR-673	28/08/2020 		manuel guerra			agegar el calendario en fecha
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
				fieldLabel: 'Tramite-VI',				

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
					fields: ['nro_tramite','gestion'],
					remoteSort: true,
					baseParams:{par_filtro:'cd.nro_tramite'}
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
			filters:{pfiltro:'cd.nro_tramite',type:'string'},
			id_grupo: 1,
			bottom_filter: true,
			form: true
		},    
    ],
	onNew: function(){    	
		Phx.vista.FormRendicionPS.superclass.onNew.call(this);			
		//#13 
		//#ETR-673
		this.Cmp.fecha.setReadOnly(false);
		this.ocultarComponente(this.Cmp.dia);
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
		//#122	
		this.Cmp.fecha.on('select', function(combo, record, index){
			this.Cmp.nro_tramite.enable();
			this.Cmp.nro_tramite.reset();
			var anio= this.Cmp.fecha.getValue();
			anio = anio.getFullYear();	
			this.Cmp.nro_tramite.store.baseParams = Ext.apply(
				this.Cmp.nro_tramite.store.baseParams, {
					gestion: anio
				});
			this.Cmp.nro_tramite.modificado = true;
		},this);
		
		/*this.Cmp.fecha.on('change',function( cmp, newValue, oldValue){
			var anio= this.Cmp.fecha.getValue();
			this.Cmp.nro_tramite.enable();
			this.Cmp.nro_tramite.reset();			
			this.Cmp.nro_tramite.store.baseParams = {gestion:anio.getFullYear()};
            this.Cmp.nro_tramite.modificado = true;
		}, this);				*/	
    	this.Cmp.sw_pgs.setValue('reg');  		
	},
	
	onEdit: function(){    	
		Phx.vista.FormRendicionPS.superclass.onEdit.call(this);
		//#ETR-673
		this.Cmp.fecha.setReadOnly(false);
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
		//#14
		this.cmpnota_debito_agencia = this.getComponente('nota_debito_agencia');
		this.cmpnro_tramite = this.getComponente('nro_tramite');		
		if(this.data.datosOriginales.data.id_int_comprobante){
			this.cmpnota_debito_agencia.disable();
			this.cmpnro_tramite.disable();
		} 
		//#15
		this.Cmp.fecha.on('change',function( cmp, newValue, oldValue){				
			var anio= this.Cmp.fecha.getValue();						
			this.Cmp.nro_tramite.store.baseParams = {gestion:anio.getFullYear()};
            this.Cmp.nro_tramite.modificado = true;
		}, this);
	},		
};
</script>
