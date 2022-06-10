<?php

		if(isset($_POST['save']) && $_POST['save']=='Save')
		{
			$host='localhost';
			$bd='MasterDB';
			$user='postgres';
			$pass='atomico';
			$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

			$queryControl = "SELECT name_ FROM ProductType WHERE name_ = '$_POST[name]';";
			$consulta=pg_query($connexion,$queryControl);
			$name = pg_fetch_array($consulta);
			if($name['name_'] == $_POST['name'] )
			{
				header("Location: errorDuplicate.html");
				exit();
			}
			else
			{
			$query = ("Insert into ProductType(name_) VALUES('$_POST[name]');");
			$consulta=pg_query($connexion,$query);
			pg_close();
			header("Location: AdminMenu.html");
			exit();
			}
	}

?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	
	<title>Insertar Producto</title>
</head>
<body>
	<div class="page-header bg-primary text-white text-center">
		<span class="h3">Whisky Club administration</span>
	</div>
	<form action="" method="post" style="width:40%;margin:0 auto;" enctype="multipart/form-data">	
	<legend class="text-center header text-success"></legend>
		<br>
		<legend class="text-center header text-success">Add a new Product Type</legend>

		<div class="form-group">
			<label for="nombre">Name</label>
			<input type="text" class="form-control" name="name">
		</div>

		<div class="form-group">		
				<input type="submit" class="btn btn-success form-control" name="save" value="Save">
		</div>

		<div class="form-group">
		<a href="adminMenu.html">
			<input type="button" value="Back to menu">
		</a>
		</div>
	</form>
</body>
</html>