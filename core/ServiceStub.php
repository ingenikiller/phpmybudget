<?php

abstract class ServiceStub {

	protected $logger=null;

	public function fictive(ContextExecution $p_contexte){}
	
	final public function __construct(){
		$this->logger = Logger::getRootLogger();
	}
	
	protected function getLogger() {
		if($this->logger==null) {
			$this->logger = Logger::getRootLogger();
		}
		return $this->logger;
	}
	
}



?>