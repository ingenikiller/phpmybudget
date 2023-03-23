<?php

//require 'vtemplate.class.php';

class FabriqueClasse {
	private $m_tabChamps = array();
	private $m_tabForeignKey = array();
	private $m_nomTable = '';
	private $m_primaryKey = '';
	private $m_repertoireSortie;
	private $m_genereClasseUser = false;
		
	public function __construct($p_nomTable, $p_repertoireSortie, $p_genereClasseUser) {
		$this->m_nomTable = $p_nomTable;
		$this->m_repertoireSortie = $p_repertoireSortie;
		$this->m_genereClasseUser = $p_genereClasseUser;
	}
	
	public function addPrimaryKey($p_primaryKey) {
		$this->m_primaryKey = $p_primaryKey;
	}
	
	public function addForeignKey($p_foreignKey) {
		echo 'froror'. $p_foreignKey .'<br>';
		$this->m_tabForeignKey[count($this->m_tabForeignKey)] = $p_foreignKey;
	}
	
	public function addChamps($p_nomChamps) {
		//$this->m_tabChamps->add($p_nomChamps);
		$this->m_tabChamps[count($this->m_tabChamps)] = $p_nomChamps;
	}
	
	public function construireClasse(){
		$l_nomClasse = ucfirst($this->m_nomTable);
		$l_template = new VTemplate();
		
		if($this->m_genereClasseUser){
			$this->construireClasseExtend($l_template, $l_nomClasse);
		}
		$this->construireClasseStub($l_template, $l_nomClasse);
	}
	
	private function construireClasseExtend($p_template, $p_nomClasse) {
		$l_handle = $p_template->Open("./tpl/classeExtend.tpl");
		$p_template->AddSession($l_handle,"classe");
		$p_template->setVar($l_handle, "classe.nomClasse", $p_nomClasse);
		$p_template->CloseSession($l_handle,"classe");
		
		$l_file = fopen($this->m_repertoireSortie . '/' . $p_nomClasse . '.php', 'w');
		fwrite ($l_file, $p_template->Display($l_handle,0));
		fclose($l_file);
	}
	
	public function construireClasseStub($p_template, $p_nomClasse) {
		$p_template = new VTemplate();
		$l_handle = $p_template->Open("./tpl/classeStub.tpl");
		
		$p_template->AddSession($l_handle,"classe");
		
		$p_template->setVar($l_handle, "classe.nomClasse", $p_nomClasse);
		
		$p_template->setVar($l_handle, "classe.nomTable", $this->m_nomTable);
		/*$l_template->setVar($l_handle, "classe.primaryKey", $this->m_primaryKey);
		$l_template->setVar($l_handle, "classe.primaryKeyMaj", ucfirst($this->m_primaryKey));*/
		
		$this->ajouteChamps($l_handle, $p_template, $this->m_primaryKey);
		$this->ajouteInsert($l_handle, $p_template, 'insertFirst', $this->m_primaryKey);
		
		$l_first=true;
		foreach($this->m_tabChamps as $l_nomChamps) {
			
			//ajout d�claration et accesseurs
			$this->ajouteChamps($l_handle, $p_template, $l_nomChamps);
			//ajout partie insert de la requete
			$this->ajouteInsert($l_handle, $p_template, 'insert', $l_nomChamps);

			//suivant si c'est le premier champs �crit
			if($l_first) {
				$this->ajouteInsert($l_handle, $p_template, 'updateFirst', $l_nomChamps);
				$l_first=false;
			}else {
				$this->ajouteInsert($l_handle, $p_template, 'update', $l_nomChamps);
			}
			
		}
		
		//print_r($this->m_tabForeignKey);
		foreach($this->m_tabForeignKey as $l_nomChamps) {
			$this->ajouteForeignKey($l_handle, $p_template, $l_nomChamps);
			$this->ajouteInsert($l_handle, $p_template, 'insert', $l_nomChamps.'Id');
			$this->ajouteInsert($l_handle, $p_template, 'update', $l_nomChamps.'Id');
		}
		
		
		$p_template->CloseSession($l_handle,"classe");
		
		$l_file = fopen($this->m_repertoireSortie . '/' . $p_nomClasse . 'Stub.php', 'w');
		fwrite ($l_file, $p_template->Display($l_handle,0));
		fclose($l_file);
	}
	
	
	
	private function ajouteChamps($p_handle, $p_template, $p_nomChamps) {
		$p_template->AddSession($p_handle,'attribut');
		
		$p_template->setVar($p_handle, "attribut.nomAttribut", $p_nomChamps);
		$p_template->setVar($p_handle, "attribut.nomAttributMaj", ucfirst($p_nomChamps));
		
		$p_template->CloseSession($p_handle,'attribut');
	}
	
	private function ajouteForeignKey($p_handle, $p_template, $p_nomChamps) {
		$p_template->AddSession($p_handle,'foreignKey');
		$p_template->setVar($p_handle, "foreignKey.nomAttribut", $p_nomChamps);
		$p_template->setVar($p_handle, "foreignKey.nomAttributMaj", ucfirst($p_nomChamps));
		
		$p_template->CloseSession($p_handle,'foreignKey');
	}
	
	private function ajouteinsert($p_handle, $p_template, $p_zone, $p_nomChamps) {
		$p_template->AddSession($p_handle,$p_zone);
		
		$p_template->setVar($p_handle, "$p_zone.nomAttribut", $p_nomChamps);
		//$p_template->setVar($p_handle, "$p_zone.nomAttribut", $p_nomChamps);
		
		$p_template->CloseSession($p_handle,$p_zone);
	}
}

?>