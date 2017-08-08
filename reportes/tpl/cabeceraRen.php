
<table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">
	<tbody>
	<tr>
		<td style="width: 23%; color: #444444; " rowspan="4">
			 &nbsp;<br/>
			<img  style="width: 100px;" src="./../../../lib/imagenes/logos/logo.jpg" alt="Logo">
		</td>		
		<td style="width: 54%; color: #444444;" rowspan="2"><h1><?php  echo $titulo1?></h1></td>
		<td style="width: 23%; color: #444444;"><b>Depto.:</b> <?php  echo $this->datos_detalle[0]['desc_depto']; ?> </td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>N°:</b> <?php echo $this->datos_detalle[0]["nro_tramite"].'-'.$this->datos_detalle[0]["num_rendicion"]?> </td>
	</tr>
	<tr>
		<td style="width: 54%; color: #444444;" rowspan="2"><h2><?php if ($titulo3 == 'borrador') { echo $titulo2.'<br><span style="color: red;">Borrador</div>';}else{echo $titulo2;} ?></h2></td>
		<td style="width: 23%; color: #444444;"><b>Fecha:</b> <?php  echo $newDate; ?></td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>Moneda</b> <?php  echo $this->datos_detalle[0]['desc_moneda']; ?> </td>
	</tr>
</tbody>
</table>