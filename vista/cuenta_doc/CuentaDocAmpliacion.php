<?php
/**
 *@package pXP
 *@file CuentaDocAmpliacion.php
 *@author  Gonzalo Sarmiento
 *@date 08-02-2017
 *@description Archivo con la interfaz de usuario que permite
 *realizar la ampliacion de dias de rendicion
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CuentaDocAmpliacion = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
        requireclase:'Phx.vista.CuentaDoc',
        title:'Cuenta Documentada Ampliacion',
        nombreVista: 'CuentaDocAmpliacion',
        ActList:'../../sis_cuenta_documentada/control/CuentaDoc/listarCuentaDocConsulta',
        bactGroups : [0],
        bexcelGroups : [0],

        gruposBarraTareas : [{
            name : 'entregados',
            title : '<H1 align="center"><i class="fa fa-eye"></i> Entregados</h1>',
            grupo : 0,
            height : 0
        }],

        constructor: function(config) {
            var me = this;
            this.tbarItems = ['-',
                {xtype: 'label',text: 'Gestión:'},
                this.cmbGestion,'-'];


            this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {
                if (record.data.estado == 'contabilizado') {
                    var  saldo = me.roundTwo(value) - me.roundTwo(record.data.importe_documentos) - me.roundTwo(record.data.importe_depositos) +  me.roundTwo(record.data.importe_retenciones);
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
                        "<b><font color = 'orange' >Rendido de Ley:{1}</font></b><br>"+
                        "<b><font color = 'blue' >Saldo:{2}</font></b>", value, record.data.importe_total_rendido, saldo );

                }
                else {
                    return String.format('<font>Solicitado: {0}</font>', value);
                }

            };

            this.Atributos[this.getIndAtributo('sw_max_doc_rend')].grid = true;

            Phx.vista.CuentaDocAmpliacion.superclass.constructor.call(this,config);

            this.addButton('onBtnAmpRen', {
                grupo : [0],
                text : 'Ampliar Días',
                iconCls : 'blist',
                disabled : true,
                handler : this.onBtnAmpRen,
                tooltip : '<b>Agergar días para rendir</b><br>permite  sumar o restar días al limite de rendición indicado por la columna "Lim Rend"'
            });

            this.init();
            this.store.baseParams = { estado : 'entregados',tipo_interfaz: this.nombreVista };
            this.load({params:{start:0, limit:this.tam_pag}});

            this.cmbGestion.on('select',function(){

                this.store.baseParams.id_gestion = this.cmbGestion.getValue();
                if(!this.store.baseParams.id_gestion){
                    delete this.store.baseParams.id_gestion;
                }
                this.reload();
            }, this);

            this.finCons = true;
        },

        cmbGestion: new Ext.form.ComboBox({
            fieldLabel: 'Gestion',
            allowBlank: true,
            emptyText:'Gestion...',
            store:new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Gestion/listarGestion',
                    id: 'id_gestion',
                    root: 'datos',
                    sortInfo:{
                        field: 'gestion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
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

        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.CuentaDocAmpliacion.superclass.preparaMenu.call(this,n);
            this.getBoton('chkpresupuesto').enable();
            this.getBoton('btnObs').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();
            this.getBoton('btnObs').disable();
            this.getBoton('chkpresupuesto').disable();

            if(data.sw_solicitud == 'si' && data.estado == 'contabilizado'){
                this.getBoton('onBtnAmpRen').enable();
            }
            else{
                this.getBoton('onBtnAmpRen').disable();
            }
        },

        liberaMenu:function(){
            var tb = Phx.vista.CuentaDocAmpliacion.superclass.liberaMenu.call(this);
            if(tb){
                this.getBoton('btnChequeoDocumentosWf').disable();
                this.getBoton('btnObs').disable();
                this.getBoton('btnObs').disable();
                this.getBoton('chkpresupuesto').disable();
            }
            return tb
        },
        onBtnAmpRen : function() {
            var rec = this.sm.getSelected();
            var data = rec.data;
            if(data && data.estado != 'finalziado' && data.sw_solicitud  == 'si'){
                var selection, sw = true;
                do{
                    var selection = window.prompt("Introuzca los dias de ampliación -15 y 15", 5);
                    var sw = selection?isNaN(selection):false;

                    console.log('......',selection, sw  , parseInt(selection, 10) > 15 , parseInt(selection, 10) < -15)

                }while(  sw  || parseInt(selection, 10) > 15 || parseInt(selection, 10) < -15);

                if(selection){
                    Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url : '../../sis_cuenta_documentada/control/CuentaDoc/ampliarRendicion',
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
        } ,

        successRep:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                this.reload();
            }else{
                alert('Ocurrió un error durante el proceso')
            }
        }
    };
</script>