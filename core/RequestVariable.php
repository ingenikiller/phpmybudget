<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ResquestVariable
 *
 * @author oljean
 */
class RequestVariable {
    //put your code here
    public $name;
    public $value=null;
    
    public function __construct($name, $value) {
        $this->name=$name;
        $this->value=$value;
    }
}

?>
