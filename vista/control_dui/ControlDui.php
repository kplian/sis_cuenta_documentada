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
    	//llama al constructor de la clase padre
		Phx.vista.ControlDui.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
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
				fieldLabel: 'Monto comision',
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
				fieldLabel: 'Archivo Dui',
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
				fieldLabel: 'Archivo Comision',
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
		
		