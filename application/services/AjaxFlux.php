<?php

namespace Application\Services;

use Core\ContextExecution;
use Application\Objects\Flux;

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
