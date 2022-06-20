<?php
	if(isset($_POST['save']) && $_POST['save']=='Save')
	{	
		//connexion to dababase params	
		$host = 'localhost';
		$dbname = 'IrelandStore';
		$username = 'sa';
		$password= '12345678';
		$puerto = 62727;
		$serverName = "PINK-KIRBY\ENTERPRISE2, 62727";
	 
		//connexion controls
		$connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
		$conexion = sqlsrv_connect( $serverName, $connectionInfo);

		//querys to work with
		$queryInsert = ("EXEC UpdateSuscription '$_POST[oldname]','$_POST[name]','$_POST[DisBuy]','$_POST[DisDelivery]',$_POST[cost],0;");
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
	
	<title>Add Product</title>
</head>
<body>

	<div class="page-header bg-primary text-white text-center">
		<span class="h4">The Whisky Club administration: Ireland</span>
	</div>

	<form action="" method="POST" style="width:40%;margin:0 auto;" enctype="multipart/form-data">			
			<legend class="text-center header text-success">Add a new suscription</legend>
			
			<?php
			echo"
				<div class='form-group'>
					<label for='oldname'>Old name</label>
					<input readonly type='text' class='form-control' name='oldname' value='$_REQUEST[name]'>
				</div>"
			?>

			<div class="form-group">
				<label for="name">Name</label>
				<input type="text" class="form-control" name="name">
			</div>

			<div class="form-group">
				<label for="DisBuy">Discount buy</label>
				<input type="number" class="form-control" name="DisBuy">
			</div>

			<div class="form-group">
				<label for="DisDelivery">Discount delivery</label>
				<input type="number" class="form-control" name="DisDelivery">
			</div>

			<div class="form-group">
				<label for="cost">Cost</label>
				<input type="number" class="form-control" name="cost">
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