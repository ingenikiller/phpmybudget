<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


class JPDO extends PDO 
{
    final public function __construct($dsn, $username = '', $password = '', $driver_options = array())
    {
        //$driver_options += array(self::ATTR_ERRMODE => self::ERRMODE_EXCEPTION);
        parent::__construct($dsn, $username, $password, $driver_options);
		$this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        //Statement::setPDOInstance($this);
    }
    
   
}

/**
 * Description of ConnexionPDO
 *
 * @author ingeni
 */
class ConnexionPDO {
    static private $instance=null;
    //static public $instance=new JPDO($dsn, $username = '', $password = '', $driver_options = array());
     public static function getInstance(){
        if(self::$instance==null){
            $arrExtraParam= array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8");//utf8
            self::$instance = new JPDO('mysql:host='.HOST.';dbname='.DATABASE,USER,PASSWD,$arrExtraParam);
            self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            //self::$instance  = new JPDO($dsn, $username = '', $password = '', $driver_options = array());
        }
        return self::$instance;
    }
}

?>
