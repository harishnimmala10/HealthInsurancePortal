<?php
session_start();
$val1 = $_GET['value'];
$val2 = $_GET['value2'];

echo $val1;
echo $val2;

try {
    $mysqli = new mysqli("localhost", "root", "", "healthinsurance2");

    if ($mysqli->connect_error) {
        die("Connection failed: " . $mysqli->connect_error);
    }
else {
echo "db connected";
}

$sql = $mysqli->query("SELECT policy_id FROM policy WHERE policy_name ='".$val1."' ");
while ($rs = $sql->fetch_assoc()) {
  $temp = $rs['policy_id'];
  }

    echo($temp);

  $sql2 = $mysqli->query("SELECT customer_id FROM customer WHERE user_name ='".$val2."' ");
  while ($rs = $sql2->fetch_assoc() ) {
    $temp2 = $rs['customer_id'];
    }

    echo($temp2);

$query = "UPDATE enrollment SET due_date = DATE_ADD(due_date,INTERVAL 1 YEAR) WHERE customer_id ='".$temp2."' AND policy_id = '".$temp."' ";

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
