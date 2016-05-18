<?php

class AuthentificateurStandard {

	public function __construct() {
	
	}

	/*public function getLoginSession() {
		if(isset($_SESSION['login'])) {
			return $_SESSION['login'];
		}
		
		return null;;
	}*/
	
	public function authenticate($p_contexte){
		if(!isset($_SESSION['userid'])){
			Logger::getInstance()->addLogMessage('Session non ouverte!');
			throw new exception('Session non ouverte');
		} else {
			$userid = $_SESSION['userid'];
		}
		Logger::getInstance()->addLogMessage('appel authenticate'. ' avec ' . $userid);

		$user = new Users();
		$user->userId = $_SESSION['userid'];
		$user->load();
		$p_contexte->setUser($user);
	}
}

?>