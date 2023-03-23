<?php

abstract class ComptesCommun {
	
	public static function calculSommeOperations($numeroCompte){
		$l_requete = "SELECT SUM(montant) as total FROM operation WHERE noCompte='$numeroCompte'";
		
		$dyn = new ListDynamicObject('SommeOperations');
		$dyn->request($l_requete);
		//$dyn->getData();
		
		return $dyn;
		
	}
	
}

?>