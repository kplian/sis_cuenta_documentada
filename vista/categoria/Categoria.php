<?php
/**
*@package pXP
*@file gen-Categoria.php
*@author  (admin)
*@date 05-05-2016 14:07:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Categoria=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Categoria.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_categoria'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_categoria'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				filters:{pfiltro:'cat.codigo',type:'string'},
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
				maxLength:400
			},
				type:'TextField',
				filters:{pfiltro:'cat.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:50,
                 renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:1,
            filters:{ pfiltro:'mon.codigo',type:'string'},
            grid:true,
            form:true
        },
		{
			config:{
				name: 'monto',
				fieldLabel: 'monto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cat.monto', type: 'numeric'},
				id_grupo:1,
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
				filters:{ pfiltro:'cat.estado_reg', type: 'string'},
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
				filters:{pfiltro:'cat.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cat.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cat.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'cat.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
	],
	tam_pag:50,	
	title:'Categoría',
	ActSave:'../../sis_cuenta_documentada/control/Categoria/insertarCategoria',
	ActDel:'../../sis_cuenta_documentada/control/Categoria/eliminarCategoria',
	ActList:'../../sis_cuenta_documentada/control/Categoria/listarCategoria',
	id_store:'id_categoria',
	fields: [
		{name:'id_categoria', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'monto', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_tipo_categoria', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_moneda'
		
	],
	sortInfo:{
		field: 'id_categoria',
		direction: 'ASC'
	},
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_tipo_categoria:this.maestro.id_tipo_categoria};
		this.load({params:{start:0, limit:50}})
		
	},
	
	loadValoresIniciales:function(){
		Phx.vista.Categoria.superclass.loadValoresIniciales.call(this);
		this.Cmp.id_tipo_categoria.setValue(this.maestro.id_tipo_categoria);		
	},
	
	bdel:true,
	bsave:true
	}
)
</script>
		
		