<?php
/**
*@package pXP
*@file gen-PagoSimplePro.php
*@author  (admin)
*@date 14-01-2018 21:26:07
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PagoSimplePro=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PagoSimplePro.superclass.constructor.call(this,config);
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
					name: 'id_pago_simple_pro'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_pago_simple'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_partida'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'factor',
				fieldLabel: 'Factor',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxValue: 1,
				minValue: 0
			},
				type:'NumberField',
				filters:{pfiltro:'pasipr.factor',type:'numeric'},
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
				filters:{pfiltro:'pasipr.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
            config:{
                name: 'id_concepto_ingas',
                fieldLabel: 'Concepto de Gasto',
                allowBlank: false,
                emptyText: 'Concepto...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                    id : 'id_concepto_ingas',
                    root: 'datos',
                    sortInfo:{
                        field: 'desc_ingas',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot','desc_gestion'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'desc_ingas#par.codigo',movimiento:'gasto'}//, autorizacion: 'viatico'}
                }),
               	valueField: 'id_concepto_ingas',
				displayField: 'desc_ingas',
				gdisplayField: 'desc_ingas',
				hiddenName: 'id_concepto_ingas',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				listWidth:500,
				resizable:true,
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 250,
				gwidth:350,
				minChars:2,
				anchor:'100%',
				qtip:'Si el concepto de gasto que necesita no existe por favor  comuniquese con el área de presupuestos para solicitar la creación.',
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>PARTIDA: {desc_partida} - ({desc_gestion})</p></div></tpl>',
				renderer:function(value, p, record){
					return String.format('{0} <br/><b>{1} - ({2}) </b>', record.data['desc_ingas'],  record.data['desc_partida'], record.data['gestion']);
				}
            },
            type:'ComboBox',
			bottom_filter: true,
            filters:{pfiltro:'cig.desc_ingas#par.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_centro_costo',
                origen: 'CENTROCOSTO',
                allowBlank: true,
                fieldLabel: 'Centro de Costo',
                gdisplayField: 'desc_cc',//mapea al store del grid
                gwidth: 150,
                url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXUsuaio',
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_cc']);},
                baseParams:{filtrar:'grupo_ep'}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'cc.descripcion_tcc',type:'string'},
            grid: true,
            form: true
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'pasipr.fecha_reg',type:'date'},
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
				filters:{pfiltro:'pasipr.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'pasipr.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'pasipr.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Prorrateo',
	ActSave:'../../sis_cuenta_documentada/control/PagoSimplePro/insertarPagoSimplePro',
	ActDel:'../../sis_cuenta_documentada/control/PagoSimplePro/eliminarPagoSimplePro',
	ActList:'../../sis_cuenta_documentada/control/PagoSimplePro/listarPagoSimplePro',
	id_store:'id_pago_simple_pro',
	fields: [
		{name:'id_pago_simple_pro', type: 'numeric'},
		{name:'factor', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_pago_simple', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_ingas', type: 'string'},
		{name:'desc_partida', type: 'string'},
		{name:'gestion', type: 'string'},
		{name:'desc_cc', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_pago_simple_pro',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_pago_simple;
        this.Atributos[this.getIndAtributo('id_gestion')].valorInicial = this.maestro.id_gestion;

        //Filtro de gestion para los centros de costo
		/*var time = new Date(this.maestro.fecha);

        Ext.Ajax.request({
            url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
            params: {fecha: this.maestro.fecha},
            success: function(resp){
            	var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
        		Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: reg.datos.id_gestion});*/
        		Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: this.maestro.id_gestion})
				this.Cmp.id_centro_costo.modificado=true;
				this.Cmp.id_centro_costo.setValue('');
            /*},
            failure: function(resp) {
                 Phx.CP.conexionFailure(resp);
            },
            timeout: function() {
                Phx.CP.config_ini.timeout();
            },
            scope:this
        });*/


        //Filtro para los datos
        this.store.baseParams = {
            id_pago_simple: this.maestro.id_pago_simple
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    }

})
</script>
		
		