<?php

class DataRequest {

    private $m_data = Array();

    public function __construct() {
        $logger = Logger::getRootLogger();
        foreach ($_POST as $key => $value) {
            $this->m_data[$key] = htmlspecialchars($value);
            //$logger->debug("cle post: $key");
        }

        foreach ($_GET as $key => $value) {
            $this->m_data[$key] = htmlspecialchars($value);
            //$logger->debug("cle get: $key : $value");
        }
    }

    public function getData($p_key) {
        if (isset($this->m_data[$p_key])) {
            return $this->m_data[$p_key];
        } else {
            return null;
        }
    }

    public function getDataJson($p_key) {
        if (isset($this->m_data[$p_key])) {
            return json_decode(htmlspecialchars_decode($this->m_data[$p_key]),true);
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