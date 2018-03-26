<?php
/**
*@package pXP
*@file ReportePasajesFuncionariosDet
*@author  RCM
*@date 28/02/2018
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReportePasajesFuncionariosDet=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //Llama al constructor de la clase padre
        Phx.vista.ReportePasajesFuncionariosDet.superclass.constructor.call(this,config);
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
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_doc_compra_venta'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'nro_tramite',
                fieldLabel: 'Nro.Trámite',
                allowBlank: false,
                anchor: '50%',
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.nro_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'desc_plantilla',
                fieldLabel: 'Tipo Doc.',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.desc_plantilla',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
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
                baseParams: { es_combo_solicitud : 'no' },
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
             },
            type:'ComboRec',//ComboRec
            id_grupo:0,
            filters:{pfiltro:'fun1.desc_funcionario2',type:'string'},
            bottom_filter:true,
            grid:true,
            form:true,
            egrid: true
        },
        {
            config:{
                name: 'importe_mb',
                fieldLabel: 'Importe Moneda Base',
                allowBlank: false,
                anchor: '50%',
                gwidth: 170
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_mb_excento',
                fieldLabel: 'Importe Excento Moneda Base',
                allowBlank: false,
                anchor: '50%',
                gwidth: 170
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_int_comprobante',
                fieldLabel: 'Id.Cbte.',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.id_int_comprobante',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'estado_cbte',
                fieldLabel: 'Estado Cbte.',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nit',
                fieldLabel: 'NIT',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.nit',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_documento',
                fieldLabel: 'Nro.Documento',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.nro_documento',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_autorizacion',
                fieldLabel: 'Nro.Autorización',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.nro_autorizacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fecha',
                fieldLabel: 'Fecha',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'TextField',
            filters:{pfiltro:'dcv.fecha',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'razon_social',
                fieldLabel: 'Razón Social',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.razon_social',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'desc_moneda',
                fieldLabel: 'Moneda',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'mon.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_doc',
                fieldLabel: 'Importe Doc.',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_doc',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_excento',
                fieldLabel: 'Excento',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_excento',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_descuento',
                fieldLabel: 'Descuento',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_descuento',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_neto',
                fieldLabel: 'Neto',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_neto',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'codigo_control',
                fieldLabel: 'Código Control',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.codigo_control',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_iva',
                fieldLabel: 'IVA',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_iva',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_it',
                fieldLabel: 'IT',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_it',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_ice',
                fieldLabel: 'ICE',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_ice',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe_pago_liquido',
                fieldLabel: 'Líquido Pagable',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.importe_pago_liquido',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_dui',
                fieldLabel: 'Nro.DUI',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'dcv.nro_dui',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nro_tramite_viatico',
                fieldLabel: 'Nro.Trámite Viático',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'cdo.nro_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fecha_viatico',
                fieldLabel: 'Fecha Viático',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'TextField',
            filters:{pfiltro:'cdo.fecha',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'desc_funcionario_sol',
                fieldLabel: 'Funcionario Viático',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'fun.desc_funcionario2',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        }
    ],
    tam_pag:50, 
    title:'Detalle Viáticos Form.110',
    ActList:'../../sis_cuenta_documentada/control/CuentaDoc/listarPasajesFuncionariosDet',
    ActSave:'../../sis_cuenta_documentada/control/CuentaDoc/modificarViaticosForm110Det',
    id_store:'id_doc_compra_venta',
    fields: [
        {name:'id_doc_compra_venta', type: 'numeric'},
        {name:'nro_tramite', type: 'string'},
        {name:'desc_plantilla', type: 'string'},
        {name:'id_int_comprobante', type: 'numeric'},
        {name:'estado_cbte', type: 'string'},
        {name:'nit', type: 'string'},
        {name:'nro_documento', type: 'string'},
        {name:'nro_autorizacion', type: 'string'},
        {name:'fecha', type: 'date',dateFormat:'Y-m-d'},
        {name:'razon_social', type: 'string'},
        {name:'importe_doc', type: 'numeric'},
        {name:'importe_excento', type: 'numeric'},
        {name:'importe_descuento', type: 'numeric'},
        {name:'importe_neto', type: 'numeric'},
        {name:'codigo_control', type: 'string'},
        {name:'importe_iva', type: 'numeric'},
        {name:'importe_it', type: 'numeric'},
        {name:'importe_ice', type: 'numeric'},
        {name:'importe_pago_liquido', type: 'numeric'},
        {name:'nro_dui', type: 'string'},
        {name:'nro_tramite_viatico', type: 'string'},
        {name:'fecha_viatico', type: 'date',dateFormat:'Y-m-d'},
        {name:'desc_funcionario_sol', type: 'string'},
        {name:'id_funcionario', type: 'numeric'},
        {name:'desc_funcionario', type: 'string'},
        {name:'desc_moneda', type: 'string'},
        {name:'importe_mb', type: 'numeric'},
        {name:'importe_mb_excento', type: 'numeric'}
    ],
    sortInfo:{
        field: 'dcv.fecha',
        direction: 'ASC'
    },
    bdel: false,
    bsave: true,
    bnew: false,
    bedit: false,

    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_funcionario')].valorInicial = this.maestro.id_funcionario;

        //Filtro para los datos
        this.store.baseParams = {
            id_funcionario: this.maestro.id_funcionario,
            id_depto: this.maestro.id_depto_conta,
            id_periodo: this.maestro.id_periodo
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

    }

})
</script>