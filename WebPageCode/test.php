
<?php
function getData()
{
	$data = array();
	$data[0] = $_POST['ID'];
	$data[1] = $_POST['Nombre'];
	$data[2] = $_POST['UID'];
	$data[3] = $_POST['email'];
	$data[4] = $_POST['telefono'];
	$data[5] = $_POST['quantity'];
	$data[6] = $_POST['idSuscription'];
	$data[7] = $_POST['location1'];
	//$data[8] = $_POST['location2'];
	return $data;
}


if(isset($_POST['save']) && $_POST['save']=='Save')	
{


	$serverName = "localhost, 62727"; 
	$connectionInfo = array( "Database"=>"ScotlandStore", "UID"=>"sa", "PWD"=>"12345678");

	$conn = sqlsrv_connect( $serverName, $connectionInfo);

	$info= getData();

	$insert = "INSERT INTO Client (name_, uid, email, telephone, quantityBuy, idSuscription) VALUES ('$info[1]','$info[2]','$info[3]','$info[4]','$info[5]','$info[6]')";

	$consulta = sqlsrv_query($conn,$insert);
	if( $consulta === false )
	{
		die(print_r( sqlsrv_errors(), true));
 	}

}
?> 


<!DOCTYPE html>
 <html>
<body>
<br>
<br>
<form method="post">

ID: <input type="text" name="ID" id="ID" value="6"><br>
Nombre: <input type="text" name="Nombre" id="Nombre" value="nombre"><br>
UID: <input type="text" name="UID"  id="UID"value="666"><br>
email: <input type="text" name="email" id="email" value="email@gmail.com"><br>
telefono: <input type="text" name="telefono" id="telefono" value="70959696"><br>
quantity: <input type="text" name="quantity" id="quantity" value="0"><br>
idSuscription: <input type="text" name="idSuscription" id="idSuscription"value="1"><br>
location1: <input type="text" name="location1" id="location1" value="USA"><br>
location2: <input type="text" name="location2" id="location2" value="Scotland"><br>


<button type="submit" value="Save" name="save" >insertar</button>

</form> 
 

<p>If you click the "Submit" button, the form-data will be sent to a my test table test_name.</p>