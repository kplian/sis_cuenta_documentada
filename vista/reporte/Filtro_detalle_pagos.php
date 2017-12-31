<?php
/**
 *@package pXP
 *@file    GenerarLibroBancos.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    01-12-2014
 *@description Archivo con la interfaz para generaci�n de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Filtro_detalle_pagos = Ext.extend(Phx.frmInterfaz, {
		
		Atributos : [
	   	   {
				config:{
					name: 'desde',
					fieldLabel: 'Fecha inicio',
					allowBlank: true,
					format: 'd/m/Y',
					width : 250,
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  },
		  {
				config:{
					name: 'hasta',
					fieldLabel: 'Fecha fin',
					allowBlank: true,
					format: 'd/m/Y',
					width : 250,
				},
				type: 'DateField',
				id_grupo: 0,
				form: true
		  },
	      {
	            config:{
	                name:'id_funcionario',
	                origen:'FUNCIONARIO',
	                tinit:true,
	                fieldLabel:'Funcionario',
	                allowBlank:true,
	                valueField: 'id_funcionario',
	                gdisplayField:'desc_funcionario1',//mapea al store del grid
	                //anchor: '80%',
	                renderer:function (value, p, record){return String.format('{0}', record.data['desc_funcionario1']);},
	                width : 250,
	            },
	            type:'ComboRec',
	            id_grupo:0,
	            filters:{
	                pfiltro:'FUN.desc_funcionario1::varchar',
	                type:'string'
	            },
	
	            grid:true,
	            form:true
	       },
           {
                config:{
                    name: 'id_plantilla',
                    fieldLabel: 'Tipo Documento',
                    allowBlank: false,
                    emptyText:'Elija una plantilla...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                            id: 'id_plantilla',
                            root:'datos',
                            sortInfo:{
                                field:'desc_plantilla',
                                direction:'ASC'
                            },
                            totalProperty:'total',
                            fields: ['id_plantilla','nro_linea','desc_plantilla','tipo',
                                'sw_tesoro', 'sw_compro','sw_monto_excento','sw_descuento',
                                'sw_autorizacion','sw_codigo_control','tipo_plantilla','sw_nro_dui','sw_ic','tipo_excento','valor_excento','sw_qr','sw_nit','plantilla_qr',
                                'sw_estacion','sw_punto_venta','sw_codigo_no_iata'],
                            remoteSort: true,
                            baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
                        }),
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                    valueField: 'id_plantilla',
                    hiddenValue: 'id_plantilla',
                    displayField: 'desc_plantilla',
                    gdisplayField:'desc_plantilla',
                    listWidth:'280',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:20,
                    queryDelay:500,
                    minChars:2,
                    width : 250,
                },
                type:'ComboBox',
                id_grupo: 0,
                form: true
            },
		],
		
		
		title : 'Detalle pagos',		
		ActSave : '../../sis_presupuestos/control/MemoriaCalculo/reporteMemoriaCalculo',
		
		topBar : true,
		botones : false,
		labelSubmit : 'Generar',
		tooltipSubmit : '<b>Detalle de pagos</b>',
		
		constructor : function(config) {
			Phx.vista.Filtro_detalle_pagos.superclass.constructor.call(this, config);
			this.init();
			
		},
		

		
		tipo : 'reporte',
		clsSubmit : 'bprint',
		
		Grupos : [{
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Datos para el reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '500px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}],
		
	ActSave:'../../sis_cuenta_documentada/control/MemoriaCalculo/reporteMemoriaCalculo',
	timeout : 2500000,
	
	onSubmit: function(o, x, force){
		
                //arma una matriz de los identificadores de registros que se van a eliminar
                this.agregarArgsExtraSubmit();
                console.log("Cargar datos ",this.Cmp.id_plantilla.value);
     			var rec = {desde: this.Cmp.desde.value, hasta: this.Cmp.hasta.value, id_funcionario: this.Cmp.id_funcionario.value, id_plantilla: this.Cmp.id_plantilla.value}
                Phx.CP.loadWindows('../../../sis_cuenta_documentada/vista/reporte/DetallePagos.php',
                    'Lista detalle pagos',
                    {
                        width: 700,
                        height: 450
                    },
                    rec,
                    this.idContenedor,'DetallePagos');
           
	},

	successSave :function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if (reg.ROOT.error) {
            alert('error al procesar');
            return
       } 
       
       var nomRep = reg.ROOT.detalle.archivo_generado;
        if(Phx.CP.config_ini.x==1){  			
        	nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
        }
       
        if(this.Cmp.formato_reporte.getValue()=='pdf'){
        	window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
        }
        else{
        	window.open('../../../reportes_generados/'+nomRep+'?t='+new Date().toLocaleTimeString())
        }
       
	}
})
</script>