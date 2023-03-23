<?php

/**
 * Description of ListDynamicObject
 *
 * @author ingeni
 */
class ListDynamicObject extends ListStructure implements IList{
    
    final public function __construct($name){
		parent::__construct();
		$this->name=$name;
		$this->logger = Logger::getRootLogger();
		$this->ligneParPage = LIGNE_PAR_PAGE;
	}
        
    /**
     * fonction de requ�tage
     * @param string $st1 requ�te
     * @param integer $st2 numero de page
     * @param object $st3 inutilis�e
     */
    public function request($p_requete, $p_numPage=null, $dummy=null){
        $this->logger->debug('requete dynamique origine:'.$p_requete);
        
        if($p_numPage!=null){
			$stmt = null;
			try{
				$stmt = self::$_pdo->query($p_requete);
			} catch (Exception $e) {
				throw new TechnicalException($e);
			}
			
        	//$l_tab = $stmt->fetch(PDO::FETCH_ASSOC);
        	$this->nbLineTotal = $stmt->rowCount();
        	
        	
        	$p_requete .= " LIMIT " . ($p_numPage-1)*$this->ligneParPage . ', ' . $this->ligneParPage;        	
        }
        
        $this->logger->debug('requete dynamique finale:'.$p_requete);
		$stmt=null;
        try{
			$stmt = self::$_pdo->query($p_requete);
		} catch (Exception $e) {
			throw new TechnicalException($e);
		}
		$this->logger->debug('requete OK');
        $this->nbLine = $stmt->rowCount();
        $stmt->setFetchMode(PDO::FETCH_INTO, $this);
        $this->tabResult = $stmt->fetchAll(PDO::FETCH_OBJ);
        if($p_numPage==null){
			$this->nbLineTotal = count($this->tabResult);
		}
        $this->totalPage = ceil($this->nbLineTotal / $this->ligneParPage);
        $this->page=($p_numPage==null)? 1 : $p_numPage;
        
        //ex�cute les requ�tes associ�es
        $this->callAssoc();
    }

}
?>