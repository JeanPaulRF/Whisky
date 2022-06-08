<?php

class Cconexion
{
   public static function ConexionDB()
   {
      $host = 'localhost';
      $dbname = 'ScotlandStore';
      $username = 'sa';
      $password= '12345678';
      $puerto = 62727;

      try
      {
         $conn =  new PDO("sqlsrv:Server=$host,$puerto;Database=$dbname",$username,$password);   
         echo ("Conectado");
      }
      catch(PDOException $ex)
      {
         echo ("Error__________: $ex");
      }
      return $conn;

   }
}

?>