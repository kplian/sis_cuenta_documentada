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
Phx.vista.CuentaDocConsulta = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
	requireclase:'Phx.vista.CuentaDoc',
	title:'Cuenta Documentada',
	nombreVista: 'CuentaDocConsulta',
	ActList:'../../sis_cuenta_documentada/control/CuentaDoc/listarCuentaDocConsulta',
	bactGroups : [0, 1, 2, 3,4],
	bexcelGroups : [0, 1, 2, 3,4],
	
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
		}, {
			name : 'entregados',
			title : '<H1 align="center"><i class="fa fa-eye"></i> Entregados</h1>',
			grupo : 2,
			height : 0
		}, {
			name : 'rendiciones',
			title : '<H1 align="center"><i class="fa fa-eye"></i> Rendiciones</h1>',
			grupo : 2,
			height : 0
		}, {
			name : 'finalizados',
			title : '<H1 align="center"><i class="fa fa-file-o"></i> Finalizados</h1>',
			grupo : 3,
			height : 0
		}],
	
	constructor: function(config) {
		
		this.tbarItems = ['-',
        				  {xtype: 'label',text: 'Gestión:'},
        				  this.cmbGestion,'-'];
		
		
	   this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
				    var saldo = value - record.data.importe_documentos - record.data.importe_depositos;
					if (record.data.estado == 'contabilizado') {
						return String.format("<b><font color = 'red'>Entregado: {0}</font></b><br>"+
											 "<b><font color = 'green'>En Facturas:{1}</font></b><br>"+
											 "<b><font color = 'green'>En Depositos:{2}</font></b><br>"+
											 "<b><font color = 'orange'>Retenciones de Ley:{3}</font></b><br>"+
											 "<b><font color = 'blue' >Saldo:{4}</font></b>", value, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones, saldo );
					} 
					else {
						return String.format('<font>Solicitado: {0}</font>', value);
					}

			};
	   
	   this.Atributos[this.getIndAtributo('sw_max_doc_rend')].grid = true;
	   
	   Phx.vista.CuentaDocConsulta.superclass.constructor.call(this,config);
       this.init();
       
       this.addButton('onBtnRepSol', {
				grupo : [0,1,2,3],
				text : 'Reporte Sol.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepSol,
				tooltip : '<b>Reporte de solicitud de fondos</b>'
		});
		
		this.addButton('onBtnRen', {
				grupo : [0,1,2,3],
				text : 'Reporte Rendición.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRendicion,
				tooltip : '<b>Reporte de rendición de gastos</b>'
		});
		
		this.addButton('onBtnRepRenCon', {
				grupo : [0,1,2,3],
				text : 'Rendición Consolidada',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepRenCon,
				tooltip : '<b>Reporte de redición consolidada</b>'
		 });
		 
		 this.addButton('onBtnAmpRen', {
				grupo : [0,1,2,3],
				text : 'Ampliar Días',
				iconCls : 'blist',
				disabled : false,
				handler : this.onBtnAmpRen,
				tooltip : '<b>Agergar días para rendir</b><br>permite  sumar o restar días al limite de rendición indicado por la columna "Lim Rend"'
		 });
		 
		 this.addButton('onSwBloq', {
				grupo : [0,1,2,3],
				text : 'Cambio Bloqueo',
				iconCls : 'blist',
				disabled : false,
				handler : this.onSwBloq,
				tooltip : '<b>Cambia el estado del bloqueo para facturas grandes</b> <BR>NO = no permite facturas grandes <br>SI = permite facturas grandes mayores a 20 000 BS'
		 });
		 
		this.store.baseParams = { estado : 'borrador',tipo_interfaz: this.nombreVista };
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
    			mode:'remote',
				pageSize:50,
				queryDelay:500,
				listWidth:'280',
				width:80
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
      Phx.vista.CuentaDocConsulta.superclass.preparaMenu.call(this,n); 
      this.getBoton('chkpresupuesto').enable();  
      this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnObs').enable();     
      this.getBoton('btnChequeoDocumentosWf').enable();
      
      if(data.sw_solicitud == 'si'){
      	this.getBoton('onBtnRepSol').enable();
      	this.getBoton('onBtnRen').disable(); 
      	this.getBoton('onBtnRepRenCon').enable();  
      }
      else{
      	this.getBoton('onBtnRepSol').disable();
      	this.getBoton('onBtnRen').enable(); 
      	this.getBoton('onBtnRepRenCon').disable();   
      }
      
      if(data.sw_solicitud == 'si' && data.estado == 'contabilizado'){
        this.getBoton('onBtnAmpRen').enable();   
      }
      else{
        this.getBoton('onBtnAmpRen').disable();   
      }
      
      if(data.sw_solicitud == 'no' ){
        this.getBoton('onSwBloq').enable();   
      }
      else{
        this.getBoton('onSwBloq').disable();   
      } 
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.CuentaDocConsulta.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('onBtnRepSol').disable(); 
            this.getBoton('onSwBloq').disable(); 
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
	
	onSwBloq : function() {   		
   		var rec = this.sm.getSelected();
			var data = rec.data;
			if(data && data.sw_solicitud  == 'no'){
				
   	        	Phx.CP.loadingShow(); 
			   	        Ext.Ajax.request({
							url : '../../sis_cuenta_documentada/control/CuentaDoc/cambiarBloqueo',
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
