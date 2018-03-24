<?php
/**
*@package pXP
*@file CuentaDocDevolRepo.php
*@author  RCM
*@date 20/03/2018
*@description Archivo con la interfaz de usuario que permite 
*procesar las devoluciones/reposiciones
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocDevolRepo = {
	require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDocVbContaCentral.php',
	requireclase:'Phx.vista.CuentaDocVbContaCentral',
	title:'Cuenta Documentada/Devoluciones',
	nombreVista: 'CuentaDocDevolRepo',
	
	constructor: function(config){
	    Phx.vista.CuentaDocDevolRepo.superclass.constructor.call(this,config);
        this.init();
    }

};
</script>
