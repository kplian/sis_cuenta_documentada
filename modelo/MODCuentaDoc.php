<?php
/**
 *@package pXP
 *@file gen-MODCuentaDoc.php
 *@author  (admin)
 *@date 05-05-2016 16:41:21
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

/***************************************************************************
ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
CD                   	05/05/2016              Creación del archivo
#8 	CD 		  ETR 			15/10/2019	RCM 		Adición de detalle de funcionarios en viáticos para más de una persona
 ****************************************************************************
 */
class MODCuentaDoc extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarCuentaDoc(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_CDOC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        $this->setParametro('historico','historico','varchar');
        $this->setParametro('estado','estado','varchar');


        $this->captura('id_cuenta_doc','INTEGER');
        $this->captura('dias_para_rendir','INTEGER');
        $this->captura('max_fecha_rendicion','DATE');

        $this->captura('id_tipo_cuenta_doc','INTEGER');
        $this->captura('id_proceso_wf','INTEGER');
        $this->captura('id_caja','INTEGER');
        $this->captura('nombre_cheque','VARCHAR');
        $this->captura('id_uo','INTEGER');
        $this->captura('id_funcionario','INTEGER');
        $this->captura('tipo_pago','VARCHAR');
        $this->captura('id_depto','INTEGER');
        $this->captura('id_cuenta_doc_fk','INTEGER');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('motivo','VARCHAR');
        $this->captura('fecha','DATE');
        $this->captura('fecha_entrega','DATE');
        $this->captura('id_moneda','INTEGER');
        $this->captura('estado','VARCHAR');
        $this->captura('estado_reg','VARCHAR');
        $this->captura('id_estado_wf','INTEGER');
        $this->captura('id_usuario_ai','INTEGER');
        $this->captura('usuario_ai','VARCHAR');
        $this->captura('fecha_reg','TIMESTAMP');
        $this->captura('id_usuario_reg','INTEGER');
        $this->captura('fecha_mod','TIMESTAMP');
        $this->captura('id_usuario_mod','INTEGER');
        $this->captura('usr_reg','VARCHAR');
        $this->captura('usr_mod','VARCHAR');
        $this->captura('desc_moneda','VARCHAR');
        $this->captura('desc_depto','VARCHAR');
        $this->captura('obs','TEXT');
        $this->captura('desc_funcionario','TEXT');
        $this->captura('importe','numeric');
        $this->captura('desc_funcionario_cuenta_bancaria','varchar');
        $this->captura('id_funcionario_cuenta_bancaria','integer');
        $this->captura('id_depto_lb','integer');
        $this->captura('id_depto_conta','integer');
        $this->captura('importe_documentos','numeric');
        $this->captura('importe_retenciones','numeric');
        $this->captura('importe_depositos','numeric');
        $this->captura('tipo_cuenta_doc','VARCHAR');
        $this->captura('sw_solicitud','VARCHAR');
        $this->captura('sw_max_doc_rend','VARCHAR');
        $this->captura('num_rendicion','VARCHAR');
        $this->captura('importe_total_rendido','numeric');
        $this->captura('fecha_salida','DATE');
        $this->captura('fecha_llegada','DATE');
        $this->captura('tipo_viaje','VARCHAR');
        $this->captura('medio_transporte','VARCHAR');
        $this->captura('codigo_tipo_cuenta_doc','VARCHAR');
        $this->captura('cobertura','VARCHAR');
        $this->captura('id_escala','integer');
        $this->captura('desc_escala','VARCHAR');
        $this->captura('id_centro_costo','integer');
        $this->captura('descripcion_tcc','VARCHAR');
        $this->captura('desc_caja','VARCHAR');
        $this->captura('id_solicitud_efectivo','integer');
        $this->captura('dev_tipo','VARCHAR');
        $this->captura('dev_a_favor_de','VARCHAR');
        $this->captura('dev_nombre_cheque','VARCHAR');
        $this->captura('id_caja_dev','integer');
        $this->captura('dev_saldo','numeric');
        $this->captura('desc_sol_efectivo','varchar');
        $this->captura('dev_caja','varchar');
        $this->captura('tipo_sol_sigema','VARCHAR');
        $this->captura('id_sigema','integer');
        $this->captura('tipo_contrato','VARCHAR');
        $this->captura('cantidad_personas','integer');
        $this->captura('tipo_rendicion','VARCHAR');
        $this->captura('aplicar_regla_15','VARCHAR');
        $this->captura('id_funcionarios','INTEGER[]'); //#8
        $this->captura('funcinarios','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarCuentaDocRendicion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_CDOCREN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        $this->setParametro('historico','historico','varchar');
        $this->setParametro('estado','estado','varchar');


        $this->captura('id_cuenta_doc','INTEGER');
        $this->captura('id_tipo_cuenta_doc','INTEGER');
        $this->captura('id_proceso_wf','INTEGER');
        $this->captura('id_caja','INTEGER');
        $this->captura('nombre_cheque','VARCHAR');
        $this->captura('id_uo','INTEGER');
        $this->captura('id_funcionario','INTEGER');
        $this->captura('tipo_pago','VARCHAR');
        $this->captura('id_depto','INTEGER');
        $this->captura('id_cuenta_doc_fk','INTEGER');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('motivo','VARCHAR');
        $this->captura('fecha','DATE');
        $this->captura('id_moneda','INTEGER');
        $this->captura('estado','VARCHAR');
        $this->captura('estado_reg','VARCHAR');
        $this->captura('id_estado_wf','INTEGER');
        $this->captura('id_usuario_ai','INTEGER');
        $this->captura('usuario_ai','VARCHAR');
        $this->captura('fecha_reg','TIMESTAMP');
        $this->captura('id_usuario_reg','INTEGER');
        $this->captura('fecha_mod','TIMESTAMP');
        $this->captura('id_usuario_mod','INTEGER');
        $this->captura('usr_reg','VARCHAR');
        $this->captura('usr_mod','VARCHAR');
        $this->captura('desc_moneda','VARCHAR');
        $this->captura('desc_depto','VARCHAR');
        $this->captura('obs','TEXT');
        $this->captura('desc_funcionario','TEXT');
        $this->captura('importe','numeric');
        $this->captura('desc_funcionario_cuenta_bancaria','varchar');
        $this->captura('id_funcionario_cuenta_bancaria','integer');
        $this->captura('id_depto_lb','integer');
        $this->captura('id_depto_conta','integer');
        $this->captura('importe_documentos','numeric');
        $this->captura('importe_retenciones','numeric');
        $this->captura('importe_depositos','numeric');
        $this->captura('tipo_cuenta_doc','VARCHAR');
        $this->captura('sw_solicitud','VARCHAR');
        $this->captura('nro_correspondencia','VARCHAR');
        $this->captura('num_rendicion','VARCHAR');

        $this->captura('importe_solicitado','numeric');
        $this->captura('importe_total_rendido','numeric');
        $this->captura('id_periodo','integer');
        $this->captura('periodo','varchar');

        $this->captura('fecha_salida','DATE');
        $this->captura('fecha_llegada','DATE');
        $this->captura('tipo_viaje','VARCHAR');
        $this->captura('medio_transporte','VARCHAR');
        $this->captura('codigo_tipo_cuenta_doc','VARCHAR');
        $this->captura('cobertura','VARCHAR');
        $this->captura('hora_salida','varchar');
        $this->captura('hora_llegada','varchar');
        $this->captura('id_plantilla','integer');
        $this->captura('desc_plantilla','VARCHAR');
        $this->captura('cantidad_personas','integer');
        $this->captura('tipo_rendicion','varchar');
        $this->captura('aplicar_regla_15','VARCHAR');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


    function insertarCuentaDoc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDOC_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('sw_modo','sw_modo','varchar');
        $this->setParametro('id_caja','id_caja','int4');
        $this->setParametro('nombre_cheque','nombre_cheque','varchar');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('tipo_pago','tipo_pago','varchar');
        $this->setParametro('id_depto','id_depto','int4');
        $this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','int4');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        $this->setParametro('motivo','motivo','varchar');
        $this->setParametro('fecha','fecha','date');
        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('estado','estado','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('importe','importe','numeric');
        $this->setParametro('id_funcionario_cuenta_bancaria','id_funcionario_cuenta_bancaria','int4');
        $this->setParametro('fecha_salida','fecha_salida','date');
        $this->setParametro('fecha_llegada','fecha_llegada','date');
        $this->setParametro('tipo_viaje','tipo_viaje','varchar');
        $this->setParametro('medio_transporte','medio_transporte','varchar');
        $this->setParametro('cobertura','cobertura','varchar');
        $this->setParametro('id_centro_costo','id_centro_costo','integer');
        $this->setParametro('tipo_contrato','tipo_contrato','VARCHAR');
        $this->setParametro('cantidad_personas','cantidad_personas','integer');
        $this->setParametro('aplicar_regla_15','aplicar_regla_15','VARCHAR');
        $this->setParametro('id_funcionarios','id_funcionarios','VARCHAR'); //#8

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }





    function modificarCuentaDoc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDOC_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('id_tipo_cuenta_doc','id_tipo_cuenta_doc','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('sw_modo','sw_modo','varchar');
        $this->setParametro('id_caja','id_caja','int4');
        $this->setParametro('nombre_cheque','nombre_cheque','varchar');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('tipo_pago','tipo_pago','varchar');
        $this->setParametro('id_depto','id_depto','int4');
        $this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','int4');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        $this->setParametro('motivo','motivo','varchar');
        $this->setParametro('fecha','fecha','date');
        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('estado','estado','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('importe','importe','numeric');
        $this->setParametro('id_funcionario_cuenta_bancaria','id_funcionario_cuenta_bancaria','int4');
        $this->setParametro('fecha_salida','fecha_salida','date');
        $this->setParametro('fecha_llegada','fecha_llegada','date');
        $this->setParametro('tipo_viaje','tipo_viaje','varchar');
        $this->setParametro('medio_transporte','medio_transporte','varchar');
        $this->setParametro('cobertura','cobertura','varchar');
        $this->setParametro('id_centro_costo','id_centro_costo','integer');
        $this->setParametro('tipo_contrato','tipo_contrato','VARCHAR');
        $this->setParametro('cantidad_personas','cantidad_personas','integer');
        $this->setParametro('aplicar_regla_15','aplicar_regla_15','VARCHAR');
        $this->setParametro('id_funcionarios','id_funcionarios','VARCHAR'); //#8

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarCuentaDoc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDOC_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


    function alertarFondosLimiteRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_LIMREN_INS';
        $this->tipo_procedimiento='IME';
        //definicion de variables
        $this->tipo_conexion='seguridad';
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarCuentaDocRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDOCREN_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion

        $this->setParametro('motivo','motivo','varchar');
        $this->setParametro('fecha','fecha','date');
        $this->setParametro('importe','importe','numeric');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('nro_correspondencia','nro_correspondencia','varchar');
        $this->setParametro('fecha_salida','fecha_salida','date');
        $this->setParametro('hora_salida','hora_salida','time');
        $this->setParametro('fecha_llegada','fecha_llegada','date');
        $this->setParametro('hora_llegada','hora_llegada','time');
        $this->setParametro('cobertura','cobertura','varchar');

        $this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','integer');
        $this->setParametro('id_plantilla','id_plantilla','integer');

        $this->setParametro('tipo_rendicion','tipo_rendicion','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }



    function modificarCuentaDocRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDOCREN_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('id_cuenta_doc_fk','id_cuenta_doc_fk','int4');
        $this->setParametro('motivo','motivo','varchar');
        $this->setParametro('fecha','fecha','date');
        $this->setParametro('importe','importe','numeric');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('nro_correspondencia','nro_correspondencia','varchar');
        $this->setParametro('fecha_salida','fecha_salida','date');
        $this->setParametro('hora_salida','hora_salida','time');
        $this->setParametro('fecha_llegada','fecha_llegada','date');
        $this->setParametro('hora_llegada','hora_llegada','time');
        $this->setParametro('cobertura','cobertura','varchar');
        $this->setParametro('id_plantilla','id_plantilla','integer');
        $this->setParametro('tipo_rendicion','tipo_rendicion','varchar');
        $this->setParametro('aplicar_regla_15','aplicar_regla_15','VARCHAR');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarCuentaDocRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDOCREN_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


    function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'cd.ft_cuenta_doc_ime';
        $this->transaccion = 'CD_SIGESCD_IME';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        $this->setParametro('id_depto_lb','id_depto_lb','int4');
        $this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
        $this->setParametro('id_depto_conta','id_depto_conta','int4');
        $this->setParametro('id_cuenta_bancaria_mov','id_cuenta_bancaria_mov','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_ANTECD_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('obs','obs','varchar');
        $this->setParametro('estado_destino','estado_destino','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function iniciarRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_INIREND_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reporteCabeceraCuentaDoc(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPCDOC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->captura('id_cuenta_doc','INTEGER');
        $this->captura('id_tipo_cuenta_doc','INTEGER');
        $this->captura('id_proceso_wf','INTEGER');
        $this->captura('id_caja','INTEGER');
        $this->captura('nombre_cheque','VARCHAR');
        $this->captura('id_uo','INTEGER');
        $this->captura('id_funcionario','INTEGER');
        $this->captura('tipo_pago','VARCHAR');
        $this->captura('id_depto','INTEGER');
        $this->captura('id_cuenta_doc_fk','INTEGER');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('motivo','VARCHAR');
        $this->captura('fecha','DATE');
        $this->captura('id_moneda','INTEGER');
        $this->captura('estado','VARCHAR');
        $this->captura('estado_reg','VARCHAR');
        $this->captura('id_estado_wf','INTEGER');
        $this->captura('id_usuario_ai','INTEGER');
        $this->captura('usuario_ai','VARCHAR');
        $this->captura('fecha_reg','TIMESTAMP');
        $this->captura('id_usuario_reg','INTEGER');
        $this->captura('fecha_mod','TIMESTAMP');
        $this->captura('id_usuario_mod','INTEGER');
        $this->captura('usr_reg','VARCHAR');
        $this->captura('usr_mod','VARCHAR');
        $this->captura('desc_moneda','VARCHAR');
        $this->captura('desc_depto','VARCHAR');
        $this->captura('obs','TEXT');
        $this->captura('desc_funcionario','TEXT');
        $this->captura('importe','numeric');
        $this->captura('desc_funcionario_cuenta_bancaria','varchar');
        $this->captura('id_funcionario_cuenta_bancaria','integer');
        $this->captura('id_depto_lb','integer');
        $this->captura('id_depto_conta','integer');
        $this->captura('tipo_cuenta_doc','VARCHAR');
        $this->captura('sw_solicitud','VARCHAR');
        $this->captura('lugar','VARCHAR');
        $this->captura('cargo_funcionario','varchar');
        $this->captura('nombre_unidad','VARCHAR');
        $this->captura('importe_literal','VARCHAR');
        $this->captura('motivo_ori','VARCHAR');
        $this->captura('gerente_financiero','VARCHAR');
        $this->captura('cargo_gerente_financiero','VARCHAR');

        $this->captura('aprobador','TEXT');
        $this->captura('cargo_aprobador','TEXT');

        $this->captura('nro_cbte','VARCHAR');
        $this->captura('num_memo','VARCHAR');
        $this->captura('num_rendicion','VARCHAR');
        $this->captura('nro_cheque','integer');
        $this->captura('importe_solicitado','numeric');
        $this->captura('tipo_sol_sigema','VARCHAR');
        $this->captura('nro_solicitud','VARCHAR');
        $this->captura('tipo_rendicion','VARCHAR');
        $this->captura('total_entregado','numeric');
        $this->captura('otras_rendiciones','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    // listado de prorateo segun id_proceso_wf
    function recuperarDatosProrrateo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_DATPRO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->captura('descripcion_tcc','varchar');
        $this->captura('prorrateo','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    // listado de prorateo segun id_proceso_wf
    function recuperarDatosItinerario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_DATITI_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->captura('cantidad_dias','int4');
        $this->captura('desc_destino','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    // listado de prorateo segun id_proceso_wf
    function recuperarDatosPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_DATPRE_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->captura('monto_mo','numeric');
        $this->captura('moneda','varchar');
        $this->captura('desc_ingas','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    //
    function recuperarRendicionFacturas(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPRENDET_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_doc_compra_venta','int8');
        $this->captura('revisado','varchar');
        $this->captura('movil','varchar');
        $this->captura('tipo','varchar');
        $this->captura('importe_excento','numeric');
        $this->captura('id_plantilla','int4');
        $this->captura('fecha','date');
        $this->captura('nro_documento','varchar');
        $this->captura('nit','varchar');
        $this->captura('importe_ice','numeric');
        $this->captura('nro_autorizacion','varchar');
        $this->captura('importe_iva','numeric');
        $this->captura('importe_descuento','numeric');
        $this->captura('importe_doc','numeric');
        $this->captura('sw_contabilizar','varchar');
        $this->captura('tabla_origen','varchar');
        $this->captura('estado','varchar');
        $this->captura('id_depto_conta','int4');
        $this->captura('id_origen','int4');
        $this->captura('obs','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('codigo_control','varchar');
        $this->captura('importe_it','numeric');
        $this->captura('razon_social','varchar');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('desc_depto','varchar');
        $this->captura('desc_plantilla','varchar');
        $this->captura('importe_descuento_ley','numeric');
        $this->captura('importe_pago_liquido','numeric');
        $this->captura('nro_dui','varchar');
        $this->captura('id_moneda','int4');
        $this->captura('desc_moneda','varchar');
        $this->captura('id_int_comprobante','int4');
        $this->captura('desc_comprobante','varchar');
        $this->captura('importe_pendiente','numeric');
        $this->captura('importe_anticipo','numeric');
        $this->captura('importe_retgar','numeric');
        $this->captura('importe_neto','numeric');
        $this->captura('id_auxiliar','integer');
        $this->captura('codigo_auxiliar','varchar');
        $this->captura('nombre_auxiliar','varchar');
        $this->captura('id_tipo_doc_compra_venta','integer');
        $this->captura('desc_tipo_doc_compra_venta','varchar');
        $this->captura('id_rendicion_det','integer');
        $this->captura('id_cuenta_doc','integer');
        $this->captura('id_cuenta_doc_rendicion','integer');
        $this->captura('detalle','text');



        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function recuperarRetenciones(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPRENRET_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Definicion de la lista del resultado del query
        $this->captura('retenciones','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function recuperarRendicionDepositos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPDEPREN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');


        //Definicion de la lista del resultado del query
        $this->captura('id_cuenta_bancaria','int4');
        $this->captura('denominacion','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('fecha','date');
        $this->captura('tipo','varchar');
        $this->captura('importe_deposito','numeric');
        $this->captura('origen','varchar');
        $this->captura('nombre_finalidad','varchar');
        $this->captura('id_libro_bancos','int4');
        $this->captura('observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function recuperarRendicionDepositosConsolidado(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPDEPRENCO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        //Definicion de la lista del resultado del query
        $this->captura('id_cuenta_bancaria','int4');
        $this->captura('denominacion','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('fecha','date');
        $this->captura('tipo','varchar');
        $this->captura('importe_deposito','numeric');
        $this->captura('origen','varchar');
        $this->captura('nombre_finalidad','varchar');
        $this->captura('id_libro_bancos','int4');
        $this->captura('observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function recuperarDetalleConsolidado(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPCONFA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Definicion de la lista del resultado del query

        $this->captura('id_doc_concepto','INTEGER');
        $this->captura('codigo_cc','TEXT');
        $this->captura('desc_tipo_presupuesto','VARCHAR');
        $this->captura('desc_categoria_programatica','TEXT');
        $this->captura('codigo_categoria','VARCHAR');
        $this->captura('desc_ingas','VARCHAR');
        $this->captura('descripcion','TEXT');
        $this->captura('precio_total_final','NUMERIC');
        $this->captura('precio_total','NUMERIC');
        $this->captura('precio_unitario','NUMERIC');
        $this->captura('cantidad_sol','NUMERIC');
        $this->captura('fecha','DATE');
        $this->captura('razon_social','VARCHAR');
        $this->captura('nro_documento','VARCHAR');
        $this->captura('desc_plantilla','VARCHAR');
        $this->captura('partida','VARCHAR');
        $this->captura('id_int_comprobante','INTEGER');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function recuperarConsolidado(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPCON_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Definicion de la lista del resultado del query

        $this->captura('codigo_categoria','VARCHAR');
        $this->captura('partida','VARCHAR');
        $this->captura('importe','NUMERIC');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->consulta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function ampliarRendicion(){


        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_AMPCDREN_IME';
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('dias_ampliado','dias_ampliado','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function cambiarBloqueo(){


        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CAMBLOQ_IME';
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function cambioUsuarioReg(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CAMBUSUREG_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('id_usuario_new','id_usuario_new','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarReporteCuentaDoc(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPCD_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this-> setCount(false);

        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('codigo_tipo_cuenta_doc','codigo_tipo_cuenta_doc','varchar');
        $this->setParametro('estado','estado','varchar');
        $this->setParametro('fuera_estado','fuera_estado','varchar');




        $this->captura('id_cuenta_doc','INTEGER');
        $this->captura('fecha','DATE');
        $this->captura('fecha_entrega','DATE');
        $this->captura('desc_funcionario1','TEXT');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('motivo','VARCHAR');
        $this->captura('nro_cheque','INTEGER');
        $this->captura('importe_solicitado','NUMERIC');
        $this->captura('importe_cheque','NUMERIC');
        $this->captura('importe_documentos','NUMERIC');
        $this->captura('importe_depositos','NUMERIC');
        $this->captura('saldo','NUMERIC');
        $this->captura('estado','VARCHAR');
        $this->captura('id_proceso_wf','INTEGER');
        $this->captura('id_estado_wf','INTEGER');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


    function listarCuentaDocConsulta2(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_REPCD2_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion


        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('codigo_tipo_cuenta_doc','codigo_tipo_cuenta_doc','varchar');
        $this->setParametro('estado','estado','varchar');
        $this->setParametro('fuera_estado','fuera_estado','varchar');

        $this->capturaCount('importe_solicitado','numeric');
        $this->capturaCount('importe_cheque','numeric');
        $this->capturaCount('importe_documentos','numeric');
        $this->capturaCount('importe_depositos','numeric');
        $this->capturaCount('saldo','numeric');



        $this->captura('id_cuenta_doc','INTEGER');
        $this->captura('fecha','DATE');
        $this->captura('fecha_entrega','DATE');
        $this->captura('desc_funcionario1','TEXT');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('motivo','VARCHAR');
        $this->captura('nro_cheque','INTEGER');
        $this->captura('importe_solicitado','NUMERIC');
        $this->captura('importe_cheque','NUMERIC');
        $this->captura('importe_documentos','NUMERIC');
        $this->captura('importe_depositos','NUMERIC');
        $this->captura('saldo','NUMERIC');
        $this->captura('estado','VARCHAR');
        $this->captura('id_proceso_wf','INTEGER');
        $this->captura('id_estado_wf','INTEGER');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function cuentaDocumentosRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_RENREGDOC_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function cuentaItinerarioRendicion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_RENREGITI_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function obtenerSaldoCuentaDoc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDRETOT_VAL';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function generarDevolucionCuentaDoc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDDEVOL_GEN';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('dev_tipo','dev_tipo','varchar');
        $this->setParametro('dev_a_favor_de','dev_a_favor_de','varchar');
        $this->setParametro('dev_nombre_cheque','dev_nombre_cheque','varchar');
        $this->setParametro('id_caja_dev','id_caja_dev','int4');
        $this->setParametro('dev_saldo','dev_saldo','numeric');
        $this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
        $this->setParametro('total_dev','total_dev','numeric');
        $this->setParametro('id_depto_lb','id_depto_lb','int4');
        $this->setParametro('dev_saldo_original','dev_saldo_original','numeric');
        $this->setParametro('id_moneda_dev','id_moneda_dev','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarDepositoCuentaDoc(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_CDOCDEP_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->captura('total_deposito','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarElementoSigema(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_CDSIGEMAID_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->captura('tipo_sol_sigema','varchar');
        $this->captura('id_sigema','integer');
        $this->captura('nro_solicitud','varchar');
        $this->captura('gestion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function guardarSIGEMA(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_CDSIGEMA_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
        $this->setParametro('tipo_sol_sigema','tipo_sol_sigema','varchar');
        $this->setParametro('id_sigema','id_sigema','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarDatosCDSIGEMA(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_CDSIGEMADAT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        //Define los parametros para la funcion
        $this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');

        $this->captura('id_cuenta_doc','INTEGER');
        $this->captura('tipo_sol_sigema','VARCHAR');
        $this->captura('id_sigema','INTEGER');
        $this->captura('nro_solicitud','VARCHAR');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarViaticosForm110(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_VIA110_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','INTEGER');
        $this->captura('codigo','VARCHAR');
        $this->captura('desc_funcionario2','TEXT');
        $this->captura('ci','VARCHAR');
        $this->captura('id_depto_conta','INTEGER');
        $this->captura('desc_depto','TEXT');
        $this->captura('id_periodo','INTEGER');
        $this->captura('total','NUMERIC');
        $this->captura('total_excento','NUMERIC');
        $this->captura('sin_cbte','NUMERIC');
        //$this->captura('con_cbte','NUMERIC');
        $this->captura('desc_periodo','VARCHAR');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarViaticosForm110Det(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_VIA110DET_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_doc_compra_venta','BIGINT');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('desc_plantilla','VARCHAR');
        $this->captura('id_int_comprobante','INTEGER');
        $this->captura('estado_cbte','TEXT');
        $this->captura('nit','VARCHAR');
        $this->captura('nro_documento','VARCHAR');
        $this->captura('nro_autorizacion','VARCHAR');
        $this->captura('fecha','DATE');
        $this->captura('razon_social','VARCHAR');
        $this->captura('importe_doc','NUMERIC');
        $this->captura('importe_excento','NUMERIC');
        $this->captura('importe_descuento','NUMERIC');
        $this->captura('importe_neto','NUMERIC');
        $this->captura('codigo_control','VARCHAR');
        $this->captura('importe_iva','NUMERIC');
        $this->captura('importe_it','NUMERIC');
        $this->captura('importe_ice','NUMERIC');
        $this->captura('importe_pago_liquido','NUMERIC');
        $this->captura('nro_dui','VARCHAR');
        $this->captura('nro_tramite_viatico','VARCHAR');
        $this->captura('fecha_viatico','DATE');
        $this->captura('desc_funcionario_sol','TEXT');
        $this->captura('id_funcionario','integer');
        $this->captura('desc_funcionario','TEXT');
        $this->captura('desc_moneda','VARCHAR');
        $this->captura('importe_mb','NUMERIC');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarViaticosForm110Det(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='cd.ft_cuenta_doc_ime';
        $this->transaccion='CD_VIA110DET_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reporteViaticosForm110(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_VIA110REP_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','INTEGER');
        $this->captura('codigo','VARCHAR');
        $this->captura('desc_funcionario2','TEXT');
        $this->captura('ci','VARCHAR');
        $this->captura('id_periodo','INTEGER');
        $this->captura('total','NUMERIC');
        $this->captura('total_excento','NUMERIC');
        $this->captura('desc_periodo','VARCHAR');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPasajesFuncionario(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_PASAFUN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','INTEGER');
        $this->captura('codigo','VARCHAR');
        $this->captura('desc_funcionario2','TEXT');
        $this->captura('ci','VARCHAR');
        $this->captura('id_depto_conta','INTEGER');
        $this->captura('desc_depto','TEXT');
        $this->captura('id_periodo','INTEGER');
        $this->captura('total','NUMERIC');
        $this->captura('total_excento','NUMERIC');
        $this->captura('sin_cbte','NUMERIC');
        $this->captura('sin_cbte_excento','NUMERIC');
        $this->captura('con_cbte','NUMERIC');
        $this->captura('con_cbte_excento','NUMERIC');
        $this->captura('desc_periodo','VARCHAR');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reportePasajesFuncionarios(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_PASAFUNREP_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','INTEGER');
        $this->captura('codigo','VARCHAR');
        $this->captura('desc_funcionario2','TEXT');
        $this->captura('ci','VARCHAR');
        $this->captura('id_periodo','INTEGER');
        $this->captura('total','NUMERIC');
        $this->captura('total_excento','NUMERIC');
        $this->captura('desc_periodo','VARCHAR');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPasajesFuncionariosDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='cd.ft_cuenta_doc_sel';
        $this->transaccion='CD_PASAFUNDET_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_doc_compra_venta','BIGINT');
        $this->captura('nro_tramite','VARCHAR');
        $this->captura('desc_plantilla','VARCHAR');
        $this->captura('id_int_comprobante','INTEGER');
        $this->captura('estado_cbte','TEXT');
        $this->captura('nit','VARCHAR');
        $this->captura('nro_documento','VARCHAR');
        $this->captura('nro_autorizacion','VARCHAR');
        $this->captura('fecha','DATE');
        $this->captura('razon_social','VARCHAR');
        $this->captura('importe_doc','NUMERIC');
        $this->captura('importe_excento','NUMERIC');
        $this->captura('importe_descuento','NUMERIC');
        $this->captura('importe_neto','NUMERIC');
        $this->captura('codigo_control','VARCHAR');
        $this->captura('importe_iva','NUMERIC');
        $this->captura('importe_it','NUMERIC');
        $this->captura('importe_ice','NUMERIC');
        $this->captura('importe_pago_liquido','NUMERIC');
        $this->captura('nro_dui','VARCHAR');
        $this->captura('id_funcionario','integer');
        $this->captura('desc_funcionario','TEXT');
        $this->captura('desc_moneda','VARCHAR');
        $this->captura('importe_mb','NUMERIC');
        $this->captura('importe_mb_excento','NUMERIC');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>