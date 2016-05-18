<?php

class DataRequest {

    private $m_data = Array();

    public function __construct() {
        foreach ($_POST as $key => $value) {
            $this->m_data[$key] = htmlspecialchars($value); //mysql_real_escape_string(htmlspecialchars($value));
            //$this->m_data[$key] = mysql_real_escape_string(iconv("UTF-8", "ISO-8859-15", $value));
            //$this->m_data[$key] = mysql_real_escape_string(utf8_decode($value));
            /* if($this->is_utf8($value) == 1){
              Logger::getInstance()->addLogMessage('utf8 chaine '.$key. ':'.$value);
              } */
        }

        foreach ($_GET as $key => $value) {
            $this->m_data[$key] = htmlspecialchars($value); // mysql_real_escape_string(htmlspecialchars($value));//utf8_decode($value));
        }
    }

    public function getData($p_key) {
        if (isset($this->m_data[$p_key])) {
            return $this->m_data[$p_key];
        } else {
            return null;
        }
    }

    public function getDataObject($p_key) {
        if (isset($this->m_data[$p_key])) {
            return new RequestVariable($p_key, $this->m_data[$p_key]);
        } else {
            return null;
        }
    }

    public function getDataTab() {
        return $this->m_data;
    }

    /*private function is_utf8($string) {

        // From http://w3.org/International/questions/qa-forms-utf-8.html
        return preg_match('%^(?:
		 [\x09\x0A\x0D\x20-\x7E] # ASCII
		 | [\xC2-\xDF][\x80-\xBF] # non-overlong 2-byte
		 | \xE0[\xA0-\xBF][\x80-\xBF] # excluding overlongs
		 | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2} # straight 3-byte
		 | \xED[\x80-\x9F][\x80-\xBF] # excluding surrogates
		 | \xF0[\x90-\xBF][\x80-\xBF]{2} # planes 1-3
		 | [\xF1-\xF3][\x80-\xBF]{3} # planes 4-15
		 | \xF4[\x80-\x8F][\x80-\xBF]{2} # plane 16
		 )*$%xs', $string);
    }*/

}

?>