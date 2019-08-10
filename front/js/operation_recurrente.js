var listeRecFlux='';

$(document).ready(function() {
	afficheFluxSelectMulti('recFlux', $('#numeroCompte').val(), '');
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	
	listerObjects();
});

/*
	réinitialise le formulaire de recherche pour lancer une nouvelle recherche
*/
function rechercherOperations(form){
	listerObjects();
	return false;
}

function listerObjects(){

	$('#numeroPage').val($.isNumeric($('#numeroPage').val())? $('#numeroPage').val():1);

	var params = "numeroCompte="+$('#numeroCompte').val()+'&numeroPage='+$('#numeroPage').val();
	if($('#recFlux').val()!='' && $('#recFlux').val()!=null) {
		params+="&recFlux="+$('#recFlux').val();
	}
	
	if($('#recMontant').val()!='') {
		params+="&recMontant="+$('#recMontant').val();
	}

	//appel synchrone du service
	$.ajax({
		url: "index.php?domaine=operationrecurrente&service=getliste",
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
	$('tr[typetr=operation]').remove();

	var total = json[0].nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);

	$('#numeroPage').val(json[0].page);
	$('#rch_page').val(json[0].page);
	$('#max_page').val(json[0].totalPage);
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="operation"/>');
		row.append($('<td/>').text(tabJson[i].libelle));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		var classeMontant='';
		if(Number(tabJson[i].montant.replace(',','')) >= 0) {
			classeMontant='positif';
		} else {
			classeMontant='negatif';
		}

		row.append($('<td class="text-right '+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].montant.replace(',','')))));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerOperation(\''+ tabJson[i].nocompte +'\','+ tabJson[i].operationrecurrenteId +')"><span class="oi oi-pencil"/></a>'));
		
		$("#tbodyResultat").append(row);
	}
}

function editerOperation(numeroCompte, operationrecurrenteId){

	var params = "numeroCompte="+numeroCompte;
	var largeur = 620;

	if(operationrecurrenteId!='') {
		params+="&operationrecurrenteId="+operationrecurrenteId;

		$.getJSON(
			"index.php?domaine=operationrecurrente&service=getone",
			data=params,
			function(json){
				$('#service').val('update');
				$('#operationrecurrenteId').val(json[0].tabResult[0].operationrecurrenteId);
				$('#libelle').val(json[0].tabResult[0].libelle);
				$('#fluxId').val(json[0].tabResult[0].fluxId);
				$('#modePaiementId').val(json[0].tabResult[0].modePaiementId);
				$('#montant').val(json[0].tabResult[0].montant.replace(',',''));
				
				$('#boiteOperation').modal({
					backdrop: 'static',
					keyboard: false
				});
			}
		);
	} else {
		$('#service').val('create');
		$('#operationRecurrenteId').val('');
		$('#libelle').val('');
		$('#montant').val('');
		$('#fluxId').val('');
		$('#modePaiementId').val('');

		$('#boiteOperation').modal({
			backdrop: 'static',
			keyboard: false
		});
	}
	return false;
}

function soumettre(form) {
	if(!validForm(form)) {
		return false;
	}

	var service = form.service.value;
	$.ajax({
		url: "index.php?domaine=operationrecurrente&service="+service,
		data: { 
			"noCompte": form.noCompte.value,
			"operationRecurrenteId": form.operationrecurrenteId.value,
			"libelle": form.libelle.value,
			"fluxId": form.fluxId.value,
			'modePaiementId': form.modePaiementId.value,
			'montant': form.montant.value
		}, 
		success: function(retour) {
			//si on est en création, on garde la popup ouverte, sinon, on la ferme
			if(service=='create') {
				form.libelle.value='';
				form.fluxId.value='';
				form.modePaiementId.value='';
				form.montant.value='';
				form.libelle.focus();
			} else {
				$('#boiteOperation').modal('hide');
			}
			
			//maj de la liste des opérations
			pagination('recherche');
			return false;
		}
	});
	return false;
}