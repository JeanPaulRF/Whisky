<?php

    $host = 'localhost';
		$dbname = 'ScotlandStore';
		$username = 'sa';
		$password= '12345678';
		$puerto = 62727;
		$serverName = "PINK-KIRBY\ENTERPRISE2, 62727";
	 
		//connexion controls
		$connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
		$conexion = sqlsrv_connect( $serverName, $connectionInfo);

		//querys to work with
		$queryInsert = ("");


?>


<!DOCTYPE html>
<html lang="en">

  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="TemplateMo">
    <link href="https://fonts.googleapis.com/css?family=Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i&display=swap" rel="stylesheet">

    <title>Buy</title>

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
              <li class="nav-item active">
                <a class="nav-link" href="LogInClient.html">Store  <span class="sr-only">(current)</span></a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="suscriptionInformation.html">Suscription</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="post-details.html">reviews</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="insertClient.php">Sign in</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="AdminMenu.html">Log in</a>
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
                <h4>Store</h4>
                <h2>Buy what you want!</h2>
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
                      <h2>Logged User:</h2>
                    </div>
                    <div class="content">    
                      <form id="contact" action="" method="post">
                        <div class="row">
                          <div class="col-md-6 col-sm-12">

                            <fieldset>
                              <input name="username" type="text" id="username" required="" readonly>
                              <script>
                                document.getElementById("username").setAttribute('value',localStorage.getItem("textvalue"));
                              </script>
                            </fieldset>
                          </div>

                        </div>
                      </form>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>          
        </div>
      </div>
    </section>
    <section class="about-us">
      <div class="container">	
        
       
      <?php

        //echo "REQUESt:", $_REQUEST['store'];
        
        $dbname = 'IrelandStore';
          
        $host = 'localhost';
        //$dbname = 'ScotlandStore';
        $username = 'sa';
        $password= '12345678';
        $puerto = 62727;
        $serverName = "PINK-KIRBY\ENTERPRISE2, 62727";

        $connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
        $conexion = sqlsrv_connect( $serverName, $connectionInfo);

        $query = "SELECT id from User_ where username = '$_REQUEST[username]'";
        $consult= sqlsrv_query($conexion,$query);
        $register1 = sqlsrv_fetch_array($consult); 
 

        $query = "SELECT id, quantity, idProduct from inventory;";
        $consult= sqlsrv_query($conexion,$query); 


        while ($register = sqlsrv_fetch_array($consult))
        {

          $host='localhost';
          $bd='MasterDB';
          $user='postgres';
          $pass='atomico';
          $connexion = pg_connect("host=$host dbname=$bd user=$user password=$pass");

          $queryControl = "SELECT name_, presentation, cost_, currency FROM product WHERE id = '$register[id]';";
          $consulta=pg_query($connexion,$queryControl);
          $name = pg_fetch_array($consulta);

					echo
          "
          <div class='row'>
            <div class='col-lg-6'>
              <h4>$name[name_]</h4>
              <p>Description: $name[presentation] <br> Products available: $register[quantity] <br> Currency: $name[currency] <br> Price: $name[cost_]</p>
            </div>   
          </div>";
				}

      ?>

        
        
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