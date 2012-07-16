<?php


class ivisite_data_parser
{
	// Debug output 
	var $debug = false;
	
	//Signs to replace
	var $signs         = array('Ä'=> '&A',  'ä'=>'&a',  'Ö'=>'&O',  'ö'=>'&o',  'Ü'=>'&U', 'ü'=>'&u', 'ß'=> '&s'  );
	//Protocol signs
	var $startsign = 1;			//'SOH'
	var $starttx   = 2;			//'STX'
	var $endtx     = 3;			//'ETX'
	var $endsign   = 4;			//'EOT'
	var $oksign    = 6;			//'ACK'
	var $poundsign = 35;		//'#';
	var $sepsign   = 124;		//'|';
	var $com_endsign= 64;		//'@';
	var $breaksign1 = 13;		//'\r'
	var $breaksign2 = 10;		//'\n'
	//Frame signs
	var $frame_init = 0;
	var $frame_data = 1;
	var $frame_hand = 2;
	//Protocol packets
	var $packet_count = -1;
	var $packet_rows = -1;
	var $packet_cols = -1;
	//Contain the whole packets
	var $packet_data = '';
	
	//Constructor init the debug signs if debug is enabled
	function __construct($d = false) {
	
		$this->debug = $d;
		
		if($this->debug){
			$this->packet_data =  '<br>Result with Debug Infos:<br>';
		
			$this->startsign = 'SOH';
			$this->starttx   = 'STX';
			$this->endtx     = 'ETX';
			$this->endsign   = 'EOT';
			$this->oksign    = 'OK';
			$this->poundsign = '#';
			$this->sepsign   = '|';
			$this->com_endsign = '@';
			$this->breaksign1 = '\r';
			$this->breaksign2 = '\n';
			
		}else{
			$this->startsign = '[';
			$this->starttx   = '(';
			$this->endtx     = ')';
			$this->endsign   = ']';
			$this->oksign    = 'OK';
			$this->poundsign = '#';
			$this->sepsign   = '|';
			$this->com_endsign = '@';
			$this->breaksign1 = "\r";
			$this->breaksign2 = "\n";
		}
	}
	
	/**
	* Writes the initiale protocol header
	**/
	public function setInitHeader(){
		if($this->debug){
			$this->packet_data .= '<br>StartHeader:<br>';
		}
		
		$this->packet_data .= $this->startsign.
					   $this->frame_init.
					   $this->poundsign.
					   $this->packet_count.
					   $this->endsign;
	}
	
	/**
	* Writes the initiale protocol header
	**/
	public function getInitHeader($count){

		$data .= $this->startsign.
					   $this->frame_init.
					   $this->poundsign.
					   $count.
					   $this->endsign.
					   $this->breaksign1.
					   $this->breaksign2;
		return $data;
	}
	
	/**
	* Writes the initiale protocol end header
	**/
	public function setBreakLines(){
		if($this->debug){
			$this->packet_data .= '<br>EndHeader:<br>';
		}
		
		$this->packet_data .= 
					   $this->breaksign1.
					   $this->breaksign2;
					   //$this->startsign.
					   //$this->frame_hand.
					   //$this->oksign.
					   //$this->endsign;
	}
	/**
	* Writes the initiale protocol end header
	**/
	public function getEndHeader(){
		$return = "";
		if($this->debug){
			$return .= '<br><br>EndHeader:<br>';
		}
		
		$return .= 
					   $this->com_endsign.
					   $this->breaksign1.
					   $this->breaksign2;
					   //$this->startsign.
					   //$this->frame_hand.
					   //$this->oksign.
					   //$this->endsign;
		return $return;
	}
	
	
	/**
	* Transform ascii code to unicode 
	**/
	//function unichr($u) {
	//	return mb_convert_encoding('&#' . intval($u) . ';', 'UTF-8', 'HTML-ENTITIES');
	//}
	
	/**
	* Transforms the data packet in the right transmission data
	**/
	public function transform_elements($de){
	
		$ret = false;
		$idata_element = '';
		
		//normalize data 
		$data_element = strtr($de, $this->signs);
		
		
		//transform date
		$date_format = '/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/';	
		$date_exists = preg_match($date_format, $data_element);
		
		//check if date exists
		if($date_exists){
		
			//split date parts
			list($date, $time) = explode(' ', $data_element);
			if(($time!='') && ($date!='')){
				
				list($hh, $mm, $ss) = explode(":", $time);
				list($yy, $mo, $dd) = explode("-", $date);
				
				$ret = date('dmY', mktime($hh, $mm, $ss, $mo, $dd, $yy));
				
			}
		}else{
		
			//Char to Ascii
			/*$strarray = str_split($data_element);
			foreach($strarray as $c){
				$sic = strval(ord($c));
				$sic = (strlen($sic)==1)?'00'.$sic:$sic;
				$sic = (strlen($sic)==2)?'0'.$sic:$sic;
				$idata_element .= $sic;
			}*/
			
			$ret = $data_element;
			//return $ret;
			
		}
		
		
		
	
		return $ret;
	
	}
	
    /**
	* Method to parse the result and return the protocol data
	* @param data data array
	* @return coded data to the protocol
	**/
    public function parseData($data = array() , $type ='-1', $offset) {
		
		$data_element = '';
		
		
		$this->packet_rows = count($data);
		$this->packet_cols = count($data[0]);
		$this->packet_count = $this->packet_rows;
		
		//$this->setInitHeader();
		$packet_counter = $offset;

        for( $row=0; $row < $this->packet_rows; $row++ ){
				
				
				if($this->debug){
					$this->packet_data .= '<br>StartData:<br>';
				}
				
			
				$this->packet_data .= 
								$this->startsign .
								$this->frame_data .
								$this->poundsign .
								$packet_counter .
								$this->starttx.
								$type .
								$this->sepsign;
					
					
				for( $col=0; $col < $this->packet_cols; $col++ ){
					
					$data_element = $this->transform_elements($data[$row][$col]);
				
					$this->packet_data .= 			
								$data_element.
								$this->sepsign;
					
					

					
					
				}
				$packet_counter = $packet_counter + 1;
				
				if(strlen($this->packet_data)>=1){
					$this->packet_data = substr($this->packet_data, 0, strlen($this->packet_data)-1);
				}
				
				$this->packet_data .= 			
								$this->endtx .
								$this->endsign;
			
			
			
		}
		
		//return $type;
		
		$this->setBreakLines();
		
		return $this->packet_data;
		
    }
}