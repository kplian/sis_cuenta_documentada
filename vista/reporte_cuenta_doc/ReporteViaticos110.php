<?php
/**
*@package pXP
*@file ReporteViaticos110
*@author  RCM
*@date 27/02/2018
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReporteViaticos110=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
		this.initButtons=[this.cmbDepto, this.cmbGestion, this.cmbPeriodo];
    	//Llama al constructor de la clase padre
		Phx.vista.ReporteViaticos110.superclass.constructor.call(this,config);
		this.init();

		this.cmbGestion.on('select', function(combo, record, index){
			this.tmpGestion = record.data.gestion;
		    this.cmbPeriodo.enable();
		    this.cmbPeriodo.reset();
		    this.store.removeAll();
		    this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
		    this.cmbPeriodo.modificado = true;
        },this);
        
        this.cmbPeriodo.on('select', function( combo, record, index){
			this.tmpPeriodo = record.data.periodo;
			this.capturaFiltros();
		    
        },this);
        
        this.cmbDepto.on('select', function( combo, record, index){
			this.capturaFiltros();
		    
        },this);

        //Botones para el reporte
        this.addButton('btnReporte',
        {
            text: 'Reporte',
            iconCls: 'bchecklist',
            handler: this.loadReporte,
            disabled: false,
            tooltip: '<b>Reporte Form.110</b><br/>Listado de viajes para el Form.110.'
        });
	},
			
	Atributos:[
    	{
          config:{
              labelSeparator:'',
              inputType:'hidden',
              name: 'id_funcionario'
          },
          type:'Field',
          form:true 
        },
        {
          config:{
            name: 'codigo',
            fieldLabel: 'Código Funcionario',
            allowBlank: false,
            anchor: '50%',
            gwidth: 100,
            maxLength:30
          },
          type:'TextField',
          filters:{pfiltro:'dcv.codigo',type:'string'},
          id_grupo:1,
          grid:true,
          form:true
        },
        {
          config:{
            name: 'desc_funcionario2',
            fieldLabel: 'Nombre funcionario',
            allowBlank: false,
            anchor: '50%',
            gwidth: 350,
            maxLength:30
          },
          type:'TextField',
          filters:{pfiltro:'pla.desc_funcionario2',type:'string'},
          id_grupo:1,
          grid:true,
          form:true
        },
        {
          config:{
            name: 'ci',
            fieldLabel: 'CI',
            allowBlank: false,
            anchor: '50%',
            gwidth: 100,
            maxLength:30
          },
          type:'TextField',
          id_grupo:1,
          grid:true,
          form:true
        },
        {
          config:{
            name: 'total',
            fieldLabel: 'Total',
            allowBlank: false,
            anchor: '50%',
            gwidth: 130,
            maxLength:30,
            /*renderer: function(value,p,record){
                return String.format("<b><font color='green'>TOTAL:</font> <u>{0}</u></b><br>"+
                                     "<font color='blue'>Con Cbte.:</font> {1}, <font color='red'>Sin Cbte.:</font> {2}<br>",value,record.data.con_cbte,record.data.sin_cbte);
            }*/
          },
          type:'TextField',
          id_grupo:1,
          grid:true,
          form:true
        },
         {
          config:{
            name: 'detalle_total',
            fieldLabel: 'Detalle Total',
            allowBlank: false,
            anchor: '50%',
            gwidth: 200,
            maxLength:30,
            renderer: function(value,p,record){
                return String.format("<font color='blue'>Con Cbte.:</font> {0}, <font color='red'>Sin Cbte.:</font> {1}<br>",record.data.con_cbte,record.data.sin_cbte);
            }
          },
          type:'TextField',
          id_grupo:1,
          grid:true,
          form:true
        },
        {
          config:{
            name: 'id_depto_conta',
            fieldLabel: 'Dpto.Contabilidad',
            allowBlank: false,
            anchor: '50%',
            gwidth: 100,
            maxLength:30,
            renderer: function(value,p,record){
                return String.format('{0}',record.data.desc_depto);
            }
          },
          type:'TextField',
          filters:{pfiltro:'dep.codigo#dep.nombre',type:'string'},
          id_grupo:1,
          grid:true,
          form:true
        }
	],
	tam_pag:50,	
	title:'Viáticos Form.110',
	ActList:'../../sis_cuenta_documentada/control/CuentaDoc/listarViaticosForm110',
	id_store:'id_funcionario',
	fields: [
		{name:'id_funcionario', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'desc_funcionario2', type: 'string'},
		{name:'ci', type: 'string'},
		{name:'total', type: 'numeric'},
        {name:'id_depto_conta', type: 'numeric'},
        {name:'desc_depto', type: 'string'},
        {name:'sin_cbte', type: 'numeric'},
        {name:'con_cbte', type: 'numeric'},
        {name:'id_periodo', type: 'numeric'}
	],
	sortInfo:{
		field: 'fun.desc_funcionario2',
		direction: 'ASC'
	},
	bdel: false,
	bsave: false,
	bnew: false,
	bedit: false,

	cmbDepto: new Ext.form.ComboBox({
        name: 'id_depto',
        fieldLabel: 'Depto',
        blankText: 'Depto',
        typeAhead: false,
        forceSelection: true,
        allowBlank: false,
        disableSearchButton: true,
        emptyText: 'Depto Contable',
        store: new Ext.data.JsonStore({
            url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
            id: 'id_depto',
			root: 'datos',
			sortInfo:{
				field: 'deppto.nombre',
				direction: 'ASC'
			},
			totalProperty: 'total',
			fields: ['id_depto','nombre','codigo'],
			// turn on remote sorting
			remoteSort: true,
			baseParams: { par_filtro:'deppto.nombre#deppto.codigo', estado:'activo', codigo_subsistema: 'CONTA', _adicionar : 'si'}
        }),
        valueField: 'id_depto',
			displayField: 'nombre',
			hiddenName: 'id_depto',
        enableMultiSelect: true,
        triggerAction: 'all',
        lazyRender: true,
        mode: 'remote',
        pageSize: 20,
        queryDelay: 200,
        anchor: '80%',
        listWidth:'280',
        resizable:true,
        minChars: 2
    }),
    
	cmbGestion: new Ext.form.ComboBox({
		fieldLabel: 'Gestion',
		allowBlank: false,
		emptyText:'Gestion...',
		blankText: 'Año',
		store:new Ext.data.JsonStore(
		{
			url: '../../sis_parametros/control/Gestion/listarGestion',
			id: 'id_gestion',
			root: 'datos',
			sortInfo:{
				field: 'gestion',
				direction: 'DESC'
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
	
	
    cmbPeriodo: new Ext.form.ComboBox({
		fieldLabel: 'Periodo',
		allowBlank: false,
		blankText : 'Mes',
		emptyText:'Periodo...',
		store:new Ext.data.JsonStore(
		{
			url: '../../sis_parametros/control/Periodo/listarPeriodo',
			id: 'id_periodo',
			root: 'datos',
			sortInfo:{
				field: 'periodo',
				direction: 'ASC'
			},
			totalProperty: 'total',
			fields: ['id_periodo','periodo','id_gestion','literal'],
			// turn on remote sorting
			remoteSort: true,
			baseParams:{par_filtro:'gestion'}
		}),
		valueField: 'id_periodo',
		triggerAction: 'all',
		displayField: 'literal',
	    hiddenName: 'id_periodo',
		mode:'remote',
		pageSize:50,
		disabled: true,
		queryDelay:500,
		listWidth:'280',
		width:80
	}),

	capturaFiltros:function(combo, record, index){
        this.desbloquearOrdenamientoGrid();
        this.store.baseParams.nombre_vista = this.nombreVista;
        if(this.validarFiltros()){
        	this.store.baseParams.id_gestion = this.cmbGestion.getValue();
	        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
	        this.store.baseParams.id_depto = this.cmbDepto.getValue();
	        this.load(); 
        }
        
    },

    validarFiltros:function(){
        if(this.cmbDepto.getValue() && this.cmbGestion.validate() && this.cmbPeriodo.validate()){
            this.desbloquearOrdenamientoGrid();
            return true;
        }
        else{
            this.bloquearOrdenamientoGrid();
            return false;
        }
    },

    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Debe especificar año y mes previamente')
         }
        else{
            this.store.baseParams.id_gestion=this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.store.baseParams.id_depto = this.cmbDepto.getValue();
            this.store.baseParams.nombre_vista = this.nombreVista;
            Phx.vista.ReporteViaticos110.superclass.onButtonAct.call(this);
        }
    },

    south: {
        url: '../../../sis_cuenta_documentada/vista/reporte_cuenta_doc/ReporteViaticos110Det.php',
        title: 'Detalle Viátios Form.110',
        height: '40%',
        cls: 'ReporteViaticos110Det'
    },

    loadReporte: function() {

        if(!this.validarFiltros()){
            alert('Debe especificar año y mes previamente')
        } else {

            var rec = this.sm.getSelected();
            Ext.MessageBox.alert('Información','Este reporte solamente incluye a los Recibos Sin Retención de Viáticos que tienen asociado al Funcionario y tienen su Comprobante Validado');

            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_cuenta_documentada/control/CuentaDoc/reporteViaticosForm110',
                params: {
                    id_periodo: this.cmbPeriodo.getValue(),
                    id_depto: this.cmbDepto.getValue(),
                    tipo: 'oficial',
                    sort: 'dcv.id_funcionario',
                    dir:'ASC',
                    start: 0,
                    limit: 10000
                },
                success: this.successExport,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });

        }



    }

})
</script>