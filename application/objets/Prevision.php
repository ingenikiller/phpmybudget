<?php
class Prevision extends SavableObject {
	static private $key='ligneId';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $ligneId=NULL;
	
	public $typenr;
	
	public $identete;
	
	public $nomEntete;
	
	public $noCompte;
	
	public $fluxId;
	
	public $montant;
	
	public $annee;
	
	public $mois;
	
	public $datecre;
	
	public $datemod;
	
	public $utimod;
	
}
?>