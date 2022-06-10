


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
		success: function(retour) { 
			$('table#tableResultat').html(retour);
			return false;
		} 
	});
	return false;
}

function soumettreMois(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
	    url: "index.php?domaine=statistique&service=statmois",
	    data: { "numeroCompte": form.numeroCompte.value,
				"premiereAnnee": form.premiereAnnee.value,
				"premierMois": form.premierMois.value,
				"derniereAnnee": form.derniereAnnee.value,
				"dernierMois": form.dernierMois.value
		}, 
	    success: function(retour) { 
			$('table#tableResultat').html(retour);
			return false;
	    }
	});
	return false;
}

function soumettreRelevesMois(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
		url: "index.php?domaine=statistique&service=statreleves",
		data: { "numeroCompte": form.numeroCompte.value,
				"premierReleve": form.premierReleve.value,
				"dernierReleve": form.dernierReleve.value
		}, 
		success: function(retour) { 
			$('table#tableResultat').html(retour);
			return false;
		} 
	});
	return false;
}

function afficheDetail(params){
	$('#params').val(params);
	$('#numeroPage').val(1);
	listerObjects();
	/*$("div#boiteDetail").dialog({
					resizable: false,
					height:750,
					width:700,
					modal: true
				});*/
	var myModal = new bootstrap.Modal(document.getElementById('boiteDetail'), {
		backdrop: 'static',
		keyboard: false
	});
	myModal.show();
}

/************************
 * 	affichege des résultats
 ************************/
function listerObjects(){
	var params = $('#params').val();
	//appel synchrone de l'ajax
	$.ajax({
		url: "index.php?domaine=operation&service=getliste",
		dataType: 'json',
		data: $('#params').val()+'&numeroPage='+$('#numeroPage').val(),
		success: function(resultat) {
			parseListeJson(resultat);
		}
	});
	return false;
}


/************************
 * parse le tableau Json et génère le tableau
 ************************/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=operation]').remove();
	
	var tabJson = json.racine.ListeOperations.data;
	document.getElementById('numeroPage').value=json.racine.ListeOperations.page;
	document.getElementById('rch_page').value=json.racine.ListeOperations.page;
	document.getElementById('max_page').value=json.racine.ListeOperations.totalPage;
	
	
	for(var i=0; i<tabJson.length; i++) {
		var row = $('<tr typetr="operation"/>');
		row.append($('<td/>').text(tabJson[i].dateOperation));
		row.append($('<td/>').text(tabJson[i].libelle));
		row.append($('<td class="text-end"/>').text(tabJson[i].montant.replace(',','')));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		$("#tbodylisteoperation").append(row);
	}
}

/************************
 * gère le dépliage et repliage des détails
 ************************/
function deplieDetail(lien){
	var attrReplie=lien.getAttribute('replie');
	var attrRef=lien.getAttribute('fluxid');
	if(attrReplie == "O") {
		attrReplie=lien.setAttribute('replie', 'N');
		$('tr[fluxid='+attrRef+']').show('N');
	} else {
		attrReplie=lien.setAttribute('replie', 'O');
		$('tr[fluxid='+attrRef+']').hide('O');
	}
}
