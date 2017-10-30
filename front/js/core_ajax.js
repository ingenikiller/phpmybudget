
function traiteRetourAjax(retour) {
	if(retour[0].status=='OK'){
		return true;
	} else {
		alert(retour[0].message);
		return false;
	}
}
