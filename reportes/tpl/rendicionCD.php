<table width="100%" cellpadding="5px"  rules="cols" border="1" style="font-size: 9" border="1">
	<tbody>
	<tr>		
		<td width="33.33%" class="td_label" align="center"><span><b>Nombre y Apellido</b></span></td>		
		<td width="33.33%" class="td_label" align="center"><span><b>Cargo</b></span></td>
		<td width="33.33%" class="td_label" align="center"><span><b>Centro Responsable</b></span></td>
	</tr>
	<tr>
		<td width="33.33%" class="td_label"><font size="9">&nbsp;<?php echo $this->datos_detalle[0]["desc_funcionario"]?></font></td>
		<td width="33.33%" class="td_label"><font size="9">&nbsp;<?php echo $this->datos_detalle[0]["cargo_funcionario"]?></font></td>
		<td width="33.33%" class="td_label"><font size="9">&nbsp;<?php echo $this->datos_detalle[0]["nombre_unidad"]?></font></td>
	</tr>
	
	<tr>
		<td width="66.66%" class="td_label"><font size="9">&nbsp;<b>MOTIVO:</b>&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["motivo_ori"]?></font></td>
	    <td width="33.33%" class="td_label"><font size="9">&nbsp;<b>LUGAR:</b>&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["lugar"]?></font></td>
		
	</tr>
	
	<tr>
		<td width="66.66%" class="td_label" rowspan="42"><font size="9">&nbsp;<b>MONTO (Literal):</b><br/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["importe_literal"].'  '. $this->datos_detalle[0]['desc_moneda']; ?></font></td>
		<td width="33.33%"  align="center"><font size="9">&nbsp;<b>MONTO (<?php  echo $this->datos_detalle[0]['desc_moneda']; ?> ):</b></font></td>
	</tr>
	<tr>
		<td width="33.33%"  align="right"><font size="9"><?php echo number_format($this->datos_detalle[0]["importe"], 2, '.', ',') ?>&nbsp;&nbsp;&nbsp;</font></td>
	</tr>
 </tbody>
</table>	 
<table width="100%" cellpadding="5px"  rules="cols" border="1" style="font-size: 9"> 
<tbody>
	
	 <tr>
		<td width="100%" colspan="4" align="left" ><b>DOCUMENTOS DE COMPRA</b></td>
	 </tr>  
     <tr>
     	<td width="15%"  align="center" ><b>FECHA</b></td>
		<td width="20%"  align="center" ><b>DOCUMENTO</b></td>
		<td width="50%"  align="center" ><b>DESCRIPCION</b></td>
		<td width="15%"  align="center" ><b>DESCARGO</b></td>
	 </tr>
	
	
	<?php 
	   $total_facturas = 0;
	   
	  
	   foreach($this->facturas as $key=>$val){
	   	 $newDate = date("d/m/Y", strtotime(  $val['fecha']));	
		 $total_facturas = $total_facturas	 + $val['importe_pago_liquido'];   
	   	
	   	?>
	   	<tr>
		   	<td width="15%"  align="left" ><?php  echo $newDate;?></td>
			<td width="20%"  align="left" ><?php  echo $val['desc_plantilla'].' (N# '.$val['nro_documento'].')<br>Prov. '.$val['razon_social'].' NIT: '.$val['nit']; ?></td>
			<td width="50%"  align="left" ><?php  echo $val['detalle']; ?></td>
			<td width="15%"  align="right" ><?php  echo number_format($val['importe_pago_liquido'], 2, '.', ','); ?></td>
	   	</tr>
	   	
	<?php } ?>
	
	<tr>
		<td width="85%" align="right"><b>Total Liquido Pagable&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
	    <td width="15%" align="right" class="td_currency"><span><b><?php  echo number_format($total_facturas, 2, '.', ','); ?></b></span></td>
	</tr>
	
	<tr>
		<td width="85%" align="right"><b>Total Retenciones&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
	    <td width="15%" align="right" class="td_currency"><span><b><?php  echo number_format($this->retenciones, 2, '.', ','); ?></b></span></td>
	</tr>
	
		
    </tbody>
</table>

<table width="100%" cellpadding="5px"  rules="cols" border="1" style="font-size: 9"> 
<tbody>
	
	 <tr>
		<td width="100%" colspan="4" align="left" ><b>DEPOSITOS BANCARIOS</b></td>
	 </tr>  
     <tr>
     	<td width="15%"  align="center" ><b>FECHA</b></td>
		<td width="20%"  align="center" ><b>FINALIDAD</b></td>
		<td width="50%"  align="center" ><b>CUENTA BANCARIA</b></td>
		<td width="15%"  align="center" ><b>DESCARGO</b></td>
	 </tr>
	 
	 
	 <?php 
	   $total_deposito = 0;
	   
	  
	   foreach($this->datos_depositos as $key=>$val){
	   	 $newDate = date("d/m/Y", strtotime(  $val['fecha']));	
		 $total_deposito = $total_deposito	 + $val['importe_deposito'];   
	   	?>
	   	
	   	<tr>
		   	<td width="15%"  align="left" ><?php  echo $newDate;?></td>
			<td width="20%"  align="left" ><?php  echo $val['nombre_finalidad']; ?></td>
			<td width="50%"  align="left" ><?php  echo $val['denominacion'].' ('.$val['nro_cuenta'].')'; ?></td>
			<td width="15%"  align="right" ><?php  echo number_format($val['importe_deposito'], 2, '.', ',');?></td>
	   	</tr>
	
	
	 
	  <?php } ?> 	
	
	
	<tr>
		<td width="85%" align="right"><b>Total Depositos&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
	    <td width="15%" align="right" class="td_currency"><span><b><?php  echo number_format($total_deposito, 2, '.', ','); ?></b></span></td>
	</tr>
	<tr>
		<td width="85%" align="right"><b>TOTAL DESCARGOS&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
	    <td width="15%" align="right" class="td_currency"><span><b><?php  echo number_format($total_deposito + $total_facturas + $this->retenciones, 2, '.', ','); ?></b></span></td>
	</tr>
	
	<tr>
		<td width="85%" align="right"><b>SALDO A FAVOR DE LA EMPRESA&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
	    <td width="15%" align="right" class="td_currency"><span><b><?php  echo number_format($this->datos_detalle[0]["importe_solicitado"] - ($total_deposito + $total_facturas + $this->retenciones), 2, '.', ','); ?></b></span></td>
	</tr>
	
    </tbody>
</table>
