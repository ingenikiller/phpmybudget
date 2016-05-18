<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of PeriodeCommun
 *
 * @author ingeni
 */
class PeriodeCommun {
    //put your code here
    
    public static function initialiserPeriodeMois($p_annee){
        //
        for($i=1; $i<=12; $i++) {
            $dernierjour = cal_days_in_month(CAL_GREGORIAN, $i, $p_annee);
            //$dernierjour='28';
            $deb = mktime(0, 0, 0, $i, 1, $p_annee);
            $fin = mktime(0, 0, 0, $i, $dernierjour, $p_annee);
            $periode = new Periode();
            $periode->periode=date('Y-m', $deb);
            $periode->annee = $p_annee;
            $periode->mois = date('m', $deb);;
            $periode->debut = date('Y-m-d', $deb);
            $periode->fin = date('Y-m-d', $fin);
            $periode->create();
        }
    }
    
}

?>
