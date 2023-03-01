<?php

class AuthentificateurToken {

	private $logger;
	
	public function __construct() {
		$this->logger = Logger::getRootLogger();
	}
	
	public function authenticate($p_contexte){
		//récupération du token dans la requête
		$tokenid = $p_contexte->m_dataRequest->getData('token');
		
		//suppression des token expirés
		TokenCommun::suppToken();
		
		//récupération du token
		$token = new Tokensession();
		$token->token = $tokenid;
		$token->load();
		
		if( $token->userid !=null ) {
			//mise à jour de la date
			$token->startdate='now()';
			//sauvegarde
			$token->update();
			//récupération du user
			$user = new Users();
			$user->userId = $token->userid;
			$user->load();
			$p_contexte->setUser($user);
		} else {
			throw new FunctionalException(Constantes::SESSION_CLOSE, 'Session close');
		}
	}
}
?>