<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.RDui = Ext.extend(Phx.frmInterfaz, {
		
		Atributos : [
		{
            config:{
                name:'id_gestion',
                fieldLabel:'Gestión',
                allowBlank:false,
                emptyText:'Gestión...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Gestion/listarGestion',
                         id: 'id_gestion',
                         root: 'datos',
                         sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion','moneda','codigo_moneda'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
                    }),
                valueField: 'id_gestion',
                displayField: 'gestion',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_gestion',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'80%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'gestion',
                        type:'string'
                    },
            grid:true,
            form:true
        },
        {
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'gestion'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name:'filtro',
				fieldLabel:'Filtro',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Filtro...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[
						
	        	        ['todos','Todos'],
	        	        ['pend_comi_agen','Pendientes de comisión agencia'],
	        	        ['pend_comp_pag_comi','Pendientes de comprobantes pago comisión'],
				
						]	        				
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:260,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
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
            config: {
                name: 'pedido_sap',
                fieldLabel: 'Pedido Sap',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_cuenta_documentada/control/ControlDui/listarControlDuiFiltro',
                    id: 'pedido_sap',
                    root: 'datos',
                    sortInfo: {
                        field: 'cdui.pedido_sap',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['pedido_sap'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'cdui.pedido_sap'}
                }),
                valueField: 'pedido_sap',
                displayField: 'pedido_sap',
                gdisplayField: 'pedido_sap',
                hiddenName: 'pedido_sap',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 200,
                queryDelay: 1000,
                anchor: '80%',
                gwidth: 150,
                minChars: 2,
                renderer: function (value, p, record) {
                    return String.format('{0}', record.data['pedido_sap']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'cdui.pedido_sap', type: 'string'},
            grid: true,
            form: true
        },	
        {
            config: {
                name: 'tramite_pedido_endesis',
                fieldLabel: 'Tramite pedido endesis',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_cuenta_documentada/control/ControlDui/listarControlDuiFiltro',
                    id: 'tramite_pedido_endesis',
                    root: 'datos',
                    sortInfo: {
                        field: 'cdui.tramite_pedido_endesis',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['tramite_pedido_endesis'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'cdui.tramite_pedido_endesis'}
                }),
                valueField: 'tramite_pedido_endesis',
                displayField: 'tramite_pedido_endesis',
                gdisplayField: 'tramite_pedido_endesis',
                hiddenName: 'tramite_pedido_endesis',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 200,
                queryDelay: 1000,
                anchor: '80%',
                gwidth: 150,
                minChars: 2,
                renderer: function (value, p, record) {
                    return String.format('{0}', record.data['tramite_pedido_endesis']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'cdui.tramite_pedido_endesis', type: 'string'},
            grid: true,
            form: true
        },	
        {
            config: {
                name: 'tramite_comision_agencia',
                fieldLabel: 'Tramite comision agencia',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_cuenta_documentada/control/ControlDui/listarControlDuiFiltro',
                    id: 'tramite_comision_agencia',
                    root: 'datos',
                    sortInfo: {
                        field: 'cdui.tramite_comision_agencia',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['tramite_comision_agencia'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'cdui.tramite_comision_agencia'}
                }),
                valueField: 'tramite_comision_agencia',
                displayField: 'tramite_comision_agencia',
                gdisplayField: 'tramite_comision_agencia',
                hiddenName: 'tramite_comision_agencia',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 200,
                queryDelay: 1000,
                anchor: '80%',
                gwidth: 150,
                minChars: 2,
                renderer: function (value, p, record) {
                    return String.format('{0}', record.data['tramite_comision_agencia']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'cdui.tramite_comision_agencia', type: 'string'},
            grid: true,
            form: true
        },	

		/*{
            config:{
                name:'id_periodo',
                fieldLabel:'Periodo',
                allowBlank:true,
                emptyText:'Periodo...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Periodo/listarPeriodo',
                         id: 'id_periodo',
                         root: 'datos',
                         sortInfo:{
                            field: 'id_periodo',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_periodo','literal','periodo','fecha_ini','fecha_fin'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'periodo#literal'}
                    }),
                valueField: 'id_periodo',
                displayField: 'literal',
                //tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>{denominacion}</p></div></tpl>',
                hiddenName: 'id_periodo',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:12,
                queryDelay:1000,
                listWidth:600,
                resizable:true,
                anchor:'100%'
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'literal',
                        type:'string'
                    },
            grid:true,
            form:true
        },*/
		/*{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},*/
		/*{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},*/
		/*{
			config:{
				name:'formato_reporte',
				fieldLabel:'Formato del Reporte',
				typeAhead: true,
				allowBlank:false,
	    		triggerAction: 'all',
	    		emptyText:'Formato...',
	    		selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
	        	fields: ['ID', 'valor'],
	        	data :	[['pdf','PDF'],	
                        ['xls','XLS']]
	    		}),
				valueField:'ID',
				displayField:'valor',
				width:250,			
				
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},*/


		],
		
		
		//title : 'Reporte Libro Compras Ventas IVA',		
		//ActSave : '../../sis_contabilidad/control/TsLibroBancos/reporteLibroBancos',
		
		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Reporte Dui</b>',
		
		constructor : function(config) {
			Phx.vista.RDui.superclass.constructor.call(this, config);
			this.init();
			

			//this.ocultarComponente(this.Cmp.id_gestion);
			//this.ocultarComponente(this.Cmp.id_periodo);
						
			this.iniciarEventos();
			
			//this.Cmp.datos.setValue('No contabilizado');
			//this.Cmp.datos.setValue('contabilizado');
		},
		
		iniciarEventos:function(){        
			
			this.Cmp.id_gestion.on('select',function(c,r,n){
				
				//this.Cmp.id_periodo.reset();
				//alert(this.Cmp.id_gestion.lastSelectionText);
				this.Cmp.gestion.setValue(this.Cmp.id_gestion.lastSelectionText);
				/*this.Cmp.id_periodo.store.baseParams={id_gestion:c.value, vista: 'reporte'};				
				this.Cmp.id_periodo.modificado=true;*/
				
			},this);
			
			
			/*this.Cmp.filtro_sql.on('select',function(combo, record, index){
				
				if(index == 0){
					this.ocultarComponente(this.Cmp.fecha_fin);
					this.ocultarComponente(this.Cmp.fecha_ini);
					this.mostrarComponente(this.Cmp.id_gestion);
					this.mostrarComponente(this.Cmp.id_periodo);
				}
				else{
					this.mostrarComponente(this.Cmp.fecha_fin);
					this.mostrarComponente(this.Cmp.fecha_ini);
					this.ocultarComponente(this.Cmp.id_gestion);
					this.ocultarComponente(this.Cmp.id_periodo);
				}
				
			}, this);*/
		},
		
		
		
		tipo : 'reporte',
		clsSubmit : 'bprint',
		
		/*Grupos : [{
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Datos para el reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '800px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}],*/
		
	ActSave:'../../sis_cuenta_documentada/control/ControlDui/reporteDui',
	
    successSave :function(resp){
   
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if (reg.ROOT.error) {
            alert('error al procesar');
            return
       } 
       var nomRep = reg.ROOT.detalle.archivo_generado;
        if(Phx.CP.config_ini.x==1){  			
        	nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
        }
       
        //if(this.Cmp.formato_reporte.getValue()=='pdf'){
        //	window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
        //}
        //else{
        	window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())
        //}
	}
})
</script>