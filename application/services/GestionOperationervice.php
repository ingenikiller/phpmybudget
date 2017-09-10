<?php

class GestionOperationervice extends ServiceStub{
	
	public function gesListe(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $operationId=$p_contexte->m_dataRequest->getData('operationId');
        $page=1;
        $numeroPage=$p_contexte->m_dataRequest->getData('numeroPage');
        if($numeroPage!=null && $numeroPage!=''){
        	$page=$numeroPage;
        }
        
        $requete='SELECT operation.operationId, operation.noReleve, operation.date, operation.libelle, operation.fluxId, operation.modePaiementId, flux.flux, operation.modePaiementId, 
        format(operation.montant,2) as montant, operation.nocompte, operation.verif FROM operation LEFT JOIN flux ON operation.fluxid = flux.fluxid WHERE ';
        $requete.=" operation.nocompte='$numeroCompte'";
        if($operationId!=null){
			$requete.=" AND operationId=$operationId";        	
        }
        $recFlux = $p_contexte->m_dataRequest->getData('recFlux');
		if($recFlux!=null){
			$requete.=" AND (operation.fluxId=$recFlux OR flux.fluxMaitreId=$recFlux)";        	
        }
        
		$recDate = $p_contexte->m_dataRequest->getData('recDate');
		if($recDate	!=null){
			$requete.=" AND operation.date like concat('$recDate','%')";        	
        }
		
        $recIntervalle = $p_contexte->m_dataRequest->getData('recIntervalle');
		if($recIntervalle	!=null){
			//Logger::getInstance()->addLogMessage('intervalle' . $recIntervalle);
			$intervalle = explode('_', $recIntervalle);
			$requete.=" AND operation.date between '". $intervalle[0] . "' AND '" . $intervalle[1] . "' ";	
        }
		
        $recNoReleve = $p_contexte->m_dataRequest->getData('recNoReleve');
        if($recNoReleve!=null){
			$requete.=" AND operation.noReleve LIKE'$recNoReleve'";        	
        }
        $recMontant = $p_contexte->m_dataRequest->getData('recMontant');
        if($recMontant!=null){
			$requete.=" AND operation.montant=$recMontant";        	
        }
        $requete.=" ORDER BY date desc, operationid desc";
        
        $listeOperations = new ListDynamicObject();
        $listeOperations->name = 'ListeMontantFlux';
        $listeOperations->request($requete,$page);
        $p_contexte->addDataBlockRow($listeOperations);
	}
	
	public function create(ContextExecution $p_contexte){
        $operation = new Operation();
        $operation->fieldObject($p_contexte->m_dataRequest);
        $operation->create();
        $operation->operationId = $operation->lastInsertId();
        Logger::getInstance()->addLogMessage('last insert:' . $operation->lastInsertId());
        $operation->load();
        OperationCommun::operationLiee($operation);
		
        $reponse = new ReponseAjax();
        $reponse->status='OK';
        $p_contexte->addDataBlockRow($reponse);
    }
	
	public function update(ContextExecution $p_contexte){
        $operationId=$p_contexte->m_dataRequest->getData('operationId');
        $operation = new Operation();
        $operation->operationId=$operationId;
        $operation->load();
        $operation->fieldObject($p_contexte->m_dataRequest);
        $operation->update();
        OperationCommun::operationLiee($operation);
        
        $reponse= new ReponseAjax();
        $reponse->status='OK';
        $p_contexte->addDataBlockRow($reponse);
    }
	
	public function recLibelle(ContextExecution $p_contexte){
		
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$debLibelle = $p_contexte->m_dataRequest->getData('debLibelle');
		$requete="SELECT distinct operation.libelle FROM operation WHERE operation.nocompte='$numeroCompte' AND libelle LIKE concat('$debLibelle', '%')";
		$listeLibelles = new ListDynamicObject();
		$listeLibelles->name = 'ListeLibelles';
		$listeLibelles->request($requete,1);
		$p_contexte->addDataBlockRow($listeLibelles);
	}
	
	public function getPage(ContextExecution $p_contexte){
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$compte = new Comptes();
		$compte->numeroCompte = $numeroCompte;
		$compte->load();
		$p_contexte->addDataBlockRow($compte);
        $p_contexte->setTitrePage("Opérations sur compte " . $numeroCompte);
	}
}

?>