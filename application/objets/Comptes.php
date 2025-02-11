<?php
class Comptes extends SavableObject {
	static private $key='numeroCompte';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $numeroCompte=NULL;
	
	public $libelle;
	
	public $solde;

	public $ordreaffichage;
	
	public $userId;
	
	public $datecre;
	
	public $datemod;
	
	public $utimod;
	
}
?>