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
	exécute une requete Json et alimente le tableau des tésultats
*/
function listerObjects(){
	//appel synchrone de l'ajax
	var jsonObjectInstance = $.parseJSON(
	    $.ajax({
	         url: "index.php?domaine=periode&service=getliste",
	         async: false,
	         dataType: 'json'
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
	$('tr[typetr=annee]').remove();
	
	var total = json[0].nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);
	//document.getElementById('numeroPage').value=json[0].page;
	//document.getElementById('rch_page').value=json[0].page;
	//document.getElementById('max_page').value=json[0].totalPage;
	
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = tab.insertRow(i+1);
		row.setAttribute('typetr', "annee")
		row.setAttribute('class', 'l'+i%2);
		
		var cell1=row.insertCell(0)
		cell1.innerHTML=tabJson[i].annee;
		cell1.setAttribute('align', "center")
		
		var cell2 = row.insertCell(1);
		cell2.innerHTML=tabJson[i].nbmois;
		cell2.setAttribute('align', "center");
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
		async: false, 
		success: function(retour) { 
			traiteRetourJSON(retour);
			return false;
		} 
	});
	listerObjects();
	return false;
}

