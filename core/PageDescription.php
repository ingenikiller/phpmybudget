<?php

class PageDescription {

    private $m_nomClasse = '';
    private $m_privee;
    
	private $m_domaine = null;
	private $m_service = null;
	
	private $m_classe = null;
	private $m_methode = null;
	
    private $m_paramFlow = null;
    private $m_render = null;

    public function paramFlow($flow) {
        $this->m_paramFlow = $flow;
    }

    private $m_xsl;
	
	private $logger;
	
    public function __construct($p_domaine, $p_service, $p_nomClasse, $p_methode, $p_privee) {
		$this->logger = Logger::getRootLogger();
        $this->m_domaine = $p_domaine;
        $this->m_service = $p_service;
        $this->m_nomClasse = $p_nomClasse;
        $this->m_methode = $p_methode;
        $this->m_privee = $p_privee;
    }

    public function getNom() {
        return $this->m_nomClasse;
    }

    public function isPrivee() {
        return $this->m_privee == 'true' ? 1 : 0;
    }

    public function setPrivee($privee) {
        $this->m_privee = $privee;
    }
    
    public function setRender($render){
        $this->m_render=$render;
    }
	
	public function getRender(){
        return $this->m_render;
    }
	
	public function setClasse($classe){
        $this->m_classe=$classe;
    }

    /**
     * 
     * Enter description here ...
     * @param ContextExecution $p_contexte
     */
    public function execute(ContextExecution $p_contexte) {
        $this->logger->debug('Domaine:' . $this->m_domaine);
        $this->logger->debug('Service:' . $this->m_service);
        $this->logger->debug('Classe:' . $this->m_nomClasse);
        $this->logger->debug('Methode:' . $this->m_methode);

        try {
            $service = new $this->m_nomClasse;
			$methode = $this->m_methode.'';
			$service->$methode($p_contexte);
        } catch (FunctionnalException $fe) {
			$this->logger->debug('functional');
            $p_contexte->addError($fe->getMessage());
        }
        //lance l'affichage si le rendu est xsl
        if($this->m_render==null || $this->m_render=='xsl'){
            $this->parse($p_contexte);
        } else if($this->m_render=='json'){
            echo json_encode($p_contexte->m_dataResponse);
        } else {
			$parser = new ParserJson2();
			echo $parser->parse($p_contexte);
		}
    }

    public function setXslFile($p_xslFile) {
        $this->m_xsl = $p_xslFile;
    }

    private function addBlock($p_noeud, $p_data) {
        $p_noeud->addAttribute('total', count($p_data));
        foreach ($p_data as $key => $value) {
            if ($key == 'associatedObjet') {
                if (count($value) != 0) {
                    $asso = $p_noeud->addChild('associatedObjet');
                    foreach($value as $key2 => $data) {
                        $this->parseListObject($asso, $data);
                    }
                }
            } else if (is_array($value)){
                $this->logger->debug('addBlock tableau');
                $tab = $p_noeud->addChild($key);
                $this->parseData($tab, $value);
            } else {
                $p_noeud->addChild($key, htmlspecialchars($value));
            }
        }
    }

    private function addBlockForce($p_noeud, $p_data, $force) {
        $p_noeud->addAttribute('total', count($p_data));
        foreach ($p_data as $key => $value) {
            $p_noeud->addChild($force, $value);
        }
    }

    /**
     * 
     * Enter description here ...
     * @param unknown_type $p_noeud
     * @param unknown_type $p_tabDataRow
     */
    public function parseData($p_noeud, $p_tabDataRow) {
        $this->logger->debug('parse data');
        foreach ($p_tabDataRow as $key => $dataRow) {
            if ($dataRow instanceof IList) {
                //$this->logger->debug('List:' . $dataRow->name);
				$this->parseListObject($p_noeud, $dataRow);
            } else if ($dataRow instanceof SavableObject) {
                //$this->logger->debug('parseobjet: ');
                $group = $p_noeud->addChild($dataRow->getName());
                $this->addBlock($group, $dataRow->fetchPublicMembers());
            } else if (is_array($dataRow)) {
                //$this->logger->debug('traite tableau');
                $this->addBlockRow($p_noeud, $dataRow);
            } else if ($dataRow instanceof ReponseAjax) {
                $tab = array();
                $reflect = new ReflectionObject($dataRow);
                $group = $p_noeud->addChild($dataRow->getName());
                foreach ($reflect->getProperties(ReflectionProperty::IS_PUBLIC) as $var) {
                    $tab[$var->getName()] = $dataRow->{$var->getName()};
                }
                $this->addBlock($group, $tab);
            } else {
                //$this->logger->debug('parse ligne');
                $ligne = $p_noeud->addChild($key, $dataRow);
            }
        }
    }

