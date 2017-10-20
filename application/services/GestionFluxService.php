<?php

class GestionFluxService extends ServiceStub {
	
	/**
     * 
     * méthode de recherche des flux
     * @param ContextExecution $p_contexte
     */
	public function getListe(ContextExecution $p_contexte){
        $userid = $p_contexte->getUser()->userId;
        $comptePrincipal = $p_contexte->m_dataRequest->getData('comptePrincipal');
        $compteDestination = $p_contexte->m_dataRequest->getData('compteDestination');
        $fluxMaitre = $p_contexte->m_dataRequest->getData('fluxMaitre');
        $fluxMaitreId = $p_contexte->m_dataRequest->getData('fluxMaitreId');
        $fluxMaitreExclu = $p_contexte->m_dataRequest->getData('fluxMaitreExclu');
		
		//paramètre permettant de rechercher les flux dont le compte est principal ou destinataire
        $recFluxOperations = $p_contexte->m_dataRequest->getData('recFluxOperations');
                
		$numeroPage=$p_contexte->m_dataRequest->getData('numeroPage');
		
		$listFlux = new ListObject();
		$listFlux->name='ListeFlux';
		$requete="userId='$userid'";
		
		if($recFluxOperations!=null && $recFluxOperations=='O'){
			$requete.= " AND (compteid='$comptePrincipal' OR compteDest='$comptePrincipal')";
		} else if($comptePrincipal!=''){
			$requete.= " AND compteid='$comptePrincipal' ";
		}
		if($compteDestination!=''){
			$requete.= " AND compteDest='$compteDestination'";
		}
		if($fluxMaitre!=''){
			$requete.= " AND fluxMaitre='$fluxMaitre' ";
		}
		/*$this->logger->debug('flux maitre id:'.$fluxMaitreId);
		$this->logger->debug('flux maitre exclu:'.$fluxMaitreExclu);*/
		
		if($fluxMaitreId!=''){
			$requete.= " AND fluxMaitreId='$fluxMaitreId' ";
		}
		if($fluxMaitreExclu!=''){
			$requete.= " AND fluxMaitreId!='$fluxMaitreExclu' ";
		}
		
		$listFlux->request('Flux', $requete.' order by flux', $numeroPage);
		$p_contexte->addDataBlockRow($listFlux);
	
    }
	
	public function getOne(ContextExecution $p_contexte){
        $userid = $p_contexte->getUser()->userId;
        $fluxid = $p_contexte->m_dataRequest->getData('fluxId');
			
		$flux = new Flux();
		$flux->fluxId=$fluxid;
		$flux->userId=$userid;
		$flux->load();
		$p_contexte->addDataBlockRow($flux);
    }
	
	/**
     * 
     * méthode de création
     * @param ContextExecution $p_contexte
     */
	public function create(ContextExecution $p_contexte){
		$flux = new Flux();
		$userid = $p_contexte->getUser()->userId;
		$flux->fieldObject($p_contexte->m_dataRequest);
		$flux->userId = $userid;
		$flux->create();
	}
	
	/**
	 * 
	 * méthode de mise à jour
	 * @param ContextExecution $p_contexte
	 */
	public function update(ContextExecution $p_contexte){
		$flux = new Flux();
		$flux->fluxId = $p_contexte->m_dataRequest->getData('fluxId');
		$flux->load();
		$flux->fieldObject($p_contexte->m_dataRequest);
		$flux->update();
	}
}


?>