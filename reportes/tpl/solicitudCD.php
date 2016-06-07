<table width="100%" cellspacing="0" cellpadding="0" border="1">
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
	<?php if($this->datos_detalle[0]["tipo_pago"] == 'transferencia'){?>
		<tr>
			<td width="100%" class="td_label"><font size="9"><b>A FAVOR DE:</b>&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["desc_funcionario"]."(".$this->datos_detalle[0]["desc_funcionario_cuenta_bancaria"].")" ?> </font></td>
		</tr>
	<?php 
	 }
	 else {?>
		<tr>
			<td width="100%" class="td_label"><font size="9">&nbsp;<b>A FAVOR DE:</b>&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["nombre_cheque"]?></font></td>
		</tr>
	<?php }?>
	<tr>
		<td width="100%" class="td_label"><font size="9">&nbsp;<b>MOTIVO:</b>&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["motivo"]?></font></td>
	</tr>
	<tr>
		<td width="50%" class="td_label"><font size="9">&nbsp;<b>LUGAR:</b>&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["lugar"]?></font></td>
		<td width="50%" class="td_label"><font size="9">&nbsp;<b>TIPO PAGO:</b>&nbsp;&nbsp;&nbsp;<?php echo strtoupper($this->datos_detalle[0]["tipo_pago"])?></font></td>
	</tr>
	<tr>
		<td width="70%" class="td_label" rowspan="42"><font size="9">&nbsp;<b>MONTO (Literal):</b><br/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php echo $this->datos_detalle[0]["importe_literal"].'  '. $this->datos_detalle[0]['desc_moneda']; ?></font></td>
		<td width="30%" class="td_label" align="center"><font size="9">&nbsp;<b>MONTO (<?php  echo $this->datos_detalle[0]['desc_moneda']; ?> ):</b></font></td>
	</tr>
	<tr>
		<td width="30%" class="td_label" align="right"><font size="9"><?php echo number_format($this->datos_detalle[0]["importe"], 2, '.', ',') ?>&nbsp;&nbsp;&nbsp;</font></td>
	</tr>
</tbody></table>
<br><br>
<table width="100%" cellspacing="0" cellpadding="0" border="1">
	<tbody><tr>		
		<td width="33.33%" class="td_label" align="center"><font size="9"><b><span>SOLICITUD</span></b></font></td>		
		<td width="33.33%" class="td_label" align="center"><font size="9"><b><span>AUTORIZACION</span></b></font></td>
		<td width="33.33%" class="td_label" align="center"><font size="9"><b><span>Vo. Bo.</span></b></font></td>
	</tr>
	<tr>
		<td width="33.33%" class="td_label"><br><br><br></td>
		<td width="33.33%" class="td_label"><br><br><br></td>
		<td width="33.33%" class="td_label"><span></span></td>
	</tr>
	<tr>
		<td width="33.33%" class="td_label"><span></span></td>
		<td width="33.33%" class="td_label"><span></span></td>
		<td width="33.33%" class="td_label"><span></span></td>
	</tr>
</tbody></table>