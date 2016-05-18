<?php
class Operation extends SavableObject {
	static private $key='operationId';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $operationId=NULL;
	
	public $noCompte;
	
	public $noReleve;
	
	public $date;
	
	public $libelle;
	
	public $fluxId;
	
	public $modePaiementId;
	
	public $montant;
	
	public $verif;
	
	public $operationIdOri;
	
	public $numeroCompteOri;
	
}
?>