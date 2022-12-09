<?php

class GestionCompteService extends ServiceStub {

	public function gesListe(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
		$listSolde = new ListDynamicObject();
		$listSolde->name='SommeOperation';
		$listSolde->setAssociatedRequest(null, 'SELECT SUM(montant) AS somme, noCompte FROM operation where noCompte=\'$parent->numeroCompte\'');

		$list = new ListDynamicObject();
		$list->name='ListeComptes';
		$list->setAssociatedKey($listSolde);
		$requete = "SELECT * FROM comptes WHERE userId=$userid";
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
	}
}
?>