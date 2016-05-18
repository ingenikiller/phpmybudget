<?php

class GestionPrevisionEnteteService extends ServiceStub {
	
	public function create(ContextExecution $p_contexte){
        $numeroCompte = $p_contexte->m_dataRequest->getData('noCompte');
        $fluxId = $p_contexte->m_dataRequest->getData('fluxId');
        $montant = $p_contexte->m_dataRequest->getData('montant');
        $annee = $p_contexte->m_dataRequest->getData('annee');
        $frequence = $p_contexte->m_dataRequest->getData('periodicite');
        $nomEntete = $p_contexte->m_dataRequest->getData('nomEntete');
        
        
        $entete = new Prevision();
        $entete->typenr='E';
        $entete->annee=$annee;
        $entete->noCompte = $numeroCompte;
        $entete->nomEntete = $nomEntete;
        $entete->fluxId = $fluxId;
        $entete->create();
        //$idEntete = $entete->lastInsertId();
        
        Logger::getInstance()->addLogMessage('nouvelle entete:' . $idEntete);
        
        
        $init=1;
        $intervalle=1;
        
        switch($frequence){
        	case 'M1':
        		$init=1;
        		$intervalle=1;
        		break;
        	case 'T1':
        		$init=1;
        		$intervalle=3;
        		break;
        	case 'T3':
        		$init=3;
        		$intervalle=3;
        		break;
        }
        
        while($init<=12){
        	$mois=$annee.'-'.sprintf("%02d", $init);//+$init;
        	
        	$prevision = new Prevision();
        	$prevision->annee=$annee;
        	$prevision->mois=$mois;
        	$prevision->montant=$montant;
        	$prevision->fluxId=$fluxId;
        	$prevision->typenr='L';
        	//$prevision->identete=$idEntete;
        	$prevision->noCompte=$numeroCompte;
        	$prevision->create();
        	Logger::getInstance()->addLogMessage('nouvelle prevision:' . $prevision->lastInsertId());
        	$init+=$intervalle;
        }
	}



	public function update(ContextExecution $p_contexte){
		$numeroCompte = $p_contexte->m_dataRequest->getData('noCompte');
		$nb = $p_contexte->m_dataRequest->getData('nbligne');
		for($i=1;$i<=$nb;$i++){
			 //Logger::$instance->addLogMessage('ligneId'.$i':'.$p_contexte->m_dataRequest->getData('ligneId-'+$i));
			$prevision= new Prevision();
			$prevision->ligneId=$p_contexte->m_dataRequest->getData('ligneId-'.$i);
			$prevision->load();
			$prevision->fieldObject($p_contexte->m_dataRequest, '', '-', $i);
			$prevision->update();
		}
		
		
	}
	
    /**
     * 
     * Enter description here ...
     * @param ContexteExecution $p_contexte
     */
    public function getListeEntete(ContextExecution $p_contexte){
    	$liste = new ListDynamicObject();
    	$liste->name='ListeEntete';
    	$annee=$p_contexte->m_dataRequest->getData('annee');
    	$numeroCompte=$p_contexte->m_dataRequest->getData('noCompte');
    	
    	$l_requete="SELECT fluxid, flux FROM flux WHERE compteId='$numeroCompte' AND EXISTS(SELECT 1 FROM prevision WHERE prevision.noCompte=flux.compteId AND typenr='E' AND prevision.annee='$annee' AND prevision.fluxid=flux.fluxid)";
        
        $liste->request($l_requete);
        
    	$p_contexte->addDataBlockRow($liste);
    }
	
	public function getOne(ContextExecution $p_contexte){
    	$numeroCompte=$p_contexte->m_dataRequest->getData('noCompte');
    	$fluxId=$p_contexte->m_dataRequest->getData('fluxId');
    	$annee=$p_contexte->m_dataRequest->getData('annee');
    	
    	$liste = new ListObject();
    	$liste->name='PrevisionListe';
    	$liste->request('Prevision', "noCompte='$numeroCompte' AND fluxId='$fluxId' AND annee='$annee' AND typenr='L'");
    	
    	$p_contexte->addDataBlockRow($liste);
    }
}

?>