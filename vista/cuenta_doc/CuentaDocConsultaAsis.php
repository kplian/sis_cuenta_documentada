<?php
/**
 * @package pXP
 * @file gen-SistemaDist.php
 * @author  (fprudencio)
 * @date 20-09-2011 10:22:05
 * @description Archivo con la interfaz de usuario que permite
 *dar el visto a solicitudes de compra
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CuentaDocConsultaAsis= {
        bedit: false,
        bnew: false,
        bsave: false,
        bdel: false,
        require: '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
        requireclase: 'Phx.vista.CuentaDoc',
        title: 'Cuenta Documentada',
        nombreVista: 'CuentaDocConsulta',
        ActList: '../../sis_cuenta_documentada/control/CuentaDoc/listarCuentaDocConsulta',
        bactGroups: [],
        bexcelGroups: [],

        gruposBarraTareas: [],

        constructor: function (config) {
            var me = this;
            this.tbarItems = ['-',
                {xtype: 'label', text: 'Gestión:'},
                this.cmbGestion, '-'];
            Phx.vista.CuentaDocConsultaAsis.superclass.constructor.call(this, config);
            this.init();
            this.getBoton('chkpresupuesto').hide();
            this.getBoton('diagrama_gantt').hide();
            this.getBoton('btnObs').hide();
            this.getBoton('btnChequeoDocumentosWf').hide();
            this.getBoton('sig_estado').hide();
            this.getBoton('ant_estado').hide();
            this.cmbGestion.on('select',function(){

                this.store.baseParams.id_gestion = this.cmbGestion.getValue();
                if(!this.store.baseParams.id_gestion){
                    delete this.store.baseParams.id_gestion;
                }
                this.reload();
            }, this)
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.load({params: {start: 0, limit: this.tam_pag}});

            this.finCons = true;
        },

        cmbGestion: new Ext.form.ComboBox({
            fieldLabel: 'Gestion',
            allowBlank: true,
            emptyText: 'Gestion...',
            store: new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Gestion/listarGestion',
                    id: 'id_gestion',
                    root: 'datos',
                    sortInfo: {
                        field: 'gestion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion', 'gestion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {par_filtro: 'gestion'}
                }),
            valueField: 'id_gestion',
            triggerAction: 'all',
            displayField: 'gestion',
            hiddenName: 'id_gestion',
            mode: 'remote',
            pageSize: 50,
            queryDelay: 500,
            listWidth: '280',
            width: 80
        }),

        getParametrosFiltro: function () {
            this.store.baseParams.estado = this.swEstado;
            this.store.baseParams.tipo_interfaz = this.nombreVista;
        },

        actualizarSegunTab: function (name, indice) {
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

        preparaMenu: function (n) {
            var data = this.getSelectedData();
            var tb = this.tbar;
            Phx.vista.CuentaDocConsultaAsis.superclass.preparaMenu.call(this, n);
            this.getBoton('chkpresupuesto').hide();
            this.getBoton('diagrama_gantt').hide();
            this.getBoton('btnObs').hide();
            this.getBoton('btnChequeoDocumentosWf').hide();
        },
        onBtnAmpRen: function () {
            var rec = this.sm.getSelected();
            var data = rec.data;
            if (data && data.estado != 'finalziado' && data.sw_solicitud == 'si') {
                var selection, sw = true;
                do {
                    var selection = window.prompt("Introuzca los dias de ampliación -15 y 15", 5);
                    var sw = selection ? isNaN(selection) : false;

                    console.log('......', selection, sw, parseInt(selection, 10) > 15, parseInt(selection, 10) < -15)

                } while (sw || parseInt(selection, 10) > 15 || parseInt(selection, 10) < -15);

                if (selection) {
                    Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url: '../../sis_cuenta_documentada/control/CuentaDoc/ampliarRendicion',
                        params: {
                            id_cuenta_doc: data.id_cuenta_doc,
                            dias_ampliado: parseInt(selection)
                        },
                        success: this.successRep,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }
            }
        },

        onSwBloq: function () {
            var rec = this.sm.getSelected();
            var data = rec.data;
            if (data && data.sw_solicitud == 'no') {

                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_cuenta_documentada/control/CuentaDoc/cambiarBloqueo',
                    params: {
                        id_cuenta_doc: data.id_cuenta_doc
                    },
                    success: this.successRep,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
        },

        cambioUsu: function (res) {
            var rec = this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_seguridad/vista/usuario/FormUsuario.php',
                'Estado de Wf',
                {
                    modal: true,
                    width: 450,
                    height: 250
                },
                {data: rec.data},
                this.idContenedor, 'FormUsuario',
                {
                    config: [{
                        event: 'beforesave',
                        delegate: this.onCambioUsu,
                    }],
                    scope: this
                });
        },

        onBtnRendicion: function () {
            var rec = this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocRenConsulta.php', 'Rendicion', {
                modal: true,
                width: '95%',
                height: '95%',
            }, rec.data, this.idContenedor, 'CuentaDocRenConsulta');
        },

        onCambioUsu: function (wizard, resp) {
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_cuenta_documentada/control/CuentaDoc/cambioUsuarioReg',
                params: {
                    id_usuario_new: resp.id_usuario,
                    id_cuenta_doc: resp.data.id_cuenta_doc
                },
                argument: {wizard: wizard},
                success: this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },
        successRep: function (resp) {
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if (!reg.ROOT.error) {
                this.reload();
            } else {
                alert('Ocurrió un error durante el proceso')
            }
        },
        Atributos: [
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_cuenta_doc'
                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_cuenta_doc_fk'
                },
                type: 'Field',
                form: false
            },
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_estado_wf'
                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_proceso_wf'
                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'codigo_tipo_cuenta_doc'
                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    name: 'nro_tramite',
                    fieldLabel: 'Nro Trámite',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 120,
                    maxLength: 150,
                    renderer: function (value, p, record) {
                        if (record.data.sw_solicitud == 'no') {
                            return String.format('{0}-{1}', value, record.data.num_rendicion);
                        } else {
                            return String.format('{0}', value);
                        }

                    }
                },
                type: 'TextField',
                bottom_filter: true,
                filters: {pfiltro: 'cdoc.nro_tramite', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha',
                    fieldLabel: 'Fecha Solicitud',
                    allowBlank: false,
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'cdoc.fecha', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'motivo',
                    qtip: 'Explique el objetivo del fondo solicitado',
                    fieldLabel: 'Motivo',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 200,
                    maxLength: 500
                },
                type: 'TextArea',
                filters: {pfiltro: 'cdoc.motivo', type: 'string'},
                bottom_filter: true,
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'estado',
                    fieldLabel: 'Estado',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 100
                },
                type: 'TextField',
                filters: {pfiltro: 'cdoc.estado', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'id_funcionario',
                    hiddenName: 'Solicitante',
                    origen: 'FUNCIONARIOCAR',
                    fieldLabel: 'Solicitante',
                    allowBlank: false,
                    gwidth: 200,
                    anchor: '100%',
                    valueField: 'id_funcionario',
                    gdisplayField: 'desc_funcionario',
                    baseParams: {es_combo_solicitud: 'si'},
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['desc_funcionario']);
                    }
                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {pfiltro: 'fun.desc_funcionario1', type: 'string'},
                bottom_filter: true,
                grid: true,
                form: true
            },
            {
                config: {
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
                    baseParams: {estado: 'activo', codigo_subsistema: 'TES', modulo: 'OP'},//parametros adicionales que se le pasan al store
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['desc_depto']);
                    }
                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {pfiltro: 'dep.nombre', type: 'string'},
                grid: true,
                form: true
            },

            {
                config: {
                    name: 'fecha_salida',
                    fieldLabel: 'Fecha Salida',
                    allowBlank: false,
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y') : ''
                    },
                    hidden: false,
                },
                type: 'DateField',
                filters: {pfiltro: 'cdoc.fecha_salida', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: true
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
                    hidden: false
                },
                type: 'TextField',
                filters: {pfiltro: 'cdoc.hora_salida', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'fecha_llegada',
                    fieldLabel: 'Fecha Llegada',
                    allowBlank: false,
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y') : ''
                    },
                    hidden: false,
                },
                type: 'DateField',
                filters: {pfiltro: 'cdoc.fecha_llegada', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: true
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
                    hidden: false
                },
                type: 'TextField',
                filters: {pfiltro: 'cdoc.hora_salida', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
        ],
    };
</script>