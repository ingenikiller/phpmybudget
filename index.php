<?php

session_start();

require './../librairies/classautoloader/1.0/ClassAutoLoader.php';
require 'config/bdd.php';
//require 'application/scripts/functions_xsl.php';

define('CHEMIN_LOGERREUR', './logs/');

define('LIGNE_PAR_PAGE', 20);
define('RACINE_DATA', 'data/projets');

$pageControl = new PageControl();
$pageControl->process();

?>