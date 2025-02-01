<?php

abstract class ComptesCommun {
	
	public static function calculSommeOperations($numeroCompte){
		$l_requete = "SELECT SUM(montant) as total FROM operation WHERE noCompte='$numeroCompte' and noncomptabilisee=0";
		
		$dyn = new ListDynamicObject('SommeOperations');
		$dyn->request($l_requete);
		//$dyn->getData();
		
		return $dyn;
		
	}
	
}

?>