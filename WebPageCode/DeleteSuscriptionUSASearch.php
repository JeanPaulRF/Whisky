<?php
if(isset($_POST['save']) && $_POST['save']=='Delete')
{		
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

		
		$queryInsert = ("EXEC DeleteSuscription '$_POST[name]',0;");
		$consultInsert = sqlsrv_query($conexion,$queryInsert);
		if($consultInsert)
		{
			header("Location: AdminMenu.html");
			exit();
		}
		else
		{
			echo "<div class='page-header bg-primary text-white text-center'>
			<span class='h4'>An error ocurred, the tier was not inserted</span>
			</div> <br>";
		}		
}


?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	
	<title>Delete</title>
</head>
<body>

	<div class="page-header bg-primary text-white text-center">
		<span class="h4">suscription</span>
	</div>

	<form method="post" style="width:40%;margin:0 auto;">
		<fieldset>		
			<legend class="text-center header text-success">Delete suscription</legend>
			
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

						//querys to work with
						$queryControl = "Select name_ from suscription where active_ = 1;";
						$consult = sqlsrv_query($conexion,$queryControl);
						while ($registro = sqlsrv_fetch_array($consult))
         			{
							echo "<option name='name'> ".$registro['name_']." </option>";
						}
					?>			
				</select>
			</div>			

		<div class="form-group">
			<input type="submit" class="btn btn-success form-control" name="save" value="Delete">
		</div>
	</fieldset>
</form>
</html>