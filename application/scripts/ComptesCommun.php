<?php

abstract class ComptesCommun {
	
	/**
	 * calcul la somme des opérations comptabilisées
	 */
	public static function calculSommeOperations($numeroCompte){
		$l_requete = "SELECT SUM(montant) as total FROM operation WHERE noCompte='$numeroCompte' and noncomptabilisee=0";
		
		$dyn = new ListDynamicObject('SommeOperations');
		$dyn->request($l_requete);
		//$dyn->getData();
		
		return $dyn;
		
	}

	/**
	 * calcul la somme des opérations non comptabilisées
	 */
	public static function calculSommeOperationsNonComptabilisees($numeroCompte){
		$l_requete = "SELECT SUM(montant) as total FROM operation WHERE noCompte='$numeroCompte' and noncomptabilisee=1";
		
		$dyn = new ListDynamicObject('SommeOperationsNonComptabilisees');
		$dyn->request($l_requete);
		//$dyn->getData();
		
		return $dyn;
		
	}
	
}

?>