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
	
	var total = json[0].tabResult.nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);
	document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;
		
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="compte"/>');
		row.append($("<td/>").text(tabJson[i].numeroCompte));
		row.append($("<td/>").text(tabJson[i].libelle));
		row.append($('<td class="text-right"/>').text(formatMonetaire(tabJson[i].solde)));
		var solde = tabJson[i].solde;
		var sommeOpe  = tabJson[i].associatedObjet[0].tabResult[0].somme;
		var calcul = Number(solde) + Number(sommeOpe);
		var numeroCompte = tabJson[i].numeroCompte;
		row.append($('<td class="text-right"/>').text(formatMonetaire(calcul)));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerCompte(\''+ numeroCompte +'\')"><span class="oi oi-pencil"/></a>'));
		
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=operation&amp;service=getpage&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-list"/>'
					+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=operationrecurrente&amp;service=getpage&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-box"/>'
					+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=statistique&amp;service=menu&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-bar-chart"/>'
					+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=prevision&amp;numeroCompte='+ numeroCompte +'">'
					+'<span class="oi oi-signal"/>'
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
				$('#numeroCompte').val(json[0].numeroCompte);
				$('#numeroCompte').attr('readonly', 'readonly');
				$('#libelle').val(json[0].libelle);
				$('#solde').val(json[0].solde.replace(',',''));
			}
		);
	} else {
		$('#service').val('create');
		$('#numeroCompte').val('');
		$('#numeroCompte').removeAttr('readonly');
		$('#libelle').val('');
		$('#solde').val(0);
	}
	
	$("div#boiteCompte").dialog({
		resizable: false,
		width: 620,
		modal: true
	});
}


function soumettre(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
		url: "index.php?domaine=compte&service="+$('#service').val(),
		data: { "numeroCompte": form.numeroCompte.value,
				"libelle": form.libelle.value,
				"solde": form.solde.value
		}, 
		success: function(retour) { 
			$("div#boiteCompte").dialog('close');
			listerObjects()
			return false;
		}
	});
	return false;
}
