<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Statement
 *
 * @author ingeni
 */
final class Statement extends PDOStatement 
{
    private static $_pdo;
    
    public function __construct() {
        self::$_pdo = ConnexionPDO::getInstance();
    }


    public static function setPDOInstance(PDO $pdo)
    {
        self::$_pdo = $pdo;
    }
    
    private function _prepareFetchObject($className)
    {
        if (!preg_match("/.*FROM\s(.*)[\s|;]?/i", $this->queryString, $table)) {
            throw new Exception("Could not find table name in query");
        }
        
        if (!class_exists($className, true)) {
            throw new Exception("Class $className does not exist");
        }

        if (!is_subclass_of($className, __NAMESPACE__ . '\Result\Objects')) {
            throw new Exception("Class $className should extend JPDO\ResultObjects");
        }

        return $table;
    }
    
    public function fetchObjectOfClass($className)
    {
        $table = $this->_prepareFetchObject($className);        
        $instance = new $className(self::$_pdo, $table[1]);
        $this->setFetchMode(PDO::FETCH_INTO, $instance);
        return parent::fetch(PDO::FETCH_INTO);
    }

    public function fetchAllObjectOfClass($className)
    {
        $table = $this->_prepareFetchObject($className);        
        return parent::fetchAll(PDO::FETCH_CLASS, $className, array(self::$_pdo, $table[1]));    
    }

    // Attention aux bugs PHP (http://bugs.php.net/52098)
    public function __call($method, $args)
    {
        if (preg_match("/^fetchAll(\w+)$/", $method, $matches)) {
            return $this->fetchAllObjectOfClass($matches[1]);
        } elseif (preg_match("/^fetchOne(\w+)$/", $method, $matches)) {
            return $this->fetchObjectOfClass($matches[1]);
        } else {
            throw new Exception("Call to undefined method $matches[1]");
        }
    }
    
    public function fetchObjectLoaded($instance){
        $this->setFetchMode(PDO::FETCH_INTO, $instance);
        parent::fetch(PDO::FETCH_INTO);
    }
}

?>
