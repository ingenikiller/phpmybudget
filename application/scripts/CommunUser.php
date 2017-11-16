<?php 

class CommunUser {
	
	public static function getParameters(ContextExecution $p_contexte){
		//
		$tab = array();
		$tab['nom'] = $p_contexte->m_dataRequest->getData('nom');
		$tab['motDePasse'] = $p_contexte->m_dataRequest->getData('motDePasse');
		return $tab;
	}
	
	public static function getUserLogin($p_user, $p_mdp) {
		$l_requete = "SELECT * FROM users WHERE 
							nom='". $p_user ."' AND 
							motDePasse='". $p_mdp . "'";
		
		$list = new ListObject();
		$clause="nom='". $p_user ."' AND motDePasse='". $p_mdp . "'";
		$list->request('Users', $clause);
		/*if($list->nbLine!=1){
			throw new FunctionnalException('nom ou mot de passe incorrect');
		}*/
		if(isset($list->tabResult[0])){
			return $list->tabResult[0];			
		} else {
			return null;
		}
	}
	
	public static function getUser($p_connexion, $p_user) {
		$l_requete = "SELECT * FROM intervenants WHERE 
							intervenantid='$p_user'";
		//Logger::getInstance()->addLogMessage('requete:'.$l_requete);
		$l_result = $p_connexion->requeteBDD($l_requete);
		if($l_result == FALSE) {
			echo $p_connexion->getLastError();
		}
		
		if($p_connexion->nbRows($l_result) != 1) {
			throw new FunctionnalException('nom ou mot de passe incorrect');
			return null;
		}
		
		return $p_connexion->fetchArray($l_result);
	}
	
	/*public static function getListe(ContextExecution $p_contexte) {
		$l_connexion = $p_contexte->getConnexion();
		
		$l_requete = 'SELECT * FROM INTERVENANTS';
		Logger::getInstance()->addLogMessage('requete:' . $l_requete);
		$l_result = $l_connexion->requeteBDD($l_requete);
		$rowSet = new DataRowSet();
		$rowSet->addRows($l_connexion, $l_result, 'UtilisateursListe', 'Utilisateur');
		//print_r($rowSet);
		$p_contexte->addDataBlockRow($rowSet);
	}*/
	
	
	
}

?>