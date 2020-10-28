<!DOCTYPE html>
<html>    
    <head>
        <style type='text/css'>            
            table.mp_c1 {
                font-family: Verdana, Geneva, sans-serif;
                border: 2px solid #000000;
                background-color: #F0F1EB;        
                text-align: left;
            }
            table.mp_c1 td{
                border: 1px solid #000000;       
                font-size: 9px;
                text-align: center;
                height: 22px;
                vertical-align: middle;
            }
            table.mp_c2 tr{
                border: 1px solid #000000;       
                font-size: 9px;
                text-align: center;
                padding: 2px 2px; 
                vertical-align: middle;               
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
                align:center;
                vertical-align: middle;
            }
            body {
                margin: 0px;
            }
            table.mp_c2 {
                border: 1px;
                display: inline-table;            
            }
        </style>
        
    </head>
    <body>            
        <table>
            <tr>
                <td style="height:40px;" width="10%" align="center"><img width="110" height="75" src="./../../../lib/imagenes/logos/logo.jpg" alt="Logo"></td>                
                <td width="90%" align="center"><h3 class="post-title">PROCESO DE REGISTRO DE PASAJES AEREOS</h3></td>      
            </tr>
        </table>
        <?php  
            $sum=0;           
            $datos1 = array(); 
            $datos1 = $this->datos_detalle; 
            $myarray = array_shift($datos1);                       
        ?>      
        <table class="mp_c1" border="1" >
            <tr style="background-color: #81BEF7;vertical-align: middle;font-size: 7;border: 2px solid #300BE7;  ">       
                <td width="17.5%" height="16px">BENEFICIARIO</td>                
                <td valign="middle" width="82.4%" height="16px" style="background-color: white;" align="left" ><?php echo $myarray['rotulo_comercial'];?></td>
            </tr>
            <tr style="background-color: #81BEF7;vertical-align: middle;font-size: 7;border: 2px solid #300BE7;  ">       
                <td width="17.5%" height="16px">NRO TRAMITE</td>                
                <td valign="middle" width="82.4%" height="16px" style="background-color: white;" align="left" ><?php echo $myarray['tram'];?></td>
            </tr>
        </table>      
        <!--p></p-->
        <br>
        <table class="mp_c1" border="1" >
            <thead>
                <tr height="auto" valign="middle" style="border: 2px solid #300BE7;font-size: 7;padding: 2px 2px;text-align: center;background-color: #81BEF7;border-left: 2px solid #000000;">                    
                    <td align="center" style="width: 140px;">NOMBRE DEL PASAJERO</td>
                    <td align="center" style="width: 70px;">N&ordm;  FACTURA</td>
                    <td align="center"style="width: 70px;">NOTA DE DEBITO</td>
                    <td align="center"style="width: 80px;">PROCESO VI</td>
                    <td align="center"style="width: 180px;"><br/>RUTA, MOTIVO Y FECHA</td>
                    <td align="center" style="vertical-align: middle;width: 250px; ">CENTRO DE COSTO</td>                    
                    <td align="center" style="width: 120px;">IMPORTE</td>
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
                                $tds .= '<td align="center" style="width: 70px; height=100px;">'.$value.'</td>';
                            }
                            if($keyIn=='desc_funcionario2'){
                                $tds .= '<td style="width: 140px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_documento'){
                                $tds .= '<td align="center" style="width: 70px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='nro_tramite'){
                                $tds .= '<td style="width: 80px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='obs'){
                                $tds .= '<td style="width: 180px; height=30px;">'.$value.'</td>';
                            }  
                            if($keyIn=='descripcion'){
                                $tds .= '<td style="width: 250px; height=30px;">'.$value.'</td>';
                            } 
                            if($keyIn=='importe_doc'){
                                $tds .= '<td align="right" style="width: 120px; height=30px;">'.number_format($value,2).'</td>';
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
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">TOTAL</td><td style="background-color: white;" align="right" height="15px">'.$moneda.'</td><td colspan="4" style="background-color: white;" align="right" height="15px">'.number_format($sum,2).'</td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">OTROS</td><td style="background-color: white;" align="right" height="15px">'.$moneda.'</td><td colspan="4" style="background-color: white;" align="right" height="15px">0</td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">LIQUIDO PAGABLE</td><td style="background-color: white;" align="right" height="15px">'.$moneda.'</td><td colspan="4" style="background-color: white;" align="right" height="15px">'.number_format($sum,2).'</td></tr>';
                    //echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">MONEDA</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.$moneda.'</td></tr>';                    
                    echo '<tr><td colspan="7" style="background-color: white;border-right-color: white;border-left-color: white;border-left: 0px" height="10px"></td></tr>';                    
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">TIPO SOLICITUD</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.$tpopago.'</td></tr>';                    
                    echo '<tr><td colspan="7" style="background-color: white;border-right-color: white;border-left-color: white;border-left: 0px" height="10px"></td></tr>';                    
                   // echo '<tr style="border: solid 0.3em gold;border-right-color: red;"><td colspan="7" style="background-color: white;border-right-color: red;" height="10px;"></td></tr>';
                    echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">NRO CHEQUE</td><td colspan="5" style="background-color: white;" align="right" height="15px"></td></tr>';
                   // echo '<tr><td colspan="7" style="background-color: white;" height="10px"></td></tr>';
                   // echo '<tr align="right" style="background-color: #81BEF7;vertical-align: middle"><td colspan="2" style="height: 15px;">BENEFICIARIO</td><td colspan="5" style="background-color: white;" align="right" height="15px">'.$rotulo.'</td></tr>';
                ?>                                       
            </tbody>              
        </table> 
       
        <!--p></p>
        <div style="text-align: center;">                    
            <table align="center" valign="middle" border="1" style="font-size: 8;padding: 2px 2px;">            
                <tr align="center" style='text-align: center;'>
                    <td width="280px" height="25px" style='text-align: center;'>&nbsp;</td>     
                    <td width="280px" height="25px" style='text-align: center;'>&nbsp;</td>                
                </tr>
                <tr>
                    <td style='text-align: center;'>Depto Contabilidad</td> 
                    <td style='text-align: center;'>Depto Finanzas</td>                    
                </tr>                
            </table>  
        </div-->     
    </body>
</html>

