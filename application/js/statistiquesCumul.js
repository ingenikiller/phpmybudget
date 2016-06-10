
$(document).ready(function() {
	afficheFluxSelect('multiselect', $('#numeroCompte').val(), '');
	//afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	//getSoldeCompte($('#numeroCompte').val(), 'solde');
	//listerObjects();
	//$("listeComplete").offsetWidth = $("listeSelection").offsetWidth;
	$('#multiselect').multiselect();
	
});



function soumettreRelevesAnnee(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
    url: "index.php?domaine=statistique&service=statannees",
    data: { "numeroCompte": form.numeroCompte.value,
			"premiereAnnee": form.premiereAnnee.value,
			"derniereAnnee": form.derniereAnnee.value
	}, 
    async: false, 
    success: function(retour) { 
      $('table#tableResultat').html(retour);
      return false;
    } 
	});
	return false;
}

