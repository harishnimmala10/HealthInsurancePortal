<?php
session_start();
$value = $_GET['val'];
$singlevalue = $_SESSION['polarray'][$value];

$mysqli = new mysqli("localhost", "root", "", "healthinsurance2");


  $policyListSQL = " SELECT `hospital_name`, `hospital_addr`,`zip_code`
                      FROM aff_hospitals
                      WHERE policy_name= '".$singlevalue."'  ";

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

     <title>DocList and Patient List</title>

     <!-- Bootstrap Core CSS - Uses Bootswatch Flatly Theme: http://bootswatch.com/flatly/ -->
     <link href="css/bootstrap.min.css" rel="stylesheet">

     <!-- Custom CSS -->
     <link href="css/freelancer.css" rel="stylesheet">

     <!-- Custom Fonts -->
     <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
     <link href="http://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">
     <link href="http://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css">


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
                   echo $_SESSION['polarray'][$value];
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
                         <a href="#policy">Doctors</a>
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
                  Hospital-List
                 </h2>
                 <hr class="star-primary">
             </div>
         </div>
         <div class = "col-sm-9" style="padding-left:110px; width:100%">
               <?php
               $modcounter =0;
               $counter =0;
                   while( $policy = $policyListQuery->fetch_assoc() ){
                     $modcounter = $modcounter+1;
                     $counter = $counter+1;
                       echo '

                       <div class="portfolio-modal modal fade" id="portfolioModal'.$modcounter.'" tabindex="-1" role="dialog" aria-hidden="true">
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
                                               <h2>',$policy['hospital_name'],'</h2>
                                               <hr class="star-primary">';
                                               $statement = "SELECT `doctor_name`,`specialization`
                                                            FROM ass_doctor
                                                            WHERE hospital_name='".$policy['hospital_name']."' ";
                                                $docList  = $mysqli->query($statement);
                                                while ($doc = $docList->fetch_assoc()){
                                                 echo '
                                               <div class="well company-well alg">
                                               <h4>
                                                   <b>',$doc['doctor_name'],'</b>
                                                   <div class="pull-right">';

                                                   //print star rating in glyphicons
                                                     echo'<b>',$doc['specialization'],'</b>';

                                       echo '    </div>
                                               </h4>
                                               </div>';

                                             }
                                              echo '<button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times"></i> Close</button>
                                           </div>
                                       </div>
                                   </div>
                               </div>
                           </div>
                       </div>



                           <div class="well company-well">
                               <h3>
                                   <b>',$policy['hospital_name'],'</b>
                                   <div class="pull-right">';

                                   //print star rating in glyphicons
                                     echo'<b> ',$policy['hospital_name'],'</b>';

                       echo '    </div>
                               </h3>
                               <div class="text-right"><a href="modal" data-toggle="modal" data-target="#portfolioModal',$counter,'">View Doctors</a></div>
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
