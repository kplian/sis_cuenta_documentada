<!DOCTYPE html>
<html>    
    <head>
        <style type='text/css'>
            div
            {
                width:80px;
                height: 35px;
                vertical-align:middle;
                text-align: center;
            }     
            table.mp_c1 {
                font-family: Verdana, Geneva, sans-serif;
                border: 2px solid #000000;
                background-color: #F0F1EB;
                text-align: left;
                font-size: 9px;
                text-align: left;
                height: 22px;
                display: table-header-group;
                page-break-inside:auto ;
            }
        </style>
        
    </head>
    <body>
        <table>
            <tr>
                <td style="height:25;border:1px solid #999;" width="15%" align="center"><h1 style="font-size:20%;color:white;">This is a heading</h1><img width="80" height="50" src="./../../../lib/imagenes/logos/logo.jpg"></td>
                <td style="border:1px solid #999;text-align: center;" width="65%"><h1 style="font-size:35%;color:white;">This is a heading</h1><h2 style="font-family:courier,arial,helvética;">DETALLE DE PASAJES PARA AUTORIZACION</h2></td>
                <td style="border:1px solid #999;text-align: center;" width="20%"><h1 style="font-size:50%;color:white;">This is a heading</h1><h4 style="font-family:courier,arial,helvética;">REGISTRO 5-R-272</h4></td>
            </tr>
        </table>
        <p style="height: 50px;"></p>
        <table class="mp_c1" border="1" >
            <thead>
                <tr style="border: 2px solid #300BE7;display:table-header-group;font-size: 7;padding: 2px 2px;text-align: center;background-color: #81BEF7;border-left: 2px solid #000000;">
                    <th style="width: 68px;">NOTA DE DEBITO</th>
                    <th style="width: 110px;">NOMBRE DEL PASAJERO</th>
                    <th style="width: 80px;">N&ordm;  FACTURA</th>
                    <th style="width: 78px;">PROCESO VI</th>
                    <th style="width: 120px;">RUTA, MOTIVO Y FECHA</th>
                    <th style="width: 155px;">CENTRO DE COSTO</th>
                    <th style="width: 50px;">MONEDA</th>
                    <th style="width: 68px;">IMPORTE</th>
                    <th style="width: 48px;font-size: 5;word-wrap: break-word;overflow-wrap: break-word;">PASAJE UTILIZADO / PENDIENTE</th>
                    <th style="width: 80px;">FIRMA AUTORIZADA</th>
                    <th style="width: 80px;">NOMBRE</th>
                </tr>
            </thead>
            <p></p>
            <tbody>
                <?php  
                    $sum=0;
                    $datos = array(); 
                    $datos = $this->datos_detalle;
                    
                    foreach ($datos as $keyOut => $out) {
                        $tds = ''; 
                        foreach($out as $keyIn => $value) {
                            if($keyIn=='importe_doc'){
                                $sum+= $value;
                            }
                            if($keyIn=='nota_debito_agencia'){
                                $tds .= '<td align="center" style="width: 68px">'.$value.'</td>';
                            }
                            if($keyIn=='desc_funcionario2'){
                                $tds .= '<td style="width: 110px">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_documento'){
                                $tds .= '<td align="center" style="width: 80px">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_tramite'){
                                $tds .= '<td align="center" style="width: 78px">'.$value.'</td>';
                            }  
                            if($keyIn=='obs'){
                                $tds .= '<td style="width: 120px;word-wrap: break-word;overflow-wrap: break-word;">'.$value.'</td>';
                            }  
                            if($keyIn=='descripcion'){
                                $tds .= '<td align="left" style="width: 155px;">'.$value.'</td>';
                            }  
                            if($keyIn=='desc_moneda'){
                                $tds .= '<td align="center" style="width: 50px;">'.$value.'</td>';
                            } 
                            if($keyIn=='importe_doc'){
                                $tds .= '<td align="right" style="width: 68px;">'.number_format($value,2).'</td>';
                            }
                            if($keyIn=='consumido'){
                                $tds .= '<td align="center" style="width: 48px;">'.$value.'</td>';
                            }
                        } 
                        $tds .= '<td style="width: 80px;"></td><td style="width: 80px;"></td>';
                        echo '<tr style="page-break-inside:avoid;page-break-after:auto;">'.$tds.'</tr>';
                    }
                    echo '<tr style="page-break-inside:avoid;page-break-after:auto;"><td colspan="11" style="background-color: white;" height="20px"></td></tr>';
                    echo '<tr align="right" style="page-break-inside:avoid;page-break-after:auto;background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">TOTAL</td><td colspan="6" style="background-color: white;" align="right" height="15px">'.number_format($sum,2).'</td></tr>';
                ?>
            </tbody>
        </table>
        <p></p>
        <div style="text-align: center;">
            <table border="1" style="font-size: 8;padding: 2px 2px;">
                <tr style='text-align: center;'>
                    <td width="280px" height="25px" style=' text-align: center;'>&nbsp;</td>
                </tr>
                <tr>
                    <td style='text-align: center;'>Elaborado por:</td>
                </tr>
            </table>  
        </div>  
    </body>
</html>

