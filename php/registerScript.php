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
$date = mysql_real_escape_string($_POST['dob']);
$ea = mysql_real_escape_string($_POST['email']);
$a1 = mysql_real_escape_string($_POST['ad1']);
$a2 = mysql_real_escape_string($_POST['ad2']);
$ac = mysql_real_escape_string($_POST['adc']);
$as = mysql_real_escape_string($_POST['ads']);
$az = mysql_real_escape_string($_POST['adz']);
$ph = mysql_real_escape_string($_POST['phno']);
$db = mysql_real_escape_string($_POST['diabradio']);
$cd = mysql_real_escape_string($_POST['cardradio']);
$tb = mysql_real_escape_string($_POST['tobradio']);

$flag = 0;


        $createUser = "INSERT INTO `users`(`user_name`,`user_password`,`type`)
                        VALUES( '$un','$pw',1);";
        if(mysqli_query($mysqli,$createUser) == TRUE)
        {
            $flag = 1;
        }
        else{
          echo"error";
        }



        $createUserSQL = "INSERT INTO `customer` (`user_name`,`email`,`dob`,`first_name`,
                                                `last_name`,`addr_line_1`,`addr_line_2`,
                                                `addr_city`,`addr_state`,`addr_zip_code`,
                                                `phone`,`diabetes`,`cardio`,`tobacco`)
                                    VALUES('$un','$ea','$date','$fn','$ln','$a1','$a2','$ac','$as','$az',
                                      '$ph','$db','$cd','$tb')";
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
