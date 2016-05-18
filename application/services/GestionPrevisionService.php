<?php

class GestionPrevisionService extends ServiceStub {
	public function getPage(ContextExecution $p_contexte) {
        //$userid = $p_contexte->getUser()->userId;
        $annee=$p_contexte->m_dataRequest->getData('annee');
        Logger::$instance->addLogMessage('annee:'.$annee);
        if($annee==''){
            $annee = date('Y');
        }
        
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        $listeFlux = new ListObject();
        $listeFlux->name='ListeFlux';
        $l_clause="compteId='$numeroCompte' or compteDest='$numeroCompte' order by flux ASC"; 
        $listeFlux->requestNoPage('Flux', $l_clause);
        $p_contexte->addDataBlockRow($listeFlux);
        
        $l_compte = new Comptes();
		$l_compte->numeroCompte=$numeroCompte;
		$l_compte->load();
		$p_contexte->addDataBlockRow($l_compte);
        
        //périodes de l'année
        $listePeriode = new ListObject();
        $listePeriode->name='ListePeriodes';
        $l_clause=" annee='$annee' order by periode ASC"; 
        $listePeriode->requestNoPage('Periode', $l_clause);
        $p_contexte->addDataBlockRow($listePeriode);
        
		$requete = 'SELECT DISTINCT annee from periode WHERE TRIM(annee) IS NOT NULL ORDER BY annee';
		$listeAnnees = new ListDynamicObject();
        $listeAnnees->name = 'ListeAnnees';
        $listeAnnees->request($requete);
        $p_contexte->addDataBlockRow($listeAnnees);
		
        $p_contexte->addDataBlockRow(ComptesCommun::calculSommeOperations($numeroCompte));
    }
	
