<!DOCTYPE html>
<head>
   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>

<title> Datos enviados </title>

<body>
<div class="page-header bg-primary text-white text-center">
		<span class="h4">The Whisky Club Administration</span>
</div>

<br>
<form action="menu.html" method="" style="width:40%;margin:0 auto;">
   <fieldset>
   <legend class="text-center header text-success">All Products</legend>
   <br>
   <br>
   
   <table border='1' cellpadding='0' cellspacing='0' width='750' bgcolor='#F6F6F6' bordercolor='#FFFFFF' align='center' >
      <tr>
         <td width='150' style='font-weight: bold; text-align:center''>ID</td>
         <td width='250' style='font-weight: bold; text-align:center'>Name</td>
         <td width='150' style='font-weight: bold; text-align:center'>Aged</td> 
         <td width='150' style='font-weight: bold; text-align:center'>Supplier</td> 
         <td width='150' style='font-weight: bold; text-align:center'>Presentation</td> 
         <td width='150' style='font-weight: bold; text-align:center'>Currency</td> 
         <td width='150' style='font-weight: bold; text-align:center'>Cost</td>
         <td width='150' style='font-weight: bold; text-align:center'>Product Type</td>
         <td width='150' style='font-weight: bold; text-align:center'>Special</td>
         <td width='150' style='font-weight: bold; text-align:center'>Active</td>
      </tr>
      
      <?php
         $host='localhost';
         $bd='MasterDB';
         $user='postgres';
         $pass='atomico';

         $conexion=pg_connect("host=$host dbname=$bd user=$user password=$pass");
         $query=("SELECT id,name_,aged,idSupplier,presentation,currency,cost_,idtypeproduct,special,active_ FROM Product;"); 
         $consult=pg_query($conexion,$query);

         while ($registro = pg_fetch_array($consult))
         {
            
            $querySupplier = ("SELECT name_ from supplier where id = '$registro[idsupplier]';");
            $consultName = pg_query($conexion,$querySupplier);
            $idSupplier = pg_fetch_array($consultName);

            $queryType = ("SELECT name_ from producttype where id = '$registro[idtypeproduct]';");
            $consultType = pg_query($conexion,$queryType);
            $idProduct = pg_fetch_array($consultType);

            $querySpecial = ("SELECT special from product where id = '$registro[id]';");
            $consultSpecial = pg_query($conexion,$querySpecial);
            $special = pg_fetch_array($consultSpecial);
            if($special['special'] == 't')
               $specialFix = 'Yes';
            else
               $specialFix = 'No';

            $queryActive = ("SELECT active_ from product where id = '$registro[id]';");
            $consultActive = pg_query($conexion,$queryActive);
            $Active = pg_fetch_array($consultActive);
            if($Active['active_'] == 't')
               $activeFix = 'Yes';
            else
               $activeFix = 'No';

            echo"
            <tr>
            <td style='text-align:center' width='150'>".$registro['id']."</td>
            <td style='text-align:center' width='150'>".$registro['name_']."</td>
            <td style='text-align:center' width='150'>".$registro['aged']."</td>
            <td style='text-align:center' width='150'>".$idSupplier['name_']."</td>
            <td style='text-align:center' width='150'>".$registro['presentation']."</td>
            <td style='text-align:center' width='150'>".$registro['currency']."</td>
            <td style='text-align:center' width='150'>".$registro['cost_']."</td>
            <td style='text-align:center' width='150'>".$idProduct['name_']."</td>
            <td style='text-align:center' width='150'>".$specialFix."</td>
            <td style='text-align:center' width='150'>".$activeFix."</td>
            </tr>
            ";           
         }
            pg_close();
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