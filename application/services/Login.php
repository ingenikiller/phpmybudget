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
	
}


?>