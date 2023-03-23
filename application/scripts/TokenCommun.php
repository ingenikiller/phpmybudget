<?php

class TokenCommun {
    
    public static function suppToken(){
        //requête de suppression
        $requete="DELETE FROM tokensession WHERE  startdate < now()-30*60";
		
		//suppression des tokens de plus d'une demi heure
		$pdo = ConnexionPDO::getInstance ();
		$pdo->query ( $requete );
    }
    
}

?>
