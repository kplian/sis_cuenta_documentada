<?php
/**
 *@package pXP
 *@file gen-PagoSimpleConsulta.php
 *@author  (admin)
 *@date 31-12-2017 12:33:30
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 ****************************************************************************
HISTORIAL DE MODIFICACIONES:
#ISSUE		FORK		FECHA				AUTOR				DESCRIPCION
#0						31-12-2017			     RAC			Creación
#0001             		22/06/2018               RAC            Considera el Devenga y pagar con prorrateo automatico y nro de tramite tipo   DVPGPROP
#4         ENDEETR     09/01/2018         Manuel Guerra        se agrego en el combo de obligación de pago,en el formulario de pago simple
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.PagoSimpleConsulta=Ext.extend(Phx.gridInterfaz,{
        nombreVista: 'PagoSimpleSol',
        constructor:function(config){
            this.maestro=config.maestro;
            this.historico = 'no';
            this.tbarItems = ['-',{
                text: 'Histórico',
                enableToggle: true,
                pressed: false,
                toggleHandler: function(btn, pressed) {
                    if(pressed){
                        this.historico = 'si';
                       // this.getBoton('ant_estado').disable();
                       // this.getBoton('sig_estado').disable();
                    }
                    else{
                        this.historico = 'no'
                    }
                    this.store.baseParams.historico = this.historico;
                    this.reload();
                },
                scope: this
            }];

            Phx.vista.PagoSimpleConsulta.superclass.constructor.call(this,config);
            this.init();

            this.store.baseParams = { tipo_interfaz: this.nombreVista };
            if(config.filtro_directo){
                this.store.baseParams.filtro_valor = config.filtro_directo.valor;
                this.store.baseParams.filtro_campo = config.filtro_directo.campo;
            }
            this.addBotonesGantt();
            this.addButton('btnChequeoDocumentosWf', {
                    text: 'Documentos',
                    grupo:[0,1,2,3,4],
                    iconCls: 'bchecklist',
                    disabled: true,
                    handler: this.loadCheckDocumentosSolWf,
                    tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            });

            Ext.apply(this.store.baseParams, {
                estado: 'borrador',
                tipo_interfaz: this.nombreVista
            });
            this.load({params:{start:0, limit:this.tam_pag}});

            //Deshabilita el tab de prorrateo por defecto
            // this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(true);
        },
        Atributos:[
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
                    name: 'id_depto_lb'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_cuenta_bancaria'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_gestion'
                },
                type:'Field',
                form:true
            },
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_periodo'
                },
                type:'Field',
                form:true
            },
            {
                config:{
                    name: 'nro_tramite',
                    fieldLabel: 'Nro.Tramite',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 160,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'pagsim.nro_tramite',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter:true
            },
            {
                config:{
                    name: 'fecha',
                    fieldLabel: 'Fecha',
                    allowBlank: false,
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'pagsim.fecha',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name:'id_tipo_pago_simple',
                    fieldLabel:'Tipo Solicitud Pago',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    lazyRender:true,
                    mode: 'remote',
                    gwidth: 180,
                    anchor: '100%',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_cuenta_documentada/control/TipoPagoSimple/listarTipoPagoSimple',
                        id: 'id_tipo_pago_simple',
                        root: 'datos',
                        sortInfo:{
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_tipo_pago_simple','nombre','codigo'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'nombre', sw_solicitud: 'si'
                        }
                    }),
                    valueField: 'id_tipo_pago_simple',
                    displayField: 'nombre',
                    gdisplayField: 'desc_tipo_pago_simple',
                    hiddenName: 'id_tipo_pago_simple',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode:'remote',
                    pageSize: 10,
                    queryDelay: 1000,
                    resizable: true,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['desc_tipo_pago_simple']);
                    }
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'tps.codigo#tps.nombre',type:'string'},
                grid:true,
                form:true
            },
            {
                config:{
                    name:'id_funcionario',
                    hiddenName: 'id_funcionario',
                    origen:'FUNCIONARIOCAR',
                    fieldLabel:'Solicitantes',
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
                config:{
                    name:'id_depto_conta',
                    origen:'DEPTO',
                    fieldLabel: 'Departamento Contabilidad',
                    url: '../../sis_parametros/control/Depto/listarDepto',
                    emptyText : 'Departamento Contabilidad ...',
                    allowBlank:false,
                    anchor: '80%',
                    gdisplayField: 'desc_depto_conta',
                    gwidth: 200,
                    baseParams: {par_filtro: 'deppto.nombre#deppto.codigo',codigo_subsistema:'CONTA'}
                },
                type:'ComboRec',
                id_grupo:0,
                filters:{pfiltro:'dep.codigo',type:'string'},
                bottom_filter:true,
                form:true,
                grid:true
            },
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
                    fieldLabel: 'Importe a Pagar',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 160,
                    maxLength:100
                },
                type:'NumberField',
                filters:{pfiltro:'pagsim.importe',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'id_proveedor',
                    origen: 'PROVEEDOR',
                    allowBlank: true,
                    fieldLabel: 'Proveedor',
                    anchor: '100%',
                    gdisplayField: 'desc_proveedor',//mapea al store del grid
                    gwidth: 150,
                    //baseParams: { 'filtrar_base': 'si' },
                    renderer: function (value, p, record){return String.format('{0}', record.data['desc_proveedor']);}
                },
                type: 'ComboRec',
                id_grupo: 1,
                filters: { pfiltro:'pro.desc_proveedor',type:'string'},
                grid: true,
                form: true,
                bottom_filter:true,
            },
            {
                config:{
                    name:'id_funcionario_pago',
                    hiddenName: 'id_funcionario_pago',
                    origen:'FUNCIONARIOCAR',
                    fieldLabel:'Pagar a Funcionario',
                    allowBlank:true,
                    gwidth:200,
                    anchor: '100%',
                    valueField: 'id_funcionario',
                    gdisplayField: 'desc_funcionario_pago',
                    baseParams: { es_combo_solicitud : 'si' },
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario_pago']);}
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
                    name: 'estado',
                    fieldLabel: 'Estado',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:30
                },
                type:'TextField',
                filters:{pfiltro:'pagsim.estado',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter:true
            },
            {
                config:{
                    name: 'obs',
                    fieldLabel: 'Glosa',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 300,
                    maxLength:500
                },
                type:'TextArea',
                filters:{pfiltro:'pagsim.obs',type:'string'},
                id_grupo:1,
                grid:true,
                form:true,
                bottom_filter:true
            },
            {
                config:{
                    name:'id_obligacion_pago',
                    fieldLabel:'Obligacion de Pago',
                    allowBlank: true,
                    emptyText:'Seleccione un registro ...',
                    gwidth: 180,
                    anchor: '100%',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_tesoreria/control/ObligacionPago/listarObligacionPagoPS',
                        id: 'id_obligacion_pago',
                        root: 'datos',
                        sortInfo:{
                            field: 'num_tramite',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_obligacion_pago','num_tramite','fecha','obs','tipo_obligacion','total_pago','tipo_solicitud','desc_funcionario1','desc_proveedor'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'obpg.num_tramite#pv.desc_proveedor',  pago_simple : 'si' }
                    }),
                    valueField: 'id_obligacion_pago',
                    displayField: 'num_tramite',
                    gdisplayField: 'desc_obligacion_pago',
                    hiddenName: 'id_obligacion_pago',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode:'remote',
                    pageSize: 10,
                    queryDelay: 1000,
                    resizable: true,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['desc_obligacion_pago']);
                    },
                    minChars: 2,
                    //#4
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>Nro.Trámite:</b> {num_tramite}</p><p><b>Proveedor:</b> {desc_proveedor}</p><p><b>Monto:</b> {total_pago}</p></div></tpl>',
                },
                type:'ComboBox',
                id_grupo:1,
                filters:{pfiltro:'op.num_tramite',type:'string'},
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'proveedor_obligacion_pago',
                    fieldLabel: 'Proveedor Obligacion Pago',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 300,
                    maxLength:500
                },
                type:'TextArea',
                filters:{pfiltro:'prov.desc_proveedor',type:'string'},
                id_grupo:1,
                grid:true,
                form:false,
                bottom_filter:true
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
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:10
                },
                type:'TextField',
                filters:{pfiltro:'pagsim.estado_reg',type:'string'},
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
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'pagsim.fecha_reg',type:'date'},
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
                filters:{pfiltro:'pagsim.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'pagsim.usuario_ai',type:'string'},
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
                filters:{pfiltro:'pagsim.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Pago Simple',
        ActSave:'../../sis_cuenta_documentada/control/PagoSimple/insertarPagoSimple',
        ActDel:'../../sis_cuenta_documentada/control/PagoSimple/eliminarPagoSimple',
        ActList:'../../sis_cuenta_documentada/control/PagoSimple/listarPagoSimple',
        id_store:'id_pago_simple',
        fields: [
            {name:'id_pago_simple', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'id_depto_conta', type: 'numeric'},
            {name:'nro_tramite', type: 'string'},
            {name:'fecha', type: 'date',dateFormat:'Y-m-d'},
            {name:'id_funcionario', type: 'numeric'},
            {name:'estado', type: 'string'},
            {name:'id_estado_wf', type: 'numeric'},
            {name:'id_proceso_wf', type: 'numeric'},
            {name:'obs', type: 'string'},
            {name:'id_cuenta_bancaria', type: 'numeric'},
            {name:'id_depto_lb', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'desc_depto_conta', type: 'string'},
            {name:'desc_funcionario', type: 'string'},
            {name:'desc_cuenta_bancaria', type: 'string'},
            {name:'desc_depto_lb', type: 'string'},
            {name:'id_moneda', type: 'numeric'},
            {name:'id_proveedor', type: 'numeric'},
            {name:'desc_moneda', type: 'string'},
            {name:'desc_proveedor', type: 'string'},
            {name:'id_funcionario_pago', type: 'numeric'},
            {name:'id_tipo_pago_simple', type: 'numeric'},
            {name:'desc_funcionario_pago', type: 'string'},
            {name:'desc_tipo_pago_simple', type: 'string'},
            {name:'codigo_tipo_pago_simple', type: 'string'},
            {name:'importe', type: 'numeric'},
            {name:'id_obligacion_pago', type: 'numeric'},
            {name:'desc_obligacion_pago', type: 'string'},
            {name:'id_caja', type: 'numeric'},
            {name:'desc_caja', type: 'string'},
            {name:'id_gestion', type: 'numeric'},
            {name:'id_periodo', type: 'numeric'},
            {name:'proveedor_obligacion_pago', type: 'string'}
        ],
        sortInfo:{
            field: 'id_pago_simple',
            direction: 'DESC'
        },
        bdel:false,
        bsave:false,
        bnew:false,
        bedit:false,
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
            const data=this.sm.getSelected().data.id_proceso_wf;
            window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)
        },
        preparaMenu: function(n) {
            const data = this.getSelectedData();
            const tb = this.tbar;
            Phx.vista.PagoSimpleConsulta.superclass.preparaMenu.call(this, n);

            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();

            if(this.historico === 'no'){

            }



            return tb
        },


        liberaMenu: function() {
            const tb = Phx.vista.PagoSimpleConsulta.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btnChequeoDocumentosWf').disable();
            }
            return tb
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



        tabsouth: [{
            url: '../../../sis_cuenta_documentada/vista/pago_simple_det/PagoSimpleDetCon.php',
            title: 'Facturas/Recibos',
            height: '40%',
            cls: 'PagoSimpleDetCon'
        }, {
            url: '../../../sis_cuenta_documentada/vista/pago_simple_pro/PagoSimpleProCon.php',
            title: 'Prorrateo manual',
            height: '40%',
            cls: 'PagoSimpleProCon'
        }],

        agregarDocumentos: function(){
            var rec=this.sm.getSelected(),
                obj = {
                    id_pago_simple: rec.data.id_pago_simple,
                    id_usuario: this.cmbUsuario.getValue(),
                    id_plantilla: this.cmbPlantilla.getValue()
                };

            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_cuenta_documentada/control/PagoSimple/agregarDocumentos',
                params: obj,
                success: function(resp){
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                    this.reload();
                    this.winDatos.hide();
                    Phx.CP.loadingHide();
                    Ext.MessageBox.alert('Importación finalizada','Cantidad de documentos agregados: '+reg.datos.tot_fact);
                },
                failure: function(resp) {
                    Phx.CP.conexionFailure(resp);
                },
                timeout: function() {
                    Phx.CP.config_ini.timeout();
                },
                scope:this
            });

        }

    })
</script>