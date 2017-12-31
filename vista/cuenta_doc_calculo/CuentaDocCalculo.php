<?php
/**
*@package pXP
*@file gen-CuentaDocCalculo.php
*@author  (admin)
*@date 15-09-2017 13:16:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocCalculo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaDocCalculo.superclass.constructor.call(this,config);
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
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc_calculo'
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
			config:{
				name: 'numero',
				fieldLabel: 'Nro.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.numero',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'desc_moneda',
				fieldLabel: 'Moneda',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'TextField',
				filters:{pfiltro:'mon.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'destino',
				fieldLabel: 'Destino',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'cdocca.destino',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'dias_saldo_ant',
				fieldLabel: 'Saldo Ant. Días',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.dias_saldo_ant',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'dias_destino',
				fieldLabel: '#Días Destino',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.dias_destino',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'dias_hotel',
				fieldLabel: '#Días Hotel',
				allowBlank: true,
				anchor: '80%',
				gwidth: 70,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.dias_hotel',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'cobertura_sol',
				fieldLabel: 'Cobertura Sol.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.cobertura_sol',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'cobertura_hotel_sol',
				fieldLabel: 'Cobertura Hotel Sol.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.cobertura_hotel_sol',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'dias_total_viaje',
				fieldLabel: 'Total días viaje',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.dias_total_viaje',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'dias_aplicacion_regla',
				fieldLabel: 'Días p/Aplicación Reglas',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.dias_aplicacion_regla',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'hora_salida',
				fieldLabel: 'Hora salida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:8
			},
				type:'TextField',
				filters:{pfiltro:'cdocca.hora_salida',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'hora_llegada',
				fieldLabel: 'Hora llegada',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:8
			},
				type:'TextField',
				filters:{pfiltro:'cdocca.hora_llegada',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'escala_viatico',
				fieldLabel: 'Escala Viático',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.escala_viatico',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'escala_hotel',
				fieldLabel: 'Escala Hotel',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.escala_hotel',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'regla_cobertura_dias_acum',
				fieldLabel: 'Regla Cobertura Diás Acum.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.regla_cobertura_dias_acum',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'regla_cobertura_hora_salida',
				fieldLabel: 'Regla Cobertura Hora Salida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.regla_cobertura_hora_salida',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'regla_cobertura_hora_llegada',
				fieldLabel: 'Regla Cobertura Hora Llegada',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.regla_cobertura_hora_llegada',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'regla_cobertura_total_dias',
				fieldLabel: 'Regla Cobertura 1  Día',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.regla_cobertura_total_dias',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'cobertura_aplicada',
				fieldLabel: 'Cobertura Aplicada',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.cobertura_aplicada',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'cobertura_aplicada_hotel',
				fieldLabel: 'Cobertura Hotel Aplicada',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'cdocca.cobertura_aplicada_hotel',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'parcial_viatico',
				fieldLabel: 'Parcial Viático',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'parcial_hotel',
				fieldLabel: 'Parcial Hotel',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'total_viatico',
				fieldLabel: 'VIÁTICO CALCULADO',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
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
				filters:{pfiltro:'cdocca.estado_reg',type:'string'},
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
				filters:{pfiltro:'cdocca.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cdocca.usuario_ai',type:'string'},
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
				filters:{pfiltro:'cdocca.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cdocca.fecha_mod',type:'date'},
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
	title:'Cálculo de Viático',
	ActSave:'../../sis_cuenta_documentada/control/CuentaDocCalculo/insertarCuentaDocCalculo',
	ActDel:'../../sis_cuenta_documentada/control/CuentaDocCalculo/eliminarCuentaDocCalculo',
	ActList:'../../sis_cuenta_documentada/control/CuentaDocCalculo/listarCuentaDocCalculo',
	id_store:'id_cuenta_doc_calculo',
	fields: [
		{name:'id_cuenta_doc_calculo', type: 'numeric'},
		{name:'numero', type: 'numeric'},
		{name:'destino', type: 'string'},
		{name:'dias_saldo_ant', type: 'numeric'},
		{name:'dias_destino', type: 'numeric'},
		{name:'cobertura_sol', type: 'numeric'},
		{name:'cobertura_hotel_sol', type: 'numeric'},
		{name:'dias_total_viaje', type: 'numeric'},
		{name:'dias_aplicacion_regla', type: 'numeric'},
		{name:'hora_salida', type: 'string'},
		{name:'hora_llegada', type: 'string'},
		{name:'escala_viatico', type: 'numeric'},
		{name:'escala_hotel', type: 'numeric'},
		{name:'regla_cobertura_dias_acum', type: 'numeric'},
		{name:'regla_cobertura_hora_salida', type: 'numeric'},
		{name:'regla_cobertura_hora_llegada', type: 'numeric'},
		{name:'regla_cobertura_total_dias', type: 'numeric'},
		{name:'cobertura_aplicada', type: 'numeric'},
		{name:'cobertura_aplicada_hotel', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cuenta_doc', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'parcial_viatico', type: 'numeric'},
		{name:'parcial_hotel', type: 'numeric'},
		{name:'total_viatico', type: 'numeric'},
		{name:'dias_hotel', type: 'numeric'},
		{name:'desc_moneda', type: 'string'}
	],
	sortInfo:{
		field: 'numero',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_cuenta_doc;

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

    },
    bnew: false,
    bedit: false,
    bdel: false,
    bsave: false
})
</script>
		
		