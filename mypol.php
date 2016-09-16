<?php
session_start();
$session = $_SESSION['user'];

$mysqli = new mysqli("localhost", "root", "", "healthinsurance2");

  $policyListSQL = " SELECT P.policy_id,P.policy_name, P.premium,P.cardio, P.tobacco,P.diabetic,E.due_date
                      FROM policy AS P,enrollment as E,customer AS C
                      WHERE P.policy_id = E.policy_id AND
                      C.customer_id = E.customer_id AND
                      C.user_name = '".$session."'
                      ";

  $policyListQuery  = $mysqli->query($policyListSQL);

 ?>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Freelancer - Start Bootstrap Theme</title>

    <!-- Bootstrap Core CSS - Uses Bootswatch Flatly Theme: http://bootswatch.com/flatly/ -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/freelancer.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="http://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">
    <link href="http://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css">


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body id="page-top" class="index">

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header page-scroll">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#page-top">
                  <?php
                  echo($_SESSION['user']);
                   ?>
                </a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li class="hidden">
                        <a href="#page-top"></a>
                    </li>
                    <li class="page-scroll">
                        <a href="customerlanding.php">Policy</a>
                    </li>
                    <li class="page-scroll">
                        <a href="mypol.php">My Policies</a>
                    </li>
                    <li class="page-scroll">
                        <a href="/php/logout.php">Logout</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container-fluid -->
    </nav>

    <!-- Portfolio Grid Section -->
    <section id="policy" class="regclass">
      <div class="container">
        <div class="row">
            <div class="col-lg-12 text-center">
                <h2>
                  My Policy-List
                </h2>
                <hr class="star-primary">
            </div>
        </div>
        <div class = "col-sm-9" style="padding-left:110px; width:100%">
              <?php
              $count = 0;
              $modcounter =0;
                  while( $policy = $policyListQuery->fetch_assoc() ){
                    $count = $count +1;
                    $modcounter = $modcounter+1;
                    $dd = "SELECT mypremium(".$policy['policy_id'].",'".$_SESSION['user']."') as mypremium";
                    $ds = $mysqli->query($dd);
                    while($ss = $ds->fetch_assoc())
                    {
                      $temp = $ss['mypremium'];
                    }

                      echo '

                      <div class="portfolio-modal modal fade" id="payModal'.$modcounter.'" tabindex="-1" role="dialog" aria-hidden="true">
                          <div class="modal-content">
                              <div class="close-modal" data-dismiss="modal">
                                  <div class="lr">
                                      <div class="rl">
                                      </div>
                                  </div>
                              </div>
                              <div class="container">
                                  <div class="row">
                                      <div class="col-lg-8 col-lg-offset-2">
                                          <div class="modal-body">
                                              <h2>Policy Due On ',$policy['due_date'],' </h2>

                                              <hr class="star-primary">

                                              <form name="sentMessage" id="contactForm" method="POST" action="/php/payprem.php?value=',$policy['policy_name'],'&value2=',$_SESSION['user'],'">
                                                  <div class="row control-group">
                                                      <div class="form-group col-xs-12 floating-label-form-group controls">
                                                          <label>Card Name</label>
                                                          <input type="text" class="form-control" placeholder="Name on Card" name="cname" id="cname" required data-validation-required-message="Please enter your CC Name.">
                                                          <p class="help-block text-danger"></p>
                                                      </div>
                                                  </div>
                                                  <div class="row control-group">
                                                      <div class="form-group col-xs-12 floating-label-form-group controls">
                                                          <label>Credit Card Number</label>
                                                          <input type="text" class="form-control" placeholder="CC Number" name="ccnumber" id="ccnumber" required data-validation-required-message="Please enter your Credit Card Number.">
                                                          <p class="help-block text-danger"></p>
                                                      </div>
                                                  </div>

                                                  <div class="row control-group">
                                                      <div class="form-group col-xs-12 floating-label-form-group controls">
                                                          <label>Payment</label>
                                                          <input type="text" class="form-control" placeholder="$ USD" name="amount" id="amount" required data-validation-required-message="Please enter your Credit Card Number.">
                                                          <p class="help-block text-danger"></p>
                                                      </div>
                                                  </div>

                                                  <div class="row control-group">
                                                      <div class="form-group col-xs-12 floating-label-form-group controls">
                                                          <label>Expiry</label>
                                                          <input type="text" class="form-control" placeholder="YY/MM" name="cexpiry" id="cexpiry" required data-validation-required-message="Please enter your CC Expiry.">
                                                          <p class="help-block text-danger"></p>
                                                      </div>
                                                  </div>
                                                  <div class="row control-group">
                                                      <div class="form-group col-xs-12 floating-label-form-group controls">
                                                          <label>CVV</label>
                                                          <input type="text" class="form-control" placeholder="CVV" name="cvv" id="cvv" required data-validation-required-message="Please enter your CVV.">
                                                          <p class="help-block text-danger"></p>
                                                      </div>
                                                  </div>


                                                  <br>
                                                  <div id="success"></div>
                                                  <div class="row">
                                                      <div class="form-group col-xs-12">
                                                          <button style="background:#217DBB;" class="btn btn-block btn-success btn-lg col-sm-4" id="submit" type="submit">Pay</button>

                                                      </div>
                                                  </div>
                                              </form>


                                              <button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Close</button>


                                          </div>
                                      </div>
                                  </div>
                              </div>
                          </div>
                      </div>


                          <div class="well company-well">
                              <h3>
                                  <b>',$policy['policy_name'],'</b>
                                  <div class="pull-right">';

                                  //print star rating in glyphicons
                                    echo'<b>My-Premium - ',$temp,'</b>';

                      echo '    </div>
                              </h3>
                              <div class="text-right"><a href="modal" data-toggle="modal" data-target="#payModal',$count,'">Pay Premium</a></div>
                          </div>
                      ';
                  }
              ?>
          </div>

      </div>

    </section>


    <!-- Scroll to Top Button (Only visible on small and extra-small screen sizes) -->
    <div class="scroll-top page-scroll visible-xs visible-sm">
        <a class="btn btn-primary" href="#page-top">
            <i class="fa fa-chevron-up"></i>
        </a>
    </div>


    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
    <script src="js/classie.js"></script>
    <script src="js/cbpAnimatedHeader.js"></script>

    <!-- Contact Form JavaScript -->
    <script src="js/jqBootstrapValidation.js"></script>
    <script src="js/contact_me.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="js/freelancer.js"></script>

</body>

</html>
