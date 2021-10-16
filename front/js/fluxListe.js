/*********************************************************
	fonction ex�cut�e au chargement de la page
 *********************************************************/
 $(document).ready(function() {
	alimenteListesCompte();
	listerObjects();
});

/*********************************************************
	alimente les combos de s�lection de compte
 *********************************************************/
function alimenteListesCompte() {
	var fonctionSuccess = function(resultat) {
		alimenteObjetSelectCompte($('#comptePrincipal'), null, resultat);
		alimenteObjetSelectCompte($('#compteDestination'), null, resultat);
		alimenteObjetSelectCompte($('#compteId'), null, resultat);
		alimenteObjetSelectCompte($('#compteDest'), null, resultat);
	}
	
	getListeComptes(fonctionSuccess);
}

/*********************************************************
	alimente une combo de sélection de compte
 *********************************************************/
function alimenteObjetSelectCompte(objetListe, compteDefaut, fluxJson){
 	objetListe.append(new Option('','',true,true));
 	var nb=fluxJson[0].nbLine;
	var tabJson = fluxJson[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		objetListe.append(new Option(tabJson[i].libelle, tabJson[i].numeroCompte, false, false));
	}
}

/*********************************************************
	recherche les flux suivant les données du formulaire
 *********************************************************/
function rechercherFlux(form){
	//$('#numeroPage').val(1);
	listerObjects();
	return false;
}

/*********************************************************
	affiche la liste des flux
 *********************************************************/
function listerObjects(){
	
	var params = 'numeroPage='+$('#numeroPage').val();
	if($('#comptePrincipal').val()!='' && $('#comptePrincipal').val()!=null) {
		params+="&comptePrincipal="+$('#comptePrincipal').val();
	}
	if($('#compteDestination').val()!='' && $('#compteDestination').val()!=null) {
		params+="&compteDestination="+$('#compteDestination').val();
	}
	
	var fonctionSuccess = function(resultat) {
		parseListeJson(resultat);
	}
	
	//appel synchrone de l'ajax
	getListeFlux(params, fonctionSuccess);
	
	return false;
}

/*********************************************************
	parse le tableau Json et génère le tableau graphique
 *********************************************************/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=flux]').remove();
	
	var total = json[0].nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);
	$('#numeroPage').val(json[0].page);
	$('#rch_page').val(json[0].page);
	$('#max_page').val(json[0].totalPage);
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="flux"/>');
		row.append($('<td/>').text(tabJson[i].flux));
		row.append($('<td/>').text(tabJson[i].description));
		row.append($('<td class="text-center"/>').text(tabJson[i].compteId));
		row.append($('<td class="text-center"/>').text(tabJson[i].compteDest));
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerFlux(\''+ tabJson[i].fluxId +'\')"><span class="oi oi-pencil"/></a>'));
		$("#tbodyResultat").append(row);
	}
}

/*********************************************************
	affiche la popup d'édition d'un compte
 *********************************************************/
function editerFlux(fluxId){
	
	if(fluxId==''){
		$('#service').val('create');
		$('#fluxId').val('');
		$('#flux').val('');
		$('#description').val('');
		$('#modePaiementId').val('');
		$('#compteId').val('');
		$('#compteDest').val('');
		$('#fluxMaitre').val('');
		//$('#fluxMaitreId').val('');
		$('#fluxMaitreId').empty();
		
	} else {
		//
		$('#service').val('update');
		var params = '&fluxId='+fluxId;
		var fonctionSuccess = function(resultat) {
			$('#flux').val(resultat[0].flux);
			$('#fluxId').val(resultat[0].fluxId);
			$('#description').val(resultat[0].description);
			$('#modePaiementId').val(resultat[0].modePaiementId);
			$('#compteId').val(resultat[0].compteId);

			//numéro de compte en dur car compte principal
			afficheFluxSelect('fluxMaitreId', resultat[0].compteId, 'fluxMaitre=O', resultat[0].fluxMaitreId);

			$('#compteDest').val(resultat[0].compteDest);
			if(resultat[0].entreeEpargne=='') {
				$('#entreeEpargne').prop('checked', false);
			} else {	
				$('#entreeEpargne').prop('checked', true);
			}

			if(resultat[0].sortieEpargne=='') {
				$('#sortieEpargne').prop('checked', false);
			} else {	
				$('#sortieEpargne').prop('checked', true);
			}

			if(resultat[0].fluxMaitre=='N') {
				$('#fluxMaitre').prop('checked', false);
			} else {	
				$('#fluxMaitre').prop('checked', true);
			}

			$('#fluxMaitreId').val(resultat[0].fluxMaitreId);
			$('#depense').val(resultat[0].depense);
		}
		getFlux(params, fonctionSuccess);
	}
	
	var myModal = new bootstrap.Modal(document.getElementById('boiteFlux'), {
		backdrop: 'static',
		keyboard: false
	});
	myModal.show();
}


/*********************************************************
	enregistre un flux
 *********************************************************/
function enregistreFlux(form){
	
	if(validForm(form)!=true){
		return false;
	}
	
	$.ajax({ 
		url: "index.php?domaine=flux&service="+$('#service').val(),
		data: { "fluxId": form.fluxId.value,
				"flux": form.flux.value,
				"description": form.description.value,
				"modePaiementId": form.modePaiementId.value,
				"compteId": form.compteId.value,
				"compteDest": form.compteDest.value,
				"entreeEpargne": $('#entreeEpargne').is(':checked')?'O':'',
				"sortieEpargne": $('#sortieEpargne').is(':checked')?'O':'',
				"fluxMaitreId": form.fluxMaitreId.value,
				"fluxMaitre": $('#fluxMaitre').is(':checked')?'O':'N',
				"depense": form.depense.value
		}, 
		success: function(retour) { 
			$("div#boiteFlux").modal('close');
			listerObjects();
		  return false;
		} 
	});
	return false;
}
