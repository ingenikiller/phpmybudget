<?php

class PageControl {

	public function process() {
		
		$contexte = new ContextExecution;
		
		Logger::getInstance()->addLogMessage('------------------------------------------------------');
		Logger::getInstance()->addLogMessage('------------------------------------------------------');
		Logger::getInstance()->addLogMessage('lancement');
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
		
		//si pas de classe, chargement de la page par defaut
		if($classe==null) {
			if($classe==null) {
				die("Configuration incorrecte: $l_service inexistante");
			}
		}
		Logger::getInstance()->addLogMessage('classe:' . $classe->getNom());
		
		if($classe->isPrivee()) {
			$auten = new AuthentificateurStandard();
			try {
				$auten->authenticate($contexte);
			} catch (Exception $e){
				header('Location: index.php');
				die();
			}
		}
		
		try {
			$classe->execute($contexte);
		} catch(TechnicalException $e){
			Logger::getInstance()->addLogMessage('Exception render:'.$classe->getRender());
			if($classe->getRender()=='json'){
				$reponse = new ReponseAjax();
				$reponse->status='KO';
				$reponse->message='erreur technique:'.$e->message;
				$contexte->addDataBlockRow($reponse);
				echo json_encode($contexte->m_dataResponse);
				Logger::getInstance()->addLogMessage('Exception:'.$e->message);
				/*if(is_array($e->tabException)){
					
					
					Logger::getInstance()->addLogMessage(print_r($e->tabException, true));
					//Logger::getInstance()->addLogMessage(print_r($e->getTrace(), true));
					
					Logger::getInstance()->addLogMessage('Fin exception');
				}*/
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
				Logger::getInstance()->addLogMessage('Exception:'.$e->message);
			}
		}
	}
}
?>