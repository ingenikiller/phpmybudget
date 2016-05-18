<?php

class ParserConfiguration {

    public static function getAction($p_domaine, $p_service) {
        return self::parseConf($p_domaine, $p_service);
    }

    private static function parseConf($p_domaine, $p_service) {
		//lecture du fichier de conf
        $xml = simplexml_load_file('./application/application.xml');
		//recherche du domaine/service
		$result = $xml->xpath('/configuration/domaines/domaine[@name="'.$p_domaine.'"]/service[@name="'.$p_service.'"]');
		$page=null;
		if($result != null){
			$page = new PageDescription($p_domaine, $p_service, (string) $result[0]['classe'], (string) $result[0]['methode'], (string) $result[0]['isPrivee']);
		} else {
			die("Domaine/service $p_domaine/$p_service introuvable!!!");
		}
		
		
		if (isset($result[0]['render'])) {
			$page->setRender((string) $result[0]['render']);
		}
		
		$page->setXslFile($result[0]['xsl']);
		$page->setPrivee($result[0]['isPrivee']);
		
		if (isset($result[0]['paramFlow'])) {
			$page->paramFlow((string) $result[0]['paramFlow']);
		}	
        return $page;
    }
}
?>
