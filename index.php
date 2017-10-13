<?php

session_start();

require_once dirname(__FILE__).'/../librairies/\apache-log4php/2.3.0/main/php/Logger.php';
Logger::configure('config/appender_file.xml');

require './../librairies/classautoloader/1.0/ClassAutoLoader.php';
require 'config/bdd.php';
//require 'application/scripts/functions_xsl.php';

define('CHEMIN_LOGERREUR', './logs/');

define('LIGNE_PAR_PAGE', 20);
define('RACINE_DATA', 'data/projets');

$pageControl = new PageControl();
$pageControl->process();

?>