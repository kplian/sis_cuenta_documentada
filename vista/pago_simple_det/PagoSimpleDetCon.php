<?php
/**
 *@package pXP
 *@file gen-PagoSimpleDetCon.php
 *@author  (admin)
 *@date 01-01-2018 06:21:25
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema



ISSUE          FECHA:		      AUTOR                 DESCRIPCION
#14 		17/04/2020		manuel guerra	    	ocultar boton de reporte
#15			19/05/2020		manuel guerra           creacion de reportes en pdf, para pasajes
#ETR-779	29/09/2020		manuel guerra			mostrar nota de debitoe en grilla

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PagoSimpleDetCon = {

        require: '../../../sis_cuenta_documentada/vista/pago_simple/DocCompraPS.php',
        ActList:'../../sis_cuenta_documentada/control/PagoSimpleDet/listarPagoSimpleDet',
        requireclase: 'Phx.vista.DocCompraPS',
        title: 'Documentos',
        nombreVista: 'PagoSimpleDetCon',
        tipoDoc: 'compra',
        formTitulo: 'Formulario de Documento Compra',
        constructor: function(config) {
            Phx.vista.PagoSimpleDetCon.superclass.constructor.call(this,config);
            this.Atributos.push({
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_pago_simple_det'
                },
                type:'Field',
                form:true
            },);
            this.Atributos.push({
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_pago_simple'
                },
                type:'Field',
                form:true
            });
            this.cmbDepto.setVisible(false);
            this.cmbGestion.setVisible(false);
            this.cmbPeriodo.setVisible(false);
            this.getBoton('btnWizard').setVisible(false);
            this.getBoton('btnImprimir').setVisible(false);
            this.getBoton('btnExpTxt').setVisible(false);
            //#15
            this.getBoton('repasaj').setVisible(false);
        },

        loadValoresIniciales: function() {
            Phx.vista.PagoSimpleDetCon.superclass.loadValoresIniciales.call(this);
        },
        capturaFiltros:function(combo, record, index){
            this.store.baseParams.tipo = this.tipoDoc;
            Phx.vista.PagoSimpleDetCon.superclass.capturaFiltros.call(this,combo, record, index);
        },

        onReloadPage: function(m) {
            this.maestro = m;
            this.Atributos[this.getIndAtributo('id_pago_simple')].valorInicial = this.maestro.id_pago_simple;

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
        },
        validarFiltros: function(){
            return true;
        },
        preparaMenu:function(tb){
            Phx.vista.DocCompraVenta.superclass.preparaMenu.call(this,tb)
        },
        bnew: false,
        bedit: false,
        bsave: false,
        bdel:false,
        ActDel:'../../sis_cuenta_documentada/control/PagoSimpleDet/eliminarPagoSimpleDet',
        id_store:'id_pago_simple_det',
        fields: [
            {name:'id_pago_simple_det', type: 'numeric'},
            {name:'id_doc_compra_venta', type: 'string'},
            {name:'revisado', type: 'string'},
            {name:'movil', type: 'string'},
            {name:'tipo', type: 'string'},
            {name:'importe_excento', type: 'numeric'},
            {name:'id_plantilla', type: 'numeric'},
            {name:'fecha', type: 'date',dateFormat:'Y-m-d'},
            {name:'nro_documento', type: 'string'},
            {name:'nit', type: 'string'},
            {name:'importe_ice', type: 'numeric'},
            {name:'nro_autorizacion', type: 'string'},
            {name:'importe_iva', type: 'numeric'},
            {name:'importe_descuento', type: 'numeric'},
            {name:'importe_doc', type: 'numeric'},
            {name:'sw_contabilizar', type: 'string'},
            {name:'tabla_origen', type: 'string'},
            {name:'estado', type: 'string'},
            {name:'id_depto_conta', type: 'numeric'},
            {name:'id_origen', type: 'numeric'},
            {name:'obs', type: 'string'},
            {name:'estado_reg', type: 'string'},
            {name:'codigo_control', type: 'string'},
            {name:'importe_it', type: 'numeric'},
            {name:'razon_social', type: 'string'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usuario_ai', type: 'string'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'importe_pendiente', type: 'numeric'},
            {name:'importe_anticipo', type: 'numeric'},
            {name:'importe_retgar', type: 'numeric'},
            {name:'importe_neto', type: 'numeric'},
            'desc_depto','desc_plantilla',
            'importe_descuento_ley','importe_aux_neto',
            'importe_pago_liquido','nro_dui','id_moneda','desc_moneda',
            'desc_tipo_doc_compra_venta','id_tipo_doc_compra_venta','nro_tramite',
            'desc_comprobante','id_int_comprobante','id_auxiliar','codigo_auxiliar','nombre_auxiliar','tipo_reg',
            'estacion', 'id_punto_venta', 'nombre', 'id_agencia', 'codigo_noiata','desc_funcionario2','id_funcionario','sw_pgs','nota_debito_agencia'
        ],
        abrirFormulario: function(tipo, record){
            var me = this;

            if(this.maestro.id_depto_conta){

                me.objSolForm = Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/pago_simple/FormRendicionPS.php',
                    me.formTitulo,
                    {
                        modal:true,
                        width:'90%',
                        height:(me.regitrarDetalle == 'si')? '100%':'60%',



                    }, { data: {
                            objPadre: me ,
                            tipoDoc: me.tipoDoc,

                            id_gestion: this.maestro.id_gestion,
                            id_periodo: this.maestro.id_periodo,

                            id_depto: this.maestro.id_depto_conta,
                            tmpPeriodo: me.tmpPeriodo,
                            tmpGestion: me.tmpGestion,
                            tipo_form : tipo,
                            datosOriginales: record
                        },
                        regitrarDetalle: 'si'
                    },
                    this.idContenedor,
                    'FormRendicionPS',
                    {
                        config:[{
                            event:'successsave',
                            delegate: this.onSaveForm,

                        }],

                        scope:this
                    });

            }
        }

    };

    /*
    Phx.vista.PagoSimpleDet=Ext.extend(Phx.gridInterfaz,{

        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.PagoSimpleDet.superclass.constructor.call(this,config);
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
                        name: 'id_pago_simple_det'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
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
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:10
                },
                    type:'TextField',
                    filters:{pfiltro:'paside.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
            },
            {
                config: {
                    name: 'id_doc_compra_venta',
                    fieldLabel: 'Documento',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_/control/Clase/Metodo',
                        id: 'id_',
                        root: 'datos',
                        sortInfo: {
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_', 'nombre', 'codigo'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
                    }),
                    valueField: 'id_',
                    displayField: 'nombre',
                    gdisplayField: 'desc_',
                    hiddenName: 'id_doc_compra_venta',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '100%',
                    gwidth: 150,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['desc_']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'movtip.nombre',type: 'string'},
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
                    filters:{pfiltro:'paside.fecha_reg',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
            },
            {
                config:{
                    name: 'id_usuario_ai',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:4
                },
                    type:'Field',
                    filters:{pfiltro:'paside.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'paside.usuario_ai',type:'string'},
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
                    name: 'fecha_mod',
                    fieldLabel: 'Fecha Modif.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                                format: 'd/m/Y',
                                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                },
                    type:'DateField',
                    filters:{pfiltro:'paside.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
            }
        ],
        tam_pag:50,
        title:'Facturas/Recibos',
        ActSave:'../../sis_cuenta_documentada/control/PagoSimpleDet/insertarPagoSimpleDet',
        ActDel:'../../sis_cuenta_documentada/control/PagoSimpleDet/eliminarPagoSimpleDet',
        ActList:'../../sis_cuenta_documentada/control/PagoSimpleDet/listarPagoSimpleDet',
        id_store:'id_pago_simple_det',
        fields: [
            {name:'id_pago_simple_det', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'id_pago_simple', type: 'numeric'},
            {name:'id_doc_compra_venta', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},

        ],
        sortInfo:{
            field: 'id_pago_simple_det',
            direction: 'ASC'
        },
        bdel:true,
        bsave:true,
        onReloadPage: function(m) {
            this.maestro = m;
            this.Atributos[1].valorInicial = this.maestro.id_pago_simple;

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

    })*/
</script>

