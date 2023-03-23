<?php

class ContextExecution {
	
	public $m_objet;
	
	public $m_dataRequest;
	
	public $m_dataResponse=array();
	
	private $m_connexion=null;
	
	private $m_user=null;
	
	private $membre=null;
	
	
	//titre de la page
	private $m_titrePage;

	public $m_messages = null;
	public $m_erreurs = null;
	
	/**
	 * constructeur
	 */
	public function __construct(){
		$this->m_dataRequest = new DataRequest();
		//titre par défaut
		$this->m_titrePage = "";//"PhpMyBudget";
	}
	
	/**
	 * Accès à l'utilisateur identifié
	 * @param Users $p_user
	 */
	public function setUser($p_user){
		$this->m_user = $p_user;
	}
	public function getUser(){
		return $this->m_user;
	}
	
	public function setMembre($p_membre){
		$this->membre = $p_membre;
	}
	public function getMembre(){
		return $this->membre;
	}
	
	/**
	 * Ajoute un message
	 * @param message à ajouter
	 */
	public function addMessage($p_message) {
		if($this->m_messages==NULL){
			$this->m_messages=array();
		}
		$this->m_messages[count($this->m_messages)] = $p_message;
	}
	
	public function addError($p_message) {
		if($this->m_erreurs==NULL){
			$this->m_erreurs=array();
		}
		$this->m_erreurs[count($this->m_erreurs)] = $p_message;
	}
	
	public function addDataBlockRow($p_blockRow) {
		$this->m_dataResponse[] = $p_blockRow;
	}

	/**
	 * Acc�s au titre de la page
	 */
	public function getTitrePage(){
		return $this->m_titrePage;
	}

	public function setTitrePage($p_titrePage){
		$this->m_titrePage = $p_titrePage;
	}
	
	public function ajoutReponseAjaxOK() {
		$reponse = new ReponseAjax();
		$reponse->status='OK';
		$this->addDataBlockRow($reponse);
	}

}
?>