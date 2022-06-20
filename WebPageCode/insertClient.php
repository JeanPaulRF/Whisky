<?php

 //include_once("conexion.php");
 //Cconexion::ConexionDB();
  

  if(isset($_POST['save']) && $_POST['save']=='Save')
	{ 

    if($_POST['store'] == 'USA')
      $dbname = 'USAStore';
    else
      if($_POST['store'] == 'Ireland')
        $dbname = 'IrelandStore';
      else
        $dbname = 'ScotlandStore';
      
    $host = 'localhost';
    //$dbname = 'IrelandStore';
    $username = 'sa';
    $password= '12345678';
    $puerto = 62727;
    $serverName = "PINK-KIRBY\ENTERPRISE2, 62727";
  
    $connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
    $conexion = sqlsrv_connect( $serverName, $connectionInfo);

    $queryInsert = "INSERT INTO Client(name_, uid, email, telephone, quantityBuy, idSuscription) VALUES (?,?,?,?,?,?)";

    $idTierquery = "SELECT id from Suscription where name_ = '$_POST[tier]'";
    $consultId = sqlsrv_query($conexion,$idTierquery);
    $idTier = sqlsrv_fetch_array($consultId);

    $params = array($_POST['name'], $_POST['uid'], $_POST['email'],$_POST['telephone'], 0, $idTier['id']);
    $consultInsert = sqlsrv_query($conexion,$queryInsert,$params);

    if ($consultInsert)
    {  
      //echo "Row successfully inserted.\n"; 
      $queryGetID = "SELECT TOP 1 * FROM client ORDER BY id DESC";
      $consultUserId=sqlsrv_query($conexion,$queryGetID);
      $id = sqlsrv_fetch_array($consultUserId);
      
      $queryInsertUser = "EXEC CreateUser_ '$_POST[username]', '$_POST[password]', '$_POST[key]', 0, $id[id], 4, 0";
      $consultInsertUser = sqlsrv_query($conexion,$queryInsertUser);
      
      if ($consultInsertUser)
      {
        //echo "Row successfully inserted.\n"; 

        //update location
        $geomtry = 'geometry::STGeomFromText("POINT(34 1)", 0)';
        $query = "Update Client set location1 = $geomtry where id = $id[id]";
        $consultInsertUser = sqlsrv_query($conexion,$queryInsertUser);
        
      } 
      else
      {  
        echo "Row insertion failed (user).\n";  
        die(print_r(sqlsrv_errors(), true));    
      } 

    }
    else
    {  
      echo "Row insertion failed (client).\n";  
      die(print_r(sqlsrv_errors(), true));  
    }  


    //header("Location: index.html");
		//exit();
  }

?>



<!DOCTYPE html>
<html lang="en">

  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link href="https://fonts.googleapis.com/css?family=Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i&display=swap" rel="stylesheet">

    <title>Suscription</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">


    <!-- Additional CSS Files -->
    <link rel="stylesheet" href="assets/css/fontawesome.css">
    <link rel="stylesheet" href="assets/css/templatemo-stand-blog.css">
    <link rel="stylesheet" href="assets/css/owl.css">
<!--

TemplateMo 551 Stand Blog

https://templatemo.com/tm-551-stand-blog

