<?php
/**
*@package pXP
*@file TipoCategoriaViatico
*@author  RCM
*@date 04/09/2017
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCategoriaViatico = {
    bsave:false,    
    require:'../../../sis_cuenta_documentada/vista/tipo_categoria/TipoCategoria.php',
    requireclase:'Phx.vista.TipoCategoria',
    title:'Viáticos',
    
    constructor: function(config) {
        Phx.vista.TipoCategoriaViatico.superclass.constructor.call(this,config);
        this.maestro = config;
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
   
    east: {
		url: '../../../sis_cuenta_documentada/vista/categoria/CategoriaViatico.php',
		title: 'viáticos',
		width: '60%',
		cls: 'CategoriaViatico'
	},

    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_escala;

        //Filtro para los datos
        this.store.baseParams = {
            id_escala: this.maestro.id_escala
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

    }
    
};
</script>
