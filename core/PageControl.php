<?php

class PageControl {

	private $logger;
	
	private $gestionToken;
	
	public function __construct($gestionToken) {
		$this->logger = Logger::getRootLogger();
		
		$this->gestionToken = $gestionToken;
	}

	public function process() {
		
		$contexte = new ContextExecution;
		
		$this->logger->debug('------------------------------------------------------');
		$this->logger->debug('------------------------------------------------------');
		$this->logger->debug('lancement');
		$l_domaine= null;
		$l_service= null;
		
		if(isset($_GET['domaine'])){
			$l_domaine= $_GET['domaine'];
			if(isset($_GET['service'])){
				$l_service= $_GET['service'];				
			} else {
				$l_service= 'defaut';
			}
		} else {
			$l_domaine='defaut';
			$l_service= 'defaut';
		}
		$classe = ParserConfiguration::getAction($l_domaine, $l_service);
		
		//si pas de classe, chargement de la page par défaut
		if($classe==null) {
			die("Configuration incorrecte: $l_service inexistante");
		}
		
		$this->logger->debug('classe:' . $classe->getNom());
		
		if($classe->isPrivee()) {
			$auten = null;
			if($this->gestionToken==TRUE) {
				//
				$auten = new AuthentificateurToken();
			} else {
				$auten = new AuthentificateurStandard();
			}
			try {
				$auten->authenticate($contexte);
			} catch (FunctionalException $e){
				if($this->gestionToken==TRUE || $classe->getRender()=='json') {
					$reponse = new ReponseAjax();
					$reponse->status='KO';
					$reponse->message=$e->getMessage();
					$reponse->codeerr=$e->getCodeErr();
					echo json_encode($reponse);
				} else {
					header('Location: index.php');
				}
				die();
			}
		}
		
		try {
			$classe->execute($contexte);
		} catch(TechnicalException $e){
			$this->logger->debug('Exception render:'.$classe->getRender());
			if($classe->getRender()=='json'){
				$reponse = new ReponseAjax();
				$reponse->status='KO';
				$reponse->message='erreur technique:'.$e->message;
				$contexte->addDataBlockRow($reponse);
				echo json_encode($contexte->m_dataResponse);
				$this->logger->debug('Exception:'.$e->message);
			} else {
				echo $e->message;
				if(is_array($e->tabException)){
					echo '<table border="1">';
					echo '<tr><td>ERROR</td></tr>';
					foreach ($e->tabException as $value) {
						echo "<tr><td>$value</td></tr>";
					}
					echo '</table>';
					
					echo '<table border="1">';
					echo '<tr><td>ERROR</td></tr>';
					print_r($e->getTrace());
					foreach ($e->getTrace() as $value) {
						echo "<tr><td>$value</td></tr>";
					}
					echo '</table>';
				}
				$this->logger->debug('Exception:'.$e->message);
			}
		}
	}
}
?>