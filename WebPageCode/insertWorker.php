<?php
	if(isset($_POST['save']) && $_POST['save']=='Save')
	{		
			$host='localhost';
			$bd='MasterDB';
			$user='postgres';
			$pass='atomico';
			$conexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

			$queryGetWorkerType = ("SELECT id FROM WorkerType WHERE name_ = '$_POST[idWorkerType]';");
			$consult = pg_query($conexion,$queryGetWorkerType);
			$idWorkerType = pg_fetch_array($consult);

			$queryInsert = ("INSERT INTO Worker(name_, salarydolar, salarylocal, uid, email, telephone, idworkertype) VALUES('$_POST[name]','$_POST[USD]','$_POST[LocalSalary]','$_POST[uid]','$_POST[email]','$_POST[telephone]','$idWorkerType[id]');");
			
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
				<label for="USD">USD Salary</label>
				<input type="number" class="form-control" name="USD">
			</div>

			<div class="form-group">
				<label for="LocalSalary">Local Salary</label>
				<input type="number" class="form-control" name="LocalSalary">
			</div>

			<div class="form-group">
				<label for="uid">UID</label>
				<input type="text" class="form-control" name="uid">
			</div>

			<div class="form-group">
				<label for="email">E-mail</label>
				<input type="text" class="form-control" name="email">
			</div>

			<div class="form-group">
				<label for="telephone">telephone</label>
				<input type="number" class="form-control" name="telephone">
			</div>

			<div class="form-group">
				<label for="idWorkerType">Worker Type</label>
				<select class="form-control" name="idWorkerType" id="idWorkerType">
					<?php
						$host='localhost';
						$bd='MasterDB';
						$user='postgres';
						$pass='atomico';
						$connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");
			
						$queryControl = "SELECT name_ FROM WorkerType;";
						$consult=pg_query($connexion,$queryControl);
						while ($registro = pg_fetch_array($consult))
         			{
							echo "<option name='idWorkerType'> ".$registro['name_']." </option>";
						}
					?>
						
					
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