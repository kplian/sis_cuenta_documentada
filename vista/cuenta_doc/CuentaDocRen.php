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
	   	var me = this;
	   	this.maestro = config;
		
	   	this.Atributos[this.getIndAtributo('id_cuenta_doc_fk')].form = true;
	   	this.Atributos[this.getIndAtributo('id_funcionario')].form = false;
	   	this.Atributos[this.getIndAtributo('id_depto')].form = false; 
	   	this.Atributos[this.getIndAtributo('id_moneda')].form = false;
		this.Atributos[this.getIndAtributo('id_tipo_cuenta_doc')].form = false;
	   	this.Atributos[this.getIndAtributo('tipo_pago')].form = false; 
	   	this.Atributos[this.getIndAtributo('id_funcionario_cuenta_bancaria')].form = false; 
	   	this.Atributos[this.getIndAtributo('nombre_cheque')].form = false; 
	   	this.Atributos[this.getIndAtributo('importe')].config.qtip = 'Monto a rendir entre facturas y depositos';
	   	this.Atributos[this.getIndAtributo('nro_correspondencia')].form = true;
	   	this.Atributos[this.getIndAtributo('nro_correspondencia')].grid = true;
	   	this.Atributos[this.getIndAtributo('motivo')].config.qtip = 'Motivo de rendición';
	   	this.Atributos[this.getIndAtributo('motivo')].config.fieldLabel = 'Motivo';
	   	this.Atributos[this.getIndAtributo('importe')].form = false;
		this.Atributos[this.getIndAtributo('id_periodo')].form = true;
		this.Atributos[this.getIndAtributo('id_periodo')].grid = true;
		this.Atributos[this.getIndAtributo('tipo_rendicion')].form = true; 
		this.Atributos[this.getIndAtributo('tipo_rendicion')].grid = true; 
		this.Atributos[this.getIndAtributo('tipo_rendicion')].config.allowBlank = false; 

	   	this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
				    var  saldo =  me.roundTwo(record.data.importe_documentos) + me.roundTwo(record.data.importe_depositos) -  me.roundTwo(record.data.importe_retenciones);
				    saldo = me.roundTwo(saldo);
				    
				    if (record.data.estado != 'rendido') {
						
						var saldo_final = record.data.importe_solicitado - record.data.importe_total_rendido - saldo;
				        saldo_final = me.roundTwo(saldo_final);
						
						return String.format("<b><font color = 'red' >Solicitado: {0}</font></b><br>"+
											 "<b><font color = 'green' >En Documentos: {1}</font></b><br>"+
											 "<b><font color = 'green' >En Depositos: {2}</font></b><br>"+
											 "<b><font color = 'orange' >Retenciones de Ley: {3}</font></b><br>"+
											 "<b><font color = 'blue' >Monto a rendir: {4}</font></b><br>"+
											 "<b><font color = 'blue' >Otras Rendiciones: {5}</font></b><br>"+
											 "<b><font color = 'red' >Saldo: {6}</font></b>",  record.data.importe_solicitado, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones, saldo, record.data.importe_total_rendido, saldo_final );
					}
					else{
						
						var saldo_final = record.data.importe_solicitado - record.data.importe_total_rendido;
				        saldo_final = me.roundTwo(saldo_final);
						return String.format("<b><font color = 'red' >Solicitado: {0}</font></b><br>"+
										 "<b><font color = 'green' >En Documentos: {1}</font></b><br>"+
										 "<b><font color = 'green' >En Depositos: {2}</font></b><br>"+
										 "<b><font color = 'orange' >Retenciones de Ley: {3}</font></b><br>"+
										 "<b><font color = 'blue' >Monto a rendido: {4}</font></b><br>"+
										 "<b><font color = 'blue' >Total Rendido: {5}</font></b><br>"+
										 "<b><font color = 'red' >Saldo: {6}</font></b>",  record.data.importe_solicitado, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones, saldo, record.data.importe_total_rendido, saldo_final );
				
					
					}	

			};

			if(this.maestro.codigo_tipo_cuenta_doc=='SOLVIA'){
				this.Atributos[this.getIndAtributo('id_plantilla')].grid = true;
				this.Atributos[this.getIndAtributo('id_plantilla')].form = true;
				this.Atributos[this.getIndAtributo('id_plantilla')].config.allowBlank = false;	
			}
			
	   
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
	   this.iniciarEventos();
       this.finCons = true;

       	//Desactiva tab Itinerarios si no es rendición de viáticos
		this.TabPanelSouth.getItem(this.idContenedor + '-south-0').setDisabled(true);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(true);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(true);
		this.TabPanelSouth.getItem(this.idContenedor + '-south-4').setDisabled(true);

		if(config.codigo_tipo_cuenta_doc=='SOLVIA'){
			this.TabPanelSouth.getItem(this.idContenedor + '-south-0').setDisabled(false);
			this.TabPanelSouth.getItem(this.idContenedor + '-south-1').setDisabled(false);
			this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(false);
		}
		//Oculta/Muestra componentes
		this.ocultarMostrarComp(config.codigo_tipo_cuenta_doc,true);

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
      this.getBoton('chkpresupuesto').enable();  
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

	  if(this.dias_para_rendir < 0 ){
		  this.disableTabFacturasDepositos();
	  }else{
		  this.enableTabFacturasDepositos();
	  }
            
      return tb;
   },

	iniciarEventos:function(){
		console.log('EL COMBO DE FECHA',this.Cmp.fecha.getValue());
		this.Cmp.fecha.on('select', function (calendar, newValue, oldValue) {
			var fecha = new Date(newValue);
			this.setGestionPeriodo(fecha);
		}, this);

	},

	setGestionPeriodo: function(x){
		if(Ext.isDate(x)){
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
				params:{fecha: x},
				success:this.successGestion,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});	
		} else {
			Ext.apply(this.Cmp.id_periodo.store.baseParams,{id_gestion: -1});
			this.Cmp.id_periodo.setDisabled(false);
			this.Cmp.id_periodo.modificado = true;
			this.Cmp.id_periodo.setValue('');	
		}
	},
	onButtonEdit:function(){
		Phx.vista.CuentaDocRen.superclass.onButtonEdit.call(this);
		this.Cmp.fecha.fireEvent('change');
	},

	successGestion: function(resp){
		Phx.CP.loadingHide();
		console.log('si entra antes');
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		if(!reg.ROOT.error){
			var id_gestion = reg.ROOT.datos.id_gestion;
			//Setea los stores de partida, cuenta, etc. con la gestion obtenida
			Ext.apply(this.Cmp.id_periodo.store.baseParams,{id_gestion: id_gestion});
			this.Cmp.id_periodo.setDisabled(false);
			this.Cmp.id_periodo.modificado = true;
			this.Cmp.id_periodo.setValue('');

		} else {
			Ext.apply(this.Cmp.id_periodo.store.baseParams,{id_gestion: -1});
			this.Cmp.id_periodo.setDisabled(false);
			this.Cmp.id_periodo.modificado = true;
			this.Cmp.id_periodo.setValue('');
			alert('Error al obtener la gestión. Cierre y vuelva a intentarlo')
		}
	},
	disableTabFacturasDepositos:function(){
		//RCM 05/12/2017: comentado temporalemente
		/*if(this.TabPanelSouth.get(0)){
			this.TabPanelSouth.get(0).disable();
		}
		if(this.TabPanelSouth.get(1)){
			this.TabPanelSouth.get(1).disable();
		}*/
	},

	enableTabFacturasDepositos:function(){
		//RCM 05/12/2017: comentado temporalemente
		/*if(this.TabPanelSouth.get(0)){
			this.TabPanelSouth.get(0).enable();
		}
		if(this.TabPanelSouth.get(1)){
			this.TabPanelSouth.get(1).enable();
		}*/
	},
   
   
   loadValoresIniciales: function() {
    	
    	Phx.vista.CuentaDocRen.superclass.loadValoresIniciales.call(this);  
    	this.Cmp.id_cuenta_doc_fk.setValue(this.id_cuenta_doc);      
   },
   
   onButtonNew : function() {   
			Phx.vista.CuentaDocRen.superclass.onButtonNew.call(this);
			this.Cmp.motivo.setValue(this.motivo);
   },
   
	tabsouth: [
		{
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_prorrateo/CuentaDocProrrateo.php',
            title: 'Prorrateo',
            height: '40%',
            cls: 'CuentaDocProrrateo'
        },
        {
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_itinerario/CuentaDocItinerario.php',
            title: 'Itinerario',
            height: '40%',
            cls: 'CuentaDocItinerario'
        },
        {
            url: '../../../sis_cuenta_documentada/vista/cuenta_doc_calculo/CuentaDocCalculo.php',
            title: 'Cálculo de Viáticos',
            height: '40%',
            cls: 'CuentaDocCalculo'
        }, 
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
	ocultarMostrarComp: function(codigoPadre,limpiar=false){
		//Oculta los componentes del viático por defecto
		this.Cmp.fecha_salida.hide();
		this.Cmp.hora_salida.hide();
		this.Cmp.fecha_llegada.hide();
		this.Cmp.hora_llegada.hide();
		this.Cmp.cobertura.hide();

		this.Cmp.fecha_salida.allowBlank = true;
		this.Cmp.hora_salida.allowBlank = true;
		this.Cmp.fecha_llegada.allowBlank = true;
		this.Cmp.hora_llegada.allowBlank = true;
		this.Cmp.cobertura.allowBlank = true;

		this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(true);

		if(limpiar){
			this.Cmp.fecha_salida.setValue('');
			this.Cmp.hora_salida.setValue('');
			this.Cmp.fecha_llegada.setValue('');
			this.Cmp.hora_llegada.setValue('');
			this.Cmp.cobertura.setValue('');
		}

		if(codigoPadre=='SOLVIA') {
			this.Cmp.fecha_salida.show();
			this.Cmp.hora_salida.show();
			this.Cmp.fecha_llegada.show();
			this.Cmp.hora_llegada.show();
			this.Cmp.cobertura.show();

			this.Cmp.fecha_salida.allowBlank = false;
			this.Cmp.hora_salida.allowBlank = false;
			this.Cmp.fecha_llegada.allowBlank = false;
			this.Cmp.hora_llegada.allowBlank = false;
			this.Cmp.cobertura.allowBlank = false;

			this.TabPanelSouth.getItem(this.idContenedor + '-south-2').setDisabled(false);
		}
	},
	sigEstado:function(){                   
      	var rec=this.sm.getSelected();
      	//Verificacion de cantidad de documentos registrados
      	Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_cuenta_documentada/control/CuentaDoc/cuentaDocumentosRendicion',
			params:{id_cuenta_doc: rec.data.id_cuenta_doc},
			success:this.successCuentaDoc,
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});
      	
     },
     successCuentaDoc: function(resp){
     	var rec=this.sm.getSelected();
     	Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		//Si no tiene documentos registrados pregunta si quiere seguir
		if(reg.ROOT.datos.total_docs<=0) {
			Ext.MessageBox.confirm('Descargos no registrados','La rendición seleccionada no tiene registrado ningún documento de descargo. ¿Está seguro de continuar y devolver la totalidad de los fondos entregados?', function(conf){
				if(conf=='yes'){
					this.mostrarWizard(rec);				
				}
			},this)
		} else {
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_cuenta_documentada/control/CuentaDoc/cuentaItinerarioRendicion',
				params:{id_cuenta_doc: rec.data.id_cuenta_doc},
				success: function(resp1){
					Phx.CP.loadingHide();
					var reg1 = Ext.util.JSON.decode(Ext.util.Format.trim(resp1.responseText));
					//Si no tiene itinerario registrado pregunta si quiere seguir
					if(reg1.ROOT.datos.total_itinerario<=0) {
						Ext.MessageBox.alert('Itinerario no registrado','Debe registrar el Itinerario del viaje realizado',this)
					} else {
						this.mostrarWizard(rec);
					}
				},
				failure: this.conexionFailure,
				timeout: this.timeout,
				scope: this
			});	

		}
     },
     onButtonNew:function(){
        Phx.vista.CuentaDoc.superclass.onButtonNew.call(this);
        Ext.apply(this.Cmp.id_periodo.store.baseParams,{id_gestion: -1});
		this.Cmp.id_periodo.setDisabled(false);
		this.Cmp.id_periodo.modificado = true;
		this.Cmp.id_periodo.setValue('');
    }
};
</script>
