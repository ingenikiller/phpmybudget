<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ReponseAjax
 *
 * @author ingeni
 */
class ReponseAjax {
    
	//OK ou KO
    public $status='';
    
	public $codeerr='';
	
    public $message='';
    
    public $name='ReponseAjax';
    
    public $valeur=''   ;
    
    public function getName() {
        return $this->name;
    }
    
}

?>
