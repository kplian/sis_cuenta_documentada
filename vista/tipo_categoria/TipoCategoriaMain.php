<?php
/**
*@package pXP
*@file TipoCategoriaMain.php
*@author  RCM
*@date 04/09/2017
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoCategoriaMain = {
    bsave:false,    
    require:'../../../sis_cuenta_documentada/vista/tipo_categoria/TipoCategoria.php',
    requireclase:'Phx.vista.TipoCategoria',
    title:'Viáticos',
    
    constructor: function(config) {
        Phx.vista.TipoCategoriaMain.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
        this.load({params:{start:0, limit:this.tam_pag}});
    },  
   
    tabeast:[
          {
              url:'../../../sis_cuenta_documentada/vista/categoria/Categoria.php',
              title:'Categorías', 
              width:'60%',
              cls:'Categoria'
          }
    ],
    
};
</script>
