<?php
class Comptes extends SavableObject {
	static private $key='numeroCompte';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $numeroCompte=NULL;
	
	public $libelle;
	
	public $solde;
	
	public $userId;
	
}
?>