<?php
try {
    $mysqli = new mysqli("localhost", "root", "", "healthinsurance2");

    if ($mysqli->connect_error) {
        die("Connection failed: " . $mysqli->connect_error);
    }
else {
echo "db connected";
}
$un = mysql_real_escape_string($_POST['username']);
$pw = mysql_real_escape_string($_POST['password']);
$fn = mysql_real_escape_string($_POST['firstname']);
$ln = mysql_real_escape_string($_POST['lastname']);
$ea = mysql_real_escape_string($_POST['email']);
$ph = mysql_real_escape_string($_POST['phno']);

$flag = 0;


        $createUser = "INSERT INTO `users`(`user_name`,`user_password`,`type`)
                        VALUES( '$un','$pw',2);";
        if(mysqli_query($mysqli,$createUser) == TRUE)
        {
            $flag = 1;
        }
        else{
          echo"error";
        }

        $createUserSQL = "INSERT INTO `administrator` (`user_name`,`email`,`first_name`,
                                                `last_name`,`phone_no`)
                                    VALUES('$un','$ea','$fn','$ln','$ph')";
                        if(mysqli_query($mysqli,$createUserSQL) == TRUE)
                                  {
                                $flag = 1;
                                  }
                                  else{
                                    echo"error2";
                                    }
                          if($flag == 1)
                          {
                            echo("success");
                            header("Location: /index.php");
                          }
                          $mysqli->close();


                      } catch (Exception $e) {
                          echo $e->getMessage(), PHP_EOL;
                      }
 ?>
