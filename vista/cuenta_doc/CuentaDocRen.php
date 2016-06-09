<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocRen = {
    bedit:true,
    bnew:true,
    bsave:false,
    bdel:true,
	require: '../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
	requireclase: 'Phx.vista.CuentaDoc',
	title: 'Cuenta Documentada',
	nombreVista: 'CuentaDocRen',
	
	ActSave: '../../sis_cuenta_documentada/control/CuentaDoc/insertarCuentaDocRendicion',
	ActDel: '../../sis_cuenta_documentada/control/CuentaDoc/eliminarCuentaDocRendicion',
	ActList: '../../sis_cuenta_documentada/control/CuentaDoc/listarCuentaDocRendicion',
	
	gruposBarraTareas : [{
			name : 'borrador',
			title : '<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>',
			grupo : 0,
			height : 0
		}, {
			name : 'validacion',
			title : '<H1 align="center"><i class="fa fa-eye"></i> En Validación</h1>',
			grupo : 1,
			height : 0
		},{
			name : 'finalizados',
			title : '<H1 align="center"><i class="fa fa-file-o"></i> Rendidos</h1>',
			grupo : 3,
			height : 0
		}],
	
	beditGroups : [0],
	bactGroups : [0, 1, 2, 3],
	btestGroups : [0],
	bexcelGroups : [0, 1, 2, 3],
		
	constructor: function(config) {
		
	   this.Atributos[this.getIndAtributo('id_cuenta_doc_fk')].form = true;
	   this.Atributos[this.getIndAtributo('id_funcionario')].form = false;
	   this.Atributos[this.getIndAtributo('id_depto')].form = false; 
	   this.Atributos[this.getIndAtributo('id_moneda')].form = false; 
	   this.Atributos[this.getIndAtributo('tipo_pago')].form = false; 
	   this.Atributos[this.getIndAtributo('id_funcionario_cuenta_bancaria')].form = false; 
	   this.Atributos[this.getIndAtributo('nombre_cheque')].form = false; 
	   this.Atributos[this.getIndAtributo('importe')].config.qtip = 'Monto a rendir entre facturas y depositos';
	   
	   
	   Phx.vista.CuentaDocRen.superclass.constructor.call(this,config);
       this.init();
       
       this.addButton('onBtnRen', {
				grupo : [0,1,2,3],
				text : 'Reporte Rendición.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRendicion,
				tooltip : '<b>Reporte de rendición de gastos</b>'
		});
		
		
       this.store.baseParams = { estado : 'borrador',id_cuenta_doc: this.id_cuenta_doc, tipo_interfaz: this.nombreVista}; 
       this.load({params:{start:0, limit:this.tam_pag}});
       this.finCons = true;
		
   }, 
  
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
      Phx.vista.CuentaDocRen.superclass.preparaMenu.call(this,n);  
      if(data.estado == 'borrador' ){
          this.getBoton('ant_estado').disable();
          this.getBoton('sig_estado').enable();
      }
      else{
         this.getBoton('ant_estado').disable();
         this.getBoton('sig_estado').disable();
      }
      this.getBoton('btnChequeoDocumentosWf').setDisabled(false);
      this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnObs').enable(); 
            
      return tb;
   },
   
   
   
   
   
   loadValoresIniciales: function() {
    	
    	Phx.vista.CuentaDocRen.superclass.loadValoresIniciales.call(this);  
    	this.Cmp.id_cuenta_doc_fk.setValue(this.id_cuenta_doc);      
   },
   
   onBtnRendicion : function() {
			var rec = this.sm.getSelected();
			var data = rec.data;
			if (data) {
				Phx.CP.loadingShow();
				Ext.Ajax.request({
					url : '../../sis_cuenta_documentada/control/CuentaDoc/reporteRendicionFondos',
					params : {
						'id_proceso_wf' : data.id_proceso_wf
					},
					success : this.successExport,
					failure : this.conexionFailure,
					timeout : this.timeout,
					scope : this
				});
			}

	},
   
   tabsouth:[
	     {
	          url:'../../../sis_cuenta_documentada/vista/rendicion_det/RendicionDetReg.php',
	          title:'Facturas', 
	          height:'50%',
	          cls:'RendicionDetReg'
        },
        {
				url:'../../../sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php',
				title:'Depositos',
				height:'50%',
				cls:'CdDeposito'
		}
	   ],
    
    
   
    
};
</script>
