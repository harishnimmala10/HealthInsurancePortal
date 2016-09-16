<?php
session_start();
$customer = $_SESSION['user'];
$policy = $_GET['value'];
try {
    $mysqli = new mysqli("localhost", "root", "", "healthinsurance2");

    if ($mysqli->connect_error) {
        die("Connection failed: " . $mysqli->connect_error);
    }
else {
echo "db connected";
}
$cname = $_POST['cname'];
$cnumb = $_POST['ccnumber'];
$cexpiry = $_POST['cexpiry'];
$ccvv = $_POST['cvv'];
$numb = $_POST['amount'];

$sql = $mysqli->query("SELECT policy_id FROM policy WHERE policy_name ='".$policy."' ");
while ($rs = $sql->fetch_assoc()) {
  $temp = $rs['policy_id'];
  }

    echo($temp);

  $sql2 = $mysqli->query("SELECT customer_id FROM customer WHERE user_name ='".$customer."' ");
  while ($rs = $sql2->fetch_assoc() ) {
    $temp2 = $rs['customer_id'];
    }

  echo $temp2;
    $query = "CALL enrol('".$temp."','".$temp2."','".$numb."','".$cname."','".$cnumb."','".$cexpiry."','".$ccvv."','".$_SESSION['user']."')";

    $flag =0;
    if(mysqli_query($mysqli,$query) == TRUE)
              {
            $flag = 1;
              }
              else{
                echo"error2";
                }
      if($flag == 1)
      {
        echo("success");
        header("Location: /customerlanding.php");

      }


} catch (Exception $e) {
    echo $e->getMessage(), PHP_EOL;
}
 ?>
