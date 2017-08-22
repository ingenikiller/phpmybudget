
$(document).ready(function() {
	afficheFluxSelect('multiselect', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	//afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	//getSoldeCompte($('#numeroCompte').val(), 'solde');
	//listerObjects();
	//$("listeComplete").offsetWidth = $("listeSelection").offsetWidth;
	$('#multiselect').multiselect();
	
});



function soumettreCumul(form) {
	if(!validForm(form)) {
		return false;
	}
	
	var tabFlux = $('#multiselect_to')[0];
	var listeFlux='';
	for(var i=0; i<tabFlux.length; i++){
		if(i>0){
			listeFlux+=',';
		}
		listeFlux+="'"+tabFlux[i].value+"'";
	}
	
	$.ajax({ 
		url: "index.php?domaine=statistique&service=statcumul",
		data: { "numeroCompte": form.numeroCompte.value,
			"premiereAnnee": form.premiereAnnee.value,
			"derniereAnnee": form.derniereAnnee.value,
			"listeFlux": listeFlux
		},
		success: function(retour) { 
			$('table#tableResultat').html(retour);
			return false;
		} 
	});
	return false;
}
