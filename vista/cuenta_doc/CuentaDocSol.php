<?php
/**
 *@package pXP
 *@file CuentaDocSol.php
 *@author  RCM
 *@date 04/09/2017
 *@description 
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocSol = {
	bedit: true,
	bnew: true,
	bsave: false,
	bdel: true,
	require: '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
	requireclase: 'Phx.vista.CuentaDoc',
	title: 'Cuenta Documentada',
	nombreVista: 'CuentaDocSol',
	swEstado: 'borrador',
	gruposBarraTareas: [{
		name: 'borrador',
		title: '<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>',
		grupo: 0,
		height: 0
	}, {
		name: 'validacion',
		title: '<H1 align="center"><i class="fa fa-eye"></i> En Validación</h1>',
		grupo: 1,
		height: 0
	}, {
		name: 'entregados',
		title: '<H1 align="center"><i class="fa fa-eye"></i> Entregados</h1>',
		grupo: 2,
		height: 0
	}, {
		name: 'finalizados',
		title: '<H1 align="center"><i class="fa fa-file-o"></i> Finalizados</h1>',
		grupo: 3,
		height: 0
	}],
	beditGroups: [0],
	bactGroups:  [0, 1, 2, 3],
	btestGroups: [0],
	bexcelGroups: [0, 1, 2, 3],		
	constructor: function(config) {
		var me = this;
		this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {
			if (record.data.estado == 'contabilizado') {
				var  saldo = me.roundTwo(value) - me.roundTwo(record.data.importe_documentos) - me.roundTwo(record.data.importe_depositos) + me.roundTwo(record.data.importe_retenciones);
		        saldo = me.roundTwo(saldo);
				return String.format("<b><font color = 'red'>Entregado: {0}</font></b><br>"+
									 "<b><font color = 'green' >En Documentos:{1}</font></b><br>"+
									 "<b><font color = 'green' >En Depositos:{2}</font></b><br>"+
									 "<b><font color = 'orange' >Retenciones de Ley:{3}</font></b><br>"+
									 "<b><font color = 'blue' >Saldo:{4}</font></b>", value, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones, saldo );
			} 
			else if (record.data.estado == 'finalizado') {
				var  saldo = me.roundTwo(value) - me.roundTwo(record.data.importe_total_rendido);
		        saldo = me.roundTwo(saldo);
				return String.format("<b><font color = 'red'>Solicitado: {0}</font></b><br>"+
									     "<b><font color = 'orange' >Total Rendido: {1}</font></b><br>"+
									     "<b><font color = 'blue' >Saldo: {2}</font></b>", value, record.data.importe_total_rendido, saldo );
			
			}
			else {
				return String.format('<font>Solicitado: {0}</font>', value);
			}
		};
		
		Phx.vista.CuentaDocSol.superclass.constructor.call(this, config);
		this.bloquearOrdenamientoGrid();
		this.iniciarEventos();
		this.store.baseParams = {
			estado: 'borrador',
			tipo_interfaz: this.nombreVista
		};
		//coloca filtros para acceso directo si existen
		if (config.filtro_directo) {
			this.store.baseParams.filtro_valor = config.filtro_directo.valor;
			this.store.baseParams.filtro_campo = config.filtro_directo.campo;
		}
		
		this.addButton('onBtnRepSol', {
			grupo: [0,1,2,3],
			text: 'Reporte Sol.',
			iconCls: 'bprint',
			disabled: false,
			handler: this.onBtnRepSol,
			tooltip: '<b>Reporte de solicitud de fondos</b>'
	    });

		this.addButton('btnRendicion', {
			grupo: [2,3],
			text: 'Rendicion Efectivo',
			iconCls: 'bballot',
			disabled: false,
			handler: this.onBtnRendicion,
			tooltip: '<b>Rendición</b>'
		});
		
		this.addButton('onBtnRepRenCon', {
			grupo: [0,1,2,3],
			text: 'Rendición Consolidada',
			iconCls: 'bprint',
			disabled: false,
			handler: this.onBtnRepRenCon,
			tooltip: '<b>Reporte de rendición consolidada</b>'
	    });			

		this.init();
		this.load({
			params: {
				start: 0, 
				limit: this.tam_pag
			}
		});
		this.iniciarEventos();
		this.obtenerVariableGlobal();
		this.finCons = true;

		//Se desactiva el tab de Itinerario por defecto
		this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(true);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(true);

		//Filtro de fecha para el centro de costo
		this.Cmp.fecha.on('select',function(cmp,val){
			var time = new Date(val);
			Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{fecha: time.format("d/m/Y")});
			this.Cmp.id_centro_costo.modificado=true;
		},this);
	},
	EnableSelect: function(){
		Phx.vista.CuentaDocSol.superclass.EnableSelect.call(this);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(true);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(true);
		var data = this.getSelectedData();
		if(data.codigo_tipo_cuenta_doc=='SOLVIA'){
			this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(false);
			this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(false);
		}
	},

	getParametrosFiltro: function() {
		this.store.baseParams.estado = this.swEstado;
		this.store.baseParams.tipo_interfaz = this.nombreVista;
	},

	actualizarSegunTab: function(name, indice) {
		this.swEstado = name;
		this.getParametrosFiltro();
		if (this.finCons) {
			this.load({
				params: {
					start: 0,
					limit: this.tam_pag
				}
			});
		}
	},

	preparaMenu: function(n) {
		var data = this.getSelectedData();
		var tb = this.tbar;
		Phx.vista.CuentaDocSol.superclass.preparaMenu.call(this, n);
		this.getBoton('chkpresupuesto').enable(); 
		if (data.estado == 'borrador') {
			this.getBoton('ant_estado').disable();
			this.getBoton('sig_estado').enable();
		} else {
			this.getBoton('ant_estado').disable();
			this.getBoton('sig_estado').disable();
		}

		if (data.estado == 'contabiizado') {
			this.getBoton('btnRendicion').disable();
		} else {
			this.getBoton('btnRendicion').enable();
		}
		this.getBoton('btnChequeoDocumentosWf').setDisabled(false);
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('btnObs').enable();
        this.getBoton('onBtnRepSol').enable();
        this.getBoton('onBtnRepRenCon').enable(); 
		return tb
	},

	liberaMenu: function() {
		var tb = Phx.vista.CuentaDoc.superclass.liberaMenu.call(this);
		if (tb) {
			this.getBoton('sig_estado').disable();
			this.getBoton('ant_estado').disable();
			this.getBoton('btnRendicion').disable();
			this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('onBtnRepSol').disable();
            this.getBoton('onBtnRepRenCon').disable();                  
		}
		return tb
	},
	iniciarEventos: function() {
		this.Cmp.fecha.on('change', function(f) {
			this.Cmp.id_funcionario.reset();
			this.Cmp.id_depto.reset();
			this.Cmp.tipo_pago.reset();
			this.Cmp.id_funcionario.enable();
			this.Cmp.id_funcionario.store.baseParams.fecha = this.Cmp.fecha.getValue().dateFormat(this.Cmp.fecha.format);
			this.Cmp.id_funcionario.modificado = true;
			this.Cmp.id_funcionario.store.load({
				params: {
					start: 0,
					limit: this.tam_pag
				},
				callback: function(r) {
					Phx.CP.loadingHide();
					if (r.length == 1) {
						this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
						this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
					}
				},
				scope: this
			});

		}, this);

		this.Cmp.id_funcionario.on('select', function(combo, record, index) {
			if (!record.data.id_lugar) {
				alert('El funcionario no tiene oficina definida');
				return;
			}
			this.Cmp.id_depto.reset();
			this.Cmp.tipo_pago.reset();
			this.Cmp.id_depto.store.baseParams.id_lugar = record.data.id_lugar;
			this.Cmp.id_depto.modificado = true;
			this.Cmp.id_depto.enable();
			this.Cmp.id_depto.store.load({
				params: {
					start: 0,
					limit: this.tam_pag
				},
				callback: function(r) {
					if (r.length == 1) {
						this.Cmp.id_depto.setValue(r[0].data.id_depto);
					}
				},
				scope: this
			});

		}, this);

		this.Cmp.id_tipo_cuenta_doc.on('select', function(combo, rec, index) {
			if (rec.data.codigo == 'SOLFONCHAR') {
				this.Cmp.id_moneda.store.baseParams.filtrar_base = 'no';
				this.Cmp.id_moneda.store.baseParams.id_moneda = 2;
			} else{
				this.Cmp.id_moneda.store.baseParams.filtrar_base = 'si';
				this.Cmp.id_moneda.store.baseParams.id_moneda = '';
			}
			this.Cmp.id_moneda.modificado = true;
			this.Cmp.id_moneda.reset();
			//Ocultar/mostrar componentes en función del tipo de cuenta documentada
			this.ocultarMostrarComp(rec.data.codigo,true);
		}, this);

		this.Cmp.tipo_pago.on('select', function(combo, rec, index) {
			console.log('record', rec.data.variable);
			if (rec.data.variable == 'cheque') {
				this.mostrarComponente(this.Cmp.nombre_cheque);
				this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
				this.ocultarComponente(this.Cmp.id_caja);
				this.Cmp.nombre_cheque.setValue(this.Cmp.id_funcionario.getRawValue());
				this.Cmp.id_caja.allowBlank=true;

			} else if (rec.data.variable == 'transferencia') {
				this.ocultarComponente(this.Cmp.nombre_cheque);
				this.mostrarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
				this.ocultarComponente(this.Cmp.id_caja);
				this.Cmp.id_funcionario_cuenta_bancaria.store.baseParams.id_funcionario = this.Cmp.id_funcionario.getValue();
				this.Cmp.id_funcionario_cuenta_bancaria.store.baseParams.fecha = this.Cmp.fecha.getValue().dateFormat(this.Cmp.fecha.format);
				this.Cmp.id_funcionario_cuenta_bancaria.modificado = true;
				this.Cmp.id_caja.allowBlank = true;
				this.Cmp.id_funcionario_cuenta_bancaria.store.load({
					params: {
						start: 0,
						limit: this.tam_pag
					},
					callback: function(r) {
						Phx.CP.loadingHide();
						if (r.length == 1) {
							this.Cmp.id_funcionario_cuenta_bancaria.setValue(r[0].data.id_funcionario_cuenta_bancaria);
							this.Cmp.id_funcionario_cuenta_bancaria.fireEvent('select', this.Cmp.id_funcionario_cuenta_bancaria, r[0]);
						}
					},
					scope: this
				});
			} else if(rec.data.variable=='caja'){
				this.ocultarComponente(this.Cmp.nombre_cheque);
				this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
				this.mostrarComponente(this.Cmp.id_caja);

				this.Cmp.id_caja.allowBlank = false;

			}
		}, this);

	},
	onButtonNew: function() {
		Phx.vista.CuentaDocSol.superclass.onButtonNew.call(this);
		this.Cmp.id_funcionario.enable();
		this.ocultarComponente(this.Cmp.nombre_cheque);
		this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
		this.ocultarComponente(this.Cmp.id_caja);
		this.Cmp.id_caja.allowBlank = true;
		this.Cmp.fecha.setValue(new Date());
        this.Cmp.fecha.fireEvent('change');
	},
	onButtonEdit: function() {
		Phx.vista.CuentaDocSol.superclass.onButtonEdit.call(this);
		this.Cmp.id_funcionario.disable();
		this.Cmp.id_depto.disable();			
		if (this.Cmp.tipo_pago.getValue() == 'cheque') {
				this.mostrarComponente(this.Cmp.nombre_cheque);
				this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
				this.ocultarComponente(this.Cmp.id_caja);
				this.Cmp.id_caja.allowBlank = true;
		} else if (this.Cmp.tipo_pago.getValue() == 'transferencia') {
				this.ocultarComponente(this.Cmp.nombre_cheque);
				this.mostrarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
				this.ocultarComponente(this.Cmp.id_caja);
				this.Cmp.id_caja.allowBlank = true;
        } else if (this.Cmp.tipo_pago.getValue() == 'caja') {
				this.ocultarComponente(this.Cmp.nombre_cheque);
				this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
				this.mostrarComponente(this.Cmp.id_caja);
				this.Cmp.id_caja.allowBlank = false;
        }

        //Oculta muestra componentes
		this.ocultarMostrarComp(this.Cmp.codigo_tipo_cuenta_doc.getValue());
	},

	onBtnRendicion: function() {
		var rec = this.sm.getSelected();
		Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocRen.php', 'Rendicion', {
			modal: true,
			width: '95%',
			height: '95%',
		}, rec.data, this.idContenedor, 'CuentaDocRen');
	},
	
	obtenerVariableGlobal: function(){
			//Verifica que la fecha y la moneda hayan sido elegidos
			Phx.CP.loadingShow();
			Ext.Ajax.request({
					url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
					params:{
						codigo: 'cd_tipo_pago'  
					},
					success: function(resp){
						Phx.CP.loadingHide();
						var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
						
						if (reg.ROOT.error) {
							Ext.Msg.alert('Error','Error a recuperar la variable global')
						} else {
							if(reg.ROOT.datos.valor == 'todos'){
								this.Cmp.tipo_pago.store = new Ext.data.ArrayStore({
			                            fields:['variable','valor'],
			                            data:  [['cheque','cheque'],['transferencia','transferencia']]});
							}
							else if(reg.ROOT.datos.valor == 'cheque'){
								this.Cmp.tipo_pago.store = new Ext.data.ArrayStore({fields:['variable','valor'],data:  [['cheque','cheque']]});
							}
							else if(reg.ROOT.datos.valor == 'transferencia'){
								this.Cmp.tipo_pago.store = new Ext.data.ArrayStore({ fields:['variable','valor'],data:  [['transferencia','transferencia']]});
							}
							else if(reg.ROOT.datos.valor == 'cheque,caja'){
								this.Cmp.tipo_pago.store = new Ext.data.ArrayStore({
									fields:['variable','valor'],
									data:  [['caja','caja'],['cheque','cheque']]
								});
							}
						}
					},
					failure: this.conexionFailure,
					timeout: this.timeout,
					scope:this
				});		
	},
	ocultarMostrarComp: function(codigo,limpiar=false){
		//Oculta los componentes del viático por defecto
		this.Cmp.fecha_salida.hide();
		this.Cmp.hora_salida.hide();
		this.Cmp.fecha_llegada.hide();
		this.Cmp.hora_llegada.hide();
		this.Cmp.tipo_viaje.hide();
		this.Cmp.medio_transporte.hide();
		this.Cmp.importe.show();
		this.Cmp.cobertura.hide();
		this.Cmp.id_centro_costo.hide();

		this.Cmp.fecha_salida.allowBlank = true;
		this.Cmp.hora_salida.allowBlank = true;
		this.Cmp.fecha_llegada.allowBlank = true;
		this.Cmp.hora_llegada.allowBlank = true;
		this.Cmp.tipo_viaje.allowBlank = true;
		this.Cmp.medio_transporte.allowBlank = true;
		this.Cmp.importe.allowBlank = false;
		this.Cmp.cobertura.allowBlank = true;
		this.Cmp.id_centro_costo.allowBlank = true;

		this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(true);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(true);

		if(limpiar){
			this.Cmp.fecha_salida.setValue('');
			this.Cmp.fecha_llegada.setValue('');
			this.Cmp.tipo_viaje.setValue('');
			this.Cmp.medio_transporte.setValue('');
			this.Cmp.importe.setValue('');
			this.Cmp.cobertura.setValue('');
			this.Cmp.id_centro_costo.setValue('');
		}

		if(codigo=='SOLVIA') {
			this.Cmp.fecha_salida.show();
			this.Cmp.fecha_llegada.show();
			this.Cmp.tipo_viaje.show();
			this.Cmp.medio_transporte.show();
			this.Cmp.importe.hide();
			this.Cmp.cobertura.show();
			this.Cmp.id_centro_costo.hide();

			this.Cmp.fecha_salida.allowBlank = false;
			this.Cmp.fecha_llegada.allowBlank = false;
			this.Cmp.tipo_viaje.allowBlank = false;
			this.Cmp.medio_transporte.allowBlank = false;
			this.Cmp.importe.allowBlank = true;
			this.Cmp.cobertura.allowBlank = false;
			this.Cmp.id_centro_costo.allowBlank = true;

			this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(false);
			this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(false);
		}
	},
	tabsouth: [{
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_det/CuentaDocDet.php',
            title: 'Presupuesto',
            height: '40%',
            cls: 'CuentaDocDet'
        }, {
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_itinerario/CuentaDocItinerario.php',
            title: 'Itinerario',
            height: '40%',
            cls: 'CuentaDocItinerario'
        }, {
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_calculo/CuentaDocCalculo.php',
            title: 'Cálculo de Viáticos',
            height: '40%',
            cls: 'CuentaDocCalculo'
        }, {
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_prorrateo/CuentaDocProrrateo.php',
            title: 'Prorrateo',
            height: '40%',
            cls: 'CuentaDocProrrateo'
        }
    ]
}; 
</script>
