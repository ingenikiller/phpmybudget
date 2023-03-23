<?php
//namespace core;
// http://localhost/phpmybudget/index.php?domaine=prevision&service=getlisteannee2&edition=edition&periode=2021&numeroCompte=90063454011&flagPinel=complet
// http://json.parser.online.fr/
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Statement
 *
 * @author ingeni
 */
final class ParserJson 
{
    protected $logger=null;
	
    public function __construct() {
 		$this->logger = Logger::getRootLogger();
    }
	
	private function addBlock($p_data) {
		$tab=array();
		
        foreach ($p_data as $key => $value) {
            if ($key == 'associatedObjet') {
                if (count($value) != 0) {
					foreach($value as $data) {
                    	$tab[]=$this->parseListObject($data);
                    }
				}
            } else if (is_array($value)){
            } else {
                $tab[]="\"$key\":".'"'.htmlspecialchars($value).'"';
            }
        }
		return '{'.implode($tab,',').'}';
    }

    /**
     * 
     * Enter description here ...
     * @param array $p_tabDataRow
     */
    public function parseData($p_tabDataRow) {
        $this->logger->debug('parse data');
		$json='"racine":{';
		$tab=array();
        foreach ($p_tabDataRow as $dataRow) {
            if ($dataRow instanceof IList) {
                $tab[]=$this->parseListObject($dataRow);
            } else if ($dataRow instanceof SavableObject) {
                $tab[]='"'.$dataRow->getName().'":'.$this->addBlock($dataRow->fetchPublicMembers());
            } else if (is_array($dataRow)) {
                $this->logger->debug('traite tableau');
				$tab[]=$this->addBlockRow($dataRow);
            } else if ($dataRow instanceof ReponseAjax) {
                $tabReponse=array();
				$reflect = new ReflectionObject($dataRow);
				foreach ($reflect->getProperties(ReflectionProperty::IS_PUBLIC) as $var) {
                    $tabReponse[] = '"'.$var->getName().'":"'.$dataRow->{$var->getName()}.'"';
                }
				$tab[]=implode($tabReponse,',');
            } else {
                //$ligne = $p_noeud->addChild($key, $dataRow);
            }
        }
		return $json.implode($tab,',').'}';
    }

    /**
     *
     * @param ListObject $liste 
     */
    private function parseListObject(IList $liste) {
        $chaine='"'.$liste->getName().'":{';
		$chaine.='"totalPage":"'.$liste->getTotalPage().'",';
		$chaine.='"totalLigne":"'.$liste->getNbLineTotal().'",';
		$chaine.='"page":"'.$liste->getPage().'",';
		$chaine.='"data":[';
		$tab=array();
        foreach ($liste->getData() as $object) {
            //classe dynamique
            if ($object instanceof stdClass) {
                $tabData = array();
				$reflect = new ReflectionObject($object);
                foreach ($reflect->getProperties(ReflectionProperty::IS_PUBLIC) as $var) {
                    $tabData[$var->getName()] = $object->{$var->getName()};
                }
				$tab[]=$this->addBlock($tabData);
            } else {
                $tab[]=$this->addBlock($object->fetchPublicMembers());
            }
        }
		
		return $chaine.implode($tab,',').']}';
    }

    /**
     * 
     * Enter description here ...
     * @param array $p_dataRow
     */
    private function addBlockRow($p_dataRow) {
        $tab=array();
        foreach ($p_dataRow as $key => $row) {
			$tab[]="\"$key\":\"$row\"";
        }
		return implode($tab,',');
    }

    /**
     * Fonction de génération du flux xml
     * @param ContextExecution $p_contexte
     */
    public function parse(ContextExecution $p_contexte) {
        $json='{'.$this->parseData($p_contexte->m_dataResponse).'}';
		return $json;
    }
}
?>