<?php
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
  //$dbname = 'ScotlandStore';
  $username = 'sa';
  $password= '12345678';
  $puerto = 62727;
  $serverName = "PINK-KIRBY\ENTERPRISE2, 62727";

  $connectionInfo = array( "Database"=>$dbname, "UID"=>$username, "PWD"=>$password);
  $conexion = sqlsrv_connect( $serverName, $connectionInfo);

  $query = str_replace("**",$_POST['username'],"EXEC isUserCorrect '**', '++',0");
  $query2 = str_replace("++",$_POST['password'],$query);
  $queryCheckUser = $query2;

  $consultCheck= sqlsrv_query($conexion,$queryCheckUser);
  $registro = sqlsrv_fetch_array($consultCheck);
  
  if($registro['id'] == 0)
  {
    header("Location: buy.php");
		exit();
  }    
  if($registro['id'] == 1)
  {
    echo "<script> alert('Contraseña incorrecta');</script>";
  } 
  if($registro['id'] == 3)
  {
    echo "<script> alert('Usuario no registrado');</script>";
  } 
  
  
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

    <title>Stand Blog - Contact Page</title>

    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">


    <!-- Additional CSS Files -->
    <link rel="stylesheet" href="assets/css/fontawesome.css">
    <link rel="stylesheet" href="assets/css/templatemo-stand-blog.css">
    <link rel="stylesheet" href="assets/css/owl.css">
    <script>
    function passvalues()
    {
        var name = document.getElementById('username').value;
        var password = document.getElementById('password').value;
        localStorage.setItem("textvalue",name);
        return false;
    }
    </script>
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
          <a class="navbar-brand" href="index.html"><h2>Stand Blog<em>.</em></h2></a>
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
              <li class="nav-item">
                <a class="nav-link" href="insertClient.php">Sign in</a>
              </li>
              <li class="nav-item">
                <a class="nav-link active" href="LogInClient.php">Log in <span class="sr-only">(current)</span></a>
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
                <h4>Log in</h4>
                <h2>Store</h2>
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
                      <h2>Log in to view your personal store</h2>
                    </div>
                    <div class="content">    
                      <form id="contact" method="post" action="">
                        <div class="row">
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="username" type="text" id="username" placeholder="User name" required="">
                            </fieldset>
                          </div>
                          <div class="col-md-6 col-sm-12">
                            <fieldset>
                              <input name="password" type="password" id="password" placeholder="password" required="">
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
                          <div class="col-lg-12">
                            <fieldset>
                              <button type="submit" name="save" value="Save" id="form-submit" class="main-button" onclick="passvalues(); ">Log in</button>
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
                          <h5>info@company.com</h5>
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