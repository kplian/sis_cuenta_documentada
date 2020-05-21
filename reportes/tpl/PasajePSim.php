<!DOCTYPE html>
<html>    
    <head>
        <style type='text/css'>
            div
            {
                height: 35px;  
                vertical-align:middle;                
                text-align: center;
            }     
            table.mp_c1 {
                font-family: Verdana, Geneva, sans-serif;
                border: 2px solid #000000;
                background-color: #F0F1EB;        
                text-align: left;
            }
            table.mp_c1 td{
                border: 1px solid #000000;       
                font-size: 9px;
                text-align: left;
                height: 22px;
            }
            table.mp_c2 tr{
                border: 1px solid #000000;       
                font-size: 9px;
                text-align: center;
                padding: 2px 2px;                
            }      
            .post-container {                
                border: 1px solid #333;
                overflow: auto
            }
            .post-thumb {
                float: left
            }
            .post-content {
                margin-left: 50px
            }
            .post-title {
                font-weight: bold;
                font-size: 12px;
            }
            body {
                margin: 0px;
            }
        </style>
        
    </head>
    <body>            
        <div id='div'>           
            <img width="15" height="15" style="float:left" src="./../../../lib/imagenes/logos/logo.jpg">            
            <h3 class="post-title">PROCESO DE REGISTRO DE PASAJES AEREOS</h3>                
        </div>
        <table class="mp_c1" border="1" >
            <thead>
                <tr style="border: 2px solid #300BE7;font-size: 8;padding: 2px 2px;text-align: center;background-color: #81BEF7;border-left: 2px solid #000000;">                    
                    <th style="width: 90px;">NOMBRE DEL PASAJERO</th>
                    <th style="width: 70px;">N&ordm;  FACTURA</th>
                    <th style="width: 70px;">NOTA DE DEBITO</th>
                    <th style="width: 110px;">PROCESO (VI/FA)</th>
                    <th style="width: 200px;">MOTIVO, FECHA Y RUTA</th>
                    <th style="width: 250px;">CENTRO DE COSTO</th>                    
                    <th style="width: 150px;">IMPORTE</th>
                </tr>        
            </thead>  
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
                                $tds .= '<td style="width: 70px; height=100px;">'.$value.'</td>';
                            }
                            if($keyIn=='desc_funcionario2'){
                                $tds .= '<td style="width: 90px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_documento'){
                                $tds .= '<td style="width: 70px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_tramite'){
                                $tds .= '<td style="width: 110px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='obs'){
                                $tds .= '<td style="width: 200px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='descripcion'){
                                $tds .= '<td style="width: 250px; height=30px;">'.$value.'</td>';
                            } 
                            if($keyIn=='importe_doc'){
                                $tds .= '<td align="right" style="width: 150px; height=30px;">'.number_format($value,2).'</td>';
                            }  
                            if($keyIn=='tipago'){
                                $tpopago=$value;
                            }                                                         
                            if($keyIn=='rotulo_comercial'){
                                $rotulo=$value;
                            } 
                            if($keyIn=='desc_moneda'){
                                $moneda=$value;
                            }               
                        }  
                        if($keyIn=='importe_doc'){
                                $sum+= $value;
                            }             
                        echo '<tr>'.$tds.'</tr>';                   
                    }                            
                    echo '<tr ><td colspan="7" style="background-color: white;" height="20px"></td></tr>';                    
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">TOTAL</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.number_format($sum,2).'</td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">OTROS</td><td colspan="5" style="background-color: white;" align="right" height="15px">0</td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">LIQUIDO PAGABLE</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.number_format($sum,2).'</td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">MONEDA</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.$moneda.'</td></tr>';                    
                    echo '<tr><td colspan="7" style="background-color: white;" height="10px"></td></tr>';                    
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">TIPO SOLICITUD</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.$tpopago.'</td></tr>';                    
                    echo '<tr><td colspan="7" style="background-color: white;" height="10px"></td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">NRO CHEQUE</td><td colspan="5" style="background-color: white;" align="right" height="15px"></td></tr>';
                    echo '<tr><td colspan="7" style="background-color: white;" height="10px"></td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">BENEFICIARIO</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.$rotulo.'</td></tr>';
                ?>                                       
            </tbody>              
        </table> 
        <p></p>
        <table border="0" align="center" >
            <table border="1" align="center" width="500px" style="font-size: 8;padding: 2px 2px;">
                <tbody>
                    <tr style='width: 80px; text-align: center;'>
                        <td style='width: 80px; text-align: center;'>
                            <p>&nbsp;</p>
                        </td>
                        <td style='width: 80px; text-align: center;'>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style='width: 80px; text-align: center;'>Depto Contabilidad</td>
                        <td style='width: 80px; text-align: center;'>Depto Finanzas</td>
                    </tr>
                </tbody>
            </table>  
        </table>     
    </body>
</html>

