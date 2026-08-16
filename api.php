<?php
namespace root;

use Core\MyLogger;

$debut = microtime(true);
session_start();

require_once(__DIR__.'/vendor/autoload.php');

$logger = MyLogger::getInstance();

use Core\PageControl;

require 'config/bdd.php';

define('CHEMIN_LOGERREUR', './logs/');
define('LIGNE_PAR_PAGE', 40);
define('RACINE_DATA', 'data/projets');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Authorization, Content-Type, X-Requested-With");
$pageControl = new PageControl(TRUE);
$pageControl->process();
$fin = microtime(true);
$logger->debug('Version php:'.phpversion());
$logger->debug("Temps d'execution: ".($fin-$debut)*1000 . 'ms');

?>