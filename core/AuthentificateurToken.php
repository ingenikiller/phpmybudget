<?php

namespace Core;

use Exception;
use Application\Objects\Tokensession;
use Application\Objects\Users;
use Application\Scripts\TokenCommun;


class AuthentificateurToken {

	private $logger;
	
	public function __construct() {
		$this->logger = MyLogger::getInstance();
	}
	
	public function authenticate($p_contexte){
		//récupération du token dans la requête
		$tokenid = $p_contexte->m_dataRequest->getData('token');
		
		//suppression des token expirés
		TokenCommun::suppToken();
		$this->logger->debug('appel token authenticate');
		//récupération du token
		$token = new Tokensession();
		$token->token = $tokenid;
		$token->load();
		
		if( $token->userid !=null ) {
			$_SESSION['userid']=$token->userid;
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
			//throw new Exception(Constantes::SESSION_CLOSE, 'Session close');
			throw new Exception('SESSION_CLOSE');
		}
	}
}
?>