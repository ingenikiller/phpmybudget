<?php

/**
 * Description of OperationCommun
 *
 * @author ingeni
 *
 */
class OperationCommun {

	/**
	 * Recherche une op�ration fille
	 * @param unknown_type $flux
	 * @param unknown_type $p_operation
	 */
	public static function rechercherOperationLiee($flux, $p_operation){
		$logger = Logger::getRootLogger();
		
		$listOpe = new ListObject();
        $listOpe->name='ListeOperations';
        //recherche d'une op�ration ayant les r�f�rences de l'op�ration en cours
        $listOpe->request('Operation', "numeroCompteOri='$p_operation->noCompte' AND operationIdOri=$p_operation->operationId");
		$tab = $listOpe->tabResult;
        $logger->debug('Total ope '.count($tab));
        if($tab==null || count($tab)==0){
        	return null;
        } else {
        	return $tab[0];
        }
	}

	/**
     * Gestion d'une op�ration li�e pour les flux multi comptes
     */
    public static function operationLiee($p_operation){
        $logger = Logger::getRootLogger();
		
		//recherche de la conf du flux
        $l_flux = new Flux();
        $l_flux->fluxId = $p_operation->fluxId;
        $l_flux->load();
        //
        $logger->debug('Operationid '.$p_operation->operationId);

        //si le flux n'a pas de compte lié
        if($l_flux->compteDest =='') {
            //on recherche une op�ration li�e pour la supprimer ( cas du changement de flux)
        	$operation = self::rechercherOperationLiee($l_flux, $p_operation);
        	if($operation!=null){
        		$operation->delete();
        	}
            return true;
        } else {
            //le flux a un compte destination
            //ce compte est différent du compte en cours
        	if($l_flux->compteDest != $p_operation->noCompte) {
                $logger->debug('Operation liee');
                //recherche d'une op�arion existante
                $listOpe = new ListObject();
                $listOpe->name='ListeOperations';
                $listOpe->request('Operation', "operationIdOri=$p_operation->operationId");

                $tab = $listOpe->tabResult;
                $logger->debug('Total ope '.count($tab));
				//pas d'opération, on en crée une nouvelle
                if($tab==null || count($tab)==0) {
                    $logger->debug('Operation inexistante');
                    $l_operation = new Operation();
                    $l_operation->libelle = $p_operation->libelle;
                    $l_operation->date = $p_operation->date;
                    $l_operation->noCompte = $l_flux->compteDest;
                    $l_operation->fluxId = $p_operation->fluxId;
                    $l_operation->modePaiementId = $p_operation->modePaiementId;
                    $l_operation->montant = - $p_operation->montant;
                    $l_operation->verif = $p_operation->verif;
                    $l_operation->operationIdOri = $p_operation->operationId;
                    $l_operation->numeroCompteOri =  $p_operation->noCompte;
                    $l_operation->create();
                } else {
                    //operation existante
                    $logger->debug('Operation existante');
                    $logger->debug($p_operation->noCompte."----".$l_flux->compteDest);
                    //si l'opération est sur le compte destination, mise à jour
                    if($p_operation->noCompte==$l_flux->compteDest){
	                    $logger->debug('Operation meme compte');
	                    $l_operation = $tab[0];
	                    $l_operation->libelle = $p_operation->libelle;
	                    $l_operation->modePaiementId = $p_operation->modePaiementId;
	                    $l_operation->montant = - $p_operation->montant;
	                    $l_operation->verif = $p_operation->verif;
	                    $l_operation->update();
                    } else {
                    	//sinon, on modifie le num�ro de compte
                    	$logger->debug('Operation compte different');
                    	$l_operation = $tab[0];
	                    $l_operation->libelle = $p_operation->libelle;
	                    $l_operation->modePaiementId = $p_operation->modePaiementId;
	                    $l_operation->noCompte=$l_flux->compteDest;
	                    $l_operation->montant = - $p_operation->montant;
	                    $l_operation->verif = $p_operation->verif;
	                    $l_operation->update();
                    }
                }
            } else {
                if($l_flux->compteDest == $p_operation->noCompte){
                    //mise � jour de l'op�ration d'origine
                    $listOpeRec = new ListObject();
                    $listOpe->request('Operation', "noCompte='$l_flux->compteDest' AND noCompte='$p_operation->numeroCompteOri' AND operationId=$p_operation->operationIdOri");
                    $tab = $listOpeRec->tabResult;
                    $logger->debug('Total ope '.count($tab));
                    if($tab==null || count($tab)==0) {
                        $l_operation = $tab[0];
                        $l_operation->libelle = $p_operation->libelle;
                        $l_operation->modePaiementId = $p_operation->modePaiementId;
                        $l_operation->montant = - $p_operation->montant;
                        $l_operation->verif = $p_operation->verif;
                        $l_operation->update();
                    }
                } else {
                    return true;
                }
            }
        }
    }
}
?>
