<?php
/**
*@package pXP
*@file gen-CuentaDocItinerario.php
*@author  (admin)
*@date 05-09-2017 14:46:06
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocItinerario=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaDocItinerario.superclass.constructor.call(this,config);
		this.init();
		this.grid.getTopToolbar().disable();
        this.grid.getBottomToolbar().disable();

        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        } else {
           this.bloquearMenus();
        }
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc_itinerario'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_destino',
				fieldLabel: 'Destino',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_cuenta_documentada/control/Destino/listarDestino',
					id: 'id_destino',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_destino', 'nombre', 'codigo', 'descripcion'],
					remoteSort: true,
					baseParams: {par_filtro: 'dest.nombre#dest.codigo#dest.descripcion'}
				}),
				valueField: 'id_destino',
				displayField: 'nombre',
				gdisplayField: 'desc_destino',
				hiddenName: 'id_destino',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 300,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_destino']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'dest.nombre',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'cantidad_dias',
				fieldLabel: '# Días',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:4,
				allowDecimals: false
			},
			type:'NumberField',
			filters:{pfiltro:'cdite.cantidad_dias',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_desde',
				fieldLabel: 'Desde',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				disabled: true,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
				hidden: true
			},
			type:'DateField',
			filters:{pfiltro:'cdite.fecha_desde',type:'date'},
			id_grupo:1,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'fecha_hasta',
				fieldLabel: 'Hasta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				disabled: true,
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
				hidden: true
			},
			type:'DateField',
			filters:{pfiltro:'cdite.fecha_hasta',type:'date'},
			id_grupo:1,
			grid:false,
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
				filters:{pfiltro:'cdite.estado_reg',type:'string'},
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
				filters:{pfiltro:'cdite.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cdite.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cdite.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'cdite.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Itinerario',
	ActSave:'../../sis_cuenta_documentada/control/CuentaDocItinerario/insertarCuentaDocItinerario',
	ActDel:'../../sis_cuenta_documentada/control/CuentaDocItinerario/eliminarCuentaDocItinerario',
	ActList:'../../sis_cuenta_documentada/control/CuentaDocItinerario/listarCuentaDocItinerario',
	id_store:'id_cuenta_doc_itinerario',
	fields: [
		{name:'id_cuenta_doc_itinerario', type: 'numeric'},
		{name:'fecha_hasta', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_desde', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_destino', type: 'numeric'},
		{name:'cantidad_dias', type: 'numeric'},
		{name:'id_cuenta_doc', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_destino', type: 'string'}
	],
	sortInfo:{
		field: 'id_cuenta_doc_itinerario',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_cuenta_doc;

        //Filtro para el combo de destino por id_escala
        Ext.apply(this.Cmp.id_destino.store.baseParams, {
        	id_escala: this.maestro.id_escala,
        	tipo_viaje: this.maestro.tipo_viaje
        });
        this.Cmp.id_destino.modificado = true;

        //Filtro para los datos
        this.store.baseParams = {
            id_cuenta_doc: this.maestro.id_cuenta_doc
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

        //Habilitar/deshabilitar botones nuevo, edit, delete para los detalles. Habilita en estado borrador, en otro caso oculta
		this.getBoton('new').show();
		this.getBoton('edit').show();
		this.getBoton('del').show();
		this.getBoton('save').show();
		if(this.maestro.estado!='borrador'){
			this.getBoton('new').hide();
			this.getBoton('edit').hide();
			this.getBoton('del').hide();
			this.getBoton('save').hide();
		}

    }
})
</script>
		
		