<?php
class Users extends SavableObject {
	static private $key='userId';
	public function getPrimaryKey(){
		return self::$key;
	}
	public $userId=NULL;
	
	public $nom;
	
	public $motDePasse;
	
}
?>