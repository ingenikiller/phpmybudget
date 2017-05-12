<?php
/**
 * Description of SavableObject
 *
 * @author ingeni
 */
abstract class SavableObject extends Objects {

    public $associatedObjet = array();
    private $isLoaded = false;

	private $champsDef;
	
	final public function __construct(){
		parent::__construct();
		$this->champsDef = $this->getChamps();
	}
	
    public function isLoaded() {
        return $this->isLoaded;
    }

	/**
	 * renvoie la liste des champs de la table et leurs caractéristiques
	 */
	private function getChamps(){
		$table=array();
		$pdo = ConnexionPDO::getInstance ();
		$l_requete = 'SHOW COLUMNS FROM ' . $this->_tableName;
		$l_result = $pdo->query ( $l_requete );
		while ( $l_champs = $l_result->fetch ( PDO::FETCH_ASSOC ) ) {
			//Logger::getInstance()->addLogMessage($l_champs ['Field']);
			$table[$l_champs ['Field']] = $l_champs;
		}
		return $table;
	}
	
	
	
    /**
     * retourne les éléments de la clé primaire valorisée pour requete
     * @return type tableau
     */
    private function getPrimaryKeyValorisee() {
        $tab = array();
        $primaryKey = explode(',', $this->getPrimaryKey());

        $reflect = new ReflectionObject($this);

        foreach ($primaryKey as $key => $value) {
            $property = $reflect->getProperty($value);
            $tab[] = $value . '=' . self::$_pdo->quote($property->getValue($this)); //'=\'' . $property->getValue($this) . '\'';
        }
        return $tab;
    }

    /**
     * fonction qui permet de charger une ligne de table via la clé primaire
     */
    public function load() {
        $primaryKey = implode(' AND ', $this->getPrimaryKeyValorisee());
        $requete = "SELECT * FROM $this->_tableName WHERE $primaryKey";
        $stmt = null;
        try {
            $stmt = self::$_pdo->query($requete);
            //print_r($stmt);
            if ($stmt === FALSE) {
                throw new TechnicalException(self::$_pdo->errorCode() . ':' . self::$_pdo->errorInfo());
            }
        } catch (PDOException $e) {
            throw new Exception("Error occured while saving your object", null, $e);
        }
        switch ($stmt->rowCount()) {
            case 0:
                //levée exception
                $this->isLoaded = false;
                break;
            case 1:
                $this->isLoaded = true;
                break;
            default :
                echo 'BOUH';
        }

        $stmt->setFetchMode(PDO::FETCH_INTO, $this);
        $stmt->fetch(PDO::FETCH_INTO);
    }
	
	/**
     * fonction de création en base d'un objet
     */
	public function create(){
		$champs = null;
        $values = null;
        foreach ($this->fetchPublicMembers() as $col => $val) {
            if ($col != 'associatedObjet') {
				$champDefinition = $this->champsDef[$col];
				if($champDefinition['Extra']=='auto_increment'){
					
				} else {
					$champs[] = $col;
					if(stripos($champDefinition['Type'], 'date') === 0 || stripos($champDefinition['Type'], 'varchar') === 0) {
						$values[] = trim(self::$_pdo->quote($val));
					} else{
						$values[] = $val=='' ? 0 : $val;
					}
				}
            }
        }
		$query = sprintf("INSERT INTO %s (%s) VALUES (%s)", $this->_tableName, implode(',', $champs), implode(',', $values));
		
		try {
            Logger::getInstance()->addLogMessage('requete create:' . $query);
            $stmt = self::$_pdo->exec($query);
        } catch (PDOException $e) {
            throw new Exception("Error occured while saving your object", null, $e);
        }
	}
	
	/**
     * fonction de mise à jour en base d'un objet
     */
	public function update(){
		$primaryKey = implode(' AND ', $this->getPrimaryKeyValorisee());
		$set = null;
        $tabKey = explode(',', $this->getPrimaryKey());
        foreach ($this->fetchPublicMembers() as $col => $val) {
            if ($col != 'associatedObjet') {
				if (array_search($col, $tabKey) === false) {
                    $champDefinition = $this->champsDef[$col];
					if(stripos($champDefinition['Type'], 'date') === 0 || stripos($champDefinition['Type'], 'varchar') === 0) {
						$set[] = sprintf("%s=%s", $col, trim(self::$_pdo->quote($val)));
					} else{
						$set[] = sprintf("%s=%s", $col, $val=='' ? 0 : $val);
					}
                }
            }
        }
		$query = sprintf("UPDATE %s SET %s WHERE %s", $this->_tableName, implode(',', $set), $primaryKey);
		
		try {
            Logger::getInstance()->addLogMessage('requete update:' . $query);
            $stmt = self::$_pdo->exec($query);
        } catch (PDOException $e) {
            throw new Exception("Error occured while saving your object", null, $e);
        }
	}

    /**
     * fonction de suppression en base d'un objet
     */
    public function delete() {
        $requete = "DELETE FROM $this->_tableName WHERE " . implode(' AND ', $this->getPrimaryKeyValorisee());
        Logger::$instance->addLogMessage('delete:' . $requete);
        try {
            $stmt = self::$_pdo->query($requete);
        } catch (PDOException $e) {
            throw new Exception("Error occured while saving your object", null, $e);
        }
    }

    /**
     *
     * @param DataRequest $request 
     */
    public function fieldObject(DataRequest $request, $prefix='', $separator='', $indice='') {
        $reflect = new ReflectionObject($this);
        //chaque champs de la classe
        foreach ($reflect->getProperties(ReflectionProperty::IS_PUBLIC) as $prop) {
            if (!stripos($this->getPrimaryKey(), $prop->getName())) {
                $requestElement = $request->getDataObject($prefix . $prop->getName() . $separator . $indice);
                //si le champs est 

                if ($requestElement != null) {
                    Logger::$instance->addLogMessage('champs:' . $prop->getName() . '->' . $requestElement->value);
                    $prop->setValue($this, $requestElement->value);
                } else {
                    Logger::$instance->addLogMessage('champs:' . $prefix. $prop->getName() . ' vide');
                }
            }
        }
    }
    
    abstract public function getPrimaryKey();
    
	public function lastInsertId() {
        return self::$_pdo->lastInsertId();
    }
}
?>