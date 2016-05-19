<?php
/**
*@package pXP
*@file gen-TipoCuentaDoc.php
*@author  (admin)
*@date 04-05-2016 20:13:26
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCuentaDoc=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoCuentaDoc.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cuenta_doc'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'tcd.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'tcd.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextArea',
				filters:{pfiltro:'tcd.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		 {
            config: {
                name: 'codigo_plantilla_cbte',
                fieldLabel: 'Plantilla Comprobante',
                allowBlank: true,
                emptyText: 'Plantilla Comprobante..',
                store: new Ext.data.JsonStore({
                    url: '../../sis_contabilidad/control/PlantillaComprobante/listarPlantillaComprobante',
                    id: 'id_plantilla_comprobante',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_plantilla_comprobante','codigo'],
                    remoteSort: true,
                    baseParams: {par_filtro:'codigo'}
                }),
                valueField: 'codigo',
                displayField: 'codigo',
                gdisplayField: 'codigo_plantilla_cbte',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>Código: {codigo}</p></div></tpl>',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                minChars: 2
            },
            type: 'ComboBox',
            filters:{pfiltro:'codigo_plantilla_cbte',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'codigo_wf',
                fieldLabel: 'Tipo Proceso WF',
                allowBlank: true,
                emptyText: 'Elija un proceso WF..',
                store: new Ext.data.JsonStore({
                    url: '../../sis_workflow/control/TipoProceso/listarTipoProceso',
                    id: 'id_tipo_proceso',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_proceso','codigo','nombre','codigo_llave'],
                    remoteSort: true,
                    baseParams: {par_filtro:'tipproc.codigo#tipproc.nombre#tipproc.codigo_llave'}
                }),
                valueField: 'codigo',
                displayField: 'codigo',
                gdisplayField: 'codigo_wf',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 100,
                anchor: '100%',
                gwidth: 120,
                enableMultiSelect:false,
                minChars: 2
            },
            type:'AwesomeCombo',
            filters:{pfiltro:'codigo_wf',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        {
			config:{
				name: 'sw_solicitud',
				fieldLabel: 'Es Solicitud?',
				qtip: 'Marca los tipo que corresponden a solicitud de efectivo',
				allowBlank: false,
				anchor: '40%',
				gwidth: 50,
				maxLength:2,
				emptyText:'si/no...',       			
       			typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    valueField: 'inicio',       		    
       		    store:['si','no']
			},
			type:'ComboBox',
			//filters:{pfiltro:'promac.inicio',type:'string'},
			id_grupo:1,
			filters:{	
	       		         type: 'list',
	       				 pfiltro:'tcd.sw_solicitud',
	       				 options: ['si','no'],	
	       		 	},
			grid:true,
			form:true
		},
        
        
		
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'tcd.estado_reg',type:'string'},
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
				filters:{pfiltro:'tcd.fecha_reg',type:'date'},
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
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tcd.usuario_ai',type:'string'},
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
				filters:{pfiltro:'tcd.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'tcd.fecha_mod',type:'date'},
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
	title:'Tipo Cuenta Documentada',
	ActSave:'../../sis_cuenta_documentada/control/TipoCuentaDoc/insertarTipoCuentaDoc',
	ActDel:'../../sis_cuenta_documentada/control/TipoCuentaDoc/eliminarTipoCuentaDoc',
	ActList:'../../sis_cuenta_documentada/control/TipoCuentaDoc/listarTipoCuentaDoc',
	id_store:'id_tipo_cuenta_doc',
	fields: [
		{name:'id_tipo_cuenta_doc', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'codigo_plantilla_cbte','codigo_wf','sw_solicitud'
		
	],
	sortInfo:{
		field: 'id_tipo_cuenta_doc',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		