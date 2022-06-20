<?php



?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	
	<title>Tiers</title>
</head>
<body>

	<div class="page-header bg-primary text-white text-center">
		<span class="h4">Suscriptions</span>
	</div>

	<form action="ReadSuscriptionUSA.php" method="post" style="width:40%;margin:0 auto;">
		<fieldset>		
			<legend class="text-center header text-success">Search Tiers</legend>
			
			<div class="form-group">
				<label for="name">Name</label>
				<select class="form-control" name="name" id="name">
					<?php
						//connexion to dababase params	
						$host = 'localhost';
						$dbname = 'USAStore';
						$username = 'sa';
						$password= '12345678';
						$puerto = 62727;
						$serverName = "PINK-KIRBY\ENTERPRISE2, 62727";
			
						//connexion controls
						$connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
						$conexion = sqlsrv_connect( $serverName, $connectionInfo);


						$queryControl = "select name_ from Suscription where active_ = 1;";
						$consult = sqlsrv_query($conexion,$queryControl);
						while ($registro = sqlsrv_fetch_array($consult))
         			{
							echo "<option name='name'> ".$registro['name_']." </option>";
						}
					?>				
				</select>
			</div>			

		<div class="form-group">
			<input type="submit" class="btn btn-success form-control" name="registrar" value="Buscar">
		</div>
	</fieldset>
</form>
</html>