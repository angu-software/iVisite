<?php


//error_reporting(E_ALL);
//ini_set('display_errors', 'on');

// Web Service
require_once('libs/nusoap/lib/nusoap.php');
// Database

$server = new soap_server;
$server->configureWSDL('ivisite', 'urn:ivisite');

// Register the public functions		  
$server->register('getAllData',
			      array('mobileid' => 'xsd:string', 
						'debug' => 'xsd:integer'),
				  array('return' => 'xsd:string')
				  );
				  
$server->register('getAllPatients', 
				  array('doctor_id' => 'xsd:integer'),
				  array('return' => 'xsd:string'));
			  
$server->register('getPatient', 
				  array('patient_id' => 'xsd:integer'),
				  array('return' => 'xsd:string'));
			  
$server->register('getPatientTherapy', 
				  array('therapy_id' => 'xsd:integer'),
				  array('return' => 'xsd:string'));
			

								  
/**
* Get all Data from one Patient 
**/
function getAllData($mobileid, $debug){

	
	require_once('config.php');
	require_once ('libs/PEAR/MDB2.php');
	
	require_once ('ivisite_data_parser.php');
	
	$packet_count = 0;
	$bdebug = ($debug==1 || $debug=='1')?true:false;
	
	$mdb2 =& MDB2::connect($dsn);
	
	if (PEAR::isError($mdb2)) {
		die($mdb2->getMessage());
	}
	
	//********************    Arzt Daten
	$query = 'SELECT name, id, mobileid FROM Arzt where mobileid = "'.$mobileid.'"';
	
	$res =& $mdb2->queryAll($query);
	//var_dump($query);
	$arzt_id = $res[0][1];
	
	
	
	$parser = new ivisite_data_parser($bdebug);
	$type = '0';
	$data = $parser->parseData($res, $type, $packet_count);
	$packet_count = count(res);
	
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}
	
	
	//********************    Patienten Daten
	$query = 'SELECT id, name, geschlecht, patient_seit, arzt_id, id FROM Patient where arzt_id = '.$arzt_id;
	$res =& $mdb2->queryAll($query);
	
	//Hole alle Patienten Ids
	$ids = array();
	$str_ids = '';
	
	foreach ($res as $row){
		array_push($ids, $row[0]);
	}
	
	$str_ids = implode(', ', $ids);
	
	// Clean ids
	foreach ($res as &$row){
		array_shift($row);
	}
	
	$parser = new ivisite_data_parser($bdebug);
	$type = '1';
	$data .= $parser->parseData($res, $type, $packet_count);
	$packet_count = $packet_count + count($res);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	
	
	
	//********************    Behandlung Daten
	$query = 'SELECT beschreibung, plantermin, isttermin, patient_id, id FROM Behandlung where patient_id IN ( '. $str_ids .' )';
	$res =& $mdb2->queryAll($query);
	
	$parser = new ivisite_data_parser($bdebug);
	$type = '2';
	$data .= $parser->parseData($res, $type, $packet_count);
	$packet_count = $packet_count + count($res);
	

	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	// Disconnect
	$mdb2->disconnect();
	
	//$data .= $parser->getEndHeader();
	
	$data = $parser->getInitHeader($packet_count).$data;
	
	return $data;
	
}								  
								  
								  
								  
/**
* Gets all Patients
**/

function getAllPatients($doctor_id){
	
	require_once('config.php');
	require_once ('libs/PEAR/MDB2.php');
	require_once ('ivisite_data_parser.php');
	
	$mdb2 =& MDB2::connect($dsn);
	
	if (PEAR::isError($mdb2)) {
		die($mdb2->getMessage());
	}
	
	$query = 'SELECT * FROM Patient where arzt_id = '.$doctor_id;
	$res =& $mdb2->queryAll($query);
	
	$type = '001';
	
	$parser = new ivisite_data_parser();
	$data = $parser->parseData($res, $type);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		die($res->getMessage());
	}

	// Disconnect
	$mdb2->disconnect();

	return $data;
}
/**
* Get all Data from one Doctor 
**/
function getDoctor($doc_id){

	require_once('config.php');
	require_once ('libs/PEAR/MDB2.php');
	require_once ('ivisite_data_parser.php');
	
	$mdb2 =& MDB2::connect($dsn);
	
	if (PEAR::isError($mdb2)) {
		return ($mdb2->getMessage());
	}
	
	$query = 'SELECT * FROM Arzt where id = '.$doc_id;
	$res =& $mdb2->queryAll($query);
	$type = '001';
	
	$parser = new ivisite_data_parser();
	$data = $parser->parseData($res, $type);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	// Disconnect
	$mdb2->disconnect();

	return $data;
	
}		  				  

/**
* Get all Data from one Patient 
**/
function getPatient($patient_id){

	require_once('config.php');
	require_once ('libs/PEAR/MDB2.php');
	require_once ('ivisite_data_parser.php');
	
	$mdb2 =& MDB2::connect($dsn);
	
	if (PEAR::isError($mdb2)) {
		return ($mdb2->getMessage());
	}
	
	$query = 'SELECT * FROM Patient where id = '.$patient_id;
	$res =& $mdb2->queryAll($query);
	
	$type = '001';
	
	$parser = new ivisite_data_parser();
	$data = $parser->parseData($res, $type);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	// Disconnect
	$mdb2->disconnect();
	return $data;
	
}


/**
* Get Therapy of one Patient
**/
function getPatientTherapy($therapy_id){

	require_once('config.php');
	require_once('libs/PEAR/MDB2.php');
	require_once ('ivisite_data_parser.php');
	
	$mdb2 =& MDB2::connect($dsn);
	
	if (PEAR::isError($mdb2)) {
		return ($mdb2->getMessage());
	}
	
	$query = 'SELECT * FROM Behandlung where id = '.$therapy_id;
	
	$res =& $mdb2->queryAll($query);
	$type = '002';
	
	$parser = new ivisite_data_parser();
	$data = $parser->parseData($res, $type);
	
	// Always check that result is not an error
	if (PEAR::isError($res)) {
		return ($res->getMessage());
	}

	// Disconnect
	$mdb2->disconnect();

	return $data;
	
}

$HTTP_RAW_POST_DATA = isset($HTTP_RAW_POST_DATA) ? $HTTP_RAW_POST_DATA : '';
$server->service($HTTP_RAW_POST_DATA);

