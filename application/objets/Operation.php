<?php
class Operation extends SavableObject {
	static private $key='operationId';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $operationId=NULL;
	
	public $noCompte;
	
	public $noReleve;
	
	public $dateOperation;
	
	public $libelle;
	
	public $fluxId;
	
	public $modePaiementId;
	
	public $montant;
	
	public $montanttva;
	
	public $verif;
	
	public $operationIdOri;
	
	public $numeroCompteOri;

	public $noncomptabilisee;
	
	public $datecre;
	
	public $datemod;
	
	public $utimod;
	
}
?>