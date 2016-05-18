<?php
class session {

private $db; // Classe de connection à la DB (La lecture y est facile)
private $_option; // Tableau de configuration des sessions.

public $sid; // ID de session
public $vars; // Variable de session.
public $ip = '127.0.0.1'; // IP (optionnel)


// Initialise la connection à la base de donnée.
// Intialise le tableau de configuration des sessions.
// Initialise le buffer de sortie en fonction de l'utilité des cookies.
public function __construct() {

$this->db = new db;
$this->_option = array();

$this->_option['timeout'] = time() - 3600;
$this->_option['cookie_time'] = time() + 3600;
$this->_option['sid_size'] = 26;
$this->_option['use_cookie'] = true;

$this->sid = $this->search_sid();

if ( $this->sid === NULL || !$this->check_session() ) {
$this->sid = $this->generate_sid();
$this->new_session();
}

if ( !$this->_option['use_cookie'] ) {
ob_start( array ( & $this , 'callback' ) );
} else {
ob_start();
}

}

// Récupère l'ID de session via COOKIE, GET, ou POST.
// Le cas échéant, ne rien retourner.
private function search_sid() {

if ( isset($_COOKIE['session']) && strlen($_COOKIE['session']) === $this->_option['sid_size'] ) {
$this->_option['method'] = 'COOKIE';
$this->_option['use_cookie'] = true;
return $_COOKIE['session'];
} elseif ( isset($_GET['sid']) && strlen($_GET['sid']) === $this->_option['sid_size'] ) {
$this->_option['method'] = 'GET';
return $_GET['sid'];
} elseif ( isset($_POST['sid']) && strlen($_POST['sid']) === $this->_option['sid_size'] ) {
$this->_option['method'] = 'POST';
return $_POST['sid'];
} else {
$this->_option['method'] = 'NEW';
return NULL;
}

}

// Génère un indentifiant de session.
private function generate_sid() {

srand ((float) microtime() * 10000000);
return substr( md5( rand(0,9999999) ), 0, $this->_option['sid_size'] );

}

// Vérifie la présence d'une session existante dans la base de donnée.
private function check_session() {

$sql = "SELECT array FROM maj_session WHERE sid = '".$this->sid."' ";
$query = $this->db->query($sql);
if ( $this->db->num_rows($query) === 1 ) {
$data = $this->db->fetch_row($query);
if ( $data[0] !== NULL ) {
$this->vars = unserialize($data[0]);
}
return true;
} else {
return false;
}

}

// Créer une nouvelle session dans la base de donnée.
private function new_session() {

$this->_option['method'] = 'NEW';

$sql = "INSERT INTO maj_session (sid, ip, last_access)
VALUES ('".$this->sid."', '".$this->ip."', '".time()."') ";
$this->db->query($sql);

setCookie( 'session', $this->sid, $this->_option['cookie_time'] );
if ( isset($_COOKIE['session']) ) {
$this->_option['use_cookie'] = true;
}

}

// Supprime les anciennes sessions avec un timeout trop important.
private function flush_sessions() {

$sql = "DELETE FROM maj_session WHERE last_access < '".$this->_option['timeout']."' ";
$this->db->query($sql);

}

// Update la session en cours.
// Vide le buffer.
public function __destruct() {

$sql = "UPDATE maj_session SET last_access = '".time()."' ";
if ( isset($this->vars) ) {
$sql .= ", array = '".serialize($this->vars)."' ";
}
$sql .=" WHERE sid = '".$this->sid."' ";
$this->db->query($sql);

$this->flush_sessions();
ob_end_flush();

}

// Affiche les informations de session.
public function __ToString() {

$var = 'ID session : '.$this->sid.'<br/>';
$var .='Type : '.$this->_option['method'].'<br/>';
foreach ( $this->vars as $key=>$val ) {
$var .= 'Key : '.$key.' - Val : '.$val.' <br/><br/>';
}
return $var;

}

// Fonction de callback pour parser les <a></a>
// Fonction incomplète.
public static function callback($buffer) {
return $buffer;
}

}
?> 