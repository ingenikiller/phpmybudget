<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of GenerateurClasse
 *
 * @author ingeni
 */
class GenerateurClasse {
	
	//put your code here
	

	private $tabPrimary = null;
	private $tabChamps = null;
	
	/**
	 *
	 * @param type $p_connexion 
	 */
	public function generer() {
		//récupération de la liste des tables
		$l_requete = 'SHOW full tables WHERE Table_Type = \'BASE TABLE\'';
		$pdo = ConnexionPDO::getInstance ();
		$l_result = $stmt = $pdo->query ( $l_requete );
		while ( $l_table = $l_result->fetch ( PDO::FETCH_ASSOC ) ) {
			//recherche des champs de la table
			$this->tabPrimary = array ();
			$this->tabChamps = array ();
			$l_nomTable = ucfirst ( $l_table ['Tables_in_' . DATABASE] );
			$this->rechercheChamps ( $pdo, $l_nomTable );
			$this->genererClasseStub ( $l_nomTable );
		}
	}
	
	/**
	 *
	 * @param type $p_connexion
	 * @param type $p_nomTable
	 * @return type tableau des champs de la table
	 */
	private function rechercheChamps($pdo, $p_nomTable) {
		$l_requete = 'SHOW COLUMNS FROM ' . $p_nomTable;
		$l_result = $pdo->query ( $l_requete );
		while ( $l_champs = $l_result->fetch ( PDO::FETCH_ASSOC ) ) {
			//recherche des champs de la table
			

			if ($l_champs ['Key'] == 'PRI')
				$this->tabPrimary [$l_champs ['Field']] = $l_champs ['Field']; //$l_champs;
			else
				$this->tabChamps [$l_champs ['Field']] = $l_champs;
		}
		
	}
	
	/**
	 *
	 * @param type $p_nomTable 
	 */
	private function genererClasseStub($p_nomTable) {
		$l_code = "<?php\nclass $p_nomTable" . " extends SavableObject {\n";
		print_r ( $this->tabPrimary );
		$l_code .= "\tstatic private \$key='" . implode ( ',', $this->tabPrimary ) . "';\n";
		$l_code .= "\tpublic function getPrimaryKey(){\n\t\treturn self::\$key;\n\t}\n";
		foreach ( $this->tabPrimary as $key => $value ) {
			$l_code .= "\tpublic \$" . $key . "=NULL;\n\t\n";
		}
		foreach ( $this->tabChamps as $key => $value ) {
			$l_code .= "\tpublic \$" . $key . ";\n\t\n";
		}
		
		//fin du fichier
		$l_code .= "}\n?>";
		
		$l_nomFichier = './application/objets' . '/' . $p_nomTable . '.php';
		$l_file = fopen ( $l_nomFichier, 'wb' );
		echo ($l_nomFichier);
		fwrite ( $l_file, $l_code );
		fclose ( $l_file );
	}
}

?>