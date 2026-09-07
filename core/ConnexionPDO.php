<?php

namespace Core;

use PDO;

class ConnexionPDO {
    static private $instance=null;
    
    public static function getInstance(){
        if(self::$instance==null){
            $arrExtraParam= array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8");
			//php 8.5: $arrExtraParam= array(Pdo\Mysql::ATTR_INIT_COMMAND  => "SET NAMES utf8"); use PDO\Mysql;
            self::$instance = new PDO('mysql:host='.HOST.';dbname='.DATABASE,USER,PASSWD,$arrExtraParam);
            self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        }
        return self::$instance;
    }
	
	/******************************************
	 * démarrage d'une transaction
	 ******************************************/
	public static function beginTransaction() {
		self::$instance->beginTransaction();
	}
	
	/******************************************
	 * commit d'une transaction
	 ******************************************/
	public static function commit() {
		self::$instance->commit();
	}
	
	/******************************************
	 * roolback d'une transaction
	 ******************************************/
	public static function rollBack () {
		self::$instance->rollBack ();
	}
	
	
}

?>
