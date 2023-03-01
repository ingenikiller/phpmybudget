var listeRecFlux='';

$(document).ready(function() {
	afficheFluxSelectMulti('recFlux', $('#numeroCompte').val(), '');
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	
	listerObjects();
});

/**********************************************
	réinitialise le formulaire de recherche 
	pour lancer une nouvelle recherche
 **********************************************/
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

/**********************************************
	parse le tableau Json et génère le tableau
 **********************************************/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=operation]').remove();

	var tabJson = json.racine.ListeOperationsRecurrentes.data;
	
	$('#numeroPage').val(json.racine.ListeOperationsRecurrentes.page);
	$('#rch_page').val(json.racine.ListeOperationsRecurrentes.page);
	$('#max_page').val(json.racine.ListeOperationsRecurrentes.totalPage);
	
	for(var i=0; i<tabJson.length; i++) {
		var row = $('<tr typetr="operation"/>');
		row.append($('<td/>').text(tabJson[i].libelle));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		var classeMontant='';
		if(Number(tabJson[i].montant.replace(',','')) >= 0) {
			classeMontant='positif';
		} else {
			classeMontant='negatif';
		}

		row.append($('<td class="text-end '+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].montant.replace(',','')))));
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
				var opeRec = json.racine.ListeOperationsRecurrentes.data[0];
				$('#service').val('update');
				$('#operationrecurrenteId').val(opeRec.operationrecurrenteId);
				$('#libelle').val(opeRec.libelle);
				$('#fluxId').val(opeRec.fluxId);
				$('#modePaiementId').val(opeRec.modePaiementId);
				$('#montant').val(opeRec.montant.replace(',',''));
				
				$('#boiteOperation').modal({
					backdrop: 'static',
					keyboard: false
				});
				var myModal = new bootstrap.Modal(document.getElementById('boiteOperation'), {
					backdrop: 'static',
					keyboard: false
				});
				myModal.show();
			}
		);
	} else {
		$('#service').val('create');
		$('#operationRecurrenteId').val('');
		$('#libelle').val('');
		$('#montant').val('');
		$('#fluxId').val('');
		$('#modePaiementId').val('');

		var myModal = new bootstrap.Modal(document.getElementById('boiteOperation'), {
			backdrop: 'static',
			keyboard: false
		});
		myModal.show();
	}
	return false;
}

function soumettre(form) {
	if(!validForm(form)) {
		return false;
	}

	var dataJson=new Object();
	dataJson.noCompte= form.noCompte.value;
	dataJson.operationRecurrenteId= form.operationrecurrenteId.value;
	dataJson.libelle= form.libelle.value;
	dataJson.fluxId= form.fluxId.value;
	dataJson.modePaiementId= form.modePaiementId.value;
	dataJson.montant= form.montant.value;

	var service = form.service.value;
	$.ajax({
		url: "index.php?domaine=operationrecurrente&service="+service,
		type: "POST",
		//contentType: 'application/json; charset=utf-8',
    	dataType: 'text',
		data: { 
			operationRecurrente: JSON.stringify(dataJson)
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
