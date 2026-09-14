<?php
namespace Application\Services;

use Core\ServiceStub;
use Core\ContextExecution;
use Core\ListDynamicObject;

class GestionStatistiquesApiService extends ServiceStub {
	
	/*************************************************************/
	//
	// gestion des années
	//
	/*************************************************************/
	
	
	public function statAnneesFlux(ContextExecution $p_contexte) {
        
		$premiereAnnee = $p_contexte->m_dataRequest->getData('premiereAnnee');
        $derniereAnnee = '';
        if ($p_contexte->m_dataRequest->getData('derniereAnnee') == '') {
            $derniereAnnee = $premiereAnnee;//.'-12-31';
        } else {
            $derniereAnnee = $p_contexte->m_dataRequest->getData('derniereAnnee'); //.'-12-31';
        }
        //$premiereAnnee.='-01-01';
		
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
		
		$listePeriode = new ListDynamicObject('ListePeriodes');
		$listePeriode-> request("select distinct annee as periode from periode where annee between '$premiereAnnee' and '$derniereAnnee'");
		$p_contexte->addDataBlockRow($listePeriode);
        
		
		
		$listeFluxFils = new ListDynamicObject('ListeFluxFils');
		$listeFluxFils->setAssociatedRequest(null, 'SELECT fluxId, flux FROM flux WHERE fluxMaitreId=\'$parent->fluxId\' ORDER BY flux');
		
		$listeFlux = new ListDynamicObject('ListeFlux');
		
		$listeFlux->setAssociatedKey($listeFluxFils);
		$listeFlux->request("
			SELECT fluxId, flux 
				FROM flux 
				WHERE 
					(compteId='$numeroCompte' OR compteDest='$numeroCompte') 
					and fluxMaitreId = 0 
				and exists(
					select distinct annee from periode 
					join operation on operation.noCompte='$numeroCompte' and dateOperation like CONCAT(periode.annee, '%') and operation.fluxid=flux.fluxId
					where annee between '$premiereAnnee' and '$derniereAnnee'
				)
			UNION 	
			SELECT fluxId, flux 
				FROM flux 
				WHERE compteId='$numeroCompte'
				and fluxMaitre='O'
				AND EXISTS (
					select distinct annee from periode 
					join stat_flux sf on  sf.nocompte='$numeroCompte' and sf.fluxId =flux.fluxid and sf.mois like CONCAT(periode,'%') and sf.fluxid=flux.fluxId
					where annee between '$premiereAnnee' and '$derniereAnnee')
			ORDER BY flux
		");
		$p_contexte->addDataBlockRow($listeFlux);
	}
	
	public function statAnneesMontants(ContextExecution $p_contexte){
        $premiereAnnee = $p_contexte->m_dataRequest->getData('premiereAnnee');
        $derniereAnnee = '';
        if ($p_contexte->m_dataRequest->getData('derniereAnnee') == '') {
            $derniereAnnee = $premiereAnnee;//.'-12-31';
        } else {
            $derniereAnnee = $p_contexte->m_dataRequest->getData('derniereAnnee'); //.'-12-31';
        }
        //$premiereAnnee.='-01-01';
		
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        
		$requeteAsso = 
			"with periodeliste as(select distinct annee from periode where annee between '$premiereAnnee' and '$derniereAnnee')
				select CONCAT(periodeliste.annee,'_',flux.fluxid) as flp, periodeliste.annee as periode,flux.fluxid, sum(montant) AS total from operation 
				join periodeliste on operation.dateOperation like concat(periodeliste.annee,'%') 
				join flux on flux.fluxid=operation.fluxid and (compteId='$numeroCompte' OR compteDest='$numeroCompte')
				where operation.noCompte='$numeroCompte'
				group by periodeliste.annee, flux.fluxid, flux
				UNION
				select CONCAT(periodeliste.annee,'_',flux.fluxid) as flp, periodeliste.annee as periode,flux.fluxid, sum(total) AS total from stat_flux 
				join periodeliste on stat_flux.mois like concat(periodeliste.annee,'%') 
				join flux on flux.fluxid=stat_flux.fluxid and flux.compteId='$numeroCompte' and flux.fluxmaitre='O'
				where stat_flux.noCompte='$numeroCompte' 
				group by periodeliste.annee, flux.fluxid, flux";
        $listMontantFlux= new ListDynamicObject('ListeMontantFlux');
        $listMontantFlux->request($requeteAsso);
		$p_contexte->addDataBlockRow($listMontantFlux);
		
        
    }
	
	/*************************************************************/
	//
	// gestion des mois
	//
	/*************************************************************/
	
	public function statMoisFlux(ContextExecution $p_contexte) {
        
		$premiereMois = $p_contexte->m_dataRequest->getData('premierMois');
        $dernierMois = $p_contexte->m_dataRequest->getData('dernierMois');
        
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
		
		$listePeriode = new ListDynamicObject('ListePeriodes');
		$listePeriode-> request("select periode as periode from periode where periode between '$premiereMois' and '$dernierMois' order by periode");
		$p_contexte->addDataBlockRow($listePeriode);
        
		
		
		$listeFluxFils = new ListDynamicObject('ListeFluxFils');
		$listeFluxFils->setAssociatedRequest(null, 'SELECT fluxId, flux FROM flux WHERE fluxMaitreId=\'$parent->fluxId\' ORDER BY flux');
		
		$listeFlux = new ListDynamicObject('ListeFlux');
		
		$listeFlux->setAssociatedKey($listeFluxFils);
		$listeFlux->request("
			SELECT fluxId, flux 
				FROM flux 
				WHERE 
					(compteId='$numeroCompte' OR compteDest='$numeroCompte') 
					and fluxMaitreId = 0 
				and exists(
					select periode.periode from periode 
					join operation on operation.noCompte='$numeroCompte' and dateOperation like CONCAT(periode.periode, '%') and operation.fluxid=flux.fluxId
					where periode.periode between '$premiereMois' and '$dernierMois'
				)
			UNION 	
			SELECT fluxId, flux 
				FROM flux 
				WHERE compteId='$numeroCompte'
				and fluxMaitre='O'
				AND EXISTS (
					select periode.periode from periode 
					join stat_flux sf on  sf.nocompte='$numeroCompte' and sf.fluxId =flux.fluxid and sf.mois like CONCAT(periode,'%') and sf.fluxid=flux.fluxId
					where periode.periode between '$premiereMois' and '$dernierMois')
			ORDER BY flux
		");
		$p_contexte->addDataBlockRow($listeFlux);
	}
	
	public function statMoisMontants(ContextExecution $p_contexte){
        $premierMois = $p_contexte->m_dataRequest->getData('premierMois');
        $dernierMois = $p_contexte->m_dataRequest->getData('dernierMois');
        
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        
		$requeteAsso = 
			"with periodeliste as(select periode from periode where periode between '$premierMois' and '$dernierMois')
				select CONCAT(periodeliste.periode,'_',flux.fluxid) as flp, periodeliste.periode as periode,flux.fluxid, sum(montant) AS total from operation 
				join periodeliste on operation.dateOperation like concat(periodeliste.periode,'%') 
				join flux on flux.fluxid=operation.fluxid and (compteId='$numeroCompte' OR compteDest='$numeroCompte')
				where operation.noCompte='$numeroCompte'
				group by periodeliste.periode, flux.fluxid, flux
				UNION
				select CONCAT(periodeliste.periode,'_',flux.fluxid) as flp, periodeliste.periode as periode,flux.fluxid, sum(total) AS total from stat_flux 
				join periodeliste on stat_flux.mois like concat(periodeliste.periode,'%') 
				join flux on flux.fluxid=stat_flux.fluxid and flux.compteId='$numeroCompte' and flux.fluxmaitre='O'
				where stat_flux.noCompte='$numeroCompte' 
				group by periodeliste.periode, flux.fluxid, flux";
        $listMontantFlux= new ListDynamicObject('ListeMontantFlux');
        $listMontantFlux->request($requeteAsso);
		$p_contexte->addDataBlockRow($listMontantFlux);
		
        
    }
	
	
	
	public function affFormAnnees(ContextExecution $p_contexte) {
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $listReleves = new ListDynamicObject('ListeAnnee');
        $listReleves->request("SELECT DISTINCT substr( dateOperation, 1, 4 ) as annee FROM operation WHERE nocompte = '$numeroCompte' order by annee desc");
        $p_contexte->addDataBlockRow($listReleves);
    }
	
	public function statMois(ContextExecution $p_contexte) {
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');

        //requ�te des montants par flux/mois
        $requeteAsso = 'SELECT fluxId, sum(total) as total
					FROM stat_flux 
					WHERE nocompte=' . $numeroCompte . ' and mois like concat(\'$parent->mois\',\'%\') GROUP BY fluxid';

        $listMontantFlux = new ListDynamicObject('ListeMontantFlux');
        $listMontantFlux->setAssociatedRequest(null, $requeteAsso);
        
        //requ�te des op�rations r�currentes
        $requeteTotaux = "SELECT sum(montant) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId  
						WHERE operation.nocompte='$numeroCompte' and operationRecurrente='checked'" .
                'AND dateOperation like concat(\'$parent->mois\',\'%\')';
        $listMontantTotaux = new ListDynamicObject('ListeMontantOpeRecurrente');
        $listMontantTotaux->setAssociatedRequest(null, $requeteTotaux);

        //requ�te des calculs concernant l'�pargne
        $requeteEpargne = "SELECT sum(montant) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId  
						WHERE operation.nocompte='$numeroCompte' and entreeEpargne='checked'" .
                'AND dateOperation like concat(\'$parent->mois\',\'%\')';
		
        $listMontantEpargne = new ListDynamicObject('ListeMontantEpargne');
        $listMontantEpargne->setAssociatedRequest(null, $requeteEpargne);

        $premierMois = $p_contexte->m_dataRequest->getData('premiereAnnee') . '-' . $p_contexte->m_dataRequest->getData('premierMois') . '-01';
        $dernierReleve = '';
        if ($p_contexte->m_dataRequest->getData('derniereAnnee') == null) {
            $dernierReleve = $p_contexte->m_dataRequest->getData('premiereAnnee') . '-' . $p_contexte->m_dataRequest->getData('premierMois') . '-31';
        } else {
            $dernierReleve = $p_contexte->m_dataRequest->getData('derniereAnnee') . '-' . $p_contexte->m_dataRequest->getData('dernierMois') . '-31';
        }
        $p_contexte->m_dataRequest->getData('dernierReleve');
        //requ�te principale
        $l_requete = "SELECT distinct substr(dateOperation,1,7) AS mois FROM operation WHERE dateOperation between '$premierMois' and '$dernierReleve' and nocompte='$numeroCompte' order by mois";

        $listeReleves = new ListDynamicObject('ListeMois');
        $listeReleves->setAssociatedKey($listMontantFlux);
        $listeReleves->setAssociatedKey($listMontantTotaux);
        $listeReleves->setAssociatedKey($listMontantEpargne);
        $listeReleves->request($l_requete);
        $p_contexte->addDataBlockRow($listeReleves);

		
		$requeteMontantFils='SELECT sum(montant) AS total, substr(dateOperation, 1, 7) as date, fluxId
						FROM operation 
						WHERE operation.nocompte=\''.$numeroCompte.'\' and fluxId=$parent->fluxId
						AND dateOperation  between \''.$premierMois.'\' and \''.$dernierReleve.'\' group by substr(dateOperation, 1, 7)';
		
		$montantFluxFils = new ListDynamicObject('MontantFluxFils');
		$montantFluxFils->setAssociatedRequest(null, $requeteMontantFils);
		
		
		//flux fils
		$requeteFlux = 'SELECT fluxId, flux FROM flux WHERE fluxMaitreId=$parent->fluxId ORDER BY flux';
		$listFluxFils = new ListDynamicObject('ListeFluxFils');
		$listFluxFils->setAssociatedKey($montantFluxFils);
        $listFluxFils->setAssociatedRequest(null, $requeteFlux);
		
		
        //liste des flux
        $listeFlux = new ListDynamicObject('ListeFlux');
		$listeFlux->setAssociatedKey($listFluxFils);
        $listeFlux->request("SELECT DISTINCT flux.fluxId, flux, operationRecurrente , flux.fluxMaitre FROM stat_flux 
						LEFT JOIN flux ON flux.fluxId = stat_flux.fluxId 
                                                WHERE concat(mois, '-15') between '$premierMois' and '$dernierReleve' and nocompte='$numeroCompte' ORDER BY flux");
        $p_contexte->addDataBlockRow($listeFlux);
    }
	
	/*************************************************************/
	//
	// gestion des mois
	//
	/*************************************************************/
	
	public function affFormMois(ContextExecution $p_contexte) {
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $listReleves = new ListDynamicObject('ListeAnnee');
        $listReleves->request("SELECT DISTINCT substr( dateOperation, 1, 4 ) as annee FROM operation WHERE nocompte = '$numeroCompte' order by annee desc");
        $p_contexte->addDataBlockRow($listReleves);
    }
	
	public function statAnneesOLD(ContextExecution $p_contexte) {
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        //requ�te des montants par flux/mois
        /*$requeteAsso = 'SELECT SUM( montant) AS total , fluxId, \'$parent->annee\' AS periode
					FROM operation 
					WHERE nocompte=' . $numeroCompte . ' and date like concat(\'$parent->annee\',\'%\') GROUP BY fluxid';*/
        $requeteAsso = 'SELECT fluxId, substr(mois, 1, 4 ) AS periode, fluxMaitre, sum(total) as total
					FROM stat_flux
					WHERE nocompte=\'' . $numeroCompte . '\' and mois like concat(\'$parent->annee\',\'%\') GROUP BY fluxid, substr(mois, 1, 4 ), fluxMaitre';
					
        $listMontantFlux = new ListDynamicObject('ListeMontantFlux');
        $listMontantFlux->setAssociatedRequest(null, $requeteAsso);

			
		
		
		
		
        //requ�te des op�rations r�currentes
        $requeteTotaux = "SELECT sum(montant) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId  
						WHERE operation.nocompte='$numeroCompte' and operationRecurrente='checked'" .
                'AND dateOperation like concat(\'$parent->annee\',\'%\')';
        $listMontantTotaux = new ListDynamicObject('ListeMontantOpeRecurrente');
        $listMontantTotaux->setAssociatedRequest(null, $requeteTotaux);

        //requ�te des calculs concernant l'�pargne
        $requeteEpargne = "SELECT sum(montant) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId  
						WHERE operation.nocompte='$numeroCompte' and entreeEpargne='checked'" .
                'AND dateOperation like concat(\'$parent->annee\',\'%\')';
        $listMontantEpargne = new ListDynamicObject('ListeMontantEpargne');
        $listMontantEpargne->setAssociatedRequest(null, $requeteEpargne);
        
        $premiereAnnee = $p_contexte->m_dataRequest->getData('premiereAnnee');
        $derniereAnnee = '';
        if ($p_contexte->m_dataRequest->getData('derniereAnnee') == null) {
            $derniereAnnee = $premiereAnnee.'-12-31';
        } else {
            $derniereAnnee = $p_contexte->m_dataRequest->getData('derniereAnnee').'-12-31';
        }
        $premiereAnnee.='-01-01';
        //$p_contexte->m_dataRequest->getData('dernierReleve');
        //requ�te principale
        $l_requete = "SELECT distinct substr(dateOperation,1,4) AS annee FROM operation WHERE dateOperation between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' order by annee";

        $listeReleves = new ListDynamicObject('ListeAnnees');
        $listeReleves->setAssociatedKey($listMontantFlux);
        $listeReleves->setAssociatedKey($listMontantTotaux);
        $listeReleves->setAssociatedKey($listMontantEpargne);
        $listeReleves->request($l_requete);
        $p_contexte->addDataBlockRow($listeReleves);

		
		$requeteMontantFils='SELECT sum(montant) AS total, substr(dateOperation, 1, 4) as date, fluxId
						FROM operation 
						WHERE operation.nocompte=\''.$numeroCompte.'\' and fluxId=$parent->fluxId
						AND dateOperation  between \''.$premiereAnnee.'\' and \''.$derniereAnnee.'\' group by substr(dateOperation, 1, 4)';
		$montantFluxFils = new ListDynamicObject('MontantFluxFils');
		$montantFluxFils->setAssociatedRequest(null, $requeteMontantFils);
		
		
		//flux fils
		$requeteFlux = 'SELECT fluxId, flux FROM flux WHERE fluxMaitreId=$parent->fluxId ORDER BY flux';
		$listFluxFils = new ListDynamicObject('ListeFluxFils');
		$listFluxFils->setAssociatedKey($montantFluxFils);
        $listFluxFils->setAssociatedRequest(null, $requeteFlux);
		
        //liste des flux
        $listeFlux = new ListDynamicObject('ListeFlux');
		$listeFlux->setAssociatedKey($listFluxFils);
        $listeFlux->request("SELECT DISTINCT flux.fluxId, flux, operationRecurrente , flux.fluxMaitre FROM stat_flux 
						LEFT JOIN flux ON flux.fluxId = stat_flux.fluxId 
                                                WHERE concat(mois, '-15') between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' ORDER BY flux");
                                                //WHERE date between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' ORDER BY flux");
        $p_contexte->addDataBlockRow($listeFlux);
        
     }
	
	//http://localhost/phpmybudget/index.php?domaine=statistique&service=statanneesapi&numeroCompte=90063454011&premiereAnnee=2026&derniereAnnee=
	public function statAnneesApi(ContextExecution $p_contexte) {
        
		$premiereAnnee = $p_contexte->m_dataRequest->getData('premiereAnnee');
        $derniereAnnee = '';
        if ($p_contexte->m_dataRequest->getData('derniereAnnee') == '') {
            $derniereAnnee = $premiereAnnee;//.'-12-31';
        } else {
            $derniereAnnee = $p_contexte->m_dataRequest->getData('derniereAnnee'); //.'-12-31';
        }
        //$premiereAnnee.='-01-01';
		
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
		
		$listePeriode = new ListDynamicObject('ListePeriodes');
		$listePeriode-> request("select distinct annee from periode where annee between '$premiereAnnee' and '$derniereAnnee'");
		$p_contexte->addDataBlockRow($listePeriode);
        
		
		$reqFluxMontantMaitre = new ListDynamicObject('ListeFluxMontant');
		$reqFluxMontantMaitre->setAssociatedRequest(null, 
			"with periode as(select annee from periode where annee between '$premiereAnnee' and '$derniereAnnee')
				select periode.annee, sum(total) AS total from periode
				join stat_flux on stat_flux.noCompte='$numeroCompte' and stat_flux.mois like concat(periode.annee, '%')".'and stat_flux.fluxId = \'$parent->fluxid\'');
		
		$listeFluxFils = new ListDynamicObject('ListeFluxFils');
		$listeFluxFils->setAssociatedRequest(null, 'SELECT fluxId, flux FROM flux WHERE fluxMaitreId=\'$parent->fluxid\'');
		
		
		$listeFlux = new ListDynamicObject('ListeFlux');
		$listeFlux->setAssociatedKey($reqFluxMontantMaitre);
		$listeFlux->setAssociatedKey($listeFluxFils);
		$listeFlux->request("SELECT fluxid, flux FROM flux WHERE (compteId='$numeroCompte' OR compteDest='$numeroCompte') and fluxMaitreId = 0 ORDER BY flux");
		$p_contexte->addDataBlockRow($listeFlux);
		/*
		$reqFlux= " with (select distinct annee from periode where debut like '$premiereAnnee%' and fin like '$derniereAnnee%') as req
			SELECT req.
		*/
		
		//requ�te des montants par flux/mois
        /*$requeteAsso = 'SELECT SUM( montant) AS total , fluxId, \'$parent->annee\' AS periode
					FROM operation 
					WHERE nocompte=' . $numeroCompte . ' and date like concat(\'$parent->annee\',\'%\') GROUP BY fluxid';*/
        /*
		$requeteAsso = 'SELECT fluxId, substr(mois, 1, 4 ) AS periode, fluxMaitre, sum(total) as total
					FROM stat_flux
					WHERE nocompte=\'' . $numeroCompte . '\' and mois like concat(\'$parent->annee\',\'%\') GROUP BY fluxid, substr(mois, 1, 4 ), fluxMaitre';
					
        $listMontantFlux = new ListDynamicObject('ListeMontantFlux');
        $listMontantFlux->setAssociatedRequest(null, $requeteAsso);
		$p_contexte->addDataBlockRow($listMontantFlux);
		
		
		/*$listePeriode = new ListDynamicObject('ListePeriodes');
		$listePeriode-> request("select distinct annee from periode where debut like '$premiereAnnee%' and fin like 'derniereAnnee%'");
		
		
        //requ�te des op�rations r�currentes
        $requeteTotaux = "SELECT sum(montant) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId  
						WHERE operation.nocompte='$numeroCompte' and operationRecurrente='checked'" .
                'AND dateOperation like concat(\'$parent->annee\',\'%\')';
        $listMontantTotaux = new ListDynamicObject('ListeMontantOpeRecurrente');
        $listMontantTotaux->setAssociatedRequest(null, $requeteTotaux);

        //requ�te des calculs concernant l'�pargne
        $requeteEpargne = "SELECT sum(montant) AS total
						FROM operation 
						LEFT JOIN flux ON flux.fluxId = operation.fluxId  
						WHERE operation.nocompte='$numeroCompte' and entreeEpargne='checked'" .
                'AND dateOperation like concat(\'$parent->annee\',\'%\')';
        $listMontantEpargne = new ListDynamicObject('ListeMontantEpargne');
        $listMontantEpargne->setAssociatedRequest(null, $requeteEpargne);
        
        
        //$p_contexte->m_dataRequest->getData('dernierReleve');
        //requ�te principale
        $l_requete = "SELECT distinct substr(dateOperation,1,4) AS annee FROM operation WHERE dateOperation between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' order by annee";

        $listeReleves = new ListDynamicObject('ListeAnnees');
        $listeReleves->setAssociatedKey($listMontantFlux);
        $listeReleves->setAssociatedKey($listMontantTotaux);
        $listeReleves->setAssociatedKey($listMontantEpargne);
        $listeReleves->request($l_requete);
        $p_contexte->addDataBlockRow($listeReleves);

		
		$requeteMontantFils='SELECT sum(montant) AS total, substr(dateOperation, 1, 4) as date, fluxId
						FROM operation 
						WHERE operation.nocompte=\''.$numeroCompte.'\' and fluxId=$parent->fluxId
						AND dateOperation  between \''.$premiereAnnee.'\' and \''.$derniereAnnee.'\' group by substr(dateOperation, 1, 4)';
		$montantFluxFils = new ListDynamicObject('MontantFluxFils');
		$montantFluxFils->setAssociatedRequest(null, $requeteMontantFils);
		
		
		//flux fils
		$requeteFlux = 'SELECT fluxId, flux FROM flux WHERE fluxMaitreId=$parent->fluxId ORDER BY flux';
		$listFluxFils = new ListDynamicObject('ListeFluxFils');
		$listFluxFils->setAssociatedKey($montantFluxFils);
        $listFluxFils->setAssociatedRequest(null, $requeteFlux);
		
        //liste des flux
        $listeFlux = new ListDynamicObject('ListeFlux');
		$listeFlux->setAssociatedKey($listFluxFils);
        $listeFlux->request("SELECT DISTINCT flux.fluxId, flux, operationRecurrente , flux.fluxMaitre FROM stat_flux 
						LEFT JOIN flux ON flux.fluxId = stat_flux.fluxId 
                                                WHERE concat(mois, '-15') between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' ORDER BY flux");
                                                //WHERE date between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' ORDER BY flux");
        $p_contexte->addDataBlockRow($listeFlux);
		*/
        
     }
	 
	 
	/*************************************************************/
	//
	// gestion des cumul
	//
	/*************************************************************/
	
	public function affFormCumul(ContextExecution $p_contexte) {
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
        $listReleves = new ListDynamicObject('ListeAnnee');
        $listReleves->request("SELECT DISTINCT substr( dateOperation, 1, 4 ) as annee FROM operation WHERE nocompte = '$numeroCompte' order by annee asc");
        $p_contexte->addDataBlockRow($listReleves);
		
		$lisFlux = new ListDynamicObject('ListeFlux');
        $lisFlux->request("select distinct fluxid, flux from flux where compteId='$numeroCompte' order by flux ASC");
        $p_contexte->addDataBlockRow($lisFlux);
		
    }
	
	public function statCumul(ContextExecution $p_contexte) {
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        
		$premiereAnnee = $p_contexte->m_dataRequest->getData('premiereAnnee');
        $derniereAnnee = '';
        if ($p_contexte->m_dataRequest->getData('derniereAnnee') == null) {
            $derniereAnnee = $premiereAnnee.'-12-31';
        } else {
            $derniereAnnee = $p_contexte->m_dataRequest->getData('derniereAnnee').'-12-31';
        }
        $premiereAnnee.='-01-01';
		
		$fluxAjax = $p_contexte->m_dataRequest->getData('listeFlux');
		$this->logger->debug('liste ajax: '. $fluxAjax);
		
        //requ�te des montants par flux/mois
        /*$requeteAsso = 'SELECT SUM( montant) AS total , fluxId, \'$parent->annee\' AS periode
					FROM operation 
					WHERE nocompte=' . $numeroCompte . ' and date like concat(\'$parent->annee\',\'%\') GROUP BY fluxid';*/
        $requeteAsso = 'SELECT fluxId,  fluxMaitre, sum(total) as total
					FROM 
					WHERE nocompte=\'' . $numeroCompte . '\' and mois BETWEEN \''. $premiereAnnee .'\' AND \'' . $derniereAnnee . '\'  
					GROUP BY fluxid, fluxMaitre';
					//and fluxId IN ('.$fluxAjax.') 
					
        $listMontantFlux = new ListDynamicObject('ListeMontantFlux');
        $listMontantFlux->setAssociatedRequest(null, $requeteAsso);
		
        $l_requete = "SELECT CONCAT('$premiereAnnee', '_', '$derniereAnnee') AS annee";
		$listeReleves = new ListDynamicObject('ListeAnnees');
        $listeReleves->setAssociatedKey($listMontantFlux);
        //$listeReleves->setAssociatedKey($listMontantTotaux);
        //$listeReleves->setAssociatedKey($listMontantEpargne);
        $listeReleves->request($l_requete);
        $p_contexte->addDataBlockRow($listeReleves);

		
		$requeteMontantFils='SELECT sum(montant) AS total, fluxId
						FROM operation 
						WHERE operation.nocompte=\''.$numeroCompte.'\' and fluxId=$parent->fluxId
						AND dateOperation  between \''.$premiereAnnee.'\' and \''.$derniereAnnee.'\''; // and fluxId IN ('.$fluxAjax.')';
		$montantFluxFils = new ListDynamicObject('MontantFluxFils');
		$montantFluxFils->setAssociatedRequest(null, $requeteMontantFils);
		
		
		//flux fils
		$requeteFlux = "SELECT fluxId, flux FROM flux WHERE compteId='$numeroCompte'". ' AND fluxMaitreId=$parent->fluxId ORDER BY flux';
		$listFluxFils = new ListDynamicObject('ListeFluxFils');
		$listFluxFils->setAssociatedKey($montantFluxFils);
        $listFluxFils->setAssociatedRequest(null, $requeteFlux);
		
        //liste des flux
        $listeFlux = new ListDynamicObject('ListeFlux');
		$listeFlux->setAssociatedKey($listFluxFils);
        $listeFlux->request("SELECT DISTINCT flux.fluxId, flux, operationRecurrente , flux.fluxMaitre FROM stat_flux 
						LEFT JOIN flux ON flux.fluxId = stat_flux.fluxId 
                                                WHERE concat(mois, '-15') between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' ORDER BY flux");
												//and flux.fluxId IN ($fluxAjax) 
                                                //WHERE date between '$premiereAnnee' and '$derniereAnnee' and nocompte='$numeroCompte' ORDER BY flux");
        $p_contexte->addDataBlockRow($listeFlux);
        
    }
	 
}