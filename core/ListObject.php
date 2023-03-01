<?php
/**
 * Description of ListObject
 * Classe permettant de récupérer une liste d'objets persistents
 *
 * @author ingeni
 */
class ListObject extends ListStructure implements IList{
    
	
   	final public function __construct($name){
		parent::__construct();
		$this->logger = Logger::getRootLogger();
		$this->ligneParPage = LIGNE_PAR_PAGE;
		$this->name=$name;
	}
	
    public function requestNoPage($classe, $clause=null) {
        $l_suff = " FROM ".strtolower ($classe);
        if($clause!=null){
            $l_suff.=" WHERE $clause";
        }
        $this->logger->debug('search: '. $l_suff);
        
        //requete principale
        $l_requete = 'select * '.$l_suff;
        $this->logger->debug('search complete: '. $l_requete);
        $stmt = self::$_pdo->query($l_requete);
        $this->logger->debug('requete OK');
        $this->nbLine = $stmt->rowCount();
        $this->nbLineTotal = $stmt->rowCount();
        $this->totalPage = 1;
        $this->page = 1;
        $this->tabResult = $stmt->fetchAll(PDO::FETCH_CLASS, $classe);  
        
        //appel des requetes des objets associés
        $this->callAssoc();
    }
    
    /**
     *fonction lançant une requete SQL
     * @param string $classe nom de la classe
     * @param string $clause clause SQL de recherche
     * @param int $page numéro de page
     */
    public function request($classe, $clause=null, $page=0){
        
    	if($page==0){
    		return $this->requestNoPage($classe, $clause);
    	}
    	
    	$l_suff = " FROM ".strtolower ($classe);
        if($clause!=null){
            $l_suff.=" WHERE $clause";
        }
        $this->logger->debug('search: '. $l_suff);
        
        if($page==''){
            $page=1;
        }
        
        //requete de comptage
        $l_requete = "select count(*) as total $l_suff";
        $stmt = null;
		
		try {
            $stmt = self::$_pdo->query($l_requete);
        } catch (PDOException $e) {
            throw new TechnicalException($e);
        }
		
        $l_tab = $stmt->fetch(PDO::FETCH_ASSOC);
        $this->nbLineTotal = $l_tab['total'];
        //requete principale
        $l_requete = "select * $l_suff LIMIT " . ($page-1)*$this->ligneParPage . ', ' . $this->ligneParPage;
        $this->logger->debug('search complete: '. $l_requete);
        $stmt = self::$_pdo->query($l_requete);
        $this->logger->debug('requete OK');
        $this->nbLine = $stmt->rowCount();
        $this->tabResult = $stmt->fetchAll(PDO::FETCH_CLASS, $classe);   
        
        $this->totalPage = ceil($this->getNbLineTotal() / $this->ligneParPage);
        $this->page=$page;
		
        //appel des requetes des objets associés
        $this->callAssoc();
    }

}
?>