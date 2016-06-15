<?php
/**
 *@package pXP
 *@file gen-SistemaDist.php
 *@author  (rac)
 *@date 20-09-2011 10:22:05
 *@description Archivo con la interfaz de usuario que permite
 *dar el visto a solicitudes de compra
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.CuentaDocReg = {
		bedit : true,
		bnew : true,
		bsave : false,
		bdel : true,
		require : '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
		requireclase : 'Phx.vista.CuentaDoc',
		title : 'Cuenta Documentada',
		nombreVista : 'CuentaDocReg',
		swEstado : 'borrador',
		gruposBarraTareas : [{
			name : 'borrador',
			title : '<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>',
			grupo : 0,
			height : 0
		}, {
			name : 'validacion',
			title : '<H1 align="center"><i class="fa fa-eye"></i> En Validación</h1>',
			grupo : 1,
			height : 0
		}, {
			name : 'entregados',
			title : '<H1 align="center"><i class="fa fa-eye"></i> Entregados</h1>',
			grupo : 2,
			height : 0
		}, {
			name : 'finalizados',
			title : '<H1 align="center"><i class="fa fa-file-o"></i> Finalizados</h1>',
			grupo : 3,
			height : 0
		}],

		beditGroups : [0],
		bactGroups : [0, 1, 2, 3],
		btestGroups : [0],
		bexcelGroups : [0, 1, 2, 3],
		
		
		constructor : function(config) {
			var me = this;
			this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
				    var  saldo = me.roundTwo(value) - me.roundTwo(record.data.importe_documentos) - me.roundTwo(record.data.importe_depositos);
				    saldo = me.roundTwo(saldo);
					if (record.data.estado == 'contabilizado') {
						return String.format("<b><font color = 'red'>Entregado: {0}</font></b><br>"+
											 "<b><font color = 'green' >En Facturas:{1}</font></b><br>"+
											 "<b><font color = 'green' >En Depositos:{2}</font></b><br>"+
											 "<b><font color = 'orange' >Retenciones de Ley:{3}</font></b><br>"+
											 "<b><font color = 'blue' >Saldo:{4}</font></b>", value, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones, saldo );
					} 
					else {
						return String.format('<font>Solicitado: {0}</font>', value);
					}

			};
			
			Phx.vista.CuentaDocReg.superclass.constructor.call(this, config);
			this.bloquearOrdenamientoGrid();

			this.iniciarEventos();

			this.store.baseParams = {
				estado : 'borrador',
				tipo_interfaz : this.nombreVista
			};
			//coloca filtros para acceso directo si existen
			if (config.filtro_directo) {
				this.store.baseParams.filtro_valor = config.filtro_directo.valor;
				this.store.baseParams.filtro_campo = config.filtro_directo.campo;
			}
			
			this.addButton('onBtnRepSol', {
				grupo : [0,1,2,3],
				text : 'Reporte Sol.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepSol,
				tooltip : '<b>Reporte de solicitud de fondos</b>'
		    });

			this.addButton('btnRendicion', {
				grupo : [2],
				text : 'Rendicion Efectivo',
				iconCls : 'bballot',
				disabled : false,
				handler : this.onBtnRendicion,
				tooltip : '<b>Rendición</b>'
			});
			
			this.addButton('onBtnRepRenCon', {
				grupo : [0,1,2,3],
				text : 'Rendición Consolidada',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepRenCon,
				tooltip : '<b>Reporte de redición consolidada</b>'
		    });
			
			

			this.init();
			this.load({
				params : {
					start : 0,
					limit : this.tam_pag
				}
			});
			this.iniciarEventos();
			this.obtenerVariableGlobal();
			this.finCons = true;
		},

		getParametrosFiltro : function() {
			this.store.baseParams.estado = this.swEstado;
			this.store.baseParams.tipo_interfaz = this.nombreVista;
		},

		actualizarSegunTab : function(name, indice) {
			this.swEstado = name;
			this.getParametrosFiltro();
			if (this.finCons) {
				this.load({
					params : {
						start : 0,
						limit : this.tam_pag
					}
				});
			}

		},

		preparaMenu : function(n) {
			var data = this.getSelectedData();
			var tb = this.tbar;
			Phx.vista.CuentaDocReg.superclass.preparaMenu.call(this, n);
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
				if(data.dias_para_rendir >= 0){
					this.getBoton('btnRendicion').enable();
				}
				else{
					this.getBoton('btnRendicion').disable();
				}
				
			}
			
			this.getBoton('btnChequeoDocumentosWf').setDisabled(false);
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btnObs').enable();
            this.getBoton('onBtnRepSol').enable();
            this.getBoton('onBtnRepRenCon').enable();  
            

			return tb
		},

		liberaMenu : function() {
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
		iniciarEventos : function() {

			this.Cmp.fecha.on('change', function(f) {

				this.Cmp.id_funcionario.reset();
				this.Cmp.id_depto.reset();
				this.Cmp.tipo_pago.reset();
				this.Cmp.id_funcionario.enable();
				this.Cmp.id_funcionario.store.baseParams.fecha = this.Cmp.fecha.getValue().dateFormat(this.Cmp.fecha.format);
				this.Cmp.id_funcionario.modificado = true;

				this.Cmp.id_funcionario.store.load({
					params : {
						start : 0,
						limit : this.tam_pag
					},
					callback : function(r) {
						Phx.CP.loadingHide();
						if (r.length == 1) {
							this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
							this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
						}

					},
					scope : this
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
					params : {
						start : 0,
						limit : this.tam_pag
					},
					callback : function(r) {
						if (r.length == 1) {
							this.Cmp.id_depto.setValue(r[0].data.id_depto);
						}

					},
					scope : this
				});

			}, this);

			this.Cmp.tipo_pago.on('select', function(combo, rec, index) {
				console.log('record', rec.data.variable)

				if (rec.data.variable == 'cheque') {

					this.mostrarComponente(this.Cmp.nombre_cheque);
					this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
					this.Cmp.nombre_cheque.setValue(this.Cmp.id_funcionario.getRawValue());

				}
				if (rec.data.variable == 'transferencia') {

					this.ocultarComponente(this.Cmp.nombre_cheque);
					this.mostrarComponente(this.Cmp.id_funcionario_cuenta_bancaria);

					this.Cmp.id_funcionario_cuenta_bancaria.store.baseParams.id_funcionario = this.Cmp.id_funcionario.getValue();
					this.Cmp.id_funcionario_cuenta_bancaria.store.baseParams.fecha = this.Cmp.fecha.getValue().dateFormat(this.Cmp.fecha.format);
					this.Cmp.id_funcionario_cuenta_bancaria.modificado = true;

					this.Cmp.id_funcionario_cuenta_bancaria.store.load({
						params : {
							start : 0,
							limit : this.tam_pag
						},
						callback : function(r) {
							Phx.CP.loadingHide();
							if (r.length == 1) {
								this.Cmp.id_funcionario_cuenta_bancaria.setValue(r[0].data.id_funcionario_cuenta_bancaria);
								this.Cmp.id_funcionario_cuenta_bancaria.fireEvent('select', this.Cmp.id_funcionario_cuenta_bancaria, r[0]);
							}

						},
						scope : this
					});

				}

			}, this)

		},
		onButtonEdit : function() {
			Phx.vista.CuentaDoc.superclass.onButtonEdit.call(this);
			if (this.Cmp.tipo_pago.getValue() == 'cheque') {
				this.mostrarComponente(this.Cmp.nombre_cheque);
				this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
			} else {
				this.ocultarComponente(this.Cmp.nombre_cheque);
				this.mostrarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
			}

		},

		onButtonNew : function() {
			Phx.vista.CuentaDocReg.superclass.onButtonNew.call(this);
			this.Cmp.id_funcionario.enable();
			this.ocultarComponente(this.Cmp.nombre_cheque);
			this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
			this.Cmp.fecha.setValue(new Date());
            this.Cmp.fecha.fireEvent('change');

		},
		
		onButtonEdit : function() {
			Phx.vista.CuentaDocReg.superclass.onButtonEdit.call(this);
			this.Cmp.id_funcionario.disable();
			
			if (this.Cmp.tipo_pago.getValue() == 'cheque') {
					this.mostrarComponente(this.Cmp.nombre_cheque);
					this.ocultarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
			}
			if (this.Cmp.tipo_pago.getValue() == 'transferencia') {
					this.ocultarComponente(this.Cmp.nombre_cheque);
					this.mostrarComponente(this.Cmp.id_funcionario_cuenta_bancaria);
            }
			

		},

		onBtnRendicion : function() {
			var rec = this.sm.getSelected();
			Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocRen.php', 'Rendicion', {
				modal : true,
				width : '95%',
				height : '95%',
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
				                            fields :['variable','valor'],
				                            data :  [['cheque','cheque'],['transferencia','transferencia']]});
								}
								if(reg.ROOT.datos.valor == 'cheque'){
									this.Cmp.tipo_pago.store = new Ext.data.ArrayStore({fields :['variable','valor'],data :  [['cheque','cheque']]});
								}
								if(reg.ROOT.datos.valor == 'transferencia'){
									this.Cmp.tipo_pago.store = new Ext.data.ArrayStore({ fields :['variable','valor'],data :  [['transferencia','transferencia']]});
								}
							}
						},
						failure: this.conexionFailure,
						timeout: this.timeout,
						scope:this
					});
		
		}
		
		
}; 
</script>
