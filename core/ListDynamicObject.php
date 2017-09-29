<?php

/**
 * Description of ListDynamicObject
 *
 * @author ingeni
 */
class ListDynamicObject extends ListStructure implements IList{
    
    
    public $name='';

    public $tabResult=null;
    
    public $nbLineTotal;
    public $nbLine;
    
    public $totalPage;
    public $page;
    
//    public function getData() {
//        return $this->tabData;
//    }
    
     /**
     * fonction de requêtage
     * @param unknown_type $st1 requête
     * @param unknown_type $st2 numero de page
     * @param unknown_type $st3 inutilisée
     */
    public function request($p_requete, $p_numPage=null, $dummy=null){
        Logger::getInstance()->addLogMessage('requete dynamique:'.$p_requete);
        
        if($p_numPage!=null){
			$stmt = null;
			try{
				$stmt = self::$_pdo->query($p_requete);
			} catch (Exception $e) {
				throw new TechnicalException($e);
			}
			
        	$l_tab = $stmt->fetch(PDO::FETCH_ASSOC);
        	$this->nbLineTotal = $stmt->rowCount();
        	
        	
        	$p_requete .= " LIMIT " . ($p_numPage-1)*LIGNE_PAR_PAGE . ', ' . LIGNE_PAR_PAGE;        	
        }
        
        Logger::getInstance()->addLogMessage('requete dynamique:'.$p_requete);
		$stmt=null;
        try{
			$stmt = self::$_pdo->query($p_requete);
		} catch (Exception $e) {
			throw new TechnicalException($e);
		}
        $this->nbLine = $stmt->rowCount();
        $stmt->setFetchMode(PDO::FETCH_INTO, $this);
        $this->tabResult = $stmt->fetchAll(PDO::FETCH_OBJ);
        if($p_numPage==null){
			$this->nbLineTotal = count($this->tabResult);
		}
        $this->totalPage = ceil($this->nbLineTotal / LIGNE_PAR_PAGE);
        $this->page=($p_numPage==null)? 1 : $p_numPage;
        
        //exécute les requêtes associées
        $this->callAssoc();
    }
    
    public function getName() {
        return $this->name;
    }
    
    /**
     * (non-PHPdoc)
     * @see IList::getData()
     */
    public function getData(){
        return $this->tabResult;
    }
    
    public function getNbLineTotal(){
        return $this->nbLineTotal;
    }
    
    public function getNbLine(){
        return count($this->tabResult);
    }
}
?>