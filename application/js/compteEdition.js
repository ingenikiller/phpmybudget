/*********************************************************
	chargement de la page
 *********************************************************/
$(document).ready(function() {
	//afficheFluxSelect('recFlux', $('#numeroCompte').val(), '');
	//afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N');
	listerObjects();
	
	
});

/*********************************************************
	exécute une requete Json et alimente le tableau des tésultats
 *********************************************************/
function listerObjects(){
	
	var params = 'numeroPage='+$('#numeroPage').val();
		
	//appel synchrone de l'ajax
	var jsonObjectInstance = $.parseJSON(
	    $.ajax({
	         url: "index.php?domaine=compte&service=getliste",
	         async: false,
	         dataType: 'json',
	         data: params
	        }
	    ).responseText
	);
	
	//alert(jsonObjectInstance);
	parseListeJson(jsonObjectInstance);
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
		row.append($('<td class="text-right"/>').text(Number(tabJson[i].solde).toFixed(2).replace(',','')));
		var solde = tabJson[i].solde;
		var sommeOpe  = tabJson[i].associatedObjet[0].tabResult[0].somme;
		var calcul = Number(solde) + Number(sommeOpe);
		row.append($('<td class="text-right"/>').text(calcul.toFixed(2)));
		
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=operation&amp;service=getpage&amp;numeroCompte='+ tabJson[i].numeroCompte +'">'
					+'<img border="0" src="./application/images/operations.gif" alt="Visualiser" title="Visualiser"/>'
					+'</a>'));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerCompte(\''+ tabJson[i].numeroCompte +'\')"><img border="0" src="./application/images/editer.gif" alt="Editer" title="Editer""/></a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=statistique&amp;service=menu&amp;numeroCompte='+ tabJson[i].numeroCompte +'">'
					+'<img border="0" src="./application/images/statistiques.gif" alt="Visualiser" title="Visualiser"/>'
					+'</a>'));
		row.append($('<td class="text-center"/>').append('<a href="index.php?domaine=prevision&amp;numeroCompte='+ tabJson[i].numeroCompte +'">'
					+'<img border="0" src="./application/images/statistiques.gif" alt="Visualiser" title="Visualiser"/>'
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
		height:200,
		width:600,
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
    async: false, 
    success: function(retour) { 
		//alert('OK');
		return false;
    }
	});
	$("div#boiteCompte").dialog('close');
	listerObjects()
	return false;
}
