<?php
/**
 *@package pXP
 *@file    ReporteCuentaDoc.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    04-11-2016
 *@description Reporte Cuenta Doc
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ReporteCuentaDoc = Ext.extend(Phx.frmInterfaz, {
        Atributos : [
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
                    baseParams: { todos : 'si' },
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
                    name: 'fecha_ini',
                    fieldLabel: 'Fecha Inicio',
                    allowBlank: false,
                    disabled: false,
                    gwidth: 100,
                    format: 'd/m/Y'

                },
                type:'DateField',
                id_grupo:0,
                form:true
            },
            {
                config:{
                    name: 'fecha_fin',
                    fieldLabel: 'Fecha Fin',
                    allowBlank: false,
                    disabled: false,
                    gwidth: 100,
                    format: 'd/m/Y'

                },
                type:'DateField',
                id_grupo:0,
                form:true
            }
        ],
        title : 'Generar Reporte',
        ActSave : '../../sis_cuenta_documentada/control/CuentaDoc/listarReporteCuentaDoc',
        topBar : true,
        botones : false,
        labelSubmit : 'Imprimir',
        tooltipSubmit : '<b>Generar Reporte</b>',
        constructor : function(config) {
            Phx.vista.ReporteCuentaDoc.superclass.constructor.call(this, config);
            this.init();
        },
        tipo : 'reporte',
        clsSubmit : 'bprint'
    })
</script>