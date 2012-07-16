
<?php
  
  
error_reporting(E_ALL);
ini_set('display_errors', 'on');


	require_once('config.php');
	//require_once('libs/mdb2/MDB2.php');

	//$dir_pear = '../../../home/admin/www/plugins/pear/PEAR/MDB2.php';
	$dir_pear = 'libs/PEAR/MDB2.php';
	
	var_dump( $dir_pear);
	require_once($dir_pear);
	var_dump( 'MDB2: connect');
	$mdb2 =& MDB2::connect($dsn);
	var_dump( 'MDB2: connected');
	
	if (PEAR::isError($mdb2)) {
		die($mdb2->getMessage());
	}
	
	$res =& $mdb2->queryAll('SELECT * FROM Patient');
	$ids = array();
	$str_ids = '';
	
	foreach ($res as $row){
		array_push($ids, $row[0]);
	}
	
	$str_ids = implode(', ', $ids);
	
	var_dump($str_ids);
	die;

	// Always check that result is not an error
	if (PEAR::isError($res)) {
		die($res->getMessage());
	}


	
	// Disconnect
	$mdb2->disconnect();

	var_dump( $res);
	die;

?>