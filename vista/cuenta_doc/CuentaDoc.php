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
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Trámite',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
				type:'TextField',
				bottom_filter:true,
				filters:{pfiltro:'cdoc.nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
			config:{
				name: 'motivo',
				qtip: 'Explique el objetivo del fondo solicitado',
				fieldLabel: 'Objetivo',
				allowBlank: false,
				anchor: '80%',
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
				fieldLabel: 'Lim Rend.',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
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
				name: 'desc_tipo_cuenta_doc',
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
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
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
   				fieldLabel:'Funcionario',
   				allowBlank:false,
                gwidth:200,
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
   			config:{
   				name: 'id_depto',
   				hiddenName: 'Depto',
   				url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
	   			origen: 'DEPTO',
	   			allowBlank: false,
	   			fieldLabel: 'Depto',
	   			gdisplayField: 'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
	   			width: 250,
   			    gwidth: 180,
	   			baseParams: { estado:'activo',codigo_subsistema:'TES',modulo:'OP'},//parametros adicionales que se le pasan al store
	      		renderer: function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
   			},
   			type: 'ComboRec',
   			id_grupo: 0,
   			filters: { pfiltro:'depto.nombre', type:'string'},
   		    grid: true,
   			form: true
       	},
		{
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                gdisplayField: 'desc_moneda',//mapea al store del grid
                gwidth: 50,
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
                anchor: '80%',
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
            config: {
                name: 'tipo_pago',
                fieldLabel: 'Forma de Pago',
                allowBlank: false,
                anchor: '70%',
                gwidth: 150,
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
				anchor: '80%',
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
				fieldLabel: 'Nro Correspondencia',
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
		}
		
	],
	
	rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obs WF:&nbsp;&nbsp;</b> {obs}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>'
	        )
    }),
    
    arrayDefaultColumHidden:['usr_reg','usr_mod','estado_reg','fecha_reg'],


	tam_pag:50,	
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
		{name:'usr_reg', type: 'string'},'sw_max_doc_rend',
		{name:'usr_mod', type: 'string'},'importe','obs','nro_correspondencia',
		'id_funcionario_cuenta_bancaria','sw_solicitud','importe_depositos',
		'desc_funcionario_cuenta_bancaria','desc_tipo_cuenta_doc','importe_retenciones',
		'desc_funcionario','desc_moneda','desc_depto','id_depto_conta','id_depto_lb','importe_documentos','dias_para_rendir'
	
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
     	   if(rec.data.estado == 'vbtesoreria' &&  rec.data.sw_solicitud == 'si' ){
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
										baseParams: {'tipo_interfaz':me.tipo_interfaz},
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
								    		this.Cmp.id_cuenta_bancaria.store.baseParams = {'tipo_interfaz':me.tipo_interfaz, par_filtro :'nro_cuenta', 'permiso':'fondos_avance', id_depto_lb : obj.Cmp.id_depto_lb.getValue()};
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
	                tooltip: '<b>Mues un reporte gantt en formato de imagen</b>',
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
    
    onOpenObs:function() {
            var rec=this.sm.getSelected();            
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
    },		
	onBtnRepSol : function() {
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteSolicitudFondos',
					params : {
						'id_proceso_wf' : data.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}
	},
	
	onBtnRepRenCon : function() {
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteRendicionCon',
					params : {
						'id_proceso_wf' : data.id_proceso_wf
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
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteRendicionFondos',
					params : {
						'id_proceso_wf' : data.id_proceso_wf
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
	 
	
	
	onButtonNew:function(){
        Phx.vista.CuentaDoc.superclass.onButtonNew.call(this);
        this.Cmp.fecha.setValue(new Date());
        this.Cmp.fecha.fireEvent('change');
    }
});
</script>		