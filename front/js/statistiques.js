


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
 * 	affichege des r�sultats
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
 * parse le tableau Json et g�n�re le tableau
 ************************/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=operation]').remove();
	
	var total = json[0].nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);
	document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="operation"/>');
		row.append($('<td/>').text(tabJson[i].dateOperation));
		row.append($('<td/>').text(tabJson[i].libelle));
		row.append($('<td class="text-end"/>').text(tabJson[i].montant.replace(',','')));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		$("#tbodylisteoperation").append(row);
	}
}

/************************
 * g�re le d�pliage et repliage des d�tails
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
