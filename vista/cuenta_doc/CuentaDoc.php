<?php
/**   mysql -uroot '-peLaStIx.2oo7'
*@package pXP
*@file gen-CuentaDoc.php
*@author  (admin)
*@date 05-05-2016 16:41:21
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDoc = Ext.extend(Phx.gridInterfaz,{
    nombreVista: 'CuentaDoc',
    tipo_interfaz: 'fondo_avance',
	constructor:function(config){
		this.maestro=config.maestro;    	
    	//llama al constructor de la clase padre
    	Phx.vista.CuentaDoc.superclass.constructor.call(this,config);    	
    	this.addButton('ant_estado',{ argument: {estado: 'anterior'},text:'Rechazar',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('sig_estado',{ text:'Aprobar', iconCls: 'badelante', disabled: true, handler: this.sigEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});
        
        this.addBotonesGantt();
        this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1,2,3,4],
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            });
        
        this.addButton('btnObs',{
                    text :'Obs Wf',
                    grupo:[0,1,2,3,4],
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
         });
         
         this.addButton('chkpresupuesto',{text:'Chk Presupuesto', grupo:[0,1,2,3,4],
				iconCls: 'blist',
				disabled: true,
				handler: this.checkPresupuesto,
				tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para el tramite</p>'
			});
		   
	},
			
	Atributos:[
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc_fk'
			},
			type:'Field',
			form:false 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estado_wf'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_wf'
			},
			type:'Field',
			form:true 
		},
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'codigo_tipo_cuenta_doc'
			},
			type:'Field',
			form:true 
		},
		{
			config: {
				name: 'id_escala',
				fieldLabel: 'Escala',
				renderer: function(value,p,record){
					return String.format('{0}',record.data.desc_escala);
				}
			},
			type: 'TextField',
			grid: true,
			form: false
		},
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Trámite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 120,
				maxLength:150,
                renderer: function (value, p, record){
                	if(record.data.sw_solicitud == 'no' ){
                	     return String.format('{0}-{1}', value,record.data.num_rendicion );
                	}
                	else{
                		 return String.format('{0}', value);
                	}
                	
                }
			},
				type:'TextField',
				bottom_filter:true,
				filters: { pfiltro: 'cdoc.nro_tramite', type:'string' },
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name:'id_tipo_cuenta_doc',
				fieldLabel:'Tipo Solicitud',
				allowBlank:false,
				emptyText:'Tipo...',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'estilo',
				gwidth: 120,
				anchor: '100%',
				store: new Ext.data.JsonStore({
					url: '../../sis_cuenta_documentada/control/TipoCuentaDoc/listarTipoCuentaDoc',
					id: 'id_tipo_cuenta_doc',
					root: 'datos',
					sortInfo:{
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_cuenta_doc','nombre','codigo','descripcion'],
					// turn on remote sorting
					remoteSort: true,
					baseParams:{par_filtro:'nombre', sw_solicitud: 'si'
					}
				}),
				valueField: 'id_tipo_cuenta_doc',
				displayField: 'nombre',
				gdisplayField: 'tipo_cuenta_doc',
				hiddenName: 'codigo',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				listWidth:300,
				resizable:true,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['nombre']);
				}
			},
			type:'ComboBox',
			id_grupo:1,
			//filters:{pfiltro:'ren.tipo',type:'string'},
			grid:false,
			form:true
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha Solicitud',
				allowBlank: false,
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters: { pfiltro:'cdoc.fecha', type:'date' },
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'motivo',
				qtip: 'Explique el objetivo del fondo solicitado',
				fieldLabel: 'Motivo',
				allowBlank: false,
				anchor: '100%',
				gwidth: 200,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'cdoc.motivo',type:'string'},
			bottom_filter:true,
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'sw_max_doc_rend',
				fieldLabel: 'Bloq',
				allowBlank: false,
				anchor: '80%',
				gwidth: 50,
				maxLength:150,
                renderer: function (value, p, record){
                	if(record.data.sw_solicitud == 'no' ){
                		if(record.data.sw_max_doc_rend == 'no' ){
	                	     return String.format('<div title="No permite regitro de facturas grandes"><b><font color="green">{0}</font></b></div>', value);
	                	}
	                	else{
	                		 return String.format('<div title="Si permite el registro de facturas grandes"><b><font color="red">{0}</font></b></div>', value);
	                	}
                	}
	               else{
	               	   return '<b>--</b>';
	               }
                }
			},
			type:'Field',
			id_grupo:1,
			grid:false,
			form:false
		},
		
		{
			config:{
				name: 'dias_para_rendir',
				fieldLabel: 'Días Rend.',
				allowBlank: false,
				anchor: '80%',
				gwidth: 70,
				maxLength:150,
                renderer: function (value, p, record){
                	if(record.data.estado != 'finalizado' && record.data.estado != 'rendido'){
                		if(value < 0){
	                		   return String.format('<div title="Días vencidos"><b><font color="red">{0}</font></b></div>', value);
	                	}
	                	else{
	                		if(value < 5){
	                		   return String.format('<div title="Días restante para rendir"><b><font color="orange">{0}</font></b></div>', value);
	                	    }
	                	    else{
	                	    	return String.format('<div title="Días restante para rendir"><b><font color="green">{0}</font></b></div>', value);
	                	    }
	                	}
                	}
	               else{
	               	   return '<b>--</b>';
	               }
                }
			},
			type:'TextField',
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'max_fecha_rendicion',
				fieldLabel: 'Límite Rend.',
				allowBlank: false,
				gwidth: 80,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'tipo_cuenta_doc',
				fieldLabel: 'Tipo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
				type:'TextField',
				filters:{pfiltro:'tcd.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name : 'id_periodo',
				origen : 'PERIODO',
				fieldLabel : 'Periodo/Mes',
				allowBlank : false,
				pageSize:12,
				width:230,
				listWidth:'230',
				renderer:function(value, p, record){return String.format('{0}', record.data['periodo']);},
				valueField: 'id_periodo',
				displayField: 'periodo',
				disabled:false
			},
			type : 'ComboRec',
			id_grupo : 0,
			form : false,
			grid: false
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type: 'TextField',
				filters: { pfiltro:'cdoc.estado', type: 'string' },
				id_grupo: 1,
				grid: true,
				form: false
		},
       	{
   			config:{
       		    name:'id_funcionario',
       		    hiddenName: 'Solicitante',
   				origen:'FUNCIONARIOCAR',
   				fieldLabel:'Solicitante',
   				allowBlank:false,
                gwidth:200,
                anchor: '100%',
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario',
   			    baseParams: { es_combo_solicitud : 'si' },
      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
       	     },
   			type:'ComboRec',//ComboRec
   			id_grupo:0,
   			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
   			bottom_filter:true,
   		    grid:true,
   			form:true
		},
		{
		    config: {
		        name: 'tipo_contrato',
		        fieldLabel: 'Tipo Contrato Solicitante',
		        allowBlank: true,
		        gwidth: 150,
		        maxLength: 50,
		        typeAhead: true,
		        triggerAction: 'all',
		        lazyRender: true,
		        mode: 'local',
		        forceSelection: true,
				valueField: 'variable',
		        displayField: 'valor',
		        anchor: '100%',
		        store: new Ext.data.ArrayStore({
		            fields:['variable','valor'],
					data:  [['planta_obra_determinada','planta_obra_determinada'], ['servicio','servicio']]
				}),
				hidden: true
		    },
		    type: 'ComboBox',
		    id_grupo: 1,
		    grid: true,
		    form: true
		},
		/*{
            config: {
                name: 'tipo_sol_sigema',
                fieldLabel: 'Tipo Solicitud SIGEMA',
                allowBlank: true,
                gwidth: 150,
                maxLength: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                forceSelection: true,
				valueField: 'variable',
                displayField: 'valor',
                anchor: '100%',
                store: new Ext.data.ArrayStore({
                    fields:['variable','valor'],
        			data:  [['orden_trabajo','orden_trabajo'], ['sol_admin','sol_admin'], ['sol_man_mihv','sol_man_mihv'], ['sol_man_event','sol_man_event']]
        		}),
        		hidden: true
            },
            type: 'ComboBox',
            id_grupo: 1,
            grid: true,
            form: true
        },
        {
			config: {
				name: 'id_sigema',
				fieldLabel: 'Elemento SIGEMA',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_cuenta_documentada/control/CuentaDocumentada/listarElementoSigema',
					id: 'id_sigema',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_sigema', 'tipo_sol_sigema', 'nombre'],
					remoteSort: true,
					baseParams: {par_filtro: 'sigpr.nombre'}
				}),
				valueField: 'id_sigema',
				displayField: 'nombre',
				gdisplayField: 'desc_sigema',
				hiddenName: 'id_sigema',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 100,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_sigema']);
				},
				hidden: true
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'sigpr.nombre',type: 'string'},
			grid: true,
			form: true
		},*/			
		{
   			config:{
   				name: 'id_depto',
   				hiddenName: 'Depto',
   				url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   			origen: 'DEPTO',
	   			allowBlank: false,
	   			fieldLabel: 'Depto',
	   			anchor: '100%',
	   			gdisplayField: 'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
	   			width: 250,
   			    gwidth: 180,
	   			baseParams: { estado:'activo',codigo_subsistema:'TES',modulo:'OP'},//parametros adicionales que se le pasan al store
	      		renderer: function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
   			},
   			type: 'ComboRec',
   			id_grupo: 0,
   			filters: { pfiltro:'dep.nombre', type:'string'},
   		    grid: true,
   			form: true
       	},
		/*{
			config: {
				name: 'tipo_fondo',
				fieldLabel: 'Tipo Fondo Avance',
				allowBlank: false,
				width: 250,
				gwidth: 180,
				maxLength: 50,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'local',
				forceSelection: true,
				valueField: 'variable',
				displayField: 'valor',
				store:new Ext.data.ArrayStore({
					fields :['variable','valor'],
					data :  [['1','Comun'],['2','Charter']]})
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters:{ type: 'list',
				options: ['comun','charter'],
			},
			grid: true,
			form: true
		},*/
		{
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '100%',
                gdisplayField: 'desc_moneda',//mapea al store del grid
                gwidth: 50,
                //baseParams: { 'filtrar_base': 'si' },
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo',type:'string'},
            grid: true,
            form: true
        },
        {
            config:{
                name: 'importe',
                currencyChar:' ',
                qtip: 'Importe solicitado',
                fieldLabel: 'Importe',
                allowBlank: false,
                allowDecimals: true,
                allowNegative:false,
                decimalPrecision:2,
                anchor: '100%',
                gwidth: 200,
                maxLength:1245186
            },
            type:'NumberField',
            filters: { pfiltro: 'cdoc.importe', type: 'numeric'},
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
                gdisplayField: 'descripcion_tcc',//mapea al store del grid
                gwidth: 50,
                url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXUsuaio',
                renderer: function (value, p, record){return String.format('{0}', record.data['descripcion_tcc']);},
                baseParams:{filtrar:'grupo_ep'},
                hidden: true
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'cc.descripcion_tcc',type:'string'},
            grid: true,
            form: true
        },
        {
            config: {
                name: 'tipo_pago',
                fieldLabel: 'Forma de Pago',
                allowBlank: false,
                gwidth: 150,
                maxLength: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                forceSelection: true,
				valueField: 'variable',
                displayField: 'valor',
                anchor: '100%',
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['cheque','cheque'],['transferencia','transferencia']]})
            },
            type: 'ComboBox',
            id_grupo: 1,
            filters:{ type: 'list',
                      pfiltro:'cdoc.tipo_pago',
                      options: ['cheque','transferencia'],   
                    },
            grid: true,
            form: true
        },
	    {
			config:{
				name: 'nombre_cheque',
				fieldLabel: 'Nombre Cheque',
				allowBlank: true,
				anchor: '100%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'cdoc.nombre_cheque',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		
		},
		{
			config: {
				name: 'id_caja',
				fieldLabel: 'Caja',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_tesoreria/control/Caja/listarCaja',
					id: 'id_caja',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_caja', 'codigo', 'desc_moneda','id_depto','cajero'],
					remoteSort: true,
					baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'solicitudcaja', con_detalle:'no'}
				}),
				valueField: 'id_caja',
				displayField: 'codigo',
				gdisplayField: 'desc_caja',
				hiddenName: 'id_caja',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 100,
				minChars: 2,
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>CAJERO: {cajero}</p></div></tpl>',
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo']);
				},
				hidden: true
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'movtip.codigo',type: 'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'fecha_entrega',
				fieldLabel: 'Fecha Entrega Cheque',
				allowBlank: false,
				anchor: '80%',
				gwidth: 120,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters: { pfiltro:'cdoc.fecha', type:'date' },
			id_grupo:1,
			grid:true,
			form:false
		},
		{
            config:{
                name: 'id_funcionario_cuenta_bancaria',
                origen: 'FUNCUENTABANC',
                allowBlank: false,
                fieldLabel: 'Cuenta Destino',
                gdisplayField: 'desc_funcionario_cuenta_bancaria',//mapea al store del grid
                gwidth: 50,
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_funcionario_cuenta_bancaria']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'nro_cuenta',type:'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'nro_correspondencia',
				fieldLabel: 'Nro.Informe',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
				type:'TextField',
				filters:{pfiltro:'cdoc.nro_correspondencia',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:false,
				form:false
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
				filters:{pfiltro:'cdoc.estado_reg',type:'string'},
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
				filters:{pfiltro:'cdoc.fecha_reg',type:'date'},
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
				filters:{pfiltro:'cdoc.fecha_mod',type:'date'},
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
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cdoc.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'cdoc.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config: {
				name: 'fecha_salida',
				fieldLabel: 'Fecha Salida',
				allowBlank: false,
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
				hidden: true,
				//id: this.idContenedor+'fecha_salida',
				//vtype: 'daterange',
        		//endDateField: this.idContenedor+'fecha_llegada'
			},
			type:'DateField',
			filters: { pfiltro:'cdoc.fecha_salida', type:'date' },
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'hora_salida',
				fieldLabel: 'Hora Salida (HH:mm)',
				allowBlank: false,
				gwidth: 100,
				regex: /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/,
				regexText: 'Hora inválida. Debe estar en formato HH:mm (0 - 24)',
				maskRe: /\d|:/i,
				maxLength: 5,
				hidden: true
			},
			type:'TextField',
			filters: { pfiltro:'cdoc.hora_salida', type:'string' },
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'fecha_llegada',
				fieldLabel: 'Fecha Llegada',
				allowBlank: false,
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
				hidden: true,
				//id: this.idContenedor+'fecha_llegada',
				//vtype: 'daterange',
        		//startDateField: this.idContenedor+'fecha_salida'
			},
			type:'DateField',
			filters: { pfiltro:'cdoc.fecha_llegada', type:'date' },
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'hora_llegada',
				fieldLabel: 'Hora Llegada (HH:mm)',
				allowBlank: false,
				gwidth: 100,
				regex: /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/,
				regexText: 'Hora inválida',
				maskRe: /\d|:/i,
				maxLength: 5,
				hidden: true
			},
			type:'TextField',
			filters: { pfiltro:'cdoc.hora_salida', type:'string' },
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'tipo_viaje',
				fieldLabel: 'Tipo de Viaje',
				tinit: false,
				allowBlank: true,
				origen: 'CATALOGO',
				gdisplayField: 'tipo_viaje',
				hiddenName: 'tipo_viaje',
				gwidth: 100,
				anchor: '100%',
				baseParams:{
					cod_subsistema:'CD',
					catalogo_tipo:'tdestino__tipo'
				},
				valueField: 'codigo',
				hidden: true
			},
			type: 'ComboRec',
			id_grupo: 1,
			filters:{pfiltro:'cdoc.tipo_viaje',type:'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'medio_transporte',
				fieldLabel: 'Medio de Transporte',
				tinit: false,
				allowBlank: true,
				origen: 'CATALOGO',
				gdisplayField: 'medio_transporte',
				hiddenName: 'medio_transporte',
				gwidth: 100,
				anchor: '100%',
				baseParams:{
					cod_subsistema:'CD',
					catalogo_tipo:'tcuenta_doc__medio_transporte'
				},
				valueField: 'codigo',
				hidden: true
			},
			type: 'ComboRec',
			id_grupo: 1,
			filters:{pfiltro:'cdoc.medio_transporte',type:'string'},
			grid: true,
			form: true
		},
		{
			config: {
				name: 'cobertura',
				fieldLabel: 'Tipo de Viático/Cobertura',
				anchor: '100%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'cobertura',
				hiddenName: 'cobertura',
				gwidth: 55,
				baseParams:{
					cod_subsistema:'CD',
					catalogo_tipo:'tcuenta_doc__cobertura'
				},
				valueField: 'codigo',
				hidden: true
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'cdoc.cobertura',type:'string'},
			grid: true,
			form: true
		},
		{
			config:{
				name: 'id_plantilla',
				fieldLabel: 'Tipo Documento Viatico',
				allowBlank: true,
				emptyText:'Elija un opcion...',
				store:new Ext.data.JsonStore({
					url: '../../sis_parametros/control/Plantilla/listarPlantilla',
					id: 'id_plantilla',
					root:'datos',
					sortInfo:{
						field:'id_plantilla',
						direction:'ASC'
					},
					totalProperty:'total',
					baseParams: {filtrar: 'viatico'},
					fields: [ 'id_plantilla','desc_plantilla'],
					remoteSort: true
				}),
				valueField: 'id_plantilla',
				hiddenValue: 'id_plantilla',
				displayField: 'desc_plantilla',
				listWidth:'280',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:20,
				queryDelay:500,
				anchor: '80%',
				minChars:2,
				renderer: function (value, p, record){return String.format('{0}', record.data['desc_plantilla']);}
		   	},
			type:'ComboBox',
			form:false,
			grid:false
		},
		{
			config:{
				name: 'cantidad_personas',
				fieldLabel: 'Cantidad Personas',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:150,
				hidden: true,
				maxValue: 100,
				minValue:1
			},
			type:'NumberField',
			filters:{pfiltro:'cdoc.cantidad_personas',type:'string'},
			id_grupo:1,
			bottom_filter:true,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'tipo_rendicion',
				fieldLabel: 'Tipo Rendición',
				anchor: '100%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'tipo_rendicion',
				hiddenName: 'tipo_rendicion',
				gwidth: 55,
				baseParams:{
					cod_subsistema:'CD',
					catalogo_tipo:'tcuenta_doc__tipo_rendicion'
				},
				valueField: 'codigo'
			},
			type: 'ComboRec',
			id_grupo: 0,
			filters:{pfiltro:'cdoc.tipo_rendicion',type:'string'},
			grid: false,
			form: false
		},
		{
		    config: {
		        name: 'aplicar_regla_15',
		        fieldLabel: 'Aplicar Regla de 15 Días',
		        allowBlank: true,
		        gwidth: 150,
		        maxLength: 50,
		        typeAhead: true,
		        triggerAction: 'all',
		        lazyRender: true,
		        mode: 'local',
		        forceSelection: true,
				valueField: 'variable',
		        displayField: 'valor',
		        anchor: '100%',
		        store: new Ext.data.ArrayStore({
		            fields:['variable','valor'],
					data:  [['si','si'], ['no','no']]
				}),
				hidden: true
		    },
		    type: 'ComboBox',
		    id_grupo: 1,
		    grid: true,
		    form: true
		}
	],
	
	rowExpander: new Ext.ux.grid.RowExpander({
        tpl: new Ext.Template(
            '<br>',
            
            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obs WF:&nbsp;&nbsp;</b> {obs}</p>',
            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>',
            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>'
        )
    }),
    
    arrayDefaultColumHidden:['usr_reg','usr_mod','estado_reg','fecha_reg'],

	tam_pag: 50,	
	title:'Cuenta Documentada',
	ActSave:'../../sis_cuenta_documentada/control/CuentaDoc/insertarCuentaDoc',
	ActDel:'../../sis_cuenta_documentada/control/CuentaDoc/eliminarCuentaDoc',
	ActList:'../../sis_cuenta_documentada/control/CuentaDoc/listarCuentaDoc',
	id_store:'id_cuenta_doc',
	fields: [
		{name:'id_cuenta_doc', type: 'numeric'},
		{name:'id_tipo_cuenta_doc', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'sw_modo', type: 'string'},
		{name:'id_caja', type: 'numeric'},
		{name:'nombre_cheque', type: 'string'},
		{name:'id_uo', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'tipo_pago', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_cuenta_doc_fk', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'motivo', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_entrega', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_moneda', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},'sw_max_doc_rend','num_rendicion','importe_solicitado',
		{name:'usr_mod', type: 'string'},'importe','obs','nro_correspondencia','importe_total_rendido',
		'id_funcionario_cuenta_bancaria','sw_solicitud','importe_depositos', 'id_periodo', 'periodo',
		'desc_funcionario_cuenta_bancaria','tipo_cuenta_doc','importe_retenciones',
		'desc_funcionario','desc_moneda','desc_depto','id_depto_conta','id_depto_lb','importe_documentos','dias_para_rendir',
		{name: 'fecha_salida', type: 'date',dateFormat:'Y-m-d'},
		{name: 'fecha_llegada', type: 'date',dateFormat:'Y-m-d'},
		{name: 'tipo_viaje', type: 'string'},
		{name: 'medio_transporte', type: 'string'},
		{name: 'codigo_tipo_cuenta_doc', type: 'string'},
		{name: 'cobertura', type: 'string'},'hora_salida','hora_llegada',
		{name: 'desc_escala', type: 'string'},
		{name: 'max_fecha_rendicion', type: 'date',dateFormat:'Y-m-d'},
		{name: 'id_escala', type: 'numeric'},
		{name: 'id_centro_costo', type: 'numeric'},
		{name: 'descripcion_tcc', type: 'string'},
		{name: 'desc_caja', type: 'string'},
		{name: 'id_plantilla', type: 'numeric'},
		{name: 'desc_plantilla', type: 'string'},
		{name: 'dev_tipo', type: 'string'},
		{name: 'dev_a_favor_de', type: 'string'},
		{name: 'dev_nombre_cheque', type: 'string'},
		{name: 'id_caja_dev', type: 'numeric'},
		{name: 'dev_saldo', type: 'numeric'},
		{name: 'dev_caja', type: 'string'},
		{name: 'tipo_contrato', type: 'string'},
		{name: 'cantidad_personas', type: 'numeric'},
		{name: 'tipo_rendicion', type: 'string'},
		{name: 'aplicar_regla_15', type: 'string'}
	],
	sortInfo:{
		field: 'id_cuenta_doc',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,	
	//deshabilitas botones para informacion historica
    desBotoneshistorico: function(){
      
      this.getBoton('ant_estado').disable();
      this.getBoton('sig_estado').disable();
      
   },
  
   liberaMenu:function(){
        var tb = Phx.vista.CuentaDoc.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('chkpresupuesto').disable();
            
        }
        return tb
    },

	successGestion: function(resp){
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		if(!reg.ROOT.error){
			var id_gestion = reg.ROOT.datos.id_gestion;
			//Setea los stores de partida, cuenta, etc. con la gestion obtenida
			Ext.apply(this.Cmp.id_cuenta.store.baseParams,{id_gestion: id_gestion})

		} else{
			alert('Error al obtener la gestión. Cierre y vuelva a intentarlo')
		}
	},

    //para retroceder de estado
    antEstado:function(res){
         var rec=this.sm.getSelected(),
             obsValorInicial;
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {   modal: true,
                width: 450,
                height: 250
            }, 
            {    data: rec.data, 
            	 estado_destino: res.argument.estado,
                 obsValorInicial: obsValorInicial }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }],
               scope:this
           });
   },
   
   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  resp.estado_destino == 'inicio'?'inicio':operacion; 
            Ext.Ajax.request({
                url:'../../sis_cuenta_documentada/control/CuentaDoc/anteriorEstado',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        operacion: operacion,
                        id_cuenta_doc: resp.data.id_cuenta_doc
                 },
                argument:{wizard:wizard},  
                success: this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
           
    },
     successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
     },
     
     sigEstado:function(){                   
      	var rec=this.sm.getSelected();
      	
      	this.mostrarWizard(rec);
      	
               
     },
    
    mostrarWizard : function(rec) {
     	var me = this,
     	    configExtra = [],
     		obsValorInicial;

     	this.eventosExtra = function(obj){};
     	   	
     	   	if(rec.data.estado == 'vbtesoreria' &&  rec.data.sw_solicitud == 'si' ){

     	   		if(rec.data.tipo_pago!='caja'){
     	   			configExtra = [
			      				{     
									config:{
										name:'id_depto_lb',
										origen:'DEPTO',
										fieldLabel: 'Departamento Libro Bancos',
										url: '../../sis_parametros/control/Depto/listarDepto',
										emptyText : 'Departamento Libro Bancos...',
										allowBlank:false,
										anchor: '80%',
										baseParams: { tipo_filtro: 'DEPTO_UO', estado:'activo', codigo_subsistema:'TES', modulo:'LB', id_depto_origen: rec.data.id_depto}
									},   
									type:'ComboRec',
									form:true
								},
								{
									config:{
										name: 'id_cuenta_bancaria',
										fieldLabel: 'Cuenta Bancaria',
										allowBlank: false,
										emptyText:'Elija una Cuenta...',
										store:new Ext.data.JsonStore(
											{
											url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
											id: 'id_cuenta_bancaria',
											root:'datos',
											sortInfo:{
												field:'id_cuenta_bancaria',
												direction:'ASC'
											},
											totalProperty:'total',
											baseParams: {'tipo_interfaz':me.tipo_interfaz, id_moneda: rec.data.id_moneda},
											fields: [ 'id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
											remoteSort: true }),
										tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
										valueField: 'id_cuenta_bancaria',
										hiddenValue: 'id_cuenta_bancaria',
										displayField: 'nro_cuenta',
										disabled : true,
										listWidth:'280',
										forceSelection:true,
										typeAhead: false,
										triggerAction: 'all',
										lazyRender:true,
										mode:'remote',
										pageSize:20,
										queryDelay:500,
										anchor: '80%',
										minChars:2
								   },
								type:'ComboBox',
								form:true
							},
							{
					            config:{
					                name: 'id_cuenta_bancaria_mov',
					                fieldLabel: 'Depósito',
					                allowBlank: true,
					                emptyText : 'Depósito...',
					                store: new Ext.data.JsonStore({
					                    url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancosDepositosConSaldo',
					                    id : 'id_cuenta_bancaria_mov',
					                    root: 'datos',
					                    sortInfo:{field: 'fecha',direction: 'DESC'},
					                    totalProperty: 'total',
					                    fields: ['id_libro_bancos','id_cuenta_bancaria','fecha','detalle','observaciones','importe_deposito','saldo'],
					                    remoteSort: true,
					                    baseParams:{par_filtro:'detalle#observaciones#fecha',fecha: rec.data.fecha}
					               }),
					               valueField: 'id_libro_bancos',
					               displayField: 'importe_deposito',
					               hiddenName: 'id_cuenta_bancaria_mov',
					               forceSelection:true,
					               disabled : true,
					               typeAhead: false,
					               triggerAction: 'all',
					               listWidth:350,
					               lazyRender:true,
					               mode:'remote',
					               pageSize:10,
					               queryDelay:1000,
					               anchor: '80%',
					               minChars:2,
					               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Saldo:<strong>{saldo}</strong></p></div></tpl>'
					            },
					            type:'ComboBox',
					            id_grupo:1,
					            form:true
					        },
							{     
								config:{
										name:'id_depto_conta',
										origen:'DEPTO',
										fieldLabel: 'Departamento Contabilidad',
										url: '../../sis_parametros/control/Depto/listarDepto',
										emptyText : 'Departamento Libro Bancos...',
										allowBlank:false,
										disabled : true,
										anchor: '80%'
								  },
								type:'ComboRec',
								form:true
							}
					];

					this.eventosExtra = function(obj){
						obj.Cmp.id_depto_lb.on('select',function(data,rec,ind){
							
					        this.Cmp.id_cuenta_bancaria.enable();
					        this.Cmp.id_depto_conta.enable();
					        this.Cmp.id_cuenta_bancaria.reset();
				    		Ext.apply(this.Cmp.id_cuenta_bancaria.store.baseParams, {'tipo_interfaz':me.tipo_interfaz, par_filtro :'nro_cuenta', 'permiso':'fondos_avance', id_depto_lb : obj.Cmp.id_depto_lb.getValue()});
				    		this.Cmp.id_cuenta_bancaria.modificado = true;
				    		
				    		
				    		
				    		this.Cmp.id_depto_conta.reset();
				    		this.Cmp.id_depto_conta.store.baseParams = {tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'CONTA',id_depto_origen: obj.Cmp.id_depto_lb.getValue()};	
				    		this.Cmp.id_depto_conta.modificado = true;
				    		this.Cmp.id_cuenta_bancaria_mov.reset();
						    		
						    		
						    		
						    }, obj);	
						    	
						 
						 //Evento para filtrar los depósitos a partir de la cuenta bancaria
						obj.Cmp.id_cuenta_bancaria.on('select',function(data,rec,ind){
							//si es de una regional nacional
						    this.Cmp.id_cuenta_bancaria_mov.reset();
						    this.Cmp.id_cuenta_bancaria_mov.modificado=true;
						    Ext.apply(this.Cmp.id_cuenta_bancaria_mov.store.baseParams,{id_cuenta_bancaria: rec.id});
						    
						    //si es de una regional nacional
							if(rec.data.centro == 'no'){
								this.Cmp.id_cuenta_bancaria_mov.enable();
								this.Cmp.id_cuenta_bancaria_mov.allowBlank = false;
							}
							else{
								this.Cmp.id_cuenta_bancaria_mov.disable();
								this.Cmp.id_cuenta_bancaria_mov.allowBlank = true;
							}
						    
						    
						    
						    
						},obj);   	
						    			
					};

     	   		} 
				
			}
	     
	     
     	
     		this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal: true,
                                    width: 700,
                                    height: 450
                                }, 
                                {
                                	configExtra: configExtra,
                                	eventosExtra: this.eventosExtra,
                                	data:{
                                       id_estado_wf: rec.data.id_estado_wf,
                                       id_proceso_wf: rec.data.id_proceso_wf,
                                       id_cuenta_doc: rec.data.id_cuenta_doc,
                                       fecha_ini: rec.data.fecha
                                   },
                                   obsValorInicial: obsValorInicial,
                                }, this.idContenedor, 'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            },
					                        {
					                          event:'requirefields',
					                          delegate: function () {
						                          	this.onButtonEdit();
										        	this.window.setTitle('Registre los campos antes de pasar al siguiente estado');
										        	this.formulario_wizard = 'si';
					                          }
					                          
					                        }],
                                  
                                    scope:this
                        });        
     },
    onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/siguienteEstado',
            params:{
            	    id_cuenta_doc:     wizard.data.id_cuenta_doc,
            	    id_proceso_wf_act:  resp.id_proceso_wf_act,
	                id_estado_wf_act:   resp.id_estado_wf_act,
	                id_tipo_estado:     resp.id_tipo_estado,
	                id_funcionario_wf:  resp.id_funcionario_wf,
	                id_depto_wf:        resp.id_depto_wf,
	                obs:                resp.obs,
	                instruc_rpc:		resp.instruc_rpc,
	                json_procesos:      Ext.util.JSON.encode(resp.procesos),
	                id_depto_lb:  		resp.id_depto_lb,
	                id_cuenta_bancaria: resp.id_cuenta_bancaria,
	                id_cuenta_bancaria_mov: resp.id_cuenta_bancaria_mov,
	                id_depto_conta:  	resp.id_depto_conta
	                
                },
            success: this.successWizard,
            failure: this.conexionFailure, 
            argument: { wizard:wizard },
            timeout: this.timeout,
            scope: this
        });
    },
    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    
    diagramGantt: function (){			
			var data=this.sm.getSelected().data.id_proceso_wf;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
				params:{'id_proceso_wf':data},
				success: this.successExport,
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});			
	},
	
	diagramGanttDinamico: function (){			
			var data=this.sm.getSelected().data.id_proceso_wf;
			window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)		
	}, 
	
	addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls : 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
	            items: [{
	                id:'b-gantti-' + this.idContenedor,
	                text: 'Gantt Imagen',
	                tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
	                handler:this.diagramGantt,
	                scope: this
	            }, {
	                id:'b-ganttd-' + this.idContenedor,
	                text: 'Gantt Dinámico',
	                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
	                handler:this.diagramGanttDinamico,
	                scope: this
	            }]
            }
        });
		this.tbar.add(this.menuAdqGantt);
    },
    
    loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        )
    },
    
    onOpenObs: function() {
            var rec=this.sm.getSelected();            

            if (rec.data) {
            	var data = {
	            	id_proceso_wf: rec.data.id_proceso_wf,
	            	id_estado_wf: rec.data.id_estado_wf,
	            	num_tramite: rec.data.num_tramite
	            }
	            
	            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
	                    'Observaciones del WF',
	                    {
	                        width: '80%',
	                        height: '70%'
	                    },
	                    data,
	                    this.idContenedor,
	                    'Obs');
            }
            
    },		
	onBtnRepSol: function() {
		var rec = this.sm.getSelected();
		if (rec.data) {
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteSolicitudFondos',
				params : {
					'id_proceso_wf' : rec.data.id_proceso_wf,
					'id_cuenta_doc': rec.data.id_cuenta_doc,
					'tipo':rec.data.tipo_cuenta_doc
				},
				success : this.successExport,
				failure : this.conexionFailure,
				timeout : this.timeout,
				scope : this
			});
		}
	},
	
	onBtnRepRenCon: function() {
			var rec = this.sm.getSelected();
			if (rec.data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteRendicionCon',
					params : {
						'id_proceso_wf' : rec.data.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}
	},
	
	onBtnRendicion : function() {
			var rec = this.sm.getSelected();
			if (rec.data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteRendicionFondos',
					params : {
						'id_proceso_wf' : rec.data.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}

	},
	
	checkPresupuesto:function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
										'Estado del Presupuesto',
										{
											modal:true,
											width:700,
											height:450
										}, {
											data:{
											   nro_tramite: rec.data.nro_tramite								  
											}}, this.idContenedor,'ChkPresupuesto',
										{
											config:[{
													  event:'onclose',
													  delegate: this.onCloseChk												  
													}],
											
											scope:this
										 });  
			   
	 },
	  
	roundTwo: function(can){
    	 return  Math.round(can*Math.pow(10,2))/Math.pow(10,2);
    },
	
	onButtonNew:function(){
        Phx.vista.CuentaDoc.superclass.onButtonNew.call(this);
        this.Cmp.fecha.setValue(new Date());
        this.Cmp.fecha.fireEvent('change');
    }
});
</script>		