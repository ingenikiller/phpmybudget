<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of AjaxFlux
 *
 * @author ingeni
 */
class AjaxFlux {
    //put your code here
    public function display(ContextExecution $p_contexte){
        $fludid = $p_contexte->m_dataRequest->getData('fluxId');
        $flux = new Flux();
        $flux->fluxId = $fludid;
        $flux->load();
        
        $p_contexte->addDataBlockRow($flux);
    }
}

?>
