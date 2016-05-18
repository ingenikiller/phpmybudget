<?php
class Segment extends SavableObject {
	static private $key='cleseg,codseg';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $cleseg=NULL;
	
	public $codseg=NULL;
	
	public $libcourt;
	
	public $liblong;
	
	public $numord;
	
	public $vcar1;
	
	public $vcar2;
	
}
?>