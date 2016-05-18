<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of GenrateurService
 *
 * @author ingeni
 */
class GenerateurService {
    //put your code here
    
    public function create(ContextExecution $p_contexte){
        $l_generateur = new GenerateurClasse();
        $l_generateur->generer();
    }
    
}

?>
