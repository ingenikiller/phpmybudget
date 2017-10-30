

//fonction de validation d'un flux
function validFlux(p_form) {
	//les deux comptes ne doivent pas être identiques
	if(p_form.elements['compteId'].value==p_form.elements['compteDest'].value) {
		alert('Comptes de rattachement et destinatiare identiques');
		return false;
	}
	return true;
}




