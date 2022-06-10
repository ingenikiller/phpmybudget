<?php
class Lignebudget extends SavableObject {
	static private $key='lignebudgetid';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $lignebudgetid=NULL;
	
	public $userid;
	
	public $compteid;
	
	public $annee;
	
	public $fluxid;
	
	public $montant;
	
	public $datecre;
	
	public $utimod;
	
	public $datemod;
	
}
?>