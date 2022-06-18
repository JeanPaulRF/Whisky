<?php
if(isset($_POST['save']) && $_POST['save']=='Delete')
{		
		//connexion to the database
		$host='localhost';
		$bd='MasterDB';
		$user='postgres';
		$pass='atomico';
		$conexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

		
		$queryInsert = ("CALL DeleteProduct('$_POST[name]');");
		$consultInsert=pg_query($conexion,$queryInsert);
		pg_close();
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
	
	<title>Mostrar Producto</title>
</head>
<body>

	<div class="page-header bg-primary text-white text-center">
		<span class="h4">Products</span>
	</div>

	<form method="post" style="width:40%;margin:0 auto;">
		<fieldset>		
			<legend class="text-center header text-success">Delete products</legend>
			
			<div class="form-group">
				<label for="name">Name</label>
				<select class="form-control" name="name" id="name">
					<?php
						$host='localhost';
						$bd='MasterDB';
						$user='postgres';
						$pass='atomico';
						$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");
			
						$queryControl = "SELECT name_ FROM product where active_ = true;";
						$consult=pg_query($connexion,$queryControl);
						while ($registro = pg_fetch_array($consult))
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