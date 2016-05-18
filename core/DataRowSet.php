<?php 

class DataRowSet{
	
	private $tabData;
	
	public $m_name;
	public $m_nameElement;
	
	public $m_rowCount=0;
	public $m_totalRowCount=0;
	public $m_page=0;
	public $m_nbPage=0;
	
	public function __construct(){
		
	}
	/**
	 * 
	 * ajout de données
	 * @param classe_bdd $p_connexion
	 * @param unknown_type $p_rows
	 * @param unknown_type $p_name
	 * @param unknown_type $p_nameElement
	 */
	public function addRows(classe_bdd $p_connexion, $p_rows, $p_name, $p_nameElement){
		Logger::getInstance()->addLogMessage('Instanciation DataRowSet:' . $p_name);
		$this->m_name = $p_name;
		$this->m_nameElement = $p_nameElement;
		$this->tabData=array();
		$i=1;
		$l_result=null;
		while($l_result = $p_connexion->fetchArray($p_rows)){
			
			$this->tabData[$i]=$l_result;
			$i++;
		}
	}
	
	/**
	 * 
	 * Enter description here ...
	 * @param array $p_tab
	 * @param unknown_type $p_name
	 * @param unknown_type $p_nameElement
	 */
	public function addTab(array $p_tab, $p_name, $p_nameElement){
		$this->m_name = $p_name;
		$this->m_nameElement = $p_nameElement;
		$this->tabData=array();
		$this->tabData[1]=$p_tab;
	}
	
	/**
	 * 
	 * Enter description here ...
	 */
	public function getData() {
		return $this->tabData;
	}
	
	
	
	
}

?>
