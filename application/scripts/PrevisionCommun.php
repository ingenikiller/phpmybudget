<?php
/**
 * Description of PrevisionCommun
 *
 * @author ingeni
 */
class PrevisionCommun {
    
    /**
     * Génère les prévisions
     * @param $entete entête de rattachement
     * @param $identete
     * @param $periodicite périodicité des prévisions
     * @param $decalage décalage au début de la période
     * @param $montant montant de la prévision
     */
    public static function genereLignes(Prevision $entete, $identete, $periodicite, $decalage, $montant){
        $mois=$decalage;
        while( $mois <= 12) {
            $periode = $entete->annee * 100 + $mois;
            
            $prevision = new Prevision();
            $prevision->identete = $identete;
            $prevision->fluxId=$entete->fluxId;
            $prevision->typenr='L';
            $prevision->mois=$periode;
            $prevision->montant=$montant;
            $prevision->create();
            
            //decalage
            $mois+=$periodicite;
        }
    }
}

?>