<?php
class Operationrecurrente extends SavableObject {
	static private $key='operationRecurrenteId';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $operationRecurrenteId=NULL;
	
	public $libelle;
	
	public $noCompte;
	
	public $fluxId;
	
	public $modePaiementId;
	
	public $montant;
	
}
?>