<?php

abstract class ComptesCommun {
	
	public static function calculSommeOperations($numeroCompte){
		$l_requete = "SELECT SUM(montant) as total FROM operation WHERE noCompte='$numeroCompte'";
		
		$dyn = new ListDynamicObject();
		$dyn->name = 'SommeOperations';
		$dyn->request($l_requete);
		$tab = $dyn->getData();
		
		return $dyn;
		
	}
	
}

?>