<?php
/**
 *@package pXP
 *@file gen-PagoSimpleProCon.php
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
    Phx.vista.PagoSimpleProCon = {

        require: '../../../sis_cuenta_documentada/vista/pago_simple/DocCompraPS.php',
        ActList:'../../sis_cuenta_documentada/control/PagoSimpleDet/listarPagoSimpleDet',
        requireclase: 'Phx.vista.DocCompraPS',
        title: 'Documentos',
        nombreVista: 'PagoSimpleProCon',
        tipoDoc: 'compra',
        formTitulo: 'Formulario de Documento Compra',

        constructor: function(config) {
            Phx.vista.PagoSimpleProCon.superclass.constructor.call(this,config);

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
            //this.Cmp.id_plantilla.store.baseParams = Ext.apply(this.Cmp.id_plantilla.store.baseParams, {tipo_plantilla:this.tipoDoc});

            this.cmbDepto.setVisible(false);
            this.cmbGestion.setVisible(false);
            this.cmbPeriodo.setVisible(false);
            this.getBoton('btnWizard').setVisible(false);
            this.getBoton('btnImprimir').setVisible(false);
            this.getBoton('btnExpTxt').setVisible(false);
            //#15
            this.getBoton('repasaj').setVisible(false);
            const dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
            if(dataPadre){
                this.onEnablePanel(this, dataPadre);
            }
            else {
                this.bloquearMenus();
            }
        },


        loadValoresIniciales: function() {
            Phx.vista.PagoSimpleProCon.superclass.loadValoresIniciales.call(this);

        },
        capturaFiltros:function(combo, record, index){
            this.store.baseParams.tipo = this.tipoDoc;
            Phx.vista.PagoSimpleProCon.superclass.capturaFiltros.call(this,combo, record, index);
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


    };

</script>

