<?php

class AuthentificateurStandard {

	private $logger;
	
	public function __construct() {
		$this->logger = Logger::getRootLogger();
	}
	
	public function authenticate($p_contexte){
		if(!isset($_SESSION['userid'])){
			$this->logger->debug('Session non ouverte!');
			throw new exception('Session non ouverte');
		} else {
			$this->logger->debug('Session ouverte!');
			$userid = $_SESSION['userid'];
		}
		$this->logger->debug('appel authenticate'. ' avec ' . $userid);

		$user = new Users();
		$user->userId = $_SESSION['userid'];
		$user->load();
		$p_contexte->setUser($user);
	}
}
?>