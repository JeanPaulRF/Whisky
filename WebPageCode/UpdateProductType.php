<?php
	if(isset($_POST['save']) && $_POST['save']=='Save')
	{		
			//connexion to the database
			$host='localhost';
			$bd='MasterDB';
			$user='postgres';
			$pass='atomico';
			$conexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

			$queryInsert = ("CALL UpdateProductType('$_POST[oldname_]',
				'$_POST[name_]');");
		
			$consultInsert=pg_query($conexion,$queryInsert);
			pg_close();

			if($consultInsert)
			{
				header("Location: AdminMenu.html");
				exit();
			}
			else
			{
				echo
				"<div class='page-header bg-primary text-white text-center'>
					<span class='h4'>An error ocurred, the worker was not updated</span>
				</div>";
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
		<span class="h4">The Whisky Club administration</span>
	</div>

	<form action="" method="POST" style="width:40%;margin:0 auto;" enctype="multipart/form-data">			
			<legend class="text-center header text-success">Update product</legend>
			<?php echo 
				"<div class='form-group'>
					<label for='oldname_'>Old Name</label>
					<input readonly type='text' class='form-control' name='oldname_' value='$_REQUEST[name]'		>
				</div>"
			?>
			<div class="form-group">
				<label for="name_">Name</label>
				<input type="text" class="form-control" name="name_">
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