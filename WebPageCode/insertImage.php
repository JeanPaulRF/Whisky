<?php
	if(isset($_POST['save']) && $_POST['save']=='Save')
	{		
			$host='localhost';
			$bd='MasterDB';
			$user='postgres';
			$pass='atomico';
			$conexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

			$queryGetProduct = ("SELECT id FROM product WHERE name_ = '$_POST[idProduct]';");
			$consult = pg_query($conexion,$queryGetProduct);
			$idProduct = pg_fetch_array($consult);

			$uploadDir = getcwd().DIRECTORY_SEPARATOR.'/uploads/';
			$uploaded = false;
			$save_path = '';
			if($_FILES['img']['error']==UPLOAD_ERR_OK)
			{
				$temp_name = $_FILES['img']['tmp_name'];
				$name = basename($_FILES['img']['name']);
				$save_path = $uploadDir.$name; 
				move_uploaded_file($temp_name,$save_path);
				$uploaded = true;
			}
			if($uploaded)
			{
				$fh = fopen($save_path,'rb');
				$fbytes = fread($fh,filesize($save_path));
				echo strlen($fbytes);

				$queryInsert = "Call insertImage($1,$2)";
				$res = pg_query_params($conexion,$queryInsert,array(base64_encode($fbytes),$idProduct['id']));
			}
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
				<label for="idProduct">Whisky's name.	</label>
				<select class="form-control" name="idProduct" id="idProduct">
					<?php
						$host='localhost';
						$bd='MasterDB';
						$user='postgres';
						$pass='atomico';
						$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");
			
						$queryControl = "SELECT name_ FROM product;";
						$consult=pg_query($connexion,$queryControl);
						while ($registro = pg_fetch_array($consult))
         			{
							echo "<option name='idProduct'> ".$registro['name_']." </option>";
						}
					?>
						
					
				</select>		
			</div>
		
			<div class="form-group">
				<label for="img">Whisky's image</label>
				<input type="file" name="img"class="form-control">
			</div>

		<div class="form-group">
			<input type="submit" class="btn btn-success form-control" name="save" value="Save">
		</div>





		<div class="form-group">
		<a href="adminMenu.html">
			<input type="button"  name="save" value="Back to menu">
		</a>
		</div>

</form>
</div>
</html>