    /**
     *
     * @param type $p_noeud
     * @param ListObject $liste 
     */
    private function parseListObject($p_noeud, IList $liste) {
        $noeudListe = $p_noeud->addChild($liste->getName());
        $noeudListe->addAttribute('totalPage', $liste->totalPage);
        $noeudListe->addAttribute('total', $liste->getNbLine());
        $index = 1;
        foreach ($liste->getData() as $indice => $object) {
            //classe dynamique
            if ($object instanceof stdClass) {
                $group = $noeudListe->addChild('Dynamic');
                $group->addAttribute('index', $indice);
                //$this->addBlock($group, $object->fetchPublicMembers());
                $tab = array();
                $reflect = new ReflectionObject($object);
                foreach ($reflect->getProperties(ReflectionProperty::IS_PUBLIC) as $var) {
                    $tab[$var->getName()] = $object->{$var->getName()};
                }
                $this->addBlock($group, $tab);
            } else {
                $group = $noeudListe->addChild($object->getName());
                $group->addAttribute('index', $index++);
                $this->addBlock($group, $object->fetchPublicMembers());
            }
        }
    }

    /**
     * 
     * Enter description here ...
     * @param unknown_type $p_noeud
     * @param unknown_type $p_dataRow
     */
    private function addBlockRow($p_noeud, $p_dataRow) {
        $group = $p_noeud->addChild($p_dataRow->m_name);
        $group->addAttribute('total', count($p_dataRow->getData()));
        //on parcourt les différents enregistrements
        foreach ($p_dataRow->getData() as $key => $row) {
            $element = $group->addChild($p_dataRow->m_nameElement);
            $element->addAttribute('index', $key);
            //pour chaque champ
            foreach ($row as $l => $value) {
                $element->addChild($l, utf8_encode($value));
            }
        }
    }

    /**
     * 
     * Enter description here ...
     * @param unknown_type $p_noeud
     */
    private function addFluxParametrage($p_noeud) {
        $param = $p_noeud->addChild('paramFlow');
        if ($this->m_paramFlow != null) {
            $tab = explode(',', $this->m_paramFlow);
            foreach ($tab as $value) {
                //$this->logger->debug('flux:' . $value);
                $segment = new ListObject();
                $segment->name = $value;
                $segment->request('Segment', "cleseg='$value' order by numord");
                $this->parseListObject($param, $segment);
            }
        }
    }

    /**
     * Fonction de génération du flux xml
     * @param ContextExecution $p_contexte
     */
    public function parse(ContextExecution $p_contexte) {
        $this->logger->debug('xsl:' . $this->m_xsl);

        //création flux xml
        $doc = new SimpleXMLElement('<?xml version="1.0" encoding="ISO-8859-1"?><root></root>');

        //traitement de la requête html
        $request = $doc->addChild('request');
        $this->addBlock($request, $p_contexte->m_dataRequest->getDataTab());
        
        //date
        $baliseDate = $doc->addChild('date', date('Y-m-d'));

        //titre
        $doc->addChild('titre', $p_contexte->getTitrePage());

        //traitement des messages et erreurs
        $dial = $doc->addChild('dial');
        $messages = $dial->addChild('messages');
        if ($p_contexte->m_messages != NULL) {
            $this->addBlockForce($messages, $p_contexte->m_messages, 'message');
        }
        if ($p_contexte->m_erreurs != NULL) {
            $this->addBlockForce($messages, $p_contexte->m_erreurs, 'erreur');
        }

        //partie utilisateur
        $user = $doc->addChild('user');
        if ($p_contexte->getUser() != null) {
            $this->addBlock($user, $p_contexte->getUser()->fetchPublicMembers());
        }

        //flux paramétrage
        $this->addFluxParametrage($doc);

        //données
        $data = $doc->addChild('data');
        $this->parseData($data, $p_contexte->m_dataResponse);


        $xsl = new DOMDocument;
        $xsl->load('./application/' . $this->m_xsl);

        //instanciation xsl processor
        $proc = new XSLTProcessor;
        $proc->importStyleSheet($xsl); // attachement des règles xsl
        $proc->registerPHPFunctions();
        $fp = fopen('./logs/' . $this->m_nomClasse .'-'. $this->m_methode . '.xml', "w");
        fwrite($fp, @$doc->asXML());
        fclose($fp);
        //header( 'content-type: text/html; charset=ISO-8859-1' );
        //header( 'content-type: text/html' );
        //echo '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';
        echo $proc->transformToXML($doc);
    }
}
?>