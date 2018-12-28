<?php
/**
*@package pXP
*@file gen-ControlDui.php
*@author  (jjimenez)
*@date 13-09-2018 15:32:16
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ControlDui=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons = [this.cmbGestion,this.cmbFiltro];	
    	//llama al constructor de la clase padre
		Phx.vista.ControlDui.superclass.constructor.call(this,config);
		this.init();
		


        this.addButton('btnPagoComision', {
            text: 'Migrar',
            iconCls: 'x-btn-text bengine',
            disabled: false,
            handler: function () {
                this.actualizarPagoComision()
            },	
            tooltip: '<b>Migrar nro comprobante pago comision</b>'
        });
        this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Doc. Dui',
                grupo:[0,1,2,3],
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.loadCheckDocumentosWf,
                tooltip: '<b>Documentos del trámite de Dui</b><br/>Permite ver los documentos asociados al NRO de trámite.'
            }
        );
        this.addButton('btnChequeoDocumentosAgencia',
            {
                text: 'Doc. Agencia',
                grupo:[0,1,2,3],
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.loadCheckDocumentosAgencia,
                tooltip: '<b>Documentos del trámite de comisión agencia</b><br/>Permite ver los documentos asociados al NRO de trámite.'
            }
        );
        this.addButton('btnReporte',
            {
                text: 'Excel',
                grupo:[0,1,2,3],
                iconCls: ' x-btn-text bexcel',
                disabled: false,
                handler: this.loadExcel,
                tooltip: '<b>Excel</b><br/>Exporta la grilla en formato Excel, en tres pestañas'
            }
        );
        //this.getBoton('btnDocCmpVnt').enable();
            
		this.load({params:{start:0, limit:this.tam_pag}})
		this.cmbGestion.on('select', this.capturaFiltros, this);
		this.cmbFiltro.on('select', this.capturacmbFiltro, this);
	},
	loadExcel:function() {
		Phx.CP.loadWindows('../../../sis_cuenta_documentada/reportes/RDui.php',
			'Formulario',
			{
				modal:true,
				width:500,
				height:500
			}, 
			{
				//data:rec.data, 
				//id_depto_lb:this.store.baseParams.desc_auxiliar
			}, 
			this.idContenedor,'RDui'/*,
			{
				config:[{
					event:'beforesave',
					delegate: this.addLibroMayor,
				}],
				scope:this
			}*/
		)
	},
    loadCheckDocumentosAgencia:function() {
            var rec=this.sm.getSelected();
            
            //this.Cmp.nombre_curso.setValue('');
            var aux=rec.data.id_proceso_wf;
            rec.data.id_proceso_wf=rec.data.id_proceso_wf_comision;
            //alert(rec.data.id_proceso_wf_comision);
            
            rec.data.nombreVista = this.nombreVista;
            console.log('rec.data',rec.data);
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        )
        rec.data.id_proceso_wf=aux;
    },
    loadCheckDocumentosWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            //alert(rec.data.id_proceso_wf);
            console.log('rec.data',rec.data);
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        )
    },
    capturaFiltros: function (combo, record, index) {
        this.store.baseParams = {id_gestion: this.cmbGestion.getValue()};
        this.store.reload();
    },
    capturacmbFiltro: function (combo, record, index) {
    	if(this.cmbGestion.getValue()){
	    	//alert(this.cmbFiltro.getValue());
	    	//alert(this.cmbGestion.getValue());
	        this.store.baseParams = {filtro: this.cmbFiltro.getValue(), id_gestion : this.cmbGestion.getValue()};
	        this.store.reload();
    	}
    	else{
    		Ext.MessageBox.alert('ERROR!!!', 'Seleccione una gestión');
    	}

    },
    actualizarPagoComision: function () {
        //this.Cmp.id_proceso_wf.setValue(68410);
    	if(this.cmbGestion.getValue()){
	    	var me = this;
		            Phx.CP.loadingShow();
	                Ext.Ajax.request({
	                    url: '../../sis_cuenta_documentada/control/ControlDui/actualizarComprobantePagoComision',
	                    params: {
	                        'id_gestion': this.cmbGestion.getValue()
	                    },
	                    success: me.successPagoComision,
	                    failure: me.conexionFailureComision,
	                    timeout: me.timeout,
	                    scope: me
	                });
	               
    	}
    	else{
    		Ext.MessageBox.alert('ERROR!!!', 'Seleccione una gestión');
    	}

        /*
        if (this.cmbGestion.getValue()) {
        	if(this.cmbPeriodo.getValue()||valorAprobado==0){
            	Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_cuenta_documentada/control/ControlDui/actualizarComprobantePagoComision',
                    params: {
                        'id_gestion': this.cmbGestion.getValue()
                    },
                    success: me.successSaveAprobar,
                    failure: me.conexionFailureAprobar,
                    timeout: me.timeout,
                    scope: me
                });
        	}
        	else{
        		Ext.MessageBox.alert('ERROR!!!', 'Seleccione un periodo para la evaluación');
        	}

        }
        else {
            Ext.MessageBox.alert('ERROR!!!', 'Seleccione primero una gestion.');
        }*/
    },
    successPagoComision: function () {
        Phx.CP.loadingHide();
        this.reload();
        Ext.MessageBox.alert('EXITO!!!', 'Se realizo con exito la operación.');
    },  
    conexionFailureComision: function () {
        Phx.CP.loadingHide(); 		
        alert('Errror comuniquese con el administrador')
    },  
    cmbGestion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: true,            
        emptyText: 'Gestion...',            
        store: new Ext.data.JsonStore(
        {
            url: '../../sis_parametros/control/Gestion/listarGestion',
            id: 'id_gestion',
            root: 'datos',
            sortInfo: {
                field: 'gestion',
                direction: 'DESC'
            },
            
            totalProperty: 'total',
            fields: ['id_gestion', 'gestion'],
            remoteSort: true,
            baseParams: {par_filtro: 'gestion'}
        }),
        valueField: 'id_gestion',            
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode: 'remote',
        pageSize: 50,
        queryDelay: 500,
        listWidth: '280',
        width: 80
    }),
    cmbFiltro: new Ext.form.ComboBox({
       name:'cmbFiltro',
        fieldLabel:'Filtro',
        allowBlank: true,
        emptyText:'Filtro...',
        store: new Ext.data.ArrayStore({
            fields: ['variable', 'valor'],
            data :  [    
                         ['todos', 'Todos'],
                         ['tram_comi_agencia', 'Pendientes de comision agencias'],
                         ['comp_pago_comision', 'Pendientes de comprobantes pago comisión']
                    ]
        }),
        valueField: 'variable',
        displayField: 'valor',
        mode: 'local',
        forceSelection:true,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        queryDelay: 1000,
        width: 250,
        minChars: 2 ,
        enableMultiSelect: true
    }),
    onButtonEdit: function () {

       Phx.vista.ControlDui.superclass.onButtonEdit.call(this);
       this.Cmp.id_gestion.setValue(this.cmbGestion.getValue());
                   
    },
    onButtonNew: function () {
       //Phx.vista.ControlDui.superclass.onButtonEdit.call(this);
       if(this.cmbGestion.getValue()){
	        this.window.buttons[0].show();
	        this.form.getForm().reset();
	        this.loadValoresIniciales();
	        this.window.show();
	        this.Cmp.id_gestion.setValue(this.cmbGestion.getValue());
       }
       else{
       	   Ext.MessageBox.alert('ERROR!!!', 'Seleccione una gestión');
       }
     
    },
    
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_control_dui'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_wf'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_wf_comision'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_documento_wf'
			},
			type:'Field',
			form:true 
		},
		
		/*{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_agencia_despachante'
			},
			type:'Field',
			form:true 
		},*/
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre_agencia_despachante'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'dui',
				fieldLabel: 'Nro Dui',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'NumberField',
				filters:{pfiltro:'cdui.dui',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true,
				filters: {pfiltro: 'dui', type: 'string'}
		},
		/*{
			config:{
				name: 'agencia_despachante',
				fieldLabel: 'Agencia Despachante',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.agencia_despachante',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'agencia_despachante', type: 'string'}
		},*/
                {
                    config: {
                        name: 'id_agencia_despachante',
                        fieldLabel: 'Agencia despachante',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_cuenta_documentada/control/AgenciaDespachante/listarAgenciaDespachante',
                            id: 'id_agencia_despachante',
                            root: 'datos',
                            sortInfo: {
                                field: 'agedes.nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_agencia_despachante', 'nombre', 'codigo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'agedes.nombre',tipo:'agencia_despachante'}
                        }),
                        valueField: 'id_agencia_despachante',
                        displayField: 'nombre',
                        gdisplayField: 'agencia_despachante',
                        hiddenName: 'id_agencia_despachante',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['agencia_despachante']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'agedes.agencia_despachante', type: 'string'},
                    grid: true,
                    form: true
                },	
	            {
			config:{
				name: 'nro_factura_proveedor',
				fieldLabel: 'No Fact Proveedor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'cdui.nro_factura_proveedor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'nro_factura_proveedor', type: 'string'}
		},
		{
			config:{
				name: 'pedido_sap',
				fieldLabel: 'Pedido SAP',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'cdui.pedido_sap',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true,
				filters: {pfiltro: 'pedido_sap', type: 'string'}
		},
		{
			config:{
				name: 'tramite_pedido_endesis',
				fieldLabel: 'Tram Pedido Endesis',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.tramite_pedido_endesis',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'tramite_pedido_endesis', type: 'string'}
		},
		{
			config:{
				name: 'tramite_anticipo_dui',
				fieldLabel: 'Tramite Dui',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'cdui.tramite_anticipo_dui',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true,
				filters: {pfiltro: 'tramite_anticipo_dui', type: 'string'}
		},
		{
			config:{
				name: 'nro_comprobante_pago_dui',
				fieldLabel: 'No Comp Pago Dui',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.nro_comprobante_pago_dui',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'nro_comprobante_pago_dui', type: 'string'}
		},
		{
			config:{
				name: 'nro_comprobante_diario_dui',
				fieldLabel: 'Nro Comp Diario Dui',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.nro_comprobante_diario_dui',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'nro_comprobante_diario_dui', type: 'string'}
		},
		{
			config:{
				name: 'monto_dui',
				fieldLabel: 'Monto DUI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'TextField',
				filters:{pfiltro:'cdui.monto_dui',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true,
				filters: {pfiltro: 'monto_dui', type: 'string'}
		},
		{
			config:{
				name: 'tramite_comision_agencia',
				fieldLabel: 'Tram Comision Agencia',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.tramite_comision_agencia',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true,
				filters: {pfiltro: 'tramite_comision_agencia', type: 'string'}
		},
		{
			config:{
				name: 'nro_comprobante_diario_comision',
				fieldLabel: 'No Comp Diario Comision',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.nro_comprobante_diario_comision',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'nro_comprobante_diario_comision', type: 'string'}
		},
		{
			config:{
				name: 'nro_comprobante_pago_comision',
				fieldLabel: 'No Comp pago comision',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.nro_comprobante_pago_comision',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				egrid:true,
				bottom_filter: true,
				filters: {pfiltro: 'nro_comprobante_pago_comision', type: 'string'}
		},
		{
			config:{
				name: 'monto_comision',
				fieldLabel: 'Monto comision/Alm/Otr', //#2 endetr Juan 28/12/2018 cambio de nombre 
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:3276800
			},
				type:'TextField',
				filters:{pfiltro:'cdui.monto_comision',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true,
				filters: {pfiltro: 'monto_comision', type: 'string'}
		},
		{
			config:{
				name: 'archivo_dui',
				fieldLabel: 'Archivo de Diario Dui',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.archivo_dui',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true
		},
		{
			config:{
				name: 'archivo_comision',
				fieldLabel: 'Archivo de Diario comision',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.archivo_comision',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'cdui.observaciones',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter: true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cdui.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'cdui.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cdui.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cdui.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Control de Duis',
	ActSave:'../../sis_cuenta_documentada/control/ControlDui/insertarControlDui',
	ActDel:'../../sis_cuenta_documentada/control/ControlDui/eliminarControlDui',
	ActList:'../../sis_cuenta_documentada/control/ControlDui/listarControlDui',
	id_store:'id_control_dui',
	fields: [
		{name:'id_control_dui', type: 'numeric'},
		{name:'tramite_anticipo_dui', type: 'string'},
		{name:'dui', type: 'numeric'},
		{name:'archivo_comision', type: 'string'},
		{name:'nro_comprobante_diario_dui', type: 'string'},
		{name:'archivo_dui', type: 'string'},
		{name:'nro_comprobante_diario_comision', type: 'string'},
		{name:'nro_comprobante_pago_dui', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'monto_comision', type: 'numeric'},
		{name:'tramite_pedido_endesis', type: 'string'},
		{name:'monto_dui', type: 'string'},
		{name:'nro_factura_proveedor', type: 'string'},
		{name:'tramite_comision_agencia', type: 'string'},
		{name:'pedido_sap', type: 'string'},
		{name:'agencia_despachante', type: 'string'},
		{name:'nro_comprobante_pago_comision', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_agencia_despachante', type: 'numeric'},
		{name:'observaciones', type: 'string'},
		
		{name:'id_gestion', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_documento_wf', type: 'numeric'},
		{name:'id_proceso_wf_comision', type: 'numeric'},
		
	],
	sortInfo:{
		field: 'id_control_dui',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		