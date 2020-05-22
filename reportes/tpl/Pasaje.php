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
                <td style="height:50px;" width="10%" align="center"><img width="35" height="35" src="./../../../lib/imagenes/logos/logo.jpg"></td>
                <td width="90%" align="center"><h3 class="post-title">DETALLE DE PASAJES PARA AUTORIZACION</h3></td>      
            </tr>
        </table>
        <p></p>
        <table class="mp_c1" border="1" >
            <thead>
                <tr style="border: 2px solid #300BE7;font-size: 8;padding: 2px 2px;text-align: center;background-color: #81BEF7;border-left: 2px solid #000000;">
                    <th style="width: 70px;">NOTA DE DEBITO</th>
                    <th style="width: 90px;">NOMBRE DEL PASAJERO</th>
                    <th style="width: 70px;">N&ordm;  FACTURA</th>
                    <th style="width: 80px;">PROCESO (VI/FA)</th>
                    <th style="width: 150px;">MOTIVO, FECHA Y RUTA</th>
                    <th style="width: 180px;">CENTRO DE COSTO</th>
                    <th style="width: 60px;">MONEDA</th>
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
                                $tds .= '<td style="width: 70px">'.$value.'</td>';
                            }
                            if($keyIn=='desc_funcionario2'){
                                $tds .= '<td style="width: 90px">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_documento'){
                                $tds .= '<td style="width: 70px">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_tramite'){
                                $tds .= '<td style="width: 80px">'.$value.'</td>';
                            }  
                            if($keyIn=='obs'){
                                $tds .= '<td style="width: 150px;">'.$value.'</td>';
                            }  
                            if($keyIn=='descripcion'){
                                $tds .= '<td style="width: 180px;">'.$value.'</td>';
                            }  
                            if($keyIn=='desc_moneda'){
                                $tds .= '<td style="width: 60px;">'.$value.'</td>';
                            } 
                            if($keyIn=='importe_doc'){
                                $tds .= '<td style="width: 70px;">'.number_format($value,2).'</td>';
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
    </body>
</html>

