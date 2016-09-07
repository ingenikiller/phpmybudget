<?php
/**
 * Description of Objects
 *
 * @author ingeni
 */
abstract class Objects
{
    static protected $_pdo=null;

    protected $_tableName;
    public function getName(){
        return $this->_tableName;
    }
    
	//protected static $_pk;

    private $_props = array();
    
    
	/**
	 * constructeur
	 * 
	 */
    public function __construct(){
        if(self::$_pdo==null){
            //$arrExtraParam= array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8");
            //self::$_pdo = new JPDO('mysql:host=localhost;dbname=appli_migration','root','',$arrExtraParam);
            self::$_pdo = ConnexionPDO::getInstance();
        }
        $reflect = new ReflectionObject($this);
        $this->_tableName = $reflect->getName();
        
    }
    
    protected function _init() { }

    final public function fetchPublicMembers() {
        if ($this->_props) {
			return $this->_props;
		}
        $reflect = new ReflectionObject($this);
        foreach ($reflect->getProperties(ReflectionProperty::IS_PUBLIC) as $var) {
            $this->_props[$var->getName()] = $this->{$var->getName()};
        }
        return $this->_props;
    }

    public function __toString() {
        return implode(' - ', $this->_props);
    }    
}
?>