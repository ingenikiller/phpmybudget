
$(document).ready(function() {
	afficheFluxSelect('multiselect', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
});


function soumettreCumul(form) {
	if(!validForm(form)) {
		return false;
	}
		
	$.ajax({ 
		url: "index.php?domaine=statistique&service=statcumul",
		data: { "numeroCompte": form.numeroCompte.value,
				"premiereAnnee": form.premiereAnnee.value,
				"derniereAnnee": form.derniereAnnee.value
				//"listeFlux": listeFlux
		}, 
		success: function(retour) { 
		  $('table#tableResultat').html(retour);
		  return false;
		} 
	});
	return false;
}
