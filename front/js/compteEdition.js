/*********************************************************
	chargement de la page
 *********************************************************/
$(document).ready(function() {
	listerObjects();
});

/*********************************************************
	exécute une requete Json et alimente le tableau des tésultats
 *********************************************************/
function listerObjects(){
	
	var params = 'numeroPage='+$('#numeroPage').val();
		
	//appel synchrone de l'ajax
	$.ajax({
		url: "index.php?domaine=compte&service=getliste",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			parseListeJson(resultat);
		}
	});
	return false;
}

/*
	parse le tableau Json et génère le tableau
*/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=compte]').remove();
	
	var tabJson = json.racine.ListeComptes.data;
	var total = json.racine.ListeComptes.totalLigne;
	var nbPage = json.racine.ListeComptes.totalPage;
	document.getElementById('numeroPage').value=json.racine.ListeComptes.page;
	document.getElementById('rch_page').value=json.racine.ListeComptes.page;
	document.getElementById('max_page').value=nbPage;
		
	var nb=total;
	
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="compte"/>');
		row.append($("<td/>").text(tabJson[i].numeroCompte));
		row.append($("<td/>").text(tabJson[i].libelle));
		row.append($('<td class="text-end"/>').text(formatMonetaire(tabJson[i].solde)));
		var solde = tabJson[i].solde;
		var sommeOpe  = tabJson[i].SommeOperation.data[0].somme;
		var calcul = Number(solde) + Number(sommeOpe);
		var numeroCompte = tabJson[i].numeroCompte;
		row.append($('<td class="text-end"/>').text(formatMonetaire(calcul)));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerCompte(\''+ numeroCompte +'\')"><span class="oi oi-pencil"/></a>'));
		
		//
		if(tabJson[i].comptepro=="1"){
			row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=operation&amp;service=getpagepro&amp;numeroCompte='+ numeroCompte +'">'
				+'<span class="oi oi-list"/>'
				+'</a>'));
		} else {
			row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=operation&amp;service=getpage&amp;numeroCompte='+ numeroCompte +'">'
				+'<span class="oi oi-list"/>'
				+'</a>'));
		}
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=operationrecurrente&amp;service=getpage&amp;numeroCompte='+ numeroCompte +'">'
			+'<span class="oi oi-box"/>'
			+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=statistique&amp;service=menu&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-bar-chart"/>'
					+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=prevision&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-signal"/>'
					+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=budget&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-clock"/>'
					+'</a>'));
		$("#tbodyResultat").append(row);
	}
}

/*********************************************************
	affiche la popup de modification d'un compte
 *********************************************************/
function editerCompte(numeroCompte){
	if(numeroCompte!='') {
		var params="&numeroCompte="+numeroCompte;
		$.getJSON(
			"index.php?domaine=compte&service=getone",
			data=params,
			function(json){
				$('#service').val('update');
				$('#numeroCompte').val(json.racine.Comptes.numeroCompte);
				$('#numeroCompte').attr('readonly', 'readonly');
				$('#libelle').val(json.racine.Comptes.libelle);
				$('#solde').val(json.racine.Comptes.solde.replace(',',''));
			}
		);
	} else {
		$('#service').val('create');
		$('#numeroCompte').val('');
		$('#numeroCompte').removeAttr('readonly');
		$('#libelle').val('');
		$('#solde').val(0);
	}
	
	var myModal = new bootstrap.Modal(document.getElementById('boiteCompte'), {
		backdrop: 'static',
		keyboard: false
	});
	myModal.show();
}


function soumettre(form) {
	if(!validForm(form)) {
		return false;
	}
	
	var dataJson=new Object();
	dataJson.numeroCompte= form.numeroCompte.value;
	dataJson.libelle=form.libelle.value;
	dataJson.solde=form.solde.value;

	$.ajax({ 
		url: "index.php?domaine=compte&service="+$('#service').val(),
		//contentType: 'application/json; charset=utf-8',
    	dataType: 'text',
		type: "POST",
		data: {compte: JSON.stringify(dataJson)}, 
		success: function(retour) { 
			$("div#boiteCompte").modal('hide');
			listerObjects()
			return false;
		}
	});
	return false;
}
