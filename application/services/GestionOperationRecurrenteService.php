<?php 

class GestionOperationRecurrenteService extends ServiceStub{
	
	/**
	 * 
	 */
	public function getPage(ContextExecution $p_contexte){
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$p_contexte->setTitrePage("Opérations récurrentes du compte " . $numeroCompte);
	}
	
	/**
	 * 
	 */
	public function getListe(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
		$operationrecurrenteId=$p_contexte->m_dataRequest->getData('operationrecurrenteId');
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$numeroPage=$p_contexte->m_dataRequest->getData('numeroPage');
        $page=1;
		if($numeroPage!=null && $numeroPage!='') {
        	$page=$numeroPage;
        }

        $requete=
			'SELECT operationrecurrente.nocompte, 
				operationrecurrente.operationrecurrenteId, 
				operationrecurrente.libelle, 
				operationrecurrente.fluxId, 
				operationrecurrente.modePaiementId,
				flux.flux,
				format(operationrecurrente.montant,2) as montant 
			FROM operationrecurrente LEFT JOIN flux ON operationrecurrente.fluxid = flux.fluxid 
			WHERE ' . " operationrecurrente.nocompte='$numeroCompte'";
        
		if($operationrecurrenteId!=null){
			$requete.=" AND operationrecurrenteId=$operationrecurrenteId";
        }
        
		$recFlux = $p_contexte->m_dataRequest->getData('recFlux');
		if($recFlux!=null){
			$requete.=" AND (operation.fluxId IN ($recFlux) OR flux.fluxMaitreId IN ($recFlux))";
        }

		
        $recMontant = $p_contexte->m_dataRequest->getData('recMontant');
        if($recMontant!=null){
			$requete.=" AND ROUND(operation.montant)=ROUND($recMontant)";        	
        }
        $requete.=" ORDER BY libelle ASC";

        $listeOperations = new ListDynamicObject();
        $listeOperations->name = 'ListeOperationsRecurrentes';
        $listeOperations->request($requete,$page);
        $p_contexte->addDataBlockRow($listeOperations);
	}
	
	/**
	 * 
	 */
	public function create(ContextExecution $p_contexte){
        $operationRecurrenteJson=$p_contexte->m_dataRequest->getDataJson('operationRecurrente');

		$operation = new Operationrecurrente();
        $operation->fieldObjectJson($operationRecurrenteJson);
        $operation->create();
        
        $p_contexte->ajoutReponseAjaxOK();
    }

	/**
	 * 
	 */
	public function update(ContextExecution $p_contexte){
        $operationRecurrenteJson=$p_contexte->m_dataRequest->getDataJson('operationRecurrente');
		
		$operationRecurrente = new Operationrecurrente();
		$operationRecurrente->operationRecurrenteId = $operationRecurrenteJson['operationRecurrenteId'];
        $operationRecurrente->load();
        $operationRecurrente->fieldObjectJson($operationRecurrenteJson);
        $operationRecurrente->update();
		
        $p_contexte->ajoutReponseAjaxOK();
    }
	
}

?>