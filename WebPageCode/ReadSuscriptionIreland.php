<!DOCTYPE html>
<head>
   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>

<title>Tiers </title>

<body>
<div class="page-header bg-primary text-white text-center">
		<span class="h4">The Whisky Club Administration: Ireland</span>
</div>

<br>
<form action="menu.html" method="" style="width:40%;margin:0 auto;">
   <fieldset>
   <legend class="text-center header text-success">Suscription Data</legend>
   <br>
   <br>

   <table border='1' cellpadding='0' cellspacing='0' width='750' bgcolor='#F6F6F6' bordercolor='#FFFFFF' align='center' >
      <tr>
         <td width='150' style='font-weight: bold; text-align:center''>ID</td>
         <td width='250' style='font-weight: bold; text-align:center'>Name</td>
         <td width='150' style='font-weight: bold; text-align:center'>Buy Discount</td> 
         <td width='150' style='font-weight: bold; text-align:center'>Delivery Discount</td> 
         <td width='150' style='font-weight: bold; text-align:center'>Cost</td>
      </tr>
      
      <?php
         $host = 'localhost';
         $dbname = 'IrelandStore';
         $username = 'sa';
         $password= '12345678';
         $puerto = 62727;
         $serverName = "PINK-KIRBY\ENTERPRISE2, 62727";

         //connexion controls
         $connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
         $conexion = sqlsrv_connect( $serverName, $connectionInfo);

         $queryControl = "EXEC ReadSuscription '$_REQUEST[name]',0";
         $consult = sqlsrv_query($conexion,$queryControl);
         while ($registro = sqlsrv_fetch_array($consult))
         {    
            echo"
            <tr>
            <td width='150' style='text-align:center'>".$registro['id']."</td>
            <td width='150' style='text-align:center'>".$registro['name_']."</td>
            <td width='150' style='text-align:center'>".$registro['discountBuy']."</td>
            <td width='150' style='text-align:center'>".$registro['discountDelivery']."</td>
            <td width='150' style='text-align:center'>".$registro['cost_']."</td>
            </tr>
            "; 
            
         }
      ?>
   </table>
   <br>
   <br>
   <br>
      <div class="form-group">
         <a href="adminMenu.html">
			   <input type="button" class="btn btn-success form-control" name="aceptar" value="Back To Menu">
         </a>
         
		</div>
	</fieldset>
</form>   

</body>

</html>