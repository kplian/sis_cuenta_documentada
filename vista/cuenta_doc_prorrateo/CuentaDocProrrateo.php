<?php
/**
*@package pXP
*@file gen-CuentaDocProrrateo.php
*@author  (admin)
*@date 05-12-2017 19:08:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocProrrateo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaDocProrrateo.superclass.constructor.call(this,config);
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
			
	Atributos:[
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc_prorrateo'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cuenta_doc'
			},
			type:'Field',
			form:true 
		},
		{
            config:{
                name: 'id_centro_costo',
                origen: 'CENTROCOSTO',
                allowBlank: true,
                fieldLabel: 'Centro de Costo',
                gdisplayField: 'desc_cc',//mapea al store del grid
                gwidth: 150,
                url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXUsuaio',
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_cc']);},
                baseParams:{filtrar:'grupo_ep'}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'cc.descripcion_tcc',type:'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'prorrateo',
				fieldLabel: 'Porcentaje (0 a 1)',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				allowDecimals: true,
				maxValue: 1,
				minValue: 0
			},
				type:'NumberField',
				filters:{pfiltro:'cdpro.prorrateo',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'cdpro.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cdpro.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cdpro.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'cdpro.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cdpro.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Prorrateo',
	ActSave:'../../sis_cuenta_documentada/control/CuentaDocProrrateo/insertarCuentaDocProrrateo',
	ActDel:'../../sis_cuenta_documentada/control/CuentaDocProrrateo/eliminarCuentaDocProrrateo',
	ActList:'../../sis_cuenta_documentada/control/CuentaDocProrrateo/listarCuentaDocProrrateo',
	id_store:'id_cuenta_doc_prorrateo',
	fields: [
		{name:'id_cuenta_doc_prorrateo', type: 'numeric'},
		{name:'id_cuenta_doc', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'prorrateo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_cc', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_cuenta_doc_prorrateo',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage: function(m) {
		this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_cuenta_doc;

        //Filtro para los datos
        this.store.baseParams = {
            id_cuenta_doc: this.maestro.id_cuenta_doc
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });

        //Habilitar/deshabilitar botones nuevo, edit, delete para los detalles. Habilita en estado borrador, en otro caso oculta
		this.getBoton('new').show();
		this.getBoton('edit').show();
		this.getBoton('del').show();
		this.getBoton('save').show();
		if(this.maestro.estado!='borrador'){
			this.getBoton('new').hide();
			this.getBoton('edit').hide();
			this.getBoton('del').hide();
			this.getBoton('save').hide();
		}

        //Seteo del base params para el centro de costo
        var time = new Date(this.maestro.fecha);

        //Obtiene el id gestion
        Ext.Ajax.request({
            url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
            params: {fecha: this.maestro.fecha},
            success: function(resp){
            	var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
        		Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: reg.datos.id_gestion});
				this.Cmp.id_centro_costo.modificado=true;
				this.Cmp.id_centro_costo.setValue('');
            },
            failure: function(resp) {
                 Phx.CP.conexionFailure(resp);
            },
            timeout: function() {
                Phx.CP.config_ini.timeout();
            },
            scope:this
        });
		
	}
})
</script>
		
		