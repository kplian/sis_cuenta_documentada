<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*

ISSUE          FECHA:		      AUTOR                 DESCRIPCION
#13 		17/04/2020		manuel guerra	agrega los campos(nota_debito_agencia,nro_tramite) segun el doc seleccionado
#15			19/05/2020		manuel guerra           creacion de reportes en pdf, para pasajes

*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocCompraPS = {
    
	require: '../../../sis_contabilidad/vista/doc_compra_venta/DocCompraVenta.php',
    ActList:'../../sis_contabilidad/control/DocCompraVenta/listarDocCompraVenta',
	requireclase: 'Phx.vista.DocCompraVenta',
	title: 'Libro de Compras',
	nombreVista: 'DocCompraPS',
	tipoDoc: 'compra',
	
	formTitulo: 'Formulario de Documento Compra',
	
	constructor: function(config) {
		

	    Phx.vista.DocCompraPS.superclass.constructor.call(this,config);	
		this.addBotonesPas();
   
		//this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.tipoDoc});
		this.addButton('btnAutorizacion',
			{	
				text:'Rep. Det. Pasajes',
				iconCls: 'blist',
				disabled: false,				
				handler:this.repAutorizacion,
				tooltip: '<b> Detalle de pasajes para firmas de autorización de jefe inmediato</b>'
			}
		);
    },   
    
    loadValoresIniciales: function() {
    	Phx.vista.DocCompraPS.superclass.loadValoresIniciales.call(this);
        //this.Cmp.tipo.setValue(this.tipoDoc);         
	},
	   
    capturaFiltros:function(combo, record, index){
        this.store.baseParams.tipo = this.tipoDoc;
        Phx.vista.DocCompraPS.superclass.capturaFiltros.call(this,combo, record, index);
    },
   
    cmbDepto: new Ext.form.ComboBox({
		name: 'id_depto',
		fieldLabel: 'Depto',
		blankText: 'Depto',
		typeAhead: false,
		forceSelection: true,
		allowBlank: false,
		disableSearchButton: true,
		emptyText: 'Depto Contable',
		store: new Ext.data.JsonStore({
			url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
			id: 'id_depto',
			root: 'datos',
			sortInfo:{
				field: 'deppto.nombre',
				direction: 'ASC'
			},
			totalProperty: 'total',
			fields: ['id_depto','nombre','codigo'],
			// turn on remote sorting
			remoteSort: true,
			baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA'}
		}),
		valueField: 'id_depto',
		displayField: 'nombre',
		hiddenName: 'id_depto',
		enableMultiSelect: true,
		triggerAction: 'all',
		lazyRender: true,
		mode: 'remote',
		pageSize: 20,
		queryDelay: 200,
		anchor: '80%',
		listWidth:'280',
		resizable:true,
		minChars: 2
	}),
    //
    abrirFormulario: function(tipo, record){
   	    var me = this;
   	    me.objSolForm = Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/pago_simple/FormRendicionPS.php',
			me.formTitulo,
			{
				modal:true,
				width:'90%',
				height:(me.regitrarDetalle == 'si')? '100%':'60%',							                                    
			}, { 
				data: 
				{ 
					objPadre: me ,
					tipoDoc: me.tipoDoc,	                                	 
					id_gestion: me.cmbGestion.getValue(),
					id_periodo: me.cmbPeriodo.getValue(),
					id_depto: this.cmbDepto.getValue(),
					tmpPeriodo: me.tmpPeriodo,
					tmpGestion: me.tmpGestion,
					tipo_form : tipo,
					datosOriginales: record
				},
				regitrarDetalle: 'si'
			}, 
			this.idContenedor,
			'FormRendicionPS',
			{
				config:
				[{
					event:'successsave',
					delegate: this.onSaveForm,			                                              
				}],			                                    
				scope:this
			}
		); 	                                                      
  	},
	//#13
	repAutorizacion : function() {		
		var tmpl =this.cmbPeriodo.getValue();		
		var me = this;
		if(tmpl)
		{			
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_contabilidad/control/DocCompraVenta/repAutorizacion',
				params:{
					id_depto_conta : this.cmbDepto.getValue(),
					id_gestion : me.cmbGestion.getValue(),
					id_periodo : me.cmbPeriodo.getValue()		
				},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});	
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un periodo' );
		}
	},
	//#15
	repAutorizacionPDF : function() {		
		var tmpl =this.cmbPeriodo.getValue();		
		var me = this;
		if(tmpl)
		{			
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_cuenta_documentada/control/PagoSimple/repAutorizacionPdf',
				params:{
					id_depto_conta : this.cmbDepto.getValue(),
					id_gestion : me.cmbGestion.getValue(),
					id_periodo : me.cmbPeriodo.getValue()		
				},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});	
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un periodo' );
		}
	},	   
	//
	addBotonesPas: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-repasaj-' + this.idContenedor,
            text:'Rep. Det. Pasajes',
            disabled: false,
            iconCls : 'blist',
            handler:this.repAutorizacionPDF,
            scope: this,
            menu:{
				items: [{
					id:'b-repasajXls-' + this.idContenedor,
					text: 'Excel',
					tooltip: '<b> Detalle de pasajes para firmas de autorización de jefe inmediato</b>',
					handler:this.repAutorizacion,
					scope: this
				}, {
					id:'b-repasajPdf-' + this.idContenedor,
					text: 'Pdf',
					tooltip: '<b> Detalle de pasajes para firmas de autorización de jefe inmediato</b>',
					handler:this.repAutorizacionPDF,
					scope: this
				}]
			}
        });
		this.tbar.add(this.menuAdqGantt);
    },
 
   
   
};
</script>
