<?php
/**
*@package pXP
*@file gen-CuentaDocConsulta2.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocConsulta2=Ext.extend(Phx.gridInterfaz,{
    title:'Mayor',
	constructor:function(config){		
		var me = this;
		this.maestro=config.maestro;
		 //Agrega combo de moneda
		
		this.Atributos = [
			{
				//configuracion del componente
				config:{
						labelSeparator:'',
						inputType:'hidden',
						name: 'id_cuenta_doc'
				},
				type:'Field',
				form:true 
			},
			{
				config:{
					name: 'desc_funcionario1',
					fieldLabel: 'Funcionario',
					allowBlank: true,
					anchor: '80%',
					gwidth: 200,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'v.desc_funcionario1',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'nro_tramite',
					fieldLabel: 'Nro Trámite',
					allowBlank: true,
					anchor: '80%',
					gwidth: 110,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'v.nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'motivo',
					fieldLabel: 'Motivo',
					allowBlank: true,
					anchor: '80%',
					gwidth: 200,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'v.motivo',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			},
			
			{
				config: {
					name: 'importe_solicitado',
					fieldLabel: 'Solicitado',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'v.importe_solicitado',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			
			{
				config: {
					name: 'importe_documentos',
					fieldLabel: 'Documentos',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'v.importe_documentos',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			
			{
				config: {
					name: 'importe_depositos',
					fieldLabel: 'Depositos',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'v.importe_depositos',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			
			{
				config: {
					name: 'saldo',
					fieldLabel: 'Saldo',
					allowBlank: true,
					width: '100%',
					gwidth: 110,
					galign: 'right ',
					maxLength: 100,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}', Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
					}
				},
				type: 'NumberField',
				filters: {pfiltro: 'v.saldo',type: 'numeric'},
				id_grupo: 1,
				grid: true,
				form: true
			},
			{
				config:{
					name: 'estado',
					fieldLabel: 'Estado',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					maxLength:1000
				},
				type:'TextArea',
				filters:{pfiltro:'v.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
			}
			
		];
			
		
		
    	//llama al constructor de la clase padre
		Phx.vista.CuentaDocConsulta2.superclass.constructor.call(this,config);
		
		this.addButton('btnChequeoDocumentosWf',
	            {
	                text: 'Documentos',
	                grupo:[0,1,2,3],
	                iconCls: 'bchecklist',
	                disabled: true,
	                handler: this.loadCheckDocumentosWf,
	                tooltip: '<b>Documentos del Trámite</b><br/>Permite ver los documentos asociados al NRO de trámite.'
	            }
	     );	
		
		
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();
		this.init();
		
	},
	
	
	tam_pag: 50,	
	
	ActList: '../../sis_cuenta_documentada/control/CuentaDoc/listarCuentaDocConsulta2',
	id_store: 'id_cuenta_doc',
	fields: [
		 'id_cuenta_doc',
		 'fecha','fecha_entrega','desc_funcionario1',
		 'nro_tramite','motivo','nro_cheque','importe_solicitado',
		 'importe_cheque','importe_documentos',
		 'importe_depositos', 'saldo', 'estado',
		 'tipo_reg','id_proceso_wf','id_estado_wf'
		
	],
	
	
    sortInfo:{
		field: 'id_cuenta_doc',
		direction: 'ASC'
	},
	bdel: true,
	bsave: false,
	
	loadValoresIniciales:function(){
		Phx.vista.CuentaDocConsulta2.superclass.loadValoresIniciales.call(this);
		this.getComponente('id_int_comprobante').setValue(this.maestro.id_int_comprobante);		
	},
	onReloadPage:function(param){
		//Se obtiene la gestión en función de la fecha del comprobante para filtrar partidas, cuentas, etc.
		var me = this;
		this.initFiltro(param);
	},
	
	initFiltro: function(param){
		this.store.baseParams=param;
		this.load( { params: { start:0, limit: this.tam_pag } });
	},
	
	preparaMenu : function(n) {
		var rec=this.sm.getSelected();
		if(rec.data.tipo_reg != 'summary'){
			var tb = Phx.vista.CuentaDocConsulta2.superclass.preparaMenu.call(this);
			this.getBoton('btnChequeoDocumentosWf').enable();
			
			return tb;
		}
		else{
			 this.getBoton('btnChequeoDocumentosWf').disable();
			
		 }
			
         return undefined;
	},
	liberaMenu : function() {
			var tb = Phx.vista.CuentaDocConsulta2.superclass.liberaMenu.call(this);
			this.getBoton('btnChequeoDocumentosWf').disable();
			
			
			
	},
	
	
	
	
	 loadCheckDocumentosWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
           );
   },
	
	
	
    bnew : false,
    bedit: false,
    bdel:  false
})
</script>	