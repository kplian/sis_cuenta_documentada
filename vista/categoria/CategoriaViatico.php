<?php
/**
*@package pXP
*@file CategoriaViatico.php
*@author  RCM
*@date 04/09/2017
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CategoriaViatico = {
    bsave:false,    
    require:'../../../sis_cuenta_documentada/vista/categoria/Categoria.php',
    requireclase:'Phx.vista.Categoria',
    title:'Viáticos',
    
    constructor: function(config) {
        this.agregarCampos();
        Phx.vista.CategoriaViatico.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
        this.bloquearMenus();
        this.Cmp.id_destino.show();
        this.Cmp.id_destino.allowBlank = false;
        this.Cmp.codigo.allowBlank = true;
        this.Cmp.codigo.hide();
        this.Cmp.nombre.hide();

        //this.mostrarColumnaByName('id_destino');
        //this.mostrarColumna(4);
    },  

    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_tipo_categoria;

        //Filtro para los datos
        this.store.baseParams = {
            id_tipo_categoria: this.maestro.id_tipo_categoria
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

    },
    agregarCampos: function(){
        this.Atributos.push({
            config:{
                name: 'monto_sp',
                fieldLabel: 'Sin Pernocte',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1179650
            },
                type:'NumberField',
                filters:{pfiltro:'cat.monto_sp', type: 'numeric'},
                id_grupo:1,
                grid:true,
                form:true
        });

        this.Atributos.push({
            config:{
                name: 'monto_hotel',
                fieldLabel: 'Hotel',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1179650
            },
                type:'NumberField',
                filters:{pfiltro:'cat.monto_hotel', type: 'numeric'},
                id_grupo:1,
                grid:true,
                form:true
        });

        this.Atributos[6].config.fieldLabel = 'Con Pernocte';
        this.Atributos[2].grid = false;
        this.Atributos[3].grid = true;
        this.Atributos[4].config.gwidth = 150;
        this.Atributos[4].grid = true;
    }
    
};
</script>
