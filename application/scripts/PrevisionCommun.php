<?php
namespace Application\Scripts;

use Application\Objects\Prevision;
use Core\ListDynamicObject;

class PrevisionCommun {
    
    /**
     * Génère les prévisions
     * @param $entete Prevision entête de rattachement
     * @param $identete
     * @param $periodicite string périodicité des prévisions
     * @param $decalage integer décalage au début de la période
     * @param $montant number montant de la prévision
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
    
    /**
     * 
     * @param number $fluxId
     * @param string $annee
     * @param string $mois
     */
    public static function existeLignes($noCompte, $fluxId, $annee, $mois) {
        //sélection des lignes de prévisions dont le mois est dans la liste des mois
        $smois = "'".implode("','", $mois)."'";
        
        $requete="SELECT count(1) AS total FROM prevision WHERE noCompte='$noCompte' AND fluxId='$fluxId' and annee='$annee' and mois IN ($smois)";
        $list = new ListDynamicObject('liste');
        $list->request($requete);
        $data = $list->getData();
        return $data[0]->total;
    }
}

?>