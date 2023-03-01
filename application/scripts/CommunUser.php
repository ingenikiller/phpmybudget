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
		
		$list = new ListObject('User');
		$clause="nom='". $p_user ."' AND motDePasse='". $p_mdp . "'";
		$list->request('Users', $clause);
		
		Logger::getRootLogger()->debug('nb login:' . $list->getNbLine());
		if($list->getNbLine()==1){
			return $list->getData()[0];			
		} else {
			return null;
		}
	}
	
	public static function getUser($p_connexion, $p_user) {
		$l_requete = "SELECT * FROM intervenants WHERE 
							intervenantid='$p_user'";
		
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
	

	
	
	
}

?>