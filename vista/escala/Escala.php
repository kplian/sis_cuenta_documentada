<?php
/**
*@package pXP
*@file gen-Escala.php
*@author  (admin)
*@date 04-09-2017 16:10:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Escala=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config;
    	//llama al constructor de la clase padre
		Phx.vista.Escala.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_escala'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'tipo',
				fieldLabel: 'Tipo',
				anchor: '95%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'tipo',
				hiddenName: 'tipo',
				gwidth: 95,
				baseParams:{
						cod_subsistema:'CD',
						catalogo_tipo:'tescala__tipo'
				},
				valueField: 'codigo'
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'evia.tipo',type:'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'evia.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'desde',
				fieldLabel: 'Vigente Desde',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'evia.desde',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'hasta',
				fieldLabel: 'Vigente Hasta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'evia.hasta',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '100%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextArea',
				filters:{pfiltro:'evia.observaciones',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config: {
				name: 'estado_reg',
				fieldLabel: 'Estado',
				anchor: '95%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'estado_reg',
				hiddenName: 'estado_reg',
				gwidth: 55,
				baseParams:{
					cod_subsistema:'PARAM',
					catalogo_tipo:'tgral__estado'
				},
				valueField: 'codigo'
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'evia.estado_reg',type:'string'},
			grid: true,
			form: true
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
				filters:{pfiltro:'evia.usuario_ai',type:'string'},
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
				filters:{pfiltro:'evia.fecha_reg',type:'date'},
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
				filters:{pfiltro:'evia.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'evia.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Escalas',
	ActSave:'../../sis_cuenta_documentada/control/Escala/insertarEscala',
	ActDel:'../../sis_cuenta_documentada/control/Escala/eliminarEscala',
	ActList:'../../sis_cuenta_documentada/control/Escala/listarEscala',
	id_store:'id_escala',
	fields: [
		{name:'id_escala', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'desde', type: 'date',dateFormat:'Y-m-d'},
		{name:'observaciones', type: 'string'},
		{name:'hasta', type: 'date',dateFormat:'Y-m-d'},
		{name:'codigo', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo: {
		field: 'id_escala',
		direction: 'ASC'
	},
	bdel: true,
	bsave: true,
	tabsouth: [{
		url: '../../../sis_cuenta_documentada/vista/escala_regla/EscalaRegla.php',
		title: 'Reglas',
		height: '60%',
		cls: 'EscalaRegla'
	}, {
		url: '../../../sis_cuenta_documentada/vista/tipo_categoria/TipoCategoriaViatico.php',
		title: 'Categorías',
		height: '60%',
		cls: 'TipoCategoriaViatico'
	}, {
		url: '../../../sis_cuenta_documentada/vista/destino/Destino.php',
		title: 'Destinos',
		height: '60%',
		cls: 'Destino'
	}],
	preparaMenu: function(n) {
		var tb = Phx.vista.Escala.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
		//Activa tabs de categorías y destinos solo para Viáticos
		this.TabPanelSouth.get(1).disable();
		this.TabPanelSouth.get(2).disable();
		this.TabPanelSouth.setActiveTab(0)
		          
		if(data.tipo == 'viatico'){
			this.TabPanelSouth.get(1).enable();
			this.TabPanelSouth.get(2).enable();
		}
		return tb;
	},
	liberaMenu: function(n){
		var tb = Phx.vista.Escala.superclass.preparaMenu.call(this);
		this.TabPanelSouth.get(1).disable();
		this.TabPanelSouth.get(2).disable();
		return tb;
	}
	
})
</script>
		
		