	public function getListeAnnee(ContextExecution $p_contexte) {
        $annee=$p_contexte->m_dataRequest->getData('periode');
        //PeriodeCommun::initialiserPeriodeMois($annee);
        
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $dateDeb=$annee.'-01';
        $dateFin=$annee.'-12';
        
        $clausePrevisions = "noCompte='$numeroCompte' and typenr='L' and mois='".'$parent->periode\'';
        
        $previsions = new ListObject();
        $previsions->name='Previsions';
        $previsions->setAssociatedRequest('Prevision', $clausePrevisions);
        
        
        //requête des opérations récurrentes
        $requeteTotaux = "SELECT ROUND(sum(montant),2) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId
                                                LEFT JOIN prevision ON (prevision.fluxId = operation.fluxId AND prevision.noCOmpte='$numeroCompte' AND operation.date LIKE concat( prevision.periode,\'%\')
						WHERE operation.nocompte='$numeroCompte' and operationRecurrente='checked'" .
                'AND date like concat(\'$parent->mois\',\'%\')';
        $requete='SELECT ROUND(SUM( montant),2) AS total , fluxId
					FROM operation 
					WHERE nocompte=' . $numeroCompte . ' and date like concat(\'$parent->periode\',\'%\')
                AND EXISTS (SELECT 1 FROM prevision WHERE prevision.noCOmpte=\''.$numeroCompte.'\'  AND prevision.fluxid=operation.fluxid AND operation.date LIKE concat( substring(prevision.mois,1,4),\'%\'))
                  GROUP BY fluxid ';
        $listMontantTotaux = new ListDynamicObject();
        $listMontantTotaux->name = 'ListeMontantFlux';
        $listMontantTotaux->setAssociatedRequest(null, $requete);
        
		//liste des périodes
        $liste = new ListObject();
        $liste->name='Periodes';
        $liste->setAssociatedKey($previsions);
        $liste->setAssociatedKey($listMontantTotaux);
        $liste->request('Periode', "periode between '$dateDeb' and '$dateFin' order by periode");
        
        $p_contexte->addDataBlockRow($liste);
        
        //liste des flux
        $listeFlux = new ListDynamicObject();
        $listeFlux->name = 'ListeFlux';
        $listeFlux->request("SELECT DISTINCT flux.fluxId, flux, depense FROM prevision 
						LEFT JOIN flux ON flux.fluxId = prevision.fluxId 
                                                WHERE mois between '$dateDeb' and '$dateFin' and noCompte='$numeroCompte' ORDER BY flux");
        $p_contexte->addDataBlockRow($listeFlux);
    }
	
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
        Logger::getInstance()->addLogMessage('solde ope:'.$soldeOpe);
		
        $mois=date('Y-m');
        $l_requete = "SELECT SUM(montant) as total FROM prevision, flux WHERE 1=1 "
        			. "AND nocompte='$numeroCompte' "
        			. "AND mois='$mois'"
        			. "AND flux.fluxid=prevision.fluxid "
        			. "AND depense='O'";
        
		$dyn = new ListDynamicObject();
		$dyn->name = 'SommePrevisions';
		$dyn->request($l_requete);
		$tab = $dyn->getData();
        $soldePre = $tab[0];
		$soldePre = $soldePre->total;
        Logger::getInstance()->addLogMessage('solde pre:'.$soldePre);
		
		
		$l_requeteOpe ="SELECT sum(montant) as total FROM operation, flux WHERE 1=1 "
					. "AND nocompte='$numeroCompte' "
					. "AND date LIKE concat('$mois','%') "
					. "AND flux.fluxid=operation.fluxid AND depense='O' "
					. "AND EXISTS(SELECT 1 FROM prevision WHERE nocompte='$numeroCompte' AND mois='$mois' AND operation.fluxid=prevision.fluxid)";
		$dyn = new ListDynamicObject();
		$dyn->name = 'SommePrevisions';
		$dyn->request($l_requeteOpe);
		$tab = $dyn->getData();
        $sommeOpe = $tab[0];
		$sommeOpe = $sommeOpe->total;
		
		Logger::getInstance()->addLogMessage('solde sommeope:'.$sommeOpe);
		
		$solde = $compte->solde + $soldeOpe + $soldePre - $sommeOpe;
		$tab=array();
		$tab[1]=number_format($solde, 2,'.', '');
		
        $p_contexte->addDataBlockRow($tab);
	}
	
	public function getOne(ContextExecution $p_contexte) {
        $ligneId = $p_contexte->m_dataRequest->getData('ligneId');
        Logger::$instance->addLogMessage('ligneId:'.$ligneId);
        $prevision = new Prevision();
        $prevision->ligneId = $ligneId;
        $prevision->load();
        
        
        //echo json_encode($prevision);
        $p_contexte->addDataBlockRow($prevision);
    }
	
	public function create(ContextExecution $p_contexte) {
        $prevision = new Prevision();
        $prevision->fieldObject($p_contexte->m_dataRequest);
        $prevision->create();
    
    }
	
	public function update(ContextExecution $p_contexte){
		$ligneId = $p_contexte->m_dataRequest->getData('ligneId');
		$prevision = new Prevision();
		$prevision->ligneId=$ligneId;
		$prevision->load();
		$prevision->fieldObject($p_contexte->m_dataRequest);
		$prevision->update();
    }
	
	public function equilibrerPrevision(ContextExecution $p_contexte){
        $ligneId = $p_contexte->m_dataRequest->getData('ligneId');
		$prevision = new Prevision();
		$prevision->ligneId=$ligneId;
		$prevision->load();
		$requeteTotaux = "SELECT round(sum(montant),2) as total
						FROM operation 
						WHERE nocompte='$prevision->noCompte' and date like concat('$prevision->mois','%') and fluxid='$prevision->fluxId'";
		$listMontantTotaux = new ListDynamicObject();
		$listMontantTotaux->name = 'ListeMontantFlux';
		$listMontantTotaux->request($requeteTotaux);
		$tab=$listMontantTotaux->getData();
		$total=$tab[0];
		$prevision->montant=$total->total;
		$prevision->update();
    }
}
?>