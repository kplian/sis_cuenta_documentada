<?php
/**
*@package pXP
*@file gen-CuentaDocDet.php
*@author  (admin)
*@date 05-09-2017 17:54:29
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaDocDet.superclass.constructor.call(this,config);
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
					name: 'id_cuenta_doc_det'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
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
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '100%',
                gdisplayField: 'moneda',//mapea al store del grid
                gwidth: 100,
                baseParams: { 'filtrar_base': 'si' },
                renderer: function (value, p, record){return String.format('{0}', record.data['moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo#mon.moneda',type:'string'},
            grid: true,
            form: true
        },
        {
			config:{
				name: 'monto_mo',
				fieldLabel: 'Importe',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'cdet.monto_mo',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'id_moneda_mb',
				fieldLabel: 'Moneda Base',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				gdisplayField: 'moneda_mb'
			},
			type: 'Field',
			filters:{pfiltro:'mon1.codigo#mon1.moneda',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'monto_mb',
				fieldLabel: 'Importe Moneda Base',
				allowBlank: true,
				anchor: '80%',
				gwidth: 130,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'cdet.monto_mb',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
            config:{
                name: 'id_centro_costo',
                fieldLabel: 'Centro Costo',
                allowBlank: false,
                emptyText : 'Centro Costo...',
                store : new Ext.data.JsonStore({
                    url:'../../sis_parametros/control/CentroCosto/listarCentroCosto',
                    id : 'id_centro_costo',
                    root: 'datos',
                    sortInfo:{
                            field: 'codigo_cc',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_centro_costo','codigo_cc'],
                    remoteSort: true,
                    baseParams:{par_filtro:'codigo_cc'}
                }),
                valueField: 'id_centro_costo',
				displayField: 'codigo_cc',
				gdisplayField: 'descripcion_tcc',
				hiddenName: 'id_centro_costo',
				forceSelection:true,
				typeAhead: true,
				triggerAction: 'all',
				listWidth:350,
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width:350,
				gwidth:350,
				minChars:2,
				anchor: '100%',
				renderer:function(value, p, record){return String.format('{0}', record.data['descripcion_tcc']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
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
					return String.format('{0} <br/><b>{1} - ({2}) </b>', record.data['desc_ingas'],  record.data['desc_partida'], record.data['desc_gestion']);
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
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'cdet.estado_reg',type:'string'},
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
			filters:{pfiltro:'cdet.id_usuario_ai',type:'numeric'},
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
			filters:{pfiltro:'cdet.usuario_ai',type:'string'},
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
			filters:{pfiltro:'cdet.fecha_reg',type:'date'},
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
			filters:{pfiltro:'cdet.fecha_mod',type:'date'},
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
	title:'Presupuesto',
	ActSave:'../../sis_cuenta_documentada/control/CuentaDocDet/insertarCuentaDocDet',
	ActDel:'../../sis_cuenta_documentada/control/CuentaDocDet/eliminarCuentaDocDet',
	ActList:'../../sis_cuenta_documentada/control/CuentaDocDet/listarCuentaDocDet',
	id_store:'id_cuenta_doc_det',
	fields: [
		{name:'id_cuenta_doc_det', type: 'numeric'},
		{name:'id_cuenta_doc', type: 'numeric'},
		{name:'monto_mb', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'monto_mo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_moneda_mb', type: 'numeric'},
		{name:'moneda', type: 'string'},
		{name:'moneda_mb', type: 'string'},
		{name:'descripcion_tcc', type: 'string'},
		{name:'desc_ingas', type: 'string'},
		{name:'desc_partida', type: 'string'}
	],
	sortInfo:{
		field: 'id_cuenta_doc_det',
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

        //Aplicar filtro específico para conceptos de gasto
        var bp = { 
        	par_filtro: 'desc_ingas#par.codigo',movimiento:'gasto'
        };

        if(this.maestro.codigo_tipo_cuenta_doc=='SOLFONAVA'){
        	bp.autorizacion = 'fondo_avance';
        } else if(this.maestro.codigo_tipo_cuenta_doc=='SOLVIA'){
        	bp.autorizacion = 'viatico';
        } else if(this.maestro.codigo_tipo_cuenta_doc=='RFA'){

        }

        this.Cmp.id_concepto_ingas.store.baseParams = bp;
        this.Cmp.id_concepto_ingas.modificado=true;

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
		
		