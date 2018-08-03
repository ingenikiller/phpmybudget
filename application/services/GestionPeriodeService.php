<?php

class GestionPeriodeService extends ServiceStub{
	
	public function getListe(ContextExecution $p_contexte) {
		
		$requete = 'select distinct annee, count(1) as nbmois from periode group by annee';
		$liste = new ListDynamicObject();
    	$liste->name='ListeAnnee';
        $liste->request($requete);
    	$p_contexte->addDataBlockRow($liste);
	}
	
	public function getListeMois(ContextExecution $p_contexte) {
		$annee = $p_contexte->m_dataRequest->getData('annee');
		//$requete = "select distinct annee, count(1) as nbmois from periode where annee='$annee'";
		$listePeriode = new ListObject();
		$listePeriode->name='ListePeriodeMois';
		$requete="annee='$annee'";
        $listePeriode->request('Periode', $requete);
    	$p_contexte->addDataBlockRow($listePeriode);
	}

	public function create(ContextExecution $p_contexte){
		$annee = $p_contexte->m_dataRequest->getData('annee');
		
		$listePeriode = new ListObject();
		$listePeriode->name='ListePeriode';
		$requete="annee='$annee'";
		
		//$listFlux->setAssociatedKey($comptePrincipal);
		$listePeriode->request('Periode', $requete);
		$this->logger->debug('nb periode:' . $listePeriode->getNbRows());
		if ($listePeriode->getNbRows()!=0){
			$reponse = new ReponseAjax();
			$reponse->status='KO';
			$reponse->message="Annee déjà créée";
			$p_contexte->addDataBlockRow($reponse);
			return;
		}
		
		PeriodeCommun::initialiserPeriodeMois($annee);
		
		$reponse = new ReponseAjax();
		$reponse->status='OK';
		$p_contexte->addDataBlockRow($reponse);
	}
}
?>