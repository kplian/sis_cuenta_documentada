<?php
/**
*@package pXP
*@file CuentaDocVbContaCentral.php
*@author  Gonzalo Sarmiento
*@date 17-08-2016
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a rendiciones desde la oficina Central
*
*/<?php
/**
*@package pXP
*@file CuentaDocVbContaCentral.php
*@author  Gonzalo Sarmiento
*@date 17-08-2016
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a rendiciones desde la oficina Central
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocVbContaCentral = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
    require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
    requireclase:'Phx.vista.CuentaDoc',
    title:'Cuenta Documentada',
    nombreVista: 'CuentaDocVbContaCentral',
    
    constructor: function(config) {
       
        //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Historico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }];
           
        var me = this;
        this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
                
                if (record.data.estado == 'vbrendicion') {
                    var  saldo = me.roundTwo(record.data.importe_documentos) + me.roundTwo(record.data.importe_depositos) -  me.roundTwo(record.data.importe_retenciones);
                    saldo = me.roundTwo(saldo);
                    return String.format("<b><font color = 'red'>Monto a Rendir: {0}</font></b><br>"+
                                         "<b><font color = 'green' >En Documentos:{1}</font></b><br>"+
                                         "<b><font color = 'green' >En Depositos:{2}</font></b><br>"+
                                         "<b><font color = 'orange' >Retenciones de Ley:{3}</font></b>", saldo, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones );
                } 
                else {
                    return String.format('<font>Solicitado: {0}</font>', value);
                }
                
                

        };

        //Se aumenta columna para la devolución
        this.Atributos.push({
            config:{
                name: 'devolucion',
                fieldLabel: 'Devolucion',
                allowBlank: false,
                anchor: '80%',
                gwidth: 200,
                renderer: function(value, p, record) {
                    return String.format("<b><font color = 'red'>Saldo: {0}</font></b><br>"+
                                         "<b><font color = 'green'>A favor de: {1}</font></b><br>"+
                                         "<b><font color = 'green'>Tipo: {2}</font></b><br>"+
                                         "<b><font color = 'green'>Nombre cheque: {3}</font></b><br>"+
                                         "<b><font color = 'orange'>Caja :{4}</font></b>", record.data.dev_saldo, record.data.dev_a_favor_de, record.data.dev_tipo, record.data.dev_nombre_cheque, record.data.dev_caja );
                }
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        });
       
        Phx.vista.CuentaDocVbContaCentral.superclass.constructor.call(this,config);
        this.init();
       
        this.addButton('onBtnRepSol', {
                grupo : [0,1,2,3],
                text : 'Reporte Sol.',
                iconCls : 'bprint',
                disabled : false,
                handler : this.onBtnRepSol,
                tooltip : '<b>Reporte de solicitud de fondos</b>'
        });
        
        this.addButton('onBtnMemo', {
                grupo : [0,1,2,3],
                text : 'Memo',
                iconCls : 'bprint',
                disabled : false,
                handler : this.onButtonMemoDesignacion,
                tooltip : '<b>Reporte de designación</b>'
        });

        this.addButton('btnSaldo', {
                grupo : [0,1,2,3],
                text : 'Devolucion/Reposicion',
                iconCls : 'bgear',
                disabled : true,
                handler : this.onButtonSaldo,
                tooltip : '<b>Devolucion/Reposicion para cierre de la cuenta documentada</b>'
        });
        
        
       
        this.store.baseParams = { tipo_interfaz: this.nombreVista };
        
        if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
        //primera carga
        this.store.baseParams.pes_estado = 'borrador';
        this.load({params:{start:0, limit:this.tam_pag}});
        
        
        
        this.finCons = true;

        //Crea ventana para devolución de saldos
        this.crearVentanaDevolucion();
   },
   
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.CuentaDoc.superclass.preparaMenu.call(this,n); cued
      this.getBoton('btnChequeoDocumentosWf').enable();
      this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnObs').enable();
      this.getBoton('chkpresupuesto').enable(); 
      
      if(this.sw_solicitud == 'si'){
        this.getBoton('onBtnRepSol').enable(); 
      }
      else{
        this.getBoton('onBtnRepSol').disable(); 
      }
      if(this.historico == 'no'){
          
         if(data.estado == 'anulado' || data.estado == 'finalizado' || data.estado == 'pendiente'|| data.estado == 'contabilizado'|| data.estado == 'rendido'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
         }
            
         if(data.estado != 'borrador' && data.estado !='anulado' && data.estado !='finalizado'&& data.estado !='pendiente' && data.estado !='contabilizado'&&data.estado != 'rendido'){
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
         }
         //Habilita boton de Devoluciones cuando dev_tipo sea vacío
         this.getBoton('btnSaldo').disable();
         if(!data.dev_tipo&&data.estado == 'vbrendicion'){
            this.getBoton('btnSaldo').enable();
         }
      }     
      else{
          this.desBotoneshistorico();
      }   
      return tb 
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.CuentaDoc.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('onBtnRepSol').disable(); 
            this.getBoton('btnSaldo').disable(); 
        }
        return tb
    },
    
    onButtonMemoDesignacion: function(){
                var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_cuenta_documentada/control/CuentaDoc/reporteMemoDesignacion',
                    params: {'id_proceso_wf':rec.data.id_proceso_wf},
                    success: this.successExport,
                    failure: function() {
                        alert("fail");
                    },
                    timeout: function() {
                        alert("timeout");
                    },
                    scope:this
                });
        },
        
     
    
   tabsouth:[
         {
              url:'../../../sis_cuenta_documentada/vista/rendicion_det/RendicionDetTes.php',
              title:'Facturas', 
              height:'50%',
              cls: 'RendicionDetTes'
         },
         {
              url: '../../../sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php',
              title: 'Depositos',
              height: '50%',
              cls: 'CdDeposito'
         }
       ],
    onButtonSaldo: function(){
        var rec=this.sm.getSelected();

        if(rec.data.tipo_rendicion=='parcial'){
            Ext.MessageBox.alert('Alerta','La Rendicion esta marcada como Parcial, aun no debe registrarse los datos de la Devolucion/Reposicion.');
            exit;
        }

        //Seteo baseparams de caja y cuenta bancaria
        Ext.apply(this.cmbCaja.store.baseParams, {id_moneda: rec.data.id_moneda});
        Ext.apply(this.cmbCuentaBancaria.store.baseParams, {id_moneda: rec.data.id_moneda});
        this.cmbCaja.setValue('');
        this.cmbCaja.modificado = true;
        this.cmbCuentaBancaria.setValue('');
        this.cmbCuentaBancaria.modificado = true;

        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/obtenerSaldoCuentaDoc',
            params: {'id_cuenta_doc':rec.data.id_cuenta_doc},
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                if(reg.datos.a_favor_de=='funcionario'){
                    //Verificación de opción de devolución en función del monto
                    if(reg.datos.por_caja=='si'){
                        //Abrir ventana para pedir datos de la caja y generar solicitud de efectivo a favor del funcionario
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['cheque','cheque'],['caja','caja']]}
                        );
                    } else {
                        //Por cheque: abrir ventana para pedir datos para generación del cheque a favor del funcionario
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['cheque','cheque']]}
                        );
                    }

                } else {
                    //'empresa'
                    //Verificación de opción de devolución en función del monto
                    if(reg.datos.por_caja=='si'){
                        //Abrir ventana para pedir datos de la caja y generar recibo de ingreso en caja
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['deposito','deposito'],['caja','caja']]}
                        );

                    } else {
                        //Habilitar tab para el registro del depósito
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['deposito','deposito']]}
                        );
                    }

                }

                //Seteo de variables del formulario
                this.txtAFavorDe.setValue(reg.datos.a_favor_de);
                this.txtSaldo.setValue(reg.datos.saldo);

                if(reg.datos.saldo==0){
                    this.cmbFormaDev.allowBlank=true;
                    this.cmbFormaDev.setDisabled(true);
                    this.cmbFormaDev.setValue('deposito');
                }

                this.abrirVentana();
            },
            failure: function(resp) {
                //alert("fail");
                Phx.CP.conexionFailure(resp);
            },
            timeout: function() {
                //alert("timeout");
                Phx.CP.config_ini.timeout();
            },
            scope:this
        });
    },
    crearVentanaDevolucion: function(){
        //Componentes
        this.txtAFavorDe = new Ext.form.TextField({
            name: 'txtAFavorDe',
            fieldLabel: 'Saldo a Favor de',
            readOnly: true
        });
        this.txtSaldo = new Ext.form.TextField({
            name: 'txtSaldo',
            fieldLabel: 'Saldo',
            readOnly: true
        });
        //Combo Forma de devolución
        this.cmbFormaDev = new Ext.form.ComboBox({
            name: 'cmbFormaDev',
            fieldLabel: 'Forma Devolucion',
            allowBlank: false,
            emptyText:'Seleccione una opcion ...',
            store: new Ext.data.ArrayStore({
                fields :['variable','valor'],
                data :  [['cheque','cheque'],['deposito','deposito'],['caja','caja']]}
            ),
            valueField: 'variable',
            displayField: 'valor',
            forceSelection: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'local',
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            width: 200,
            listWidth: 300
        });

        //Combo cajas
        this.cmbCaja = new Ext.form.ComboBox({
            name: 'id_caja',
            fieldLabel: 'Caja',
            allowBlank: true,
            emptyText: 'Elija una opcion...',
            store: new Ext.data.JsonStore({
                url: '../../sis_tesoreria/control/Caja/listarCaja',
                id: 'id_caja',
                root: 'datos',
                sortInfo: {
                    field: 'codigo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_caja', 'codigo', 'desc_moneda','id_depto','cajero'],
                remoteSort: true,
                baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'solicitudcaja', con_detalle:'no'}
            }),
            valueField: 'id_caja',
            displayField: 'codigo',
            gdisplayField: 'desc_caja',
            hiddenName: 'id_caja',
            forceSelection: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'remote',
            pageSize: 15,
            queryDelay: 1000,
            anchor: '100%',
            minChars: 2,
            tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>CAJERO: {cajero}</p></div></tpl>',
            renderer : function(value, p, record) {
                return String.format('{0}', record.data['codigo']);
            },
            hidden: true,
            width: 200
        });

        //Textfield nombre cheque
        this.txtNombreCheque = new Ext.form.Field({
            name: 'txtNombreCheque',
            fieldLabel: 'Nombre cheque',
            width: '100%',
            hidden: true
        });

        //Depto LB
        this.cmbDeptoLb = new Ext.form.ComboBox({
            name:'id_depto_lb',
            fieldLabel: 'Departamento Libro Bancos',
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/Depto/listarDepto',
                id: 'id_depto',
                root: 'datos',
                sortInfo:{
                    field: 'deppto.nombre',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_depto','nombre','codigo','prioridad'],
                // turn on remote sorting
                remoteSort: true,
                baseParams: { tipo_filtro: 'DEPTO_UO', estado:'activo', codigo_subsistema:'TES', modulo:'LB', id_depto_origen: 0}
            }),
            valueField: 'id_depto',
            displayField: 'nombre',
            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
            hiddenName: 'id_depto',
            forceSelection:true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender:true,
            mode:'remote',
            pageSize:10,
            queryDelay:1000,
            width:250,
            listWidth:'280',
            minChars:2,
            emptyText : 'Departamento Libro Bancos...',
            tinit:false,
            resizable:true,
            tasignacion:false,
            hidden: true,
            width: 200

        });
 
        //Combo cuenta bancaria
        this.cmbCuentaBancaria = new Ext.form.ComboBox({
            name: 'id_cuenta_bancaria',
            fieldLabel: 'Cuenta Bancaria',
            allowBlank: true,
            emptyText: 'Elija una opcion...',
            store: new Ext.data.JsonStore({
                url: '../../sis_tesoreria/control/DeptoCuentaBancaria/listarDeptoCuentaBancaria',
                id: 'id_depto_cuenta_bancaria',
                root: 'datos',
                sortInfo: {
                    field: 'id_depto',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_depto_cuenta_bancaria', 'id_cuenta_bancaria', 'denominacion','id_depto'],
                remoteSort: true,
                baseParams: {par_filtro: 'cb.denominacion'}
            }),
            valueField: 'id_cuenta_bancaria',
            displayField: 'denominacion',
            hiddenName: 'id_cuenta_bancaria',
            forceSelection: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'remote',
            pageSize: 15,
            queryDelay: 1000,
            anchor: '100%',
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['denominacion']);
            },
            hidden: true,
            width: 200
        });


        //Formulario
        this.frmDatos = new Ext.form.FormPanel({
            layout: 'form',
            items: [
                this.txtSaldo,this.txtAFavorDe,this.cmbFormaDev, this.cmbCaja, this.txtNombreCheque,this.cmbDeptoLb,this.cmbCuentaBancaria
            ],
            padding: this.paddingForm,
            bodyStyle: this.bodyStyleForm,
            border: this.borderForm,
            frame: this.frameForm, 
            autoScroll: false,
            autoDestroy: true,
            autoScroll: true,
            region: 'center'
        });

        //Window
        this.winDatos = new Ext.Window({
            width: 450,
            height: 200,
            modal: true,
            closeAction: 'hide',
            labelAlign: 'top',
            title: 'Devolucion/reposicion de Saldos',
            bodyStyle: 'padding:5px',
            layout: 'border',
            items: [this.frmDatos],
            buttons: [{
                text: 'Guardar',
                handler: function() {
                    this.guardarDevolucion();
                },
                scope: this},
                {
                text: 'Cerrar',
                handler: function() {
                    this.winDatos.hide();
                },
                scope: this
            }]
        });

        //Eventos
        this.cmbFormaDev.on('select', function(combo,record,index){
            var rec=this.sm.getSelected();

            //Inicialización
            this.cmbCaja.allowBlank = true;
            this.cmbCaja.setVisible(false);
            this.txtNombreCheque.allowBlank=true;
            this.txtNombreCheque.setVisible(false);
            this.cmbCuentaBancaria.allowBlank = true;
            this.cmbCuentaBancaria.setVisible(false);
            this.cmbDeptoLb.allowBlank = true;
            this.cmbDeptoLb.setVisible(false);

            //Lógica
            if(record.data.valor=='caja'){
                this.cmbCaja.allowBlank = false;
                this.cmbCaja.setVisible(true);
                //Reseteo de campos de cheque
                this.txtNombreCheque.setValue('');
                this.cmbCuentaBancaria.setValue('');
                this.cmbCuentaBancaria.selectedIndex=-1;
                this.cmbDeptoLb.setValue('');
                this.cmbDeptoLb.selectedIndex=-1;
            } else if(record.data.valor=='cheque'){
                this.txtNombreCheque.allowBlank=false;
                this.txtNombreCheque.setVisible(true);
                this.txtNombreCheque.setValue(rec.data.desc_funcionario);
                //Reseteo de campos de caja
                this.cmbCaja.setValue('');
                this.cmbCaja.selectedIndex=-1;

                this.cmbCuentaBancaria.allowBlank = false;
                this.cmbCuentaBancaria.setVisible(true);

                this.cmbDeptoLb.allowBlank = false;
                this.cmbDeptoLb.setVisible(true);
            } else {
                //Reseteo de campos de caja y cheque
                this.cmbCaja.setValue('');
                this.cmbCaja.selectedIndex=-1;
                this.txtNombreCheque.setValue('');
                this.cmbCuentaBancaria.setValue('');
                this.cmbCuentaBancaria.selectedIndex=-1;
                this.cmbDeptoLb.setValue('');
                this.cmbDeptoLb.selectedIndex=-1;
            }
        },this);

        //Libro bancos depto
        this.cmbDeptoLb.on('select',function(combo,record,index){
            Ext.apply(this.cmbCuentaBancaria.store.baseParams,{id_depto: record.data.id_depto});
            this.cmbCuentaBancaria.setValue('');
            this.cmbCuentaBancaria.modificado=true;
        },this);
    },

    abrirVentana: function(){
        var rec=this.sm.getSelected();

        if(this.txtSaldo.getValue()!=0){
            this.cmbFormaDev.setValue('');
        }
        this.txtNombreCheque.setValue('');
        this.cmbCaja.setValue('');
        this.cmbCaja.selectedIndex=-1;
        this.cmbCuentaBancaria.setValue('');
        this.cmbCuentaBancaria.selectedIndex=-1;

        this.cmbCaja.allowBlank = true;
        this.cmbCaja.setVisible(false);
        this.txtNombreCheque.allowBlank=true;
        this.txtNombreCheque.setVisible(false);
        this.cmbCuentaBancaria.allowBlank = true;
        this.cmbCuentaBancaria.setVisible(false);

        Ext.apply(this.cmbDeptoLb.store.baseParams,{id_depto_origen: rec.data.id_depto});

        this.winDatos.show();
    },
    guardarDevolucion: function(){
        var rec=this.sm.getSelected();
        var obj = {
            id_cuenta_doc: rec.data.id_cuenta_doc,
            dev_tipo: this.cmbFormaDev.getValue(),
            dev_a_favor_de: this.txtAFavorDe.getValue(),
            dev_nombre_cheque: this.txtNombreCheque.getValue(),
            id_caja_dev: this.cmbCaja.getValue(),
            dev_saldo: this.txtSaldo.getValue(),
            id_cuenta_bancaria: this.cmbCuentaBancaria.getValue(),
            id_depto_lb: this.cmbDeptoLb.getValue(),
        };

        if(obj.id_caja_dev==-1){
            obj.id_cuenta_doc=null;
        }

        if(obj.id_depto_lb==-1){
            obj.id_depto_lb=null;
        }

        if(!this.frmDatos.getForm().isValid()){
            return;
        }

        //Confirmación de generación de la devolución
        Ext.MessageBox.confirm('Confirmacion', 'Al generar la Devolucion/reposicion la Cuenta Documentada se cerrara y no podra incluir mas descargos. Esta seguro de continuar?',function(resp){
            if(resp=='yes'){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_cuenta_documentada/control/CuentaDoc/generarDevolucionCuentaDoc',
                    params: obj,
                    success: function(resp){
                        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                        this.reload();
                        this.winDatos.hide();
                        Phx.CP.loadingHide();
                        Ext.MessageBox.alert('Hecho',reg.datos.respuesta);
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
        },this);

    },
    sigEstado: function(){
        var rec=this.sm.getSelected();
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/obtenerSaldoCuentaDoc',
            params: {'id_cuenta_doc':rec.data.id_cuenta_doc},
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                //Si ya se definió la forma de devolución, hace las validaciones correspondientes antes de abrir el wizard
                console.log(reg.datos.tipo_rendicion)
                //Si la rendición es final obliga a que realice la introducción de datos de la Devolución/Reposición
                if(reg.datos.tipo_rendicion=='final'){
                    if(reg.datos.dev_tipo){
                        if(reg.datos.dev_tipo=='caja'||reg.datos.dev_tipo=='cheque'){
                            //Si es por caja o cheque abre directo el wizard
                            this.mostrarWizard(rec);
                        } else if(reg.datos.dev_tipo=='deposito'){
                            //Valida que se hayan registrado los depósitos
                            this.validaDepositos(rec,reg.datos);
                        } else {
                            Ext.MessageBox.alert('Alerta','La Rendicion esta marcada como Final. Registre los datos de la Devolucion/Reposicion para continuar.');    
                        } 
                    } else {
                        Ext.MessageBox.alert('Alerta','La Rendicion esta marcada como Final. Registre los datos de la Devolucion/Reposicion para continuar.');
                    }
                } else {
                    this.mostrarWizard(rec);
                }

                /*if(reg.datos.dev_tipo){
                    if(reg.datos.dev_tipo=='caja'||reg.datos.dev_tipo=='cheque'){
                        //Si es por caja o cheque abre directo el wizard
                        this.mostrarWizard(rec);
                    } else if(reg.datos.dev_tipo=='deposito'){
                        //Valida que se hayan registrado los depósitos
                        this.validaDepositos(rec,reg.datos);
                    } else {
                        Ext.MessageBox.alert('Alerta','Tipo de devolucion no valida ('+reg.datos.dev_tipo+')');
                    }
                } else {
                    this.mostrarWizard(rec);
                }*/
            },
            failure: function(resp) {
                Phx.CP.conexionFailure(resp);
            },
            timeout: function() {
                Phx.CP.config_ini.timeout();
            },
            scope:this
        });

    },
    validaDepositos: function(rec, obj){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/listarDepositoCuentaDoc',
            params: {'id_cuenta_doc': rec.data.id_cuenta_doc},
            success: function(resp){
                Phx.CP.loadingHide();
                var response = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).datos[0];
                console.log('resp',response);
                console.log(response.total_deposito,obj.saldo_parcial,response.total_deposito>=obj.saldo_parcial);
                if(1*response.total_deposito>=1*obj.saldo_parcial){
                    this.mostrarWizard(rec);
                } else {
                    var faltante = obj.saldo,
                        saldo = obj.saldo*1+response.total_deposito*1;
                    Ext.MessageBox.alert('Depositos faltantes','Falta registro de deposito por: '+faltante+'. Saldo total: '+saldo+'. Depositado: '+response.total_deposito);
                }

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

};
</script>

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaDocVbContaCentral = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_cuenta_documentada/vista/cuenta_doc/CuentaDoc.php',
	requireclase:'Phx.vista.CuentaDoc',
	title:'Cuenta Documentada',
	nombreVista: 'CuentaDocVbContaCentral',
	
	constructor: function(config) {
	   
	    //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Historico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }];
           
        var me = this;
		this.Atributos[this.getIndAtributo('importe')].config.renderer = function(value, p, record) {  
			    
				if (record.data.estado == 'vbrendicion') {
					var  saldo = me.roundTwo(record.data.importe_documentos) + me.roundTwo(record.data.importe_depositos) -  me.roundTwo(record.data.importe_retenciones);
			        saldo = me.roundTwo(saldo);
					return String.format("<b><font color = 'red'>Monto a Rendir: {0}</font></b><br>"+
										 "<b><font color = 'green' >En Documentos:{1}</font></b><br>"+
										 "<b><font color = 'green' >En Depositos:{2}</font></b><br>"+
										 "<b><font color = 'orange' >Retenciones de Ley:{3}</font></b>", saldo, record.data.importe_documentos, record.data.importe_depositos, record.data.importe_retenciones );
				} 
				else {
					return String.format('<font>Solicitado: {0}</font>', value);
				}
				
				

		};

        //Se aumenta columna para la devolución
        this.Atributos.push({
            config:{
                name: 'devolucion',
                fieldLabel: 'Devolucion',
                allowBlank: false,
                anchor: '80%',
                gwidth: 200,
                renderer: function(value, p, record) {
                    return String.format("<b><font color = 'red'>Saldo: {0}</font></b><br>"+
                                         "<b><font color = 'green'>A favor de: {1}</font></b><br>"+
                                         "<b><font color = 'green'>Tipo: {2}</font></b><br>"+
                                         "<b><font color = 'green'>Nombre cheque: {3}</font></b><br>"+
                                         "<b><font color = 'orange'>Caja :{4}</font></b>", record.data.dev_saldo, record.data.dev_a_favor_de, record.data.dev_tipo, record.data.dev_nombre_cheque, record.data.dev_caja );
                }
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        });
	   
	    Phx.vista.CuentaDocVbContaCentral.superclass.constructor.call(this,config);
        this.init();
       
        this.addButton('onBtnRepSol', {
				grupo : [0,1,2,3],
				text : 'Reporte Sol.',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onBtnRepSol,
				tooltip : '<b>Reporte de solicitud de fondos</b>'
		});
		
		this.addButton('onBtnMemo', {
				grupo : [0,1,2,3],
				text : 'Memo',
				iconCls : 'bprint',
				disabled : false,
				handler : this.onButtonMemoDesignacion,
				tooltip : '<b>Reporte de designación</b>'
		});

        this.addButton('btnSaldo', {
                grupo : [0,1,2,3],
                text : 'Devolucion/Reposicion',
                iconCls : 'bgear',
                disabled : true,
                handler : this.onButtonSaldo,
                tooltip : '<b>Devolucion/Reposicion para cierre de la cuenta documentada</b>'
        });
		
		
       
		this.store.baseParams = { tipo_interfaz: this.nombreVista };
		
		if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
		//primera carga
		this.store.baseParams.pes_estado = 'borrador';
    	this.load({params:{start:0, limit:this.tam_pag}});
    	
    	
		
		this.finCons = true;

        //Crea ventana para devolución de saldos
        this.crearVentanaDevolucion();
   },
   
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.CuentaDoc.superclass.preparaMenu.call(this,n); 
      this.getBoton('btnChequeoDocumentosWf').enable();
      this.getBoton('diagrama_gantt').enable();
      this.getBoton('btnObs').enable();
      this.getBoton('chkpresupuesto').enable(); 
      
      if(this.sw_solicitud == 'si'){
        this.getBoton('onBtnRepSol').enable(); 
      }
      else{
      	this.getBoton('onBtnRepSol').disable(); 
      }
      if(this.historico == 'no'){
          
         if(data.estado == 'anulado' || data.estado == 'finalizado' || data.estado == 'pendiente'|| data.estado == 'contabilizado'|| data.estado == 'rendido'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
         }
            
         if(data.estado != 'borrador' && data.estado !='anulado' && data.estado !='finalizado'&& data.estado !='pendiente' && data.estado !='contabilizado'&&data.estado != 'rendido'){
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
         }
         //Habilita boton de Devoluciones cuando dev_tipo sea vacío
         this.getBoton('btnSaldo').disable();
         if(!data.dev_tipo&&data.estado == 'vbrendicion'){
            this.getBoton('btnSaldo').enable();
         }
      }     
      else{
          this.desBotoneshistorico();
      }   
      return tb 
   },
   
   liberaMenu:function(){
        var tb = Phx.vista.CuentaDoc.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnObs').disable();
            this.getBoton('onBtnRepSol').disable(); 
            this.getBoton('btnSaldo').disable(); 
        }
        return tb
    },
    
    onButtonMemoDesignacion: function(){
                var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_cuenta_documentada/control/CuentaDoc/reporteMemoDesignacion',
                    params: {'id_proceso_wf':rec.data.id_proceso_wf},
                    success: this.successExport,
                    failure: function() {
                        alert("fail");
                    },
                    timeout: function() {
                        alert("timeout");
                    },
                    scope:this
                });
        },
        
     
    
   tabsouth:[
	     {
	          url:'../../../sis_cuenta_documentada/vista/rendicion_det/RendicionDetTes.php',
	          title:'Facturas', 
	          height:'50%',
	          cls: 'RendicionDetTes'
         },
         {
			  url: '../../../sis_cuenta_documentada/vista/rendicion_det/CdDeposito.php',
			  title: 'Depositos',
			  height: '50%',
			  cls: 'CdDeposito'
		 }
	   ],
    onButtonSaldo: function(){
        var rec=this.sm.getSelected();

        if(rec.data.tipo_rendicion=='parcial'){
            Ext.MessageBox.alert('Alerta','La Rendicion esta marcada como Parcial, aun no debe registrarse los datos de la Devolucion/Reposicion.');
            exit;
        }

        //Seteo baseparams de caja y cuenta bancaria
        Ext.apply(this.cmbCaja.store.baseParams, {id_moneda: rec.data.id_moneda});
        Ext.apply(this.cmbCuentaBancaria.store.baseParams, {id_moneda: rec.data.id_moneda});
        this.cmbCaja.setValue('');
        this.cmbCaja.modificado = true;
        this.cmbCuentaBancaria.setValue('');
        this.cmbCuentaBancaria.modificado = true;

        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/obtenerSaldoCuentaDoc',
            params: {'id_cuenta_doc':rec.data.id_cuenta_doc},
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                if(reg.datos.a_favor_de=='funcionario'){
                    //Verificación de opción de devolución en función del monto
                    if(reg.datos.por_caja=='si'){
                        //Abrir ventana para pedir datos de la caja y generar solicitud de efectivo a favor del funcionario
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['cheque','cheque'],['caja','caja']]}
                        );
                    } else {
                        //Por cheque: abrir ventana para pedir datos para generación del cheque a favor del funcionario
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['cheque','cheque']]}
                        );
                    }

                } else {
                    //'empresa'
                    //Verificación de opción de devolución en función del monto
                    if(reg.datos.por_caja=='si'){
                        //Abrir ventana para pedir datos de la caja y generar recibo de ingreso en caja
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['deposito','deposito'],['caja','caja']]}
                        );

                    } else {
                        //Habilitar tab para el registro del depósito
                        this.cmbFormaDev.store = new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  [['deposito','deposito']]}
                        );
                    }

                }

                //Seteo de variables del formulario
                this.txtAFavorDe.setValue(reg.datos.a_favor_de);
                this.txtSaldo.setValue(reg.datos.saldo);

                if(reg.datos.saldo==0){
                    this.cmbFormaDev.allowBlank=true;
                    this.cmbFormaDev.setDisabled(true);
                    this.cmbFormaDev.setValue('deposito');
                }

                this.abrirVentana();
            },
            failure: function(resp) {
                //alert("fail");
                Phx.CP.conexionFailure(resp);
            },
            timeout: function() {
                //alert("timeout");
                Phx.CP.config_ini.timeout();
            },
            scope:this
        });
    },
    crearVentanaDevolucion: function(){
        //Componentes
        this.txtAFavorDe = new Ext.form.TextField({
            name: 'txtAFavorDe',
            fieldLabel: 'Saldo a Favor de',
            readOnly: true
        });
        this.txtSaldo = new Ext.form.TextField({
            name: 'txtSaldo',
            fieldLabel: 'Saldo',
            readOnly: true
        });
        //Combo Forma de devolución
        this.cmbFormaDev = new Ext.form.ComboBox({
            name: 'cmbFormaDev',
            fieldLabel: 'Forma Devolucion',
            allowBlank: false,
            emptyText:'Seleccione una opcion ...',
            store: new Ext.data.ArrayStore({
                fields :['variable','valor'],
                data :  [['cheque','cheque'],['deposito','deposito'],['caja','caja']]}
            ),
            valueField: 'variable',
            displayField: 'valor',
            forceSelection: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'local',
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            width: 200,
            listWidth: 300
        });

        //Combo cajas
        this.cmbCaja = new Ext.form.ComboBox({
            name: 'id_caja',
            fieldLabel: 'Caja',
            allowBlank: true,
            emptyText: 'Elija una opcion...',
            store: new Ext.data.JsonStore({
                url: '../../sis_tesoreria/control/Caja/listarCaja',
                id: 'id_caja',
                root: 'datos',
                sortInfo: {
                    field: 'codigo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_caja', 'codigo', 'desc_moneda','id_depto','cajero'],
                remoteSort: true,
                baseParams: {par_filtro: 'caja.codigo', tipo_interfaz:'solicitudcaja', con_detalle:'no'}
            }),
            valueField: 'id_caja',
            displayField: 'codigo',
            gdisplayField: 'desc_caja',
            hiddenName: 'id_caja',
            forceSelection: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'remote',
            pageSize: 15,
            queryDelay: 1000,
            anchor: '100%',
            minChars: 2,
            tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b></p><p>CAJERO: {cajero}</p></div></tpl>',
            renderer : function(value, p, record) {
                return String.format('{0}', record.data['codigo']);
            },
            hidden: true,
            width: 200
        });

        //Textfield nombre cheque
        this.txtNombreCheque = new Ext.form.Field({
            name: 'txtNombreCheque',
            fieldLabel: 'Nombre cheque',
            width: '100%',
            hidden: true
        });

        //Depto LB
        this.cmbDeptoLb = new Ext.form.ComboBox({
            name:'id_depto_lb',
            fieldLabel: 'Departamento Libro Bancos',
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/Depto/listarDepto',
                id: 'id_depto',
                root: 'datos',
                sortInfo:{
                    field: 'deppto.nombre',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_depto','nombre','codigo','prioridad'],
                // turn on remote sorting
                remoteSort: true,
                baseParams: { tipo_filtro: 'DEPTO_UO', estado:'activo', codigo_subsistema:'TES', modulo:'LB', id_depto_origen: 0}
            }),
            valueField: 'id_depto',
            displayField: 'nombre',
            tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
            hiddenName: 'id_depto',
            forceSelection:true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender:true,
            mode:'remote',
            pageSize:10,
            queryDelay:1000,
            width:250,
            listWidth:'280',
            minChars:2,
            emptyText : 'Departamento Libro Bancos...',
            tinit:false,
            resizable:true,
            tasignacion:false,
            hidden: true,
            width: 200

        });
 
        //Combo cuenta bancaria
        this.cmbCuentaBancaria = new Ext.form.ComboBox({
            name: 'id_cuenta_bancaria',
            fieldLabel: 'Cuenta Bancaria',
            allowBlank: true,
            emptyText: 'Elija una opcion...',
            store: new Ext.data.JsonStore({
                url: '../../sis_tesoreria/control/DeptoCuentaBancaria/listarDeptoCuentaBancaria',
                id: 'id_depto_cuenta_bancaria',
                root: 'datos',
                sortInfo: {
                    field: 'id_depto',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_depto_cuenta_bancaria', 'id_cuenta_bancaria', 'denominacion','id_depto'],
                remoteSort: true,
                baseParams: {par_filtro: 'cb.denominacion'}
            }),
            valueField: 'id_cuenta_bancaria',
            displayField: 'denominacion',
            hiddenName: 'id_cuenta_bancaria',
            forceSelection: true,
            typeAhead: false,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'remote',
            pageSize: 15,
            queryDelay: 1000,
            anchor: '100%',
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['denominacion']);
            },
            hidden: true,
            width: 200
        });


        //Formulario
        this.frmDatos = new Ext.form.FormPanel({
            layout: 'form',
            items: [
                this.txtSaldo,this.txtAFavorDe,this.cmbFormaDev, this.cmbCaja, this.txtNombreCheque,this.cmbDeptoLb,this.cmbCuentaBancaria
            ],
            padding: this.paddingForm,
            bodyStyle: this.bodyStyleForm,
            border: this.borderForm,
            frame: this.frameForm, 
            autoScroll: false,
            autoDestroy: true,
            autoScroll: true,
            region: 'center'
        });

        //Window
        this.winDatos = new Ext.Window({
            width: 450,
            height: 200,
            modal: true,
            closeAction: 'hide',
            labelAlign: 'top',
            title: 'Devolucion/reposicion de Saldos',
            bodyStyle: 'padding:5px',
            layout: 'border',
            items: [this.frmDatos],
            buttons: [{
                text: 'Guardar',
                handler: function() {
                    this.guardarDevolucion();
                },
                scope: this},
                {
                text: 'Cerrar',
                handler: function() {
                    this.winDatos.hide();
                },
                scope: this
            }]
        });

        //Eventos
        this.cmbFormaDev.on('select', function(combo,record,index){
            var rec=this.sm.getSelected();

            //Inicialización
            this.cmbCaja.allowBlank = true;
            this.cmbCaja.setVisible(false);
            this.txtNombreCheque.allowBlank=true;
            this.txtNombreCheque.setVisible(false);
            this.cmbCuentaBancaria.allowBlank = true;
            this.cmbCuentaBancaria.setVisible(false);
            this.cmbDeptoLb.allowBlank = true;
            this.cmbDeptoLb.setVisible(false);

            //Lógica
            if(record.data.valor=='caja'){
                this.cmbCaja.allowBlank = false;
                this.cmbCaja.setVisible(true);
                //Reseteo de campos de cheque
                this.txtNombreCheque.setValue('');
                this.cmbCuentaBancaria.setValue('');
                this.cmbCuentaBancaria.selectedIndex=-1;
                this.cmbDeptoLb.setValue('');
                this.cmbDeptoLb.selectedIndex=-1;
            } else if(record.data.valor=='cheque'){
                this.txtNombreCheque.allowBlank=false;
                this.txtNombreCheque.setVisible(true);
                this.txtNombreCheque.setValue(rec.data.desc_funcionario);
                //Reseteo de campos de caja
                this.cmbCaja.setValue('');
                this.cmbCaja.selectedIndex=-1;

                this.cmbCuentaBancaria.allowBlank = false;
                this.cmbCuentaBancaria.setVisible(true);

                this.cmbDeptoLb.allowBlank = false;
                this.cmbDeptoLb.setVisible(true);
            } else {
                //Reseteo de campos de caja y cheque
                this.cmbCaja.setValue('');
                this.cmbCaja.selectedIndex=-1;
                this.txtNombreCheque.setValue('');
                this.cmbCuentaBancaria.setValue('');
                this.cmbCuentaBancaria.selectedIndex=-1;
                this.cmbDeptoLb.setValue('');
                this.cmbDeptoLb.selectedIndex=-1;
            }
        },this);

        //Libro bancos depto
        this.cmbDeptoLb.on('select',function(combo,record,index){
            Ext.apply(this.cmbCuentaBancaria.store.baseParams,{id_depto: record.data.id_depto});
            this.cmbCuentaBancaria.setValue('');
            this.cmbCuentaBancaria.modificado=true;
        },this);
    },

    abrirVentana: function(){
        var rec=this.sm.getSelected();

        if(this.txtSaldo.getValue()!=0){
            this.cmbFormaDev.setValue('');
        }
        this.txtNombreCheque.setValue('');
        this.cmbCaja.setValue('');
        this.cmbCaja.selectedIndex=-1;
        this.cmbCuentaBancaria.setValue('');
        this.cmbCuentaBancaria.selectedIndex=-1;

        this.cmbCaja.allowBlank = true;
        this.cmbCaja.setVisible(false);
        this.txtNombreCheque.allowBlank=true;
        this.txtNombreCheque.setVisible(false);
        this.cmbCuentaBancaria.allowBlank = true;
        this.cmbCuentaBancaria.setVisible(false);

        Ext.apply(this.cmbDeptoLb.store.baseParams,{id_depto_origen: rec.data.id_depto});

        this.winDatos.show();
    },
    guardarDevolucion: function(){
        var rec=this.sm.getSelected();
        var obj = {
            id_cuenta_doc: rec.data.id_cuenta_doc,
            dev_tipo: this.cmbFormaDev.getValue(),
            dev_a_favor_de: this.txtAFavorDe.getValue(),
            dev_nombre_cheque: this.txtNombreCheque.getValue(),
            id_caja_dev: this.cmbCaja.getValue(),
            dev_saldo: this.txtSaldo.getValue(),
            id_cuenta_bancaria: this.cmbCuentaBancaria.getValue(),
            id_depto_lb: this.cmbDeptoLb.getValue(),
        };

        if(obj.id_caja_dev==-1){
            obj.id_cuenta_doc=null;
        }

        if(obj.id_depto_lb==-1){
            obj.id_depto_lb=null;
        }

        if(!this.frmDatos.getForm().isValid()){
            return;
        }

        //Confirmación de generación de la devolución
        Ext.MessageBox.confirm('Confirmacion', 'Al generar la Devolucion/reposicion la Cuenta Documentada se cerrara y no podra incluir mas descargos. Esta seguro de continuar?',function(resp){
            if(resp=='yes'){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_cuenta_documentada/control/CuentaDoc/generarDevolucionCuentaDoc',
                    params: obj,
                    success: function(resp){
                        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                        this.reload();
                        this.winDatos.hide();
                        Phx.CP.loadingHide();
                        Ext.MessageBox.alert('Hecho',reg.datos.respuesta);
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
        },this);

    },
    sigEstado: function(){
        var rec=this.sm.getSelected();
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/obtenerSaldoCuentaDoc',
            params: {'id_cuenta_doc':rec.data.id_cuenta_doc},
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
                //Si ya se definió la forma de devolución, hace las validaciones correspondientes antes de abrir el wizard
                console.log(reg.datos.tipo_rendicion)
                //Si la rendición es final obliga a que realice la introducción de datos de la Devolución/Reposición
                if(reg.datos.tipo_rendicion=='final'){
                    if(reg.datos.dev_tipo){
                        if(reg.datos.dev_tipo=='caja'||reg.datos.dev_tipo=='cheque'){
                            //Si es por caja o cheque abre directo el wizard
                            this.mostrarWizard(rec);
                        } else if(reg.datos.dev_tipo=='deposito'){
                            //Valida que se hayan registrado los depósitos
                            this.validaDepositos(rec,reg.datos);
                        } else {
                            Ext.MessageBox.alert('Alerta','La Rendicion esta marcada como Final. Registre los datos de la Devolucion/Reposicion para continuar.');    
                        } 
                    } else {
                        Ext.MessageBox.alert('Alerta','La Rendicion esta marcada como Final. Registre los datos de la Devolucion/Reposicion para continuar.');
                    }
                } else {
                    this.mostrarWizard(rec);
                }

                /*if(reg.datos.dev_tipo){
                    if(reg.datos.dev_tipo=='caja'||reg.datos.dev_tipo=='cheque'){
                        //Si es por caja o cheque abre directo el wizard
                        this.mostrarWizard(rec);
                    } else if(reg.datos.dev_tipo=='deposito'){
                        //Valida que se hayan registrado los depósitos
                        this.validaDepositos(rec,reg.datos);
                    } else {
                        Ext.MessageBox.alert('Alerta','Tipo de devolucion no valida ('+reg.datos.dev_tipo+')');
                    }
                } else {
                    this.mostrarWizard(rec);
                }*/
            },
            failure: function(resp) {
                Phx.CP.conexionFailure(resp);
            },
            timeout: function() {
                Phx.CP.config_ini.timeout();
            },
            scope:this
        });

    },
    validaDepositos: function(rec, obj){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_cuenta_documentada/control/CuentaDoc/listarDepositoCuentaDoc',
            params: {'id_cuenta_doc': rec.data.id_cuenta_doc},
            success: function(resp){
                Phx.CP.loadingHide();
                var response = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).datos[0];
                console.log('resp',response);
                console.log(response.total_deposito,obj.saldo_parcial,response.total_deposito>=obj.saldo_parcial);
                if(1*response.total_deposito>=1*obj.saldo_parcial){
                    this.mostrarWizard(rec);
                } else {
                    var faltante = obj.saldo,
                        saldo = obj.saldo*1+response.total_deposito*1;
                    Ext.MessageBox.alert('Depositos faltantes','Falta registro de deposito por: '+faltante+'. Saldo total: '+saldo+'. Depositado: '+response.total_deposito);
                }

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

};
</script>
