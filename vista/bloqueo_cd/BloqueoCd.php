<?php
/**
*@package pXP
*@file gen-BloqueoCd.php
*@author  (admin)
*@date 06-06-2016 16:40:35
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.BloqueoCd=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.BloqueoCd.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_bloqueo_cd'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'desc_funcionario',
				fieldLabel: 'Funcionario',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:40
			},
				type:'TextField',
				filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:40
			},
				type:'TextField',
				filters:{pfiltro:'blocd.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'desc_tipo_cuenta_doc',
				fieldLabel: 'Tipo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:40
			},
				type:'TextField',
				filters:{pfiltro:'tcd.descripcion',type:'string'},
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
				filters:{pfiltro:'blocd.estado_reg',type:'string'},
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
				filters:{pfiltro:'blocd.fecha_reg',type:'date'},
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
				filters:{pfiltro:'blocd.usuario_ai',type:'string'},
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
				filters:{pfiltro:'blocd.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'blocd.fecha_mod',type:'date'},
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
	title:'Bloqueos',
	ActSave:'../../sis_cuenta_documentada/control/BloqueoCd/insertarBloqueoCd',
	ActDel:'../../sis_cuenta_documentada/control/BloqueoCd/eliminarBloqueoCd',
	ActList:'../../sis_cuenta_documentada/control/BloqueoCd/listarBloqueoCd',
	id_store:'id_bloqueo_cd',
	fields: [
		{name:'id_bloqueo_cd', type: 'numeric'},
		{name:'id_tipo_cuenta_doc', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_funcionario','desc_tipo_cuenta_doc'
		
	],
	sortInfo:{
		field: 'id_bloqueo_cd',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	bnew: false,
	bedit: false
})
</script>
		
		