<?php

namespace Application\Services;

use Core\ServiceStub;
use Core\ContextExecution;
use Core\ListDynamicObject;
use Application\Objects\Comptes;
use Application\Scripts\ComptesCommun;

class GestionCompteService extends ServiceStub {

	public function getListe(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
		
		$list = new ListDynamicObject('ListeComptes');
		$requete = "with req as ( SELECT nocompte, SUM(montant) as total FROM operation where noncomptabilisee=0 group by nocompte ) SELECT comptes.*, solde + req.total as encours FROM comptes join req on req.noCompte=comptes.numerocompte WHERE userId=$userid AND ordreaffichage<>0 ORDER BY ordreaffichage ASC";
		$list->request($requete, 1);
		$p_contexte->addDataBlockRow($list);
	}

	public function getOne(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$compte = new Comptes();
		$compte->numeroCompte = $numeroCompte;
		$compte->userId = $userid;
		$compte->load();
		$p_contexte->addDataBlockRow($compte);
	}

	public function create(ContextExecution $p_contexte){
        $userid = $p_contexte->getUser()->userId;
        $compteJson=$p_contexte->m_dataRequest->getDataJson('compte');
        $compte = new Comptes();
        $compte->fieldObjectJson($compteJson);
        $compte->userId = $userid;
        $compte->create();
    }

    public function update(ContextExecution $p_contexte){
        $userid = $p_contexte->getUser()->userId;
        $compteJson=$p_contexte->m_dataRequest->getDataJson('compte');
		$compte = new Comptes();
        $compte->numeroCompte = $compteJson['numeroCompte'];
        $compte->userId = $userid;
        $compte->load();
        $compte->fieldObjectJson($compteJson);
        $compte->update();
		$p_contexte->addDataBlockRow($compte);
    }

	public function soldeCompte($p_contexte){
		$userid = $p_contexte->getUser()->userId;
		$numeroCompte = $p_contexte->m_dataRequest->getData('noCompte');
		$compte=new Comptes();
		$compte->userId=$userid;
		$compte->numeroCompte=$numeroCompte;
		$compte->load();
		$p_contexte->addDataBlockRow($compte);
		$p_contexte->addDataBlockRow(ComptesCommun::calculSommeOperations($numeroCompte));
		$p_contexte->addDataBlockRow(ComptesCommun::calculSommeOperationsNonComptabilisees($numeroCompte));
	}
}
?>