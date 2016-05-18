<?php

class GestionSegmentService extends ServiceStub {
	
	public function getSegment(ContextExecution $p_contexte) {
        $cleseg=$p_contexte->m_dataRequest->getData('cleseg');
        if($cleseg!=null){
            $liste = new ListObject();
            $liste->name ='Segments';
            $liste->request('Segment', "cleseg='$cleseg' order by numord");
            $p_contexte->addDataBlockRow($liste);
        }else {
            $liste = new ListObject();
            $liste->name ='Segments';
            $liste->request('Segment', "cleseg='CONF' order by codseg");
            $p_contexte->addDataBlockRow($liste);
        }
    }
	
	
	public function getOne(ContextExecution $p_contexte) {
		$cleseg=$p_contexte->m_dataRequest->getData('cleseg');
		$codseg=$p_contexte->m_dataRequest->getData('codseg');
		
		$segment = new Segment();
		$segment->cleseg = $cleseg;
		$segment->codseg = $codseg;
		$segment->load();
		$p_contexte->addDataBlockRow($segment);
	}
	
	public function create(ContextExecution $p_contexte){
        $segment = new Segment();
        $segment->fieldObject($p_contexte->m_dataRequest);
        $segment->create();
        $reponse = new ReponseAjax();
        $reponse->status='OK';
        $p_contexte->addDataBlockRow($reponse);
    }
	
	public function update(ContextExecution $p_contexte){
        $cleseg=$p_contexte->m_dataRequest->getData('cleseg');
        $codseg=$p_contexte->m_dataRequest->getData('codseg');
        $segment = new Segment();
        $segment->cleseg=$cleseg;
        $segment->codseg=$codseg;
        $segment->load();
        $segment->fieldObject($p_contexte->m_dataRequest);
        $segment->update();
        
        $reponse= new ReponseAjax();
        $reponse->status='OK';
        $p_contexte->addDataBlockRow($reponse);
    }
	
}

?>