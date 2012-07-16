<?php


error_reporting(E_ALL);
ini_set('display_errors', 'on');


require_once ('ivisite_data_parser.php');


/*  $arzt_id = $_REQUEST['arzt_id'];
  $debug = (isset($_REQUEST['debug']))?$_REQUEST['debug']:"0";
  

	require_once('config.php');
	require_once ('libs/PEAR/MDB2.php');
	require_once ('ivisite_data_parser.php');
	
	$bdebug = ($debug==1 || $debug=='1')?true:false;
	
	$mdb2 =& MDB2::connect($dsn);
	
	if (PEAR::isError($mdb2)) {
		die($mdb2->getMessage());
	}
	
	//********************    Arzt Daten
	$query = 'SELECT name, mobileid FROM Arzt where id = '.$arzt_id;
	$res =& $mdb2->queryAll($query);
	
	
	
	$parser = new ivisite_data_parser($bdebug);
	$type = '000';
	$data = $parser->parseData($res, $type);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}
	
	
	//********************    Patienten Daten
	$query = 'SELECT id, name, geschlecht, patient_seit, arzt_id FROM Patient where arzt_id = '.$arzt_id;
	$res =& $mdb2->queryAll($query);
	
	$parser = new ivisite_data_parser($bdebug);
	$type = '001';
	$data .= $parser->parseData($res, $type);
	
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	//Hole alle Patienten Ids
	$ids = array();
	$str_ids = '';
	
	foreach ($res as $row){
		array_push($ids, $row[0]);
	}
	
	$str_ids = implode(', ', $ids);
	
	
	//********************    Behandlung Daten
	$query = 'SELECT beschreibung, plantermin, isttermin, patient_id FROM Behandlung where patient_id IN ( '. $str_ids .' )';
	$res =& $mdb2->queryAll($query);
	
	$parser = new ivisite_data_parser($bdebug);
	$type = '002';
	$data .= $parser->parseData($res, $type);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	// Disconnect
	$mdb2->disconnect();

	if($bdebug == true){
		var_dump($data);
	}else{
		echo($data);
		echo("\r\n");
		echo("@\r\n");
	}
	
	die;
*/

?>