-->
  </head>

  <body>

    <!-- ***** Preloader Start ***** -->
    <div id="preloader">
        <div class="jumper">
            <div></div>
            <div></div>
            <div></div>
        </div>
    </div>  
    <!-- ***** Preloader End ***** -->

    <!-- Header -->
    <header class="">
      <nav class="navbar navbar-expand-lg">
        <div class="container">
          <a class="navbar-brand" href="index.html"><h2>The Whisky Club<em>.</em></h2></a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
              <li class="nav-item">
                <a class="nav-link" href="index.html">Home</a>
              </li> 
              <li class="nav-item">
                <a class="nav-link" href="LogInClient.php">Store</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="suscriptionInformation.html">Suscription</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="post-details.html">reviews</a>
              </li>
              <li class="nav-item active">
                <a class="nav-link" href="insertClient.php">Sign in
                    <span class="sr-only">(current)</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="LogInClient.php">Log in</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </header>

    <!-- Page Content -->
    <!-- Banner Starts Here -->
    <div class="heading-page header-text">
      <section class="page-heading">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <div class="text-content">
                <h4>Sign in</h4>
                <h2>let’s stay in touch!</h2>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    
    <!-- Banner Ends Here -->
    <section class="contact-us">
      <div class="container">
        <div class="row">     
          <div class="col-lg-12">
            <div class="down-contact">
              <div class="row">
                <div class="col-lg-8">
                  <div class="sidebar-item contact-form">
                    <div class="sidebar-heading">
                      <h2>Sign in to get a lot of benefits</h2>
                    </div>
                    <div class="content">

                      <form action="" method="post">
                          <div class="row">
                            <div class="col-md-6 col-sm-12">
                              <fieldset>
                                <input name="name" type="text" id="name" placeholder="Name" required="">
                              </fieldset>
                            </div>

                            <div class="col-md-6 col-sm-12">
                              <fieldset>
                                <input name="email" type="text" id="email" placeholder="Email" required="">
                              </fieldset>
                            </div>

                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="telephone" type="text" id="telephone" placeholder="Telephone" required="">
                            </fieldset>
                          </div>
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <label for="tier" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:130px" >Choose a Tier:</label>
                                <select name="tier" id="tier" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:200px;">
                                <?php
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
                                  $queryControl = "Select name_ from suscription where active_ = 1;";
                                  $consult = sqlsrv_query($conexion,$queryControl);
                                  while ($registro = sqlsrv_fetch_array($consult))
                                    {
                                    echo "<option name='tier'> ".$registro['name_']." </option>";
                                  }
                                ?>
                                </select>
                            </fieldset>
                          </div>
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="uid" type="text" id="uid" placeholder="uid" required="">
                            </fieldset>
                          </div>
             
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="username" type="text" id="username" placeholder="User Name" required="">
                            </fieldset>
                          </div>
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="password" type="password" id="password" placeholder="password  " required="">
                            </fieldset>
                          </div>

                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="key" type="text" id="key" placeholder="Key" required="">
                            </fieldset>
                          </div>

                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <label for="store" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:130px ;" >
                                Store:
                              </label>
                                <select name="store" id="store" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:200px;  ">
                                  <option value="USA">USA</option>
                                  <option value="Scotland">Scotland</option>
                                  <option value="Ireland">Ireland</option>
                                </select>
                            </fieldset>
                          </div>  
                          
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <label for="location1" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:130px ;" >
                                Zone 1:
                              </label>
                                <select name="location1" id="location1" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:200px;  ">
                                  <option value="1">1</option>
                                  <option value="2">2</option>
                                  <option value="3">3</option>
                                  <option value="4">4</option>
                                  <option value="5">5</option>
                                </select>
                            </fieldset>
                          </div> 

                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <label for="location2" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:130px ;" >
                                Zone 2:
                              </label>
                                <select name="location2" id="location2" style="color: rgb(141, 145, 145);  padding: 10px; font-weight: 500; width:200px;  ">
                                  <option value="1">1</option>
                                  <option value="2">2</option>
                                  <option value="3">3</option>
                                  <option value="4">4</option>
                                  <option value="5">5</option>
                                </select>
                            </fieldset>
                          </div> 
                                                
                          <div class="col-lg-12">
                            <fieldset>
                              <button type="submit" name="save" value="Save" id="form-submit" class="main-button">Suscribe</button>
                            </fieldset>
                          </div>
                        </div>
                      </form>




                    </div>
                  </div>
                </div>
                <div class="col-lg-4">
                  <div class="sidebar-item contact-information">
                    <div class="sidebar-heading">
                      <h2>contact information</h2>
                    </div>
                    <div class="content">
                      <ul>
                        <li>
                          <h5>090-484-8080</h5>
                          <span>PHONE NUMBER</span>
                        </li>
                        <li>
                          <h5>info@whisky.com</h5>
                          <span>EMAIL ADDRESS</span>
                        </li>
                        <li>
                          <h5>123 Aenean id posuere dui, 
                          	<br>Praesent laoreet 10660</h5>
                          <span>STREET ADDRESS</span>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="col-lg-12">
            <div id="map">
              <iframe src="https://maps.google.com/maps?q=edimburg&t=&z=13&ie=UTF8&iwloc=&output=embed" width="100%" height="450px" frameborder="0" style="border:0" allowfullscreen></iframe>
            </div>
          </div>
          
        </div>
      </div>
    </section>

    
    <footer>
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <ul class="social-icons">
              <li><a href="#">Facebook</a></li>
              <li><a href="#">Twitter</a></li>
              <li><a href="#">Behance</a></li>
              <li><a href="#">Linkedin</a></li>
              <li><a href="#">Dribbble</a></li>
            </ul>
          </div>
          <div class="col-lg-12">
            <div class="copyright-text">
              <p>Copyright 2020 Stand Blog Co.
                    
                 | Design: <a rel="nofollow" href="https://templatemo.com" target="_parent">TemplateMo</a></p>
            </div>
          </div>
        </div>
      </div>
    </footer>

    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Additional Scripts -->
    <script src="assets/js/custom.js"></script>
    <script src="assets/js/owl.js"></script>
    <script src="assets/js/slick.js"></script>
    <script src="assets/js/isotope.js"></script>
    <script src="assets/js/accordions.js"></script>

    <script language = "text/Javascript"> 
      cleared[0] = cleared[1] = cleared[2] = 0; //set a cleared flag for each field
      function clearField(t){                   //declaring the array outside of the
      if(! cleared[t.id]){                      // function makes it static and global
          cleared[t.id] = 1;  // you could use true and false, but that's more typing
          t.value='';         // with more chance of typos
          t.style.color='#fff';
          }
      }
    </script>

  </body>
</html>