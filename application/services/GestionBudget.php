<?php

class GestionBudget extends ServiceStub{

    public function getPage(ContextExecution $p_contexte){
		$numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
		$p_contexte->setTitrePage("Budget compte " . $numeroCompte);

        $requete = 'SELECT DISTINCT annee from periode WHERE TRIM(annee) IS NOT NULL ORDER BY annee DESC limit 0,6';
		$listeAnnees = new ListDynamicObject();
        $listeAnnees->name = 'ListeAnnees';
        $listeAnnees->request($requete);
        $p_contexte->addDataBlockRow($listeAnnees);
	}

    /**
	 * 
	 */
	public function getListe(ContextExecution $p_contexte){
		$userid = $p_contexte->getUser()->userId;
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        $annee = $p_contexte->m_dataRequest->getData('annee');

        $recFlux="select f.fluxid, f.flux
        from flux f
        join lignebudget l on l.userid =f.userId and l.compteid = f.compteId and l.annee ='2022' and l.fluxid =f.fluxId 
        where f.userid='2' and f.compteId ='$numeroCompte' 
        order by f.flux";

        $anneeBase=$annee-3;
        $recAnnees="select distinct periode.annee, sum(operation.montant) as total
        from 
        (SELECT substring('$anneeBase-01-01' + INTERVAL seq YEAR,1,4) as annee FROM seq_1_to_3) periode
        left join operation on substring(operation.dateOperation,1,4) =periode.annee and operation.noCompte='$numeroCompte' and operation.fluxId=".'\'$parent->fluxid\''."
        group by periode.annee";
        $listeAnnees = new ListDynamicObject();
        $listeAnnees->name = 'ListeAnnees';
        
		$listeAnnees->setAssociatedRequest(null, $recAnnees);

        $recActuelle="select * from lignebudget l where compteid ='$numeroCompte' and annee ='$annee' and fluxid =".'\'$parent->fluxid\'';
        $listeActuelle = new ListDynamicObject();
        $listeActuelle->name = 'ListeActuelle';
		$listeActuelle->setAssociatedRequest(null, $recActuelle);
        
        $listeFlux = new ListDynamicObject();
        $listeFlux->name = 'ListeFlux';
        $listeFlux->setAssociatedKey($listeAnnees);
        $listeFlux->setAssociatedKey($listeActuelle);
        $listeFlux->request($recFlux);        
        $p_contexte->addDataBlockRow($listeFlux);
    }

    public function getListeFluxNonTraites(ContextExecution $p_contexte){
        $userid = $p_contexte->getUser()->userId;
        $numeroCompte = $p_contexte->m_dataRequest->getData('numeroCompte');
        $annee = $p_contexte->m_dataRequest->getData('annee');
        $anneePrecedente = $annee - 1;
        $requete="select f.fluxid, f.flux , sum(o.montant) as montant
        from flux f
        join operation o on o.noCompte = f.compteId and o.fluxId =f.fluxId and o.dateOperation like '$anneePrecedente%' 
        left join lignebudget l on l.userid =f.userId and l.compteid = f.compteId and l.annee ='$annee' and l.fluxid =f.fluxId
        where f.userid='$userid' and f.compteId ='$numeroCompte' and l.fluxid is null
        group by f.fluxId, f.flux 
        order by f.flux ";

        $listeFlux = new ListDynamicObject();
        $listeFlux->name = 'listeFluxNonBudgetes';
        $listeFlux->request($requete);
        $p_contexte->addDataBlockRow($listeFlux);
    }

    public function create(ContextExecution $p_contexte){
        $ligne = new LigneBudget();
        $ligne->userid=$p_contexte->getUser()->userId;
        $ligne->annee=$p_contexte->m_dataRequest->getData('annee');
        $ligne->compteid=$p_contexte->m_dataRequest->getData('numeroCompte');
        $ligne->fluxid=$p_contexte->m_dataRequest->getData('fluxId');
        $ligne->montant=$p_contexte->m_dataRequest->getData('montant');

        $ligne->create();

        $p_contexte->ajoutReponseAjaxOK();
    }

    public function getOne(ContextExecution $p_contexte){
        $ligne = new LigneBudget();
        $ligne->lignebudgetid=$p_contexte->m_dataRequest->getData('lignebudgetid');
        $ligne->load();
        

        

        $p_contexte->addDataBlockRow($ligne);
    }

    public function update(ContextExecution $p_contexte){
        $ligne = new LigneBudget();
        $ligne->lignebudgetid=$p_contexte->m_dataRequest->getData('lignebudgetid');
        $ligne->load();
        $ligne->montant=$p_contexte->m_dataRequest->getData('montant');

        $ligne->update();

        $p_contexte->ajoutReponseAjaxOK();
    }
}
?>