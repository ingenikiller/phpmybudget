<?php

class DataRequest {

    private $m_data = Array();

    public function __construct() {
        foreach ($_POST as $key => $value) {
            $this->m_data[$key] = htmlspecialchars($value);
        }

        foreach ($_GET as $key => $value) {
            $this->m_data[$key] = htmlspecialchars($value);
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
}
?>