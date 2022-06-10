
function traiteRetourAjax(retour) {
	if(retour.racine.status=='OK'){
		return true;
	} else {
		alert(retour.racine.message);
		return false;
	}
}
