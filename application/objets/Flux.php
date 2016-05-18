<?php
class Flux extends SavableObject {
	static private $key='fluxId';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $fluxId=NULL;
	
	public $depense;
	
	public $flux;
	
	public $description;
	
	public $typeOperationId;
	
	public $modePaiementId;
	
	public $userId;
	
	public $entreeEpargne;
	
	public $sortieEpargne;
	
	public $operationRecurrente;
	
	public $compteId;
	
	public $compteDest;
	
	public $fluxMaitre;
	
	public $fluxMaitreId;
	
}
?>