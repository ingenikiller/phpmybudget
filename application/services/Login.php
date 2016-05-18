<?php 

class Login extends ServiceStub{
	
	public function connexion(ContextExecution $p_contexte){
		$tab = CommunUser::getParameters($p_contexte);
		
		
		$l_user = CommunUser::getUserLogin($tab['nom'], $tab['motDePasse']);
		
        $_SESSION['userid'] = $l_user->userId;
		
        $p_contexte->setUser($l_user);
	}
	
}


?>