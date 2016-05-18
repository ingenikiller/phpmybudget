<?php
/**
 * Description of SavableObject
 *
 * @author ingeni
 */
abstract class SavableObject extends Objects {

    public $associatedObjet = array();
    private $isLoaded = false;

    public function isLoaded() {
        return $this->isLoaded;
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

    public function save() {
        //echo 'pk1 '. $this->getPrimaryKey() .'<br>';
        //self::setPk($this->getPrimaryKey());
//        if (self::$_pk == null || !property_exists($this, self::$_pk)) {
//            throw new Exception("Primary key must exist before saving");
//        }
        $primaryKey = implode(' AND ', $this->getPrimaryKeyValorisee());
        $set = null;
        $champs = null;
        $values = null;
        $tabKey = explode(',', $this->getPrimaryKey());
        foreach ($this->fetchPublicMembers() as $col => $val) {
            //echo $col.'->';
            if ($col != 'associatedObjet') {
                //echo 'col tr<br>';
                //if (stripos($col, 'date') === 0) {
                    //
                //} else {
                    $champs[] = $col;
                    $values[] = trim(self::$_pdo->quote($val));
                //}
                if (array_search($col, $tabKey) === false) {
                    $set[] = sprintf("%s=%s", $col, self::$_pdo->quote($val));
                }
            }
        }
        //$query = 'INSERT INTO '.$this->_tableName. '(' . implode(',', $champs) . ') VALUES (' . implode(',',$values) . ') ON DUPLICATE KEY ';
        $query = sprintf("INSERT INTO %s (%s) VALUES (%s) ON DUPLICATE KEY ", $this->_tableName, implode(',', $champs), implode(',', $values));
        $query .= sprintf("UPDATE %s "//WHERE %s",
                , implode(',', $set));
        //$primaryKey);
//        $query .= sprintf("UPDATE %s SET %s WHERE %s",
//                         $this->_tableName,
//                         implode(',', $set),
//                         $primaryKey);
        try {
            Logger::getInstance()->addLogMessage('requete save:' . $query);
            $stmt = self::$_pdo->exec($query);
//            if($stmt==FALSE) {
//                throw new TechnicalException(self::$_pdo->errorCode(),self::$_pdo->errorInfo() );
//            }
        } catch (PDOException $e) {
            throw new Exception("Error occured while saving your object", null, $e);
        }
    }
	
	public function create(){
		$champs = null;
        $values = null;
        foreach ($this->fetchPublicMembers() as $col => $val) {
            if ($col != 'associatedObjet') {
                    $champs[] = $col;
                    $values[] = trim(self::$_pdo->quote($val));
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
	
	public function update(){
		$primaryKey = implode(' AND ', $this->getPrimaryKeyValorisee());
		$set = null;
        $tabKey = explode(',', $this->getPrimaryKey());
        foreach ($this->fetchPublicMembers() as $col => $val) {
            if ($col != 'associatedObjet') {
				if (array_search($col, $tabKey) === false) {
                    $set[] = sprintf("%s=%s", $col, self::$_pdo->quote($val));
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
     * 
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
