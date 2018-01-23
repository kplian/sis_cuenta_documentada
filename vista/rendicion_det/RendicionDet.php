<?php
/**
 *@package pXP
 *@file gen-RendicionDet.php
 *@author  (admin)
 *@date 17-05-2016 18:01:48
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.RendicionDet = Ext.extend(Phx.gridInterfaz, {
		mostrarFuncionario: true,
		tipoDoc : 'compra',
		bsave : false,
		constructor : function(config) {
			this.maestro = config.maestro;
			//llama al constructor de la clase padre
			Phx.vista.RendicionDet.superclass.constructor.call(this, config);
			this.init();
			
			this.addButton('btnShowDoc',
            {
                text: 'Ver Detalle',
                iconCls: 'brenew',
                disabled: true,
                handler: this.showDoc,
                tooltip: 'Muestra el detalle del documento'
            });
        
        
			this.bloquearMenus();
		},

		Atributos : [{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_doc_compra_venta'
			},
			type : 'Field',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'tipo'
			},
			type : 'Field',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_descuento_ley',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_iva_cf',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_iva_df',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_it',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'porc_ice',
				allowDecimals : true,
				decimalPrecision : 10
			},
			type : 'NumberField',
			form : true
		}, {
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_depto_conta'
			},
			type : 'Field',
			form : true
		},
		{
			config : {
				name : 'desc_plantilla',
				fieldLabel : 'Tipo Documento',
				allowBlank : false,
				emptyText : 'Elija una plantilla...',
				gwidth : 250
			},
			type : 'Field',
			filters : {
				pfiltro : 'pla.desc_plantilla',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'desc_moneda',
				origen : 'MONEDA',
				allowBlank : false,
				fieldLabel : 'Moneda',
				gdisplayField : 'desc_moneda', //mapea al store del grid
				gwidth : 70,
				width : 250,
			},
			type : 'Field',
			id_grupo : 0,
			filters : {
				pfiltro : 'incbte.desc_moneda',
				type : 'string'
			},
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha',
				fieldLabel : 'Fecha',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				readOnly : true,
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'dcv.fecha',
				type : 'date'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'nro_autorizacion',
				fieldLabel : 'Autorización',
				gwidth : 250,

			},
			type : 'Field',
			filters : {
				pfiltro : 'dcv.nro_autorizacion',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'nit',
				fieldLabel : 'NIT',
				qtip : 'Número de indentificación del proveedor',
				allowBlank : false,
				emptyText : 'nit ...',
				gwidth : 250
			},
			type : 'ComboBox',
			filters : {
				pfiltro : 'dcv.nit',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'razon_social',
				fieldLabel : 'Razón Social',
				gwidth : 100,
				maxLength : 180
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.razon_social',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'nro_documento',
				fieldLabel : 'Nro Doc',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				maxLength : 100
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.nro_documento',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'nro_dui',
				fieldLabel : 'DUI',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 16,
				minLength : 16
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.nro_dui',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'codigo_control',
				fieldLabel : 'Código de Control',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 200
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.codigo_control',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			form : false
		}, {
			config : {
				name : 'obs',
				fieldLabel : 'Obs',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 400
			},
			type : 'TextArea',
			filters : {
				pfiltro : 'dcv.obs',
				type : 'string'
			},
			id_grupo : 0,
			grid : true,
			bottom_filter : true,
			form : false
		}, {
			config : {
				name : 'importe_doc',
				fieldLabel : 'Monto',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				maxLength : 1179650,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_doc',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_descuento',
				fieldLabel : 'Descuento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_descuento',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_neto',
				fieldLabel : 'Neto',
				allowBlank : false,
				anchor : '80%',
				gwidth : 100,
				maxLength : 1179650,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_doc',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_excento',
				fieldLabel : 'Excento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_excento',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_pendiente',
				fieldLabel : 'Cuenta Pendiente',
				qtip : 'Usualmente una cuenta pendiente de  cobrar o  pagar (dependiendo si es compra o venta), posterior a la emisión del documento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_pendiente',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_anticipo',
				fieldLabel : 'Anticipo',
				qtip : 'Importe pagado por anticipado al documento',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_anticipo',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_retgar',
				fieldLabel : 'Ret. Garantia',
				qtip : 'Importe retenido por garantia',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_retgar',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_descuento_ley',
				fieldLabel : 'Descuentos de Ley',
				allowBlank : true,
				readOnly : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_descuento_ley',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_ice',
				fieldLabel : 'ICE',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_ice',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_iva',
				fieldLabel : 'IVA',
				allowBlank : true,
				readOnly : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_iva',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_it',
				fieldLabel : 'IT',
				allowBlank : true,
				anchor : '80%',
				readOnly : true,
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_it',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'importe_pago_liquido',
				fieldLabel : 'Liquido Pagado',
				allowBlank : true,
				readOnly : true,
				anchor : '80%',
				gwidth : 100,
				renderer : function(value, p, record) {
					if (record.data.tipo_reg != 'summary') {
						return String.format('{0}', value);
					} else {
						return String.format('<b><font size=2 >{0}</font><b>', value);
					}

				}
			},
			type : 'NumberField',
			filters : {
				pfiltro : 'dcv.importe_pago_liquido',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'estado',
				fieldLabel : 'Estado',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 30
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.estado',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'estado_reg',
				fieldLabel : 'Estado Reg.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 10
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.estado_reg',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'usr_reg',
				fieldLabel : 'Creado por',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'usu1.cuenta',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha_reg',
				fieldLabel : 'Fecha creación',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'dcv.fecha_reg',
				type : 'date'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'id_usuario_ai',
				fieldLabel : '',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'dcv.id_usuario_ai',
				type : 'numeric'
			},
			id_grupo : 1,
			grid : false,
			form : false
		}, {
			config : {
				name : 'usr_mod',
				fieldLabel : 'Modificado por',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 4
			},
			type : 'Field',
			filters : {
				pfiltro : 'usu2.cuenta',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'fecha_mod',
				fieldLabel : 'Fecha Modif.',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				format : 'd/m/Y',
				renderer : function(value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type : 'DateField',
			filters : {
				pfiltro : 'dcv.fecha_mod',
				type : 'date'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}, {
			config : {
				name : 'usuario_ai',
				fieldLabel : 'Funcionaro AI',
				allowBlank : true,
				anchor : '80%',
				gwidth : 100,
				maxLength : 300
			},
			type : 'TextField',
			filters : {
				pfiltro : 'dcv.usuario_ai',
				type : 'string'
			},
			id_grupo : 1,
			grid : true,
			form : false
		}],

		tam_pag : 50,
		title : 'Detalle de Rendición',
		ActSave : '../../sis_cuenta_documentada/control/RendicionDet/insertarRendicionDet',
		ActDel : '../../sis_cuenta_documentada/control/RendicionDet/eliminarRendicionDet',
		ActList : '../../sis_cuenta_documentada/control/RendicionDet/listarRendicionDet',
		id_store : 'id_rendicion_det',
		fields : [{name : 'id_rendicion_det',type : 'numeric'}, 
		          {name : 'id_cuenta_doc',type : 'numeric'}, 
		          {name : 'id_cuenta_doc_rendicion',type : 'numeric'}, 
		          {name : 'id_doc_compra_venta',type : 'string'}, 
		          {name : 'revisado',type : 'string'}, 
		          {name : 'movil',type : 'string'}, 
		          {name : 'tipo',type : 'string'}, 
		          {name : 'importe_excento',type : 'numeric'}, 
		          {name : 'id_plantilla',type : 'numeric'}, 
		          {name : 'fecha',type : 'date',dateFormat : 'Y-m-d'}, 
		          {name : 'nro_documento',type : 'string'}, 
		          {name : 'nit',type : 'string'}, 
		          {name : 'importe_ice',type : 'numeric'}, 
		          {name : 'nro_autorizacion',type : 'string'}, 
		          {name : 'importe_iva',type : 'numeric'}, 
		          {name : 'importe_descuento',type : 'numeric'}, 
		          {name : 'importe_doc',type : 'numeric'}, 
		          {name : 'sw_contabilizar',type : 'string'}, 
		          {name : 'tabla_origen',type : 'string'}, 
		          {name : 'estado',type : 'string'}, 
		          {name : 'id_depto_conta',type : 'numeric'}, 
		          {name : 'id_origen',type : 'numeric'}, 
		          {name : 'obs',type : 'string'}, 
		          {name : 'estado_reg',type : 'string'}, 
		          {name : 'codigo_control',type : 'string'}, 
		          {name : 'importe_it',type : 'numeric'}, 
		          {name : 'razon_social',type : 'string'}, 
		          {name : 'id_usuario_ai',type : 'numeric'}, 
		          {name : 'id_usuario_reg',type : 'numeric'}, 
		          {name : 'fecha_reg',type : 'date',dateFormat : 'Y-m-d H:i:s.u'}, 
		          {name : 'usuario_ai',type : 'string'}, 
				  {name : 'id_usuario_mod',type : 'numeric'}, 
				  {name : 'fecha_mod',type : 'date',dateFormat : 'Y-m-d H:i:s.u'}, 
				  {name : 'usr_reg',type : 'string'}, 
				  {name : 'usr_mod',type : 'string'}, 
				  {name : 'importe_pendiente',type : 'numeric'}, 
				  {name : 'importe_anticipo',type : 'numeric'}, 
				  {name : 'importe_retgar',type : 'numeric'}, 
				  {name : 'importe_neto',type : 'numeric'}, 
		          'tipo_reg','desc_depto', 'desc_plantilla', 'importe_descuento_ley', 'importe_pago_liquido', 'nro_dui', 'id_moneda', 'desc_moneda', 'id_auxiliar', 'codigo_auxiliar', 'nombre_auxiliar'],
		
	sortInfo : {
			field : 'id_rendicion_det',
			direction : 'ASC'
	},
	

	onButtonNew : function() {
			this.abrirFormulario('new',undefined, false)
	},

	onButtonEdit : function() {
			this.abrirFormulario('edit', this.sm.getSelected(), false)
	}, 
		
	
	
	successRep:function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
            this.reload();
            if(reg.ROOT.datos.observaciones){
               alert(reg.ROOT.datos.observaciones)
            }
           
        }else{
            alert('Ocurrió un error durante el proceso')
        }
	},
	
	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_cuenta_doc_rendicion: this.maestro.id_cuenta_doc};
		this.load({params:{start:0, limit:50}});
	},
		
		
	 abrirFormulario : function(tipo, record, readOnly) {
			//abrir formulario de solicitud
			var me = this,_autoriz,_plantilla=[];
			console.log('codigo ... ', me.maestro.codigo_tipo_cuenta_doc);

			//Define el filtro para los conceptos de gasto
			_autoriz=me.maestro.codigo_tipo_cuenta_doc=='RVI'?'viatico':'fondo_avance'

			//Obtiene la plantilla de prorrateo si corresponde
			if(me.maestro.codigo_tipo_cuenta_doc=='RVI'){
				Phx.CP.loadingShow();

	            Ext.Ajax.request({
	                url:'../../sis_cuenta_documentada/control/CuentaDocProrrateo/listarCuentaDocProrrateoRes',
	                params: {
						id_cuenta_doc: me.maestro.id_cuenta_doc
	                },
	                success: function(resp){
	                	Phx.CP.loadingHide();
	                	var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
	                	_plantilla = reg.datos;
	                	//Abre la interfaz de registro documentos
				        this.abrirFormularioDocumentos(tipo,record,readOnly,_plantilla,_autoriz);
	                },
	                failure: this.conexionFailure,
	                timeout: this.timeout,
	                scope: this
	            });
			} else {
				//Abre la interfaz de registro documentos
				this.abrirFormularioDocumentos(tipo,record,readOnly,_plantilla,_autoriz);
			}
			
	},
		
	
   showDoc:  function() {
        this.abrirFormulario('edit', this.sm.getSelected(), true);
   },

	abrirFormularioDocumentos: function(tipo,record,readOnly,plantilla,autoriz){
		var me = this;

		/*plantillaProrrateo: [{id_centro_costo: 97, desc_cc:'11500000 -  Amortización Inmovilizado sujeto remuner German Rocha 911   2017', factor: 0.60}, 
				                    {id_centro_costo:98 , desc_cc:'P112 - 97, xxxx ',factor: 0.40}] //07/12/2017 RAC , se adciona parametro de plantilla para prorrateo de gastos */

		me.objSolForm = Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/rendicion_det/FormRendicionCD.php', 'Formulario de rendicion', {
				modal : true,
				width : '95%',
				height : '95%'
			}, {
				data: {
					objPadre : me,
					tipoDoc : me.tipoDoc,
					tipo_form : tipo,
					id_depto : me.maestro.id_depto_conta,
					id_cuenta_doc : me.maestro.id_cuenta_doc,
					datosOriginales : record,
					readOnly: readOnly
				},
				id_moneda_defecto : me.maestro.id_moneda,
				bsubmit: !readOnly,
				autorizacion: autoriz,
				plantillaProrrateo: plantilla
			}, this.idContenedor, 'FormRendicionCD'
		);
	}
		
})
</script>