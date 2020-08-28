<?php
/**
*@package pXP
*@file gen-MODRendicionDet.php
*@author  (admin)
*@date 17-05-2016 18:01:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas


ISSUE          FECHA:		      AUTOR                 DESCRIPCION
#13 		17/04/2020		manuel guerra	insercion de los campos(nota debito de agencia/vi-fa) para los documentos   

*/

class MODRendicionDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRendicionDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='cd.ft_rendicion_det_sel';
		$this->transaccion='CD_RENDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//captura parametros adicionales para el count
		$this->capturaCount('total_importe_ice','numeric');
		$this->capturaCount('total_importe_excento','numeric');
		$this->capturaCount('total_importe_it','numeric');
		$this->capturaCount('total_importe_iva','numeric');
		$this->capturaCount('total_importe_descuento','numeric');
		$this->capturaCount('total_importe_doc','numeric');
		
		$this->capturaCount('total_importe_retgar','numeric');
		$this->capturaCount('total_importe_anticipo','numeric');
		$this->capturaCount('tota_importe_pendiente','numeric');
		$this->capturaCount('total_importe_neto','numeric');
		$this->capturaCount('total_importe_descuento_ley','numeric');
		$this->capturaCount('tota_importe_pago_liquido','numeric');
		
		
		
				
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

		$this->captura('id_funcionario','integer');
		$this->captura('desc_funcionario2','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRendicionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_rendicion_det_ime';
		$this->transaccion='CD_RENDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_dompra_venta','id_doc_dompra_venta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_cuenta_doc_rendicion','id_cuenta_doc_rendicion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRendicionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_rendicion_det_ime';
		$this->transaccion='CD_RENDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rendicion_det','id_rendicion_det','int4');
		$this->setParametro('id_doc_dompra_venta','id_doc_dompra_venta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
		$this->setParametro('id_cuenta_doc_rendicion','id_cuenta_doc_rendicion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRendicionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='cd.ft_rendicion_det_ime';
		$this->transaccion='CD_RENDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rendicion_det','id_rendicion_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function insertarRendicionDocCompleto(){
		
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		$copiado = false;
		
		try {
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			
			/////////////////////////
			//  inserta cabecera de la solicitud de compra
			///////////////////////
			
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_DCV_INS';
			$this->tipo_procedimiento='IME';
					
			//Define los parametros para la funcion
			$this->setParametro('revisado','revisado','varchar');
			$this->setParametro('movil','movil','varchar');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('importe_excento','importe_excento','numeric');
			$this->setParametro('id_plantilla','id_plantilla','int4');
			$this->setParametro('fecha','fecha','date');
			$this->setParametro('nro_documento','nro_documento','varchar');
			$this->setParametro('nit','nit','varchar');
			$this->setParametro('importe_ice','importe_ice','numeric');
			$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
			$this->setParametro('importe_iva','importe_iva','numeric');
			$this->setParametro('importe_descuento','importe_descuento','numeric');
			$this->setParametro('importe_doc','importe_doc','numeric');
			$this->setParametro('sw_contabilizar','sw_contabilizar','varchar');
			$this->setParametro('tabla_origen','tabla_origen','varchar');
			$this->setParametro('estado','estado','varchar');
			$this->setParametro('id_depto_conta','id_depto_conta','int4');
			$this->setParametro('id_origen','id_origen','int4');
			$this->setParametro('obs','obs','varchar');
			$this->setParametro('estado_reg','estado_reg','varchar');
			$this->setParametro('codigo_control','codigo_control','varchar');
			$this->setParametro('importe_it','importe_it','numeric');
			$this->setParametro('razon_social','razon_social','varchar');
			$this->setParametro('importe_descuento_ley','importe_descuento_ley','numeric');
			$this->setParametro('importe_pago_liquido','importe_pago_liquido','numeric');
			$this->setParametro('nro_dui','nro_dui','varchar');
			$this->setParametro('id_moneda','id_moneda','int4');			
			$this->setParametro('importe_pendiente','importe_pendiente','numeric');
			$this->setParametro('importe_anticipo','importe_anticipo','numeric');
			$this->setParametro('importe_retgar','importe_retgar','numeric');
			$this->setParametro('importe_neto','importe_neto','numeric');
			$this->setParametro('id_auxiliar','id_auxiliar','integer');
			$this->setParametro('id_funcionario','id_funcionario','integer');
			
			//Ejecuta la instruccion
            $this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);				
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			$respuesta = $resp_procedimiento['datos'];
			$id_doc_compra_venta = $respuesta['id_doc_compra_venta'];
			
			
			//////////////////////////////////////////////
			//inserta rendicion
			/////////////////////////////////////////////
			
			//$this->resetParametros();
			$this->procedimiento='cd.ft_rendicion_det_ime';
			$this->transaccion='CD_REND_INS';
			$this->tipo_procedimiento='IME';
						
			
			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
			
			$this->armarConsulta();			
			$stmt = $link->prepare($this->consulta);	
			
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			
			//////////////////////////////////////////////
			//inserta detalle de la compra
			/////////////////////////////////////////////
			
			//decodifica JSON  de detalles 
			$json_detalle = $this->aParam->_json_decode($this->aParam->getParametro('json_new_records'));			
			
			//var_dump($json_detalle)	;
			foreach($json_detalle as $f){
				
				$this->resetParametros();
				//Definicion de variables para ejecucion del procedimiento
			    $this->procedimiento='conta.ft_doc_concepto_ime';
				$this->transaccion='CONTA_DOCC_INS';
				$this->tipo_procedimiento='IME';
				
				//modifica los valores de las variables que mandaremos
				$this->arreglo['id_centro_costo'] = $f['id_centro_costo'];
								
				$this->arreglo['descripcion'] = $f['descripcion'];
				$this->arreglo['precio_unitario'] = $f['precio_unitario'];
				$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
				$this->arreglo['id_orden_trabajo'] = $f['id_orden_trabajo'];
				$this->arreglo['id_concepto_ingas'] = $f['id_concepto_ingas'];
				$this->arreglo['precio_total'] = $f['precio_total'];
				$this->arreglo['precio_total_final'] = $f['precio_total_final'];
				$this->arreglo['cantidad_sol'] = $f['cantidad_sol'];
				
				//throw new Exception("cantidad ...modelo...".$f['cantidad'], 1);
						
				//Define los parametros para la funcion
				$this->setParametro('estado_reg','estado_reg','varchar');
				$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
				$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
				$this->setParametro('id_centro_costo','id_centro_costo','int4');
				$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
				$this->setParametro('descripcion','descripcion','text');
				$this->setParametro('cantidad_sol','cantidad_sol','numeric');
				$this->setParametro('precio_unitario','precio_unitario','numeric');
				$this->setParametro('precio_total','precio_total','numeric');
				$this->setParametro('precio_total_final','precio_total_final','numeric');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al insertar detalle  en la bd", 3);
				}                    
                        
            }

             
			
			//verifica si los totales cuadran
			$this->resetParametros();
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_CHKDOCSUM_IME';
			$this->tipo_procedimiento='IME';
			
			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			
			$this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al verificar cuadre ", 3);
			}

			//verifica si el documento no excede el total del fondo
			$this->resetParametros();
			$this->procedimiento='cd.ft_rendicion_det_ime';
			$this->transaccion='CD_CHKDOCFON_IME';
			$this->tipo_procedimiento='IME';

			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');

			$this->armarConsulta();
			$stmt = $link->prepare($this->consulta);
			$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);

			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al verificar cuadre ", 3);
			}
			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}				
		}    
	    
	    return $this->respuesta;
	}
	
	function modificarRendicionDocCompleto(){
		
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		$copiado = false;			
		try {
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			
			/////////////////////////
			//  inserta cabecera de la solicitud de compra
			///////////////////////
			
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_DCV_MOD';
			$this->tipo_procedimiento='IME';
					
			//Define los parametros para la funcion
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			$this->setParametro('revisado','revisado','varchar');
			$this->setParametro('movil','movil','varchar');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('importe_excento','importe_excento','numeric');
			$this->setParametro('id_plantilla','id_plantilla','int4');
			$this->setParametro('fecha','fecha','date');
			$this->setParametro('nro_documento','nro_documento','varchar');
			$this->setParametro('nit','nit','varchar');
			$this->setParametro('importe_ice','importe_ice','numeric');
			$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
			$this->setParametro('importe_iva','importe_iva','numeric');
			$this->setParametro('importe_descuento','importe_descuento','numeric');
			$this->setParametro('importe_doc','importe_doc','numeric');
			$this->setParametro('sw_contabilizar','sw_contabilizar','varchar');
			$this->setParametro('tabla_origen','tabla_origen','varchar');
			$this->setParametro('estado','estado','varchar');
			$this->setParametro('id_depto_conta','id_depto_conta','int4');
			$this->setParametro('id_origen','id_origen','int4');
			$this->setParametro('obs','obs','varchar');
			$this->setParametro('estado_reg','estado_reg','varchar');
			$this->setParametro('codigo_control','codigo_control','varchar');
			$this->setParametro('importe_it','importe_it','numeric');
			$this->setParametro('razon_social','razon_social','varchar');
			$this->setParametro('importe_descuento_ley','importe_descuento_ley','numeric');
			$this->setParametro('importe_pago_liquido','importe_pago_liquido','numeric');
			$this->setParametro('nro_dui','nro_dui','varchar');
			$this->setParametro('id_moneda','id_moneda','int4');			
			
			$this->setParametro('importe_pendiente','importe_pendiente','numeric');
			$this->setParametro('importe_anticipo','importe_anticipo','numeric');
			$this->setParametro('importe_retgar','importe_retgar','numeric');
			$this->setParametro('importe_neto','importe_neto','numeric');
			$this->setParametro('id_auxiliar','id_auxiliar','integer');
			$this->setParametro('id_funcionario','id_funcionario','integer');
			
			//Ejecuta la instruccion
            $this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);				
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			$respuesta = $resp_procedimiento['datos'];
			
			$id_doc_compra_venta = $respuesta['id_doc_compra_venta'];
			
			
			
			//////////////////////////////////////////////
			//valida importes editados en factura para la rendicion
			/////////////////////////////////////////////
			
			$this->resetParametros();
			$this->procedimiento='cd.ft_rendicion_det_ime';
			$this->transaccion='CD_VALEDI_MOD';
			$this->tipo_procedimiento='IME';
						
			
			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			$this->setParametro('id_cuenta_doc','id_cuenta_doc','int4');
			
			$this->armarConsulta();			
			$stmt = $link->prepare($this->consulta);	
			
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			
			//////////////////////////////////////////////
			//inserta detalle de la compra o venta
			/////////////////////////////////////////////
						
			//decodifica JSON  de detalles 
			$json_detalle = $this->aParam->_json_decode($this->aParam->getParametro('json_new_records'));			
			
			//var_dump($json_detalle)	;
			foreach($json_detalle as $f){
				
				$this->resetParametros();
				//Definicion de variables para ejecucion del procedimiento
			    
			    
				//modifica los valores de las variables que mandaremos
				$this->arreglo['id_centro_costo'] = $f['id_centro_costo'];
				$this->arreglo['id_doc_concepto'] = $f['id_doc_concepto'];
				
				$this->arreglo['descripcion'] = $f['descripcion'];
				$this->arreglo['precio_unitario'] = $f['precio_unitario'];
				$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
				$this->arreglo['id_orden_trabajo'] = (isset($f['id_orden_trabajo'])?$f['id_orden_trabajo']:'null');
				$this->arreglo['id_concepto_ingas'] = $f['id_concepto_ingas'];
				$this->arreglo['precio_total'] = $f['precio_total'];
				$this->arreglo['precio_total_final'] = $f['precio_total_final'];
				$this->arreglo['cantidad_sol'] = $f['cantidad_sol'];
				
				
				$this->procedimiento='conta.ft_doc_concepto_ime';
				$this->tipo_procedimiento='IME';
				//si tiene ID modificamos
				if ( isset($this->arreglo['id_doc_concepto']) && $this->arreglo['id_doc_concepto'] != ''){
					$this->transaccion='CONTA_DOCC_MOD';
				}
				else{
					//si no tiene ID insertamos
					$this->transaccion='CONTA_DOCC_INS';
				}
								
				//throw new Exception("cantidad ...modelo...".$f['cantidad'], 1);
						
				//Define los parametros para la funcion
				$this->setParametro('estado_reg','estado_reg','varchar');
				$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
				$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
				$this->setParametro('id_centro_costo','id_centro_costo','int4');
				$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
				$this->setParametro('descripcion','descripcion','text');
				$this->setParametro('cantidad_sol','cantidad_sol','numeric');
				$this->setParametro('precio_unitario','precio_unitario','numeric');
				$this->setParametro('precio_total','precio_total','numeric');
				$this->setParametro('id_doc_concepto','id_doc_concepto','numeric');
				$this->setParametro('precio_total_final','precio_total_final','numeric');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al insertar detalle  en la bd", 3);
				}
                    
                        
            }
			
			/////////////////////////////
			//elimia conceptos marcado
			///////////////////////////
			
			$this->procedimiento='conta.ft_doc_concepto_ime';
			$this->transaccion='CONTA_DOCC_ELI';
			$this->tipo_procedimiento='IME';
			
			$id_doc_conceto_elis = explode(",", $this->aParam->getParametro('id_doc_conceto_elis'));			
			//var_dump($json_detalle)	;
			for( $i=0; $i<count($id_doc_conceto_elis); $i++){
				
				$this->resetParametros();
				$this->arreglo['id_doc_concepto'] = $id_doc_conceto_elis[$i];
				//Define los parametros para la funcion
				$this->setParametro('id_doc_concepto','id_doc_concepto','int4');
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al eliminar concepto  en la bd", 3);
				}
			
			}
			//verifica si los totales cuadran
			$this->resetParametros();
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_CHKDOCSUM_IME';
			$this->tipo_procedimiento='IME';
			
			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			
			$this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al verificar cuadre ", 3);
			}	
			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}
				
		}    
	    
	    return $this->respuesta;
	}

    function insertarCdDeposito(){
    	
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
					
		try {
				
				
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento='tes.ft_proceso_caja_ime';
			$this->transaccion='TES_DEP_INS';
			$this->tipo_procedimiento='IME';
	
			//Define los parametros para la funcion
			$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','varchar');
			$this->setParametro('fecha','fecha','date');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('observaciones','observaciones','varchar');
			$this->setParametro('nro_deposito','nro_deposito','varchar');
			$this->setParametro('importe_deposito','importe_deposito','numeric');
			$this->setParametro('origen','origen','varchar');
			$this->setParametro('tabla','tabla','varchar');
	        $this->setParametro('columna_pk','columna_pk','varchar');
	        $this->setParametro('columna_pk_valor','columna_pk_valor','int4');
			$this->setParametro('tipo_deposito','tipo_deposito','varchar');
	
			
			
			//Ejecuta la instruccion
            $this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al verificar cuadre ", 3);
			}	
			
			$respuesta = $resp_procedimiento['datos'];
			$id_libro_bancos = $respuesta['id_libro_bancos'];
			
			
			
			////////////////////////////////////////////////
			//validar ingreso de depostiros en la rendición
			///////////////////////////////////////////////
			
			$this->resetParametros();
			$this->procedimiento='cd.ft_rendicion_det_ime';
			$this->transaccion='CD_VALINDDEPREN_VAL';
			$this->tipo_procedimiento='IME';
			
			$this->arreglo['id_libro_bancos'] = $id_libro_bancos;
			$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
			
			$this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
	
			
		
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}
				
		}    
	    
	    return $this->respuesta;
	}

    function eliminarCdDeposito(){
    	
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		
		
		try {
			    $link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		      	$link->beginTransaction();
				//Definicion de variables para ejecucion del procedimiento
				$this->procedimiento='tes.ft_proceso_caja_ime';
				$this->transaccion='TES_DEP_ELI';
				$this->tipo_procedimiento='IME';
		        //Define los parametros para la funcion
				$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);
		
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al ejecutar en la bd", 3);
				}
				
				////////////////////////////////////////////////
				//validar eliminación de depostiros en la rendición
				///////////////////////////////////////////////
				
				
				
				
				$this->procedimiento='cd.ft_rendicion_det_ime';
				$this->transaccion='CD_VALDELDDEPREN_VAL';
				$this->tipo_procedimiento='IME';
				
				
				//$this->setParametro('id_libro_bancos','id_libro_bancos','int4');
				
				
				
				$this->armarConsulta();
				$stmt = $link->prepare($this->consulta);	
				
					 
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);
				
				
				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al ejecutar en la bd", 3);
				}
				//si todo va bien confirmamos y regresamos el resultado
				$link->commit();
				$this->respuesta=new Mensaje();
				$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				$this->respuesta->setDatos($respuesta);
	
			
		
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}
				
		}    
	    
	    return $this->respuesta;		
	}


    //////////////////////////////////////////////////////////////////////////
    //RAC 05/01/2018 para insertar  libro de comrpas para pagos simplificados
    //////////////////////////////////////////////////////////////////////////////
    
    function insertarPSDocCompleto(){
		
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		$copiado = false;
		
		try {
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			
			/////////////////////////
			//  inserta cabecera de la solicitud de compra
			///////////////////////
			
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_DCV_INS';
			$this->tipo_procedimiento='IME';
					
			//Define los parametros para la funcion
			$this->setParametro('revisado','revisado','varchar');
			$this->setParametro('movil','movil','varchar');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('importe_excento','importe_excento','numeric');
			$this->setParametro('id_plantilla','id_plantilla','int4');
			$this->setParametro('fecha','fecha','date');
			$this->setParametro('nro_documento','nro_documento','varchar');
			$this->setParametro('nit','nit','varchar');
			$this->setParametro('importe_ice','importe_ice','numeric');
			$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
			$this->setParametro('importe_iva','importe_iva','numeric');
			$this->setParametro('importe_descuento','importe_descuento','numeric');
			$this->setParametro('importe_doc','importe_doc','numeric');
			$this->setParametro('sw_contabilizar','sw_contabilizar','varchar');
			$this->setParametro('tabla_origen','tabla_origen','varchar');
			$this->setParametro('estado','estado','varchar');
			$this->setParametro('id_depto_conta','id_depto_conta','int4');
			$this->setParametro('id_origen','id_origen','int4');
			$this->setParametro('obs','obs','varchar');
			$this->setParametro('estado_reg','estado_reg','varchar');
			$this->setParametro('codigo_control','codigo_control','varchar');
			$this->setParametro('importe_it','importe_it','numeric');
			$this->setParametro('razon_social','razon_social','varchar');
			$this->setParametro('importe_descuento_ley','importe_descuento_ley','numeric');
			$this->setParametro('importe_pago_liquido','importe_pago_liquido','numeric');
			$this->setParametro('nro_dui','nro_dui','varchar');
			$this->setParametro('id_moneda','id_moneda','int4');			
			$this->setParametro('importe_pendiente','importe_pendiente','numeric');
			$this->setParametro('importe_anticipo','importe_anticipo','numeric');
			$this->setParametro('importe_retgar','importe_retgar','numeric');
			$this->setParametro('importe_neto','importe_neto','numeric');
			$this->setParametro('id_auxiliar','id_auxiliar','integer');
			$this->setParametro('id_funcionario','id_funcionario','integer');
			$this->setParametro('sw_pgs','sw_pgs','varchar');
			$this->setParametro('nota_debito_agencia','nota_debito_agencia','varchar');	//#13		
			$this->setParametro('nro_tramite','nro_tramite','varchar');	//#13
			//Ejecuta la instruccion
            $this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);				
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			$respuesta = $resp_procedimiento['datos'];
			$id_doc_compra_venta = $respuesta['id_doc_compra_venta'];
			
			
			//////////////////////////////////////////////
			//inserta detalle de la compra
			/////////////////////////////////////////////
			
			//decodifica JSON  de detalles 
			$json_detalle = $this->aParam->_json_decode($this->aParam->getParametro('json_new_records'));			
			
			//var_dump($json_detalle)	;
			foreach($json_detalle as $f){
				
				$this->resetParametros();
				//Definicion de variables para ejecucion del procedimiento
			    $this->procedimiento='conta.ft_doc_concepto_ime';
				$this->transaccion='CONTA_DOCC_INS';
				$this->tipo_procedimiento='IME';
				
				//modifica los valores de las variables que mandaremos
				$this->arreglo['id_centro_costo'] = $f['id_centro_costo'];
								
				$this->arreglo['descripcion'] = $f['descripcion'];
				$this->arreglo['precio_unitario'] = $f['precio_unitario'];
				$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
				$this->arreglo['id_orden_trabajo'] = $f['id_orden_trabajo'];
				$this->arreglo['id_concepto_ingas'] = $f['id_concepto_ingas'];
				$this->arreglo['precio_total'] = $f['precio_total'];
				$this->arreglo['precio_total_final'] = $f['precio_total_final'];
				$this->arreglo['cantidad_sol'] = $f['cantidad_sol'];
				
				//throw new Exception("cantidad ...modelo...".$f['cantidad'], 1);
						
				//Define los parametros para la funcion
				$this->setParametro('estado_reg','estado_reg','varchar');
				$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
				$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
				$this->setParametro('id_centro_costo','id_centro_costo','int4');
				$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
				$this->setParametro('descripcion','descripcion','text');
				$this->setParametro('cantidad_sol','cantidad_sol','numeric');
				$this->setParametro('precio_unitario','precio_unitario','numeric');
				$this->setParametro('precio_total','precio_total','numeric');
				$this->setParametro('precio_total_final','precio_total_final','numeric');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al insertar detalle  en la bd", 3);
				}                    
                        
            }

             
			
			//verifica si los totales cuadran
			$this->resetParametros();
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_CHKDOCSUM_IME';
			$this->tipo_procedimiento='IME';
			
			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			
			$this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al verificar cuadre ", 3);
			}

			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}				
		}    
	    
	    return $this->respuesta;
	}

    /////////////////////////////////////////////////////////////////////////////
    //RAC 05/01/2018 para modificar   libro de comrpas para pagos simplificados
    //////////////////////////////////////////////////////////////////////////////

     function modificarPSDocCompleto(){
		
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		$copiado = false;			
		try {
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			
			/////////////////////////
			//  inserta cabecera de la solicitud de compra
			///////////////////////
			
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_DCV_MOD';
			$this->tipo_procedimiento='IME';
					
			//Define los parametros para la funcion
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			$this->setParametro('revisado','revisado','varchar');
			$this->setParametro('movil','movil','varchar');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('importe_excento','importe_excento','numeric');
			$this->setParametro('id_plantilla','id_plantilla','int4');
			$this->setParametro('fecha','fecha','date');
			$this->setParametro('nro_documento','nro_documento','varchar');
			$this->setParametro('nit','nit','varchar');
			$this->setParametro('importe_ice','importe_ice','numeric');
			$this->setParametro('nro_autorizacion','nro_autorizacion','varchar');
			$this->setParametro('importe_iva','importe_iva','numeric');
			$this->setParametro('importe_descuento','importe_descuento','numeric');
			$this->setParametro('importe_doc','importe_doc','numeric');
			$this->setParametro('sw_contabilizar','sw_contabilizar','varchar');
			$this->setParametro('tabla_origen','tabla_origen','varchar');
			$this->setParametro('estado','estado','varchar');
			$this->setParametro('id_depto_conta','id_depto_conta','int4');
			$this->setParametro('id_origen','id_origen','int4');
			$this->setParametro('obs','obs','varchar');
			$this->setParametro('estado_reg','estado_reg','varchar');
			$this->setParametro('codigo_control','codigo_control','varchar');
			$this->setParametro('importe_it','importe_it','numeric');
			$this->setParametro('razon_social','razon_social','varchar');
			$this->setParametro('importe_descuento_ley','importe_descuento_ley','numeric');
			$this->setParametro('importe_pago_liquido','importe_pago_liquido','numeric');
			$this->setParametro('nro_dui','nro_dui','varchar');
			$this->setParametro('id_moneda','id_moneda','int4');			
			$this->setParametro('importe_pendiente','importe_pendiente','numeric');
			$this->setParametro('importe_anticipo','importe_anticipo','numeric');
			$this->setParametro('importe_retgar','importe_retgar','numeric');
			$this->setParametro('importe_neto','importe_neto','numeric');
			$this->setParametro('id_auxiliar','id_auxiliar','integer');
			$this->setParametro('id_funcionario','id_funcionario','integer');
			$this->setParametro('sw_pgs','sw_pgs','varchar');			//#13
			$this->setParametro('nota_debito_agencia','nota_debito_agencia','varchar');	//#13
			//Ejecuta la instruccion
            $this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);				
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			$respuesta = $resp_procedimiento['datos'];			
			$id_doc_compra_venta = $respuesta['id_doc_compra_venta'];
			
			
			
			
			//////////////////////////////////////////////
			//inserta detalle de la compra o venta
			/////////////////////////////////////////////
						
			//decodifica JSON  de detalles 
			$json_detalle = $this->aParam->_json_decode($this->aParam->getParametro('json_new_records'));			
			
			//var_dump($json_detalle)	;
			foreach($json_detalle as $f){
				
				$this->resetParametros();
				//Definicion de variables para ejecucion del procedimiento
			    
			    
				//modifica los valores de las variables que mandaremos
				$this->arreglo['id_centro_costo'] = $f['id_centro_costo'];
				$this->arreglo['id_doc_concepto'] = $f['id_doc_concepto'];
				
				$this->arreglo['descripcion'] = $f['descripcion'];
				$this->arreglo['precio_unitario'] = $f['precio_unitario'];
				$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
				$this->arreglo['id_orden_trabajo'] = (isset($f['id_orden_trabajo'])?$f['id_orden_trabajo']:'null');
				$this->arreglo['id_concepto_ingas'] = $f['id_concepto_ingas'];
				$this->arreglo['precio_total'] = $f['precio_total'];
				$this->arreglo['precio_total_final'] = $f['precio_total_final'];
				$this->arreglo['cantidad_sol'] = $f['cantidad_sol'];
				
				
				$this->procedimiento='conta.ft_doc_concepto_ime';
				$this->tipo_procedimiento='IME';
				//si tiene ID modificamos
				if ( isset($this->arreglo['id_doc_concepto']) && $this->arreglo['id_doc_concepto'] != ''){
					$this->transaccion='CONTA_DOCC_MOD';
				}
				else{
					//si no tiene ID insertamos
					$this->transaccion='CONTA_DOCC_INS';
				}
								
				//throw new Exception("cantidad ...modelo...".$f['cantidad'], 1);
						
				//Define los parametros para la funcion
				$this->setParametro('estado_reg','estado_reg','varchar');
				$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
				$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
				$this->setParametro('id_centro_costo','id_centro_costo','int4');
				$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
				$this->setParametro('descripcion','descripcion','text');
				$this->setParametro('cantidad_sol','cantidad_sol','numeric');
				$this->setParametro('precio_unitario','precio_unitario','numeric');
				$this->setParametro('precio_total','precio_total','numeric');
				$this->setParametro('id_doc_concepto','id_doc_concepto','numeric');
				$this->setParametro('precio_total_final','precio_total_final','numeric');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al insertar detalle  en la bd", 3);
				}
                    
                        
            }
			
			/////////////////////////////
			//elimia conceptos marcado
			///////////////////////////
			
			$this->procedimiento='conta.ft_doc_concepto_ime';
			$this->transaccion='CONTA_DOCC_ELI';
			$this->tipo_procedimiento='IME';
			
			$id_doc_conceto_elis = explode(",", $this->aParam->getParametro('id_doc_conceto_elis'));			
			//var_dump($json_detalle)	;
			for( $i=0; $i<count($id_doc_conceto_elis); $i++){
				
				$this->resetParametros();
				$this->arreglo['id_doc_concepto'] = $id_doc_conceto_elis[$i];
				//Define los parametros para la funcion
				$this->setParametro('id_doc_concepto','id_doc_concepto','int4');
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al eliminar concepto  en la bd", 3);
				}
			
			}
			//verifica si los totales cuadran
			$this->resetParametros();
			$this->procedimiento='conta.ft_doc_compra_venta_ime';
			$this->transaccion='CONTA_CHKDOCSUM_IME';
			$this->tipo_procedimiento='IME';
			
			$this->arreglo['id_doc_compra_venta'] = $id_doc_compra_venta;
			$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
			
			$this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al verificar cuadre ", 3);
			}	
			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}
				
		}    
	    
	    return $this->respuesta;
	}
	
			
}
?>