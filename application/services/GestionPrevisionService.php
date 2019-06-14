<?php

class GestionPrevisionService extends ServiceStub {
	public function getPage(ContextExecution $p_contexte) {
        
        $annee=$p_contexte->m_dataRequest->getData('annee');
        $this->logger->debug('annee:'.$annee);
        if($annee==''){
            $annee = date('Y');
        }
        
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $l_compte = new Comptes();
		$l_compte->numeroCompte=$numeroCompte;
		$l_compte->load();
		$p_contexte->addDataBlockRow($l_compte);
        
        $requete = 'SELECT DISTINCT annee from periode WHERE TRIM(annee) IS NOT NULL ORDER BY annee';
		$listeAnnees = new ListDynamicObject();
        $listeAnnees->name = 'ListeAnnees';
        $listeAnnees->request($requete);
        $p_contexte->addDataBlockRow($listeAnnees);
		
        $p_contexte->addDataBlockRow(ComptesCommun::calculSommeOperations($numeroCompte));
		$p_contexte->setTitrePage("Prévisions du compte " . $numeroCompte);
    }
	
	public function getListeAnnee(ContextExecution $p_contexte) {
        $annee=$p_contexte->m_dataRequest->getData('periode');
        $flagPinel=$p_contexte->m_dataRequest->getData('flagPinel');
        
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $dateDeb=$annee.'-01';
        $dateFin=$annee.'-12';
        
		$clausePinel='';
		switch($flagPinel){
			case 'complet':
				break;
			case 'pinel':
				$clausePinel='AND EXISTS (SELECT 1 FROM flux WHERE 1=1 AND flux.fluxid=prevision.fluxid AND flux.fluxMaitreId =\'101\')';
				break;
			case 'sans':
				$clausePinel='AND EXISTS (SELECT 1 FROM flux WHERE 1=1 AND flux.fluxid=prevision.fluxid AND flux.fluxMaitreId !=\'101\')';
				break;
		}
		
		
        $clausePrevisions = "noCompte='$numeroCompte' and typenr='L' and annee='$annee' $clausePinel";
        
        $previsions = new ListObject();
        $previsions->name='Previsions';
        $previsions->request('Prevision', $clausePrevisions);
		$p_contexte->addDataBlockRow($previsions);
		
        //requête des opérations récurrentes
        $requeteTotaux = 
			"SELECT ROUND(sum(montant),2) AS total
			FROM operation 
				LEFT JOIN flux ON flux.fluxId = operation.fluxId $clausePinel
				LEFT JOIN prevision ON (prevision.fluxId = operation.fluxId AND prevision.noCOmpte='$numeroCompte' AND operation.date LIKE concat( prevision.periode,'%')
			WHERE operation.nocompte='$numeroCompte' and operationRecurrente='checked' AND date like concat('$annee','%')";
		
        $requete=
			"SELECT ROUND(SUM( montant),2) AS total , fluxId, substring(operation.date,1,7) as mois
			FROM operation 
			WHERE nocompte='$numeroCompte' and date like concat('$annee', '%')
				AND EXISTS (SELECT 1 FROM prevision WHERE prevision.noCOmpte='$numeroCompte'
				AND prevision.fluxid=operation.fluxid AND operation.date LIKE concat( substring(prevision.mois,1,4), '%'))
			GROUP BY fluxid, mois";
        $listMontantTotaux = new ListDynamicObject();
        $listMontantTotaux->name = 'ListeMontantFlux';
        $listMontantTotaux->request($requete);
        $p_contexte->addDataBlockRow($listMontantTotaux);
		
		//liste des périodes
        $liste = new ListObject();
        $liste->name='Periodes';
        //$liste->setAssociatedKey($previsions);
        //$liste->setAssociatedKey($listMontantTotaux);
        $liste->request('Periode', "periode between '$dateDeb' and '$dateFin' order by periode");
        
        $p_contexte->addDataBlockRow($liste);
        
        //liste des flux
        $listeFlux = new ListDynamicObject();
        $listeFlux->name = 'ListeFlux';
        $listeFlux->request(
			"SELECT DISTINCT flux.fluxId, flux, depense
			FROM prevision 
				INNER JOIN flux ON flux.fluxId = prevision.fluxId  $clausePinel
			WHERE 1=1 AND 
				mois between '$dateDeb' and '$dateFin' AND 
				noCompte='$numeroCompte' ORDER BY flux");
        $p_contexte->addDataBlockRow($listeFlux);
    }
	
	/**
	 * retourne le capital restant en soustrayant au solde du compte les prévisions du mois restantes
	 */
	public function estimationReste(ContextExecution $p_contexte) {
		$userid = $p_contexte->getUser()->userId;
		$numeroCompte = $p_contexte->m_dataRequest->getData('noCompte');
		$compte=new Comptes();
        $compte->userId=$userid;
        $compte->numeroCompte=$numeroCompte;
        $compte->load();
        
        $soldeOpeDyn = ComptesCommun::calculSommeOperations($numeroCompte);
        $tab = $soldeOpeDyn->getData();
        $soldeOpe = $tab[0];
        $soldeOpe = $soldeOpe->total;
        $this->logger->debug('solde ope:'.$soldeOpe);
		
        $mois=date('Y-m');
		//on ne prend que les dépenses pour être dans le cas le plus défavorable
        $l_requete =
			"SELECT SUM(montant) as total 
			FROM prevision, flux 
			WHERE 1=1 
				AND nocompte='$numeroCompte'
				AND mois='$mois'
				AND flux.fluxid=prevision.fluxid
				AND depense='O'";
        
		$dyn = new ListDynamicObject();
		$dyn->name = 'SommePrevisions';
		$dyn->request($l_requete);
		$tab = $dyn->getData();
        $soldePre = $tab[0];
		$soldePre = $soldePre->total;
        $this->logger->debug('solde pre:'.$soldePre);
		
		$l_requeteOpe =
			"SELECT sum(montant) as total 
			FROM operation, flux 
			WHERE 1=1 
			AND nocompte='$numeroCompte' 
			AND date LIKE concat('$mois','%') 
			AND flux.fluxid=operation.fluxid AND depense='O' 
			AND EXISTS(
				SELECT 1 
				FROM prevision 
				WHERE nocompte='$numeroCompte' 
				AND mois='$mois' 
				AND operation.fluxid=prevision.fluxid)";
		$dyn = new ListDynamicObject();
		$dyn->name = 'SommePrevisions';
		$dyn->request($l_requeteOpe);
		$tab = $dyn->getData();
        $sommeOpe = $tab[0];
		$sommeOpe = $sommeOpe->total;
		
		$this->logger->debug('solde sommeope:'.$sommeOpe);
		
		// solde du compte + somme des opérations du compte + somme des prévisions du mois - somme des opérations correspondant à des prévisions
		$solde = $compte->solde + $soldeOpe + $soldePre - $sommeOpe;
		$tab=array();
		$tab[1]=number_format($solde, 2,'.', '');
		
        $p_contexte->addDataBlockRow($tab);
	}
	
	public function getOne(ContextExecution $p_contexte) {
        $ligneId = $p_contexte->m_dataRequest->getData('ligneId');
        $this->logger->debug('ligneId:'.$ligneId);
        $prevision = new Prevision();
        $prevision->ligneId = $ligneId;
        $prevision->load();
        $p_contexte->addDataBlockRow($prevision);
    }
	
	public function create(ContextExecution $p_contexte) {
        $prevision = new Prevision();
        $prevision->fieldObject($p_contexte->m_dataRequest);
        $prevision->create();
		$p_contexte->ajoutReponseAjaxOK();
    }
	
	public function update(ContextExecution $p_contexte){
		$ligneId = $p_contexte->m_dataRequest->getData('ligneId');
		$prevision = new Prevision();
		$prevision->ligneId=$ligneId;
		$prevision->load();
		$prevision->fieldObject($p_contexte->m_dataRequest);
		$prevision->update();
		$p_contexte->ajoutReponseAjaxOK();
    }
	
	public function equilibrerPrevision(ContextExecution $p_contexte){
        $ligneId = $p_contexte->m_dataRequest->getData('ligneId');
		$prevision = new Prevision();
		$prevision->ligneId=$ligneId;
		$prevision->load();
		$requeteTotaux = 
			"SELECT round(sum(montant),2) as total
			FROM operation 
			WHERE 1=1
				AND nocompte='$prevision->noCompte' 
				AND date like concat('$prevision->mois','%') 
				AND fluxid='$prevision->fluxId'";
		$listMontantTotaux = new ListDynamicObject();
		$listMontantTotaux->name = 'ListeMontantFlux';
		$listMontantTotaux->request($requeteTotaux);
		$tab=$listMontantTotaux->getData();
		$total=$tab[0];
		$prevision->montant=$total->total;
		$prevision->update();
		$p_contexte->ajoutReponseAjaxOK();
    }
	
}
?>