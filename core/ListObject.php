<?php
/**
 * Description of ListObject
 * Classe permettant de récupérer une liste d'objets persistents
 *
 * @author ingeni
 */
class ListObject extends ListStructure implements IList{
    
    public $name='';

    public $tabResult=null;
    
    public $nbLineTotal;
    public $nbLine;
    
    public $totalPage;
    public $page;
    
	private $logger;
	
	final public function __construct(){
		parent::__construct();
		$this->logger = Logger::getRootLogger();
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
        
        $this->nbLine = $stmt->rowCount();
        $this->tabResult = $stmt->fetchAll(PDO::FETCH_CLASS, $classe);//, array(self::$_pdo, $table[1]));   
        
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
    	
    	$l_suff = " FROM $classe";
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
        $l_requete = "select * $l_suff LIMIT " . ($page-1)*LIGNE_PAR_PAGE . ', ' . LIGNE_PAR_PAGE;
        $this->logger->debug('search complete: '. $l_requete);
        $stmt = self::$_pdo->query($l_requete);
        
        $this->nbLine = $stmt->rowCount();
        $this->tabResult = $stmt->fetchAll(PDO::FETCH_CLASS, $classe);//, array(self::$_pdo, $table[1]));   
        
        $this->totalPage = ceil($this->getNbLineTotal() / LIGNE_PAR_PAGE);
        $this->page=$page;
        //appel des requetes des objets associés
        $this->callAssoc();
        
         //return $this;
    }

    public function getNbRows() {
        return count($this->tabResult);
    }
    
    public function getName() {
        return $this->name;
    }
    
    public function getData(){
        return $this->tabResult;
    }
    
    public function getNbLineTotal(){
        return $this->nbLineTotal;
    }
    
    public function getNbLine(){
        return $this->nbLine;
    }
}
?>
