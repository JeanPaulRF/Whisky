<?php

  class Conexion
  {
    function ConexionDB()
    {
      $host='localhost';
      $dbname='ScotlandStore';
      $username='sa';
      $password='12345678';
      $puerto=1433;

      try
      {
        $conn = new PDO("sqlsrv:Server=$host,$puerto;Database=$dbname",$username,$password);
        echo "Conectado :)";
      }
      catch(PDOException ex)
      {
        echo ("no se conectó, error: $ex");
      }
      return $conn;

    }  
  }

?>