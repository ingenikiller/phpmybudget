<?php 

class Login extends ServiceStub{
	
	public function connexion(ContextExecution $p_contexte){
		$tab = CommunUser::getParameters($p_contexte);
		
		
		$l_user = CommunUser::getUserLogin($tab['nom'], $tab['motDePasse']);
		
		$reponse = new ReponseAjax();
		if($l_user!=null){
			$_SESSION['userid'] = $l_user->userId;
			$p_contexte->setUser($l_user);			
			$reponse->status='OK';
		} else {
			$reponse->status='KO';
			$reponse->message='nom ou mot de passe incorrect';
		}
		
		$p_contexte->addDataBlockRow($reponse);
	}
	
	public function getToken(ContextExecution $p_contexte){
		//suppression des tokens expirés
		TokenCommun::suppToken();
		
		//vérifie que l'utilisateur existe
		$tab = CommunUser::getParameters($p_contexte);
		
		
		$l_user = CommunUser::getUserLogin($tab['nom'], $tab['motDePasse']);
		
		$reponse = new ReponseAjax();
		if($l_user!=null){
			//génération du token
			/*$p = new OAuthProvider();
			$tokenValue = bin2hex($p->generateToken(16));*/
			$tokenValue = uniqid(rand(), true);;
			
			$_SESSION['userid'] = $l_user->userId;
			
			//enregistrement du token
			$token = new Tokensession();
			$token->userid = $l_user->userId;
			$token->token = $tokenValue;
			$token->startdate='now()';
			$token->create();
			
			//renvoi du token au client
			$reponse->status='OK';
			$reponse->valeur=$tokenValue;
			
		} else {
			//envoi un message d'erreur au client
			$reponse->status='KO';
			$reponse->message='nom ou mot de passe incorrect';
		}
		
		$p_contexte->addDataBlockRow($reponse);		
	}
}


?>