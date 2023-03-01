<?php

class GestionOperationService extends ServiceStub{

	public function getListe(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');

        $operationId=$p_contexte->m_dataRequest->getData('operationId');
        $page=1;
        $numeroPage=$p_contexte->m_dataRequest->getData('numeroPage');
        if($numeroPage!=null && $numeroPage!='') {
        	$page=$numeroPage;
        }

        $requete='SELECT operation.operationId, operation.noReleve, operation.dateOperation, operation.libelle, operation.fluxId, operation.modePaiementId, flux.flux, operation.modePaiementId,
        format(operation.montant,2) as montant, operation.nocompte, operation.verif FROM operation LEFT JOIN flux ON operation.fluxid = flux.fluxid WHERE ';
        $requete.=" operation.nocompte='$numeroCompte'";
        if($operationId!=null){
			$requete.=" AND operationId=$operationId";
        }
        $recFlux = $p_contexte->m_dataRequest->getData('recFlux');
		if($recFlux!=null){
			$requete.=" AND (operation.fluxId IN ($recFlux) OR flux.fluxMaitreId IN ($recFlux))";
        }

		$recDate = $p_contexte->m_dataRequest->getData('recDate');
		if($recDate	!=null){
			$requete.=" AND operation.dateOperation like concat('$recDate','%')";
        }
		
        $recIntervalle = $p_contexte->m_dataRequest->getData('recIntervalle');
		if($recIntervalle	!=null){
			$intervalle = explode('_', $recIntervalle);
			$requete.=" AND operation.dateOperation between '". $intervalle[0] . "' AND '" . $intervalle[1] . "' ";	
        }
		
        $recNoReleve = $p_contexte->m_dataRequest->getData('recNoReleve');
        if($recNoReleve!=null){
			$requete.=" AND operation.noReleve LIKE'$recNoReleve'";
        }
        $recMontant = $p_contexte->m_dataRequest->getData('recMontant');
        if($recMontant!=null){
			$requete.=" AND ROUND(operation.montant)=ROUND($recMontant)";        	
        }
        $requete.=" ORDER BY dateOperation desc, operationid desc";

        $listeOperations = new ListDynamicObject('ListeOperations');
        $listeOperations->request($requete,$page);
        $p_contexte->addDataBlockRow($listeOperations);
	}

	public function create(ContextExecution $p_contexte){
        $operationJson=$p_contexte->m_dataRequest->getDataJson('operation');
		$operation = new Operation();
        $operation->fieldObjectJson($operationJson);
        $operation->create();
        $operation->operationId = $operation->lastInsertId();
        $this->logger->debug('last insert:' . $operation->lastInsertId());
        $operation->load();
        OperationCommun::operationLiee($operation);

        $reponse = new ReponseAjax();
        $reponse->status='OK';
        $p_contexte->addDataBlockRow($reponse);
    }

	public function update(ContextExecution $p_contexte){
        $userid = $p_contexte->getUser()->userId;
		$operationJson=$p_contexte->m_dataRequest->getDataJson('operation');
        $operation = new Operation();
		$operation->operationId = $operationJson['operationId'];
        $operation->load();
        $operation->fieldObjectJson($operationJson);
		$operation->update();
        OperationCommun::operationLiee($operation);

        $reponse= new ReponseAjax();
        $reponse->status='OK';
        $p_contexte->addDataBlockRow($reponse);
    }

	public function recLibelle(ContextExecution $p_contexte){
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$debLibelle = $p_contexte->m_dataRequest->getData('debLibelle');
		$requete="SELECT distinct operation.libelle AS libelle 
					FROM operation 
					WHERE 1=1 
						AND operation.nocompte='$numeroCompte' 
						AND libelle LIKE concat('$debLibelle', '%')";
		$listeLibelles = new ListDynamicObject('ListeLibelles');
		$listeLibelles->request($requete, 1);
		$p_contexte->addDataBlockRow($listeLibelles);
	}

	public function getPage(ContextExecution $p_contexte){
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$compte = new Comptes();
		$compte->numeroCompte = $numeroCompte;
		$compte->load();
		$p_contexte->addDataBlockRow($compte);
        $p_contexte->setTitrePage('Opérations sur ' .$compte->libelle. ' ('. $numeroCompte .')');
	}
	
	public function getSoldeOperation(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$operationId = $p_contexte->m_dataRequest->getData('operationId');
		$operation = new Operation();
        $operation->operationId=$operationId;
        $operation->load();
		
		$compte=new Comptes();
		$compte->userId=$userid;
		$compte->numeroCompte=$numeroCompte;
		$compte->load();
		
		$requete = "SELECT SUM(montant) as total 
				FROM operation 
				WHERE 1=1 
					AND nocompte='$numeroCompte' 
					AND (dateOperation = '$operation->dateOperation' 
					AND operationid<$operationId OR dateOperation < '$operation->dateOperation')";
		$dyn = new ListDynamicObject('SommeOperations');
		$dyn->request($requete);
		$tab = $dyn->getData();
		 
		$reponse = new ReponseAjax();
		$reponse->status='OK';
		$reponse->valeur = $compte->solde + $tab[0]->total + $operation->montant;
		$p_contexte->addDataBlockRow($reponse);
	}
	
}

?>