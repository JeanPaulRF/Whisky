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
      </tr>
      
      <?php
         $host='localhost';
         $bd='MasterDB';
         $user='postgres';
         $pass='atomico';

         $conexion=pg_connect("host=$host dbname=$bd user=$user password=$pass");
         $query=("SELECT ReadProduct('$_REQUEST[name]')");
         $consult=pg_query($conexion,$query);

         while ($registro = pg_fetch_array($consult))
         {    
            $result = implode(",",$registro);
            $result = explode(",",$result);
            $result = str_replace("(","",$result);
            $result = str_replace(")","",$result);
            echo"
            <tr>
            <td width='150' style='text-align:center'>".$result[0]."</td>
            <td width='150' style='text-align:center'>".$result[1]."</td>
            <td width='150' style='text-align:center'>".$result[2]."</td>
            <td width='150' style='text-align:center'>".$result[3]."</td>
            <td width='150' style='text-align:center'>".$result[4]."</td>
            <td width='150' style='text-align:center'>".$result[5]."</td>
            <td width='150' style='text-align:center'>".$result[6]."</td>
            <td width='150' style='text-align:center'>".$result[7]."</td>  
            <td width='150'   style='text-align:center'>".$result[8]."</td>        
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