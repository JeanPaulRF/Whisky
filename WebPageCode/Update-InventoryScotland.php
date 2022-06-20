<?php
	if(isset($_POST['save']) && $_POST['save']=='Save')
	{	
		
		$host='localhost';
		$bd='MasterDB';
		$user='postgres';
		$pass='atomico';
		$conexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

		$queryGetProduct = ("SELECT id FROM product WHERE name_ = '$_POST[name]';");
		$consult = pg_query($conexion,$queryGetProduct);
		$idProduct = pg_fetch_array($consult);

		$host = 'localhost';
		$dbname = 'ScotlandStore';
		$username = 'sa';
		$password= '12345678';
		$puerto = 62727;
		$serverName = "PINK-KIRBY\ENTERPRISE2, 62727";
	 
		$connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
		$conexion = sqlsrv_connect( $serverName, $connectionInfo);
  
		$queryUpdate = "EXEC UpdateInventory '$idProduct[id]',$_POST[quantity],0";
    	$consultUpdate = sqlsrv_query($conexion,$queryUpdate);

		header("Location: AdminMenu.html");
		exit();
	}

?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	
	<title>Add inventory</title>
</head>
<body>

	<div class="page-header bg-primary text-white text-center">
		<span class="h4">The Whisky Club administration</span>
	</div>

	<form action="" method="POST" style="width:40%;margin:0 auto;" enctype="multipart/form-data">			
			<legend class="text-center header text-success">Add whisky in Ireland Store</legend>
		
			<div class="form-group">
				<label for="name">Product's name</label>
				<select class="form-control" name="name" id="name">
					<?php
						$host = 'localhost';
						$dbname = 'ScotlandStore';
						$username = 'sa';
						$password= '12345678';
						$puerto = 62727;
						$serverName = "PINK-KIRBY\ENTERPRISE2, 62727";
					 
						$connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
						$conexion = sqlsrv_connect( $serverName, $connectionInfo);
			
						$queryId = "select idProduct FROM inventory;";
						$consult = sqlsrv_query($conexion,$queryId);
						
						while ($registro = sqlsrv_fetch_array($consult))
         			{						
							$host='localhost';
							$bd='MasterDB';
							$user='postgres';
							$pass='atomico';
							$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

							$queryGetProduct = ("SELECT name_ FROM product WHERE id = '$registro[idProduct]';");
							$consultPG = pg_query($connexion,$queryGetProduct);
							$nameProduct = pg_fetch_array($consultPG);

							echo "<option name='name'> ".$nameProduct['name_']." </option>";
							pg_close();
						}
					?>
						
					
				</select>		
			</div>
			<div class="form-group">
				<label for="quantity">Quantity to add</label>
				<input type="number" class="form-control" name="quantity">
			</div>
		
		<div class="form-group">
		<a href="confirmacion.html">
			<input type="submit" class="btn btn-success form-control" name="save" value="Save">
		</a>
		</div>





		<div class="form-group">
		<a href="adminMenu.html">
			<input type="button"  name="save" value="Back to menu">
		</a>
		</div>

</form>
</div>
</html>