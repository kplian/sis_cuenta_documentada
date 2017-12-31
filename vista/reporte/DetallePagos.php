<?php
/**
 * @package pXP
 * @file gen-Competencia.php
 * @author  (admin)
 * @date 04-05-2017 19:30:13
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DetallePagos = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                Phx.vista.DetallePagos.superclass.constructor.call(this, config);
                this.init();                
		        console.log("ver detalle parametros ",config.desde);
		
	            this.load({params: {start: 0, limit: this.tam_pag, desde:config.desde,hasta:config.hasta, id_funcionario:config.id_funcionario,id_plantilla:config.id_plantilla}});
	        },
 

		    //
		    successSave:function(res) {
		    	Phx.CP.getPagina(this.idContenedorPadre).reload();
		     	this.close();
		    },
			//
            Atributos: [
		                 {
		                    //configuracion del componente
		                    config: {
		                        labelSeparator: '',
		                        inputType: 'hidden',
		                        name: 'id_doc_compra_venta'
		                    },
		                    type: 'Field',
		                    form: true
		                 },
					     {
					            config:{
					                name:'id_funcionario',
					                origen:'FUNCIONARIO',
					                tinit:true,
					                fieldLabel:'Funcionario',
					                allowBlank:true,
					                valueField: 'id_funcionario',
					                gdisplayField:'desc_funcionario1',//mapea al store del grid
					                //anchor: '80%',
					                renderer:function (value, p, record){return String.format('{0}', record.data['desc_funcionario1']);},
					                width : 250,
					            },
					            type:'ComboRec',
					            id_grupo:0,
					            filters:{
					                pfiltro:'FUN.desc_funcionario1::varchar',
					                type:'string'
					            },
					
					            grid:true,
					            form:true
					     },
			             {
			                config:{
			                    name: 'id_plantilla',
			                    fieldLabel: 'Tipo Documento',
			                    allowBlank: false,
			                    emptyText:'Elija una plantilla...',
			                    store:new Ext.data.JsonStore(
			                        {
			                            url: '../../sis_parametros/control/Plantilla/listarPlantilla',
			                            id: 'id_plantilla',
			                            root:'datos',
			                            sortInfo:{
			                                field:'desc_plantilla',
			                                direction:'ASC'
			                            },
			                            totalProperty:'total',
			                            fields: ['id_plantilla','nro_linea','desc_plantilla','tipo',
			                                'sw_tesoro', 'sw_compro','sw_monto_excento','sw_descuento',
			                                'sw_autorizacion','sw_codigo_control','tipo_plantilla','sw_nro_dui','sw_ic','tipo_excento','valor_excento','sw_qr','sw_nit','plantilla_qr',
			                                'sw_estacion','sw_punto_venta','sw_codigo_no_iata'],
			                            remoteSort: true,
			                            baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
			                        }),
			                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
			                    valueField: 'id_plantilla',
			                    hiddenValue: 'id_plantilla',
			                    displayField: 'desc_plantilla',
			                    gdisplayField:'desc_plantilla',
			                    listWidth:'280',
			                    forceSelection:true,
			                    typeAhead: false,
			                    triggerAction: 'all',
			                    lazyRender:true,
			                    mode:'remote',
			                    pageSize:20,
			                    queryDelay:500,
			                    minChars:2,
			                    width : 250,
			                },
			                type:'ComboBox',
			                id_grupo: 0,
			                form: true,
							grid:true,
				            form:true
			             },
				         {
								config:{
									name: 'fecha_compra_venta',
									fieldLabel: 'Fecha documento',
									allowBlank: true,
									format: 'd/m/Y',
									width : 250,
								},
								type: 'DateField',
								id_grupo: 0,
								form: true,
								grid:true,
					            form:true
						  },
						  {
								config:{
									name: 'fecha_pago_simple',
									fieldLabel: 'Fecha solicitud pago',
									allowBlank: true,
									format: 'd/m/Y',
									width : 250,
								},
								type: 'DateField',
								id_grupo: 0,
								form: true,
								grid:true,
					            form:true
						  },
			              {
			                    config: {
			                        name: 'importe_pago_liquido',
			                        fieldLabel: 'Importe pago líquido',
			                        allowBlank: false,
			                        anchor: '80%',
			                        gwidth: 100,
			                        maxLength: 50,
			                    },
			                    type: 'TextField',
			                    filters: {pfiltro: 'cv.importe_pago_liquido', type: 'string'},
			                    id_grupo: 0,
			                    grid: true,
			                    //egrid: true,
			                    form: true
			               },
			               {
			                    config: {
			                        name: 'importe_excento',
			                        fieldLabel: 'Importe externo',
			                        allowBlank: false,
			                        anchor: '80%',
			                        gwidth: 100,
			                        maxLength: 50,
			                    },
			                    type: 'TextField',
			                    filters: {pfiltro: 'cv.importe_excento', type: 'string'},
			                    id_grupo: 0,
			                    grid: true,
			                    //egrid: true,
			                    form: true
			               },
			               {
			                    config: {
			                        name: 'importe_excento',
			                        fieldLabel: 'Importe excento',
			                        allowBlank: false,
			                        anchor: '80%',
			                        gwidth: 100,
			                        maxLength: 50,
			                    },
			                    type: 'TextField',
			                    filters: {pfiltro: 'cv.importe_excento', type: 'string'},
			                    id_grupo: 0,
			                    grid: true,
			                    //egrid: true,
			                    form: true
			               },
			               {
			                    config: {
			                        name: 'sw_pgs',
			                        fieldLabel: 'Estado',
			                        allowBlank: false,
			                        anchor: '80%',
			                        gwidth: 100,
			                        maxLength: 50,
			                    },
			                    type: 'TextField',
			                    filters: {pfiltro: 'cv.importe_excento', type: 'string'},
			                    id_grupo: 0,
			                    grid: true,
			                    //egrid: true,
			                    form: true
			               },
            ],
            tam_pag: 50,
            title: 'Detalle pagos',
            //ActSave: '../../sis_formacion/control/Competencia/insertarCompetencia',
            //ActDel: '../../sis_formacion/control/Competencia/eliminarCompetencia',
            //ActList: '../../sis_formacion/control/Competencia/listarCompetencia',
            ActList: '../../sis_cuenta_documentada/control/PagoSimple/reporteDetallePagos',
            id_store: 'id_doc_compra_venta',
            fields: [
                {name: 'id_doc_compra_venta', type: 'numeric'},
                {name: 'id_funcionario', type: 'numeric'},
                {name: 'desc_funcionario1', type: 'string'},
                {name: 'id_plantilla', type: 'numeric'},
                {name: 'desc_plantilla', type: 'string'},
                {name: 'id_proveedor', type: 'numeric'},
                {name: 'rotulo_comercial', type: 'string'},
                {name: 'importe_pago_liquido', type: 'numeric'},
                {name: 'importe_excento', type: 'numeric'},
                {name: 'fecha_compra_venta', type: 'string'},
                {name: 'fecha_pago_simple', type: 'string'},
                {name: 'sw_pgs', type: 'string'}
            ],
            sortInfo: {
                field: 'id_doc_compra_venta',
                direction: 'ASC'
            },

			bdel: false,
            bsave: false,
            bnew:false,
            bedit:false	     
        }
    )
</script>
		
		