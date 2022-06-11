<?php
	if(isset($_POST['save']) && $_POST['save']=='Save')
	{		
			$host='localhost';
			$bd='MasterDB';
			$user='postgres';
			$pass='atomico';
			$conexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

			$queryGetProductType = ("SELECT id FROM productType WHERE name_ = '$_POST[idProductType]';");
			$consultProduct = pg_query($conexion,$queryGetProductType);
			$idProductType = pg_fetch_array($consultProduct);

			$queryGetSupplier = ("SELECT id FROM supplier WHERE name_ = '$_POST[idSupplier]';");
			$consultSupplier = pg_query($conexion,$queryGetSupplier);
			$idSupplier= pg_fetch_array($consultSupplier);

			$queryInsert = ("INSERT INTO product(name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_) VALUES('$_POST[name]','$_POST[aged]',$idSupplier[id],'$_POST[presentation]','$_POST[currency]','$_POST[cost]', $idProductType[id],'$_POST[special]',TRUE);");
			
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
	
	<title>Add worker</title>
</head>
<body>

	<div class="page-header bg-primary text-white text-center">
		<span class="h4">The Whisky Club administration</span>
	</div>

	<form action="" method="POST" style="width:40%;margin:0 auto;" enctype="multipart/form-data">			
			<legend class="text-center header text-success">Add a new worker</legend>
			
			<div class="form-group">
				<label for="name">Name</label>
				<input type="text" class="form-control" name="name">
			</div>

			<div class="form-group">
				<label for="aged">Aged</label>
				<input type="number" class="form-control" name="aged">
			</div>

			<div class="form-group">
				<label for="idSupplier">Supplier</label>
				<select class="form-control" name="idSupplier" id="idSupplier">
					<?php
						$host='localhost';
						$bd='MasterDB';
						$user='postgres';
						$pass='atomico';
						$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");
			
						$queryControl = "SELECT name_ FROM supplier;";
						$consult=pg_query($connexion,$queryControl);
						while ($registro = pg_fetch_array($consult))
         			{
							echo "<option name='idSupplier'> ".$registro['name_']." </option>";
						}
					?>				
				</select>
			</div>

			<div class="form-group">
				<label for="Presentation">Presentation</label>
				<input type="text" class="form-control" name="presentation">
			</div>

			<div class="form-group">
				<label for="currency">Currency</label>
				<select name="currency" id="currency" class="form-control">
					<option value="Pound sterling">Pound sterling</option>
					<option value="American Dolar">American Dolar</option>
					<option value="Euro">Euro</option>
				</select>
			</div>

			<div class="form-group">
				<label for="cost">Cost</label>
				<input type="number" class="form-control" name="cost">
			</div>

			<div class="form-group">
				<label for="idProductType">Worker Type</label>
				<select class="form-control" name="idProductType" id="idProductType">
					<?php
						$host='localhost';
						$bd='MasterDB';
						$user='postgres';
						$pass='atomico';
						$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");
			
						$queryControl = "SELECT name_ FROM ProductType;";
						$consult=pg_query($connexion,$queryControl);
						while ($registro = pg_fetch_array($consult))
         			{
							echo "<option name='idWorkerType'> ".$registro['name_']." </option>";
						}
					?>					
				</select>		
			</div>
		
			<div class="form-group">
				<label for="special">Special product</label>
				<select name="special" id="special" class="form-control">
					<option value="0">Available for al kind of clients</option>
					<option value="1">Reserved for Members</option>
				</select>
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