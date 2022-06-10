/*
	chargement de la page
*/	
$(document).ready(function() {
	listerObjects();
});



/*
	édition d'une opération
*/
function editerOperation(numeroCompte, operationId){
	
	var params = "numeroCompte="+numeroCompte;
	
	if(operationId!='') {
		params+="&operationId="+operationId;
	
	
		$.getJSON(
			"index.php?domaine=operation&service=getone",
			data=params,
			function(json){
				document.operation.service.value='update';
				document.operation.operationId.value=json[0].tabResult[0].operationId;
				document.operation.noReleve.value=json[0].tabResult[0].noReleve;
				document.operation.libelle.value=json[0].tabResult[0].libelle;
				document.operation.montant.value=json[0].tabResult[0].montant.replace(',','');
				document.operation.fluxId.value=json[0].tabResult[0].fluxId;
				document.operation.modePaiementId.value=json[0].tabResult[0].modePaiementId;
				document.operation.date.value=json[0].tabResult[0].date;
				
				$("div#boiteOperation").dialog({
					resizable: false,
					height:270,
					width:500,
					modal: true
				});
			}
		);
	} else {
		document.operation.service.value='create';
		document.operation.operationId.value='';
		document.operation.noReleve.value='';
		document.operation.libelle.value='';
		document.operation.montant.value='';
		document.operation.fluxId.value='';
		document.operation.modePaiementId.value='';
		//document.operation.date.value=;
		
		$("div#boiteOperation").dialog({
			resizable: false,
			height:270,
			width:500,
			modal: true
		});
	}
	initFormOperation();
	return false;
}

/*
	réinitialise le formulaire de recherche pour lancer une nouvelle recherche
*/
function rechercherOperations(form){
	//$('#numeroPage').val(1);
	//alert('toto');
	listerObjects();
	return false;
}

/*
	exécute une requete Json et alimente le tableau des résultats
*/
function listerObjects(){
	//appel synchrone de l'ajax
	$.ajax({
		url: "index.php?domaine=periode&service=getliste",
		dataType: 'json',
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
	$('tr[typetr=periode]').remove();
	
	var tabJson = json.racine.ListeAnnee.data;
	//var total = json[0].nbLineTotal;
	//var nbpage = Math.ceil(total/json[0].nbLine);
	
	
	//var nb=json[0].nbLine;
	
	for(var i=0; i<tabJson.length; i++) {
		var row = $('<tr typetr="periode"/>');
		row.append($('<td/>').text(tabJson[i].annee));
		row.append($('<td  class="text-center"/>').text(tabJson[i].nbmois));
		$("#tbodyResultat").append(row);
	}
}

function creerPeriode(form){
	if(!validForm(form)) {
		return false;
	}
	
	//var service = form.service.value;
	$.ajax({ 
		url: "index.php?domaine=periode&service=create",
		data: { "annee": form.nouvelleannee.value
		}, 
		success: function(retour) { 
			traiteRetourJSON(retour);
			listerObjects();
			return false;
		} 
	});
	
	return false;
}

