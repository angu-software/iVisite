<?php
  
  // Web Service
  require_once('libs/nusoap/lib/nusoap.php');
  $wsdl = "http://localhost/iVisite/server/interface/ivisite_data.php?wsdl";
  //$wsdl = "http://mk.base23.de/ivisite/server/interface/ivisite_data.php?wsdl";
  
  //$soap = new soapclient($wsdl,true);
  $soap = new nusoap_client($wsdl,true);
   
  $err = $soap->getError();
  if ($err) {
    echo '<h2>Error with soapclient creation: </h2><pre>' . $err . '</pre>';
	die;
  }
  
  
  
  
  //$mobileid = (isset($_REQUEST['mobileid']))?$_REQUEST['mobileid']:"1";
  
  
  $mobileid = (isset($_REQUEST['mobileid']))?$_REQUEST['mobileid']:"123123123123123"; 
  $debug = (isset($_REQUEST['debug']))?$_REQUEST['debug']:"0";
  
  $debug = (($debug)==0)?false:$debug;
 
  if(!empty ( $mobileid) ){
	  $param = array();
      $param = array('mobileid' => $mobileid,
					 'debug'   => $debug);
	  $result = $soap->call('getAllData', $param);
	  if($debug!= false){
		 echo 'getAllData from arzt='.$param['mobileid']; 
		 echo '<br>';
	  }
	  
	  echo ($result);
	  
	  
	  
	    // Display the request and response
		//echo '<h2>Request</h2>';
		//echo '<pre>' . htmlspecialchars($soap->request, ENT_QUOTES) . '</pre>';
		//echo '<h2>Response</h2>';
		//echo '<pre>' . htmlspecialchars($soap->response, ENT_QUOTES) . '</pre>';

  }else{
	echo 'Bitte die folgenden Parameter ergänzen<br>';
	echo '--> mobileid <br>';
  
  }
  
 //Send termination flags	 
 echo ("\r\n@\r\n");
  
  

  die;
  

?>