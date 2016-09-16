<?php


//post variables from login.php
$username = $_POST['username'];
$password = $_POST['password'];

try {
    $mysqli = new mysqli("localhost", "root", "", "healthinsurance2");

    if ($mysqli->connect_error) {
        die("Connection failed: " . $mysqli->connect_error);
    }
else {
echo "db connected";
}

$sql = $mysqli->query("SELECT user_name, user_password FROM users WHERE user_name ='".$username."' AND user_password = '".$password."'  ");
if($sql)
{
  session_start();                    //call at very begining of all pages
    //check this session varible for login
  $_SESSION['user'] = $username;      //session variable holds username

    echo("hai");
     header("Location: /customerlanding.php");
}

else {
  header("Location: /login.php?retry=1");
}


/*
* returns mysqli result set
*/
function loginRecord($mysqli, $username, $password,$userradio){
   global $mysqli;
   //sql to check login
   $loginSQL = "SELECT  `user_name`,`user_password` FROM `users` WHERE STRCMP(`user_name`, ?)=0 AND STRCMP(`user_password`, ?)=0 LIMIT 1";
   $stmt = $mysqli->prepare($loginSQL);
   $stmt->bind_param('ss', $username, $password);
   $stmt->execute();
   return $stmt->get_result();
}
} catch (Exception $e) {
    echo $e->getMessage(), PHP_EOL;
}

?>
