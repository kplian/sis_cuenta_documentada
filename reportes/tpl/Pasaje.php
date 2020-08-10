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
        </style>
        
    </head>
    <body>
        <table>
            <tr>
                <td style="height:40px;" width="10%" align="center"><img width="110" height="75" src="./../../../lib/imagenes/logos/logo.jpg"></td>
                <td width="90%" align="center"><h3 class="post-title">DETALLE DE PASAJES PARA AUTORIZACION</h3></td>                    
            </tr>
        </table>        
        <table class="mp_c1" border="1" >
            <thead>
                <tr style="border: 2px solid #300BE7;font-size: 7;padding: 2px 2px;text-align: center;background-color: #81BEF7;border-left: 2px solid #000000;">
                    <th style="width: 70px;">NOTA DE DEBITO</th>
                    <th style="width: 110px;">NOMBRE DEL PASAJERO</th>
                    <th style="width: 70px;">N&ordm;  FACTURA</th>
                    <th style="width: 78px;">PROCESO (VI/FA)</th>
                    <th style="width: 120px;">MOTIVO, FECHA Y RUTA</th>
                    <th style="width: 180px;">CENTRO DE COSTO</th>
                    <th style="width: 55px;">MONEDA</th>
                    <th style="width: 70px;">IMPORTE</th>
                    <th style="width: 80px;">FIRMA AUTORIZADA</th>
                    <th style="width: 80px;">NOMBRE</th>   
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
                                $tds .= '<td align="center" style="width: 70px">'.$value.'</td>';
                            }
                            if($keyIn=='desc_funcionario2'){
                                $tds .= '<td style="width: 110px">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_documento'){
                                $tds .= '<td align="center" style="width: 70px">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_tramite'){
                                $tds .= '<td align="center" style="width: 78px">'.$value.'</td>';
                            }  
                            if($keyIn=='obs'){
                                $tds .= '<td style="width: 120px;">'.$value.'</td>';
                            }  
                            if($keyIn=='descripcion'){
                                $tds .= '<td align="left" style="width: 180px;">'.$value.'</td>';
                            }  
                            if($keyIn=='desc_moneda'){
                                $tds .= '<td align="center" style="width: 55px;">'.$value.'</td>';
                            } 
                            if($keyIn=='importe_doc'){
                                $tds .= '<td align="right" style="width: 70px;">'.number_format($value,2).'</td>';
                            }                            
                        } 
                        $tds .= '<td style="width: 80px;"></td><td style="width: 80px;"></td>';                
                        echo '<tr>'.$tds.'</tr>';                   
                    }                            
                    echo '<tr ><td colspan="10" style="background-color: white;" height="20px"></td></tr>';                    
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">TOTAL</td><td colspan="6" style="background-color: white;" align="right" height="15px">'.number_format($sum,2).'</td></tr>';                    
                ?>                                       
            </tbody>              
        </table>
        <p></p>
        <div style="text-align: center;">                    
            <table border="1" style="font-size: 8;padding: 2px 2px;">            
                <tr>
                    <td style='width: 100px; text-align: center;'>&nbsp;</td>
                    <td style='width: 100px; text-align: center;'>&nbsp;</td>
                </tr>
                <tr>
                    <td style='width: 100px; text-align: center;'>Depto Contabilidad</td>
                    <td style='width: 100px; text-align: center;'>Depto Finanzas</td>
                </tr>                
            </table>  
        </div>  
    </body>
</html>

