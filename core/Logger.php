<?php 

class Logger {
	
	public static $instance = null;
	
	private $_file 			= null;
	// --- Possoble mode value :
	// ---  0 = error mode (error traces)
	// ---  1 = debug mode (error + debug traces)
	private $mode 			= null;
	private $nb_log 		= null;
	private $list_log 	= null;
	private $filename;
        private $sizeLimit=2000000;
	public static function getInstance(){
		if(self::$instance == null) {
			self::$instance = new Logger('log.txt', '');
		}
		return self::$instance;
	}
	
	public function __destruct() {
		/*if(self::$instance != null) {
			self::$instance->writeLogFile();
		}*/
		fclose($this->_file); 
	}
	
	private function __construct ( $file, $mode ){
		/*$this->_file = $file;
		$this->mode = $mode;
		$this->nb_log = 0;*/
                $this->filename='./logs/log.txt';
		$this->_file = fopen($this->filename,"a");
                
	}
	
	function addLogMessage ( $logMessage ){
		if(filesize($this->filename)>=$this->sizeLimit){
                    //echo 'nouveau fichier<br>';
                    fclose($this->_file);
                    rename($this->filename, './logs/log_save_'. date("d-m-Y_H_i_s").'.log');
                    $this->_file = fopen($this->filename,"a+");
                }
		fwrite($this->_file, "[" . date("d-m-Y H:i:s") . "]: "  . $logMessage . "\n");
                
	}
	function clearLogs ( ){
		for ($i = 0; $i < $this->nb_log; $i++ )
			unset($this->list_log[$i]);
		$this->nb_log = 0;
	}
	function writeLogFile ( ){		
		// --- Open the log file (read/write)
		//echo $this->_file;
		//$fp = fopen($this->_file,"a");
		// --- Go to the begin
		//fseek($fp,0);
		// --- Write the message in the file
		/*for ( $i = 0; $i < $this->nb_log; $i++ ){
			fwrite($fp,$this->list_log[$i]."\r\n");
			echo 'ligne';
		}*/
		// --- Close the log file
		//fclose($this->_file);      
	}
	
	
	
}
?>