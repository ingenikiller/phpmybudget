/*********************************************************
	fonction exécutée au chargement de la page
 *********************************************************/
 $(document).ready(function() {
	alimenteListesCompte();
	listerObjects();
});

/*********************************************************
	alimente les combos de sélection de compte
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
 	var tabJson = fluxJson.racine.ListeComptes.data;
		
	for(var i=0; i<tabJson.length; i++) {
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
	
	var tabJson = json.racine.ListeFlux.data;
	//var total = json[0].nbLineTotal;
	//var nbpage = Math.ceil(total/json[0].nbLine);
	$('#numeroPage').val(json.racine.ListeFlux.page);
	$('#rch_page').val(json.racine.ListeFlux.page);
	$('#max_page').val(json.racine.ListeFlux.totalPage);
	
	var nb=tabJson.length;
	
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
			var flux = resultat.racine.Flux;
			$('#flux').val(flux.flux);
			$('#fluxId').val(flux.fluxId);
			$('#description').val(flux.description);
			$('#modePaiementId').val(flux.modePaiementId);
			$('#compteId').val(flux.compteId);

			//numéro de compte en dur car compte principal
			afficheFluxSelect('fluxMaitreId', flux.compteId, 'fluxMaitre=O', flux.fluxMaitreId);

			$('#compteDest').val(flux.compteDest);
			if(flux.entreeEpargne=='') {
				$('#entreeEpargne').prop('checked', false);
			} else {	
				$('#entreeEpargne').prop('checked', true);
			}

			if(flux.sortieEpargne=='') {
				$('#sortieEpargne').prop('checked', false);
			} else {	
				$('#sortieEpargne').prop('checked', true);
			}

			if(flux.fluxMaitre=='N') {
				$('#fluxMaitre').prop('checked', false);
			} else {	
				$('#fluxMaitre').prop('checked', true);
			}

			$('#fluxMaitreId').val(flux.fluxMaitreId);
			$('#depense').val(flux.depense);
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
	var dataJson=new Object();
	dataJson.fluxId= form.fluxId.value;
	dataJson.flux= form.flux.value;
	dataJson.description= form.description.value;
	dataJson.modePaiementId= form.modePaiementId.value;
	dataJson.compteId= form.compteId.value;
	dataJson.compteDest= form.compteDest.value;
	dataJson.entreeEpargne= $('#entreeEpargne').is(':checked')?'O':'';
	dataJson.sortieEpargne= $('#sortieEpargne').is(':checked')?'O':'';
	dataJson.fluxMaitreId= form.fluxMaitreId.value;
	dataJson.fluxMaitre= $('#fluxMaitre').is(':checked')?'O':'N';
	dataJson.depense= form.depense.value;

	$.ajax({ 
		url: "index.php?domaine=flux&service="+$('#service').val(),
		contentType: 'application/json; charset=utf-8',
		dataType: 'json',
		data: {flux: JSON.stringify(dataJson)}, 
		success: function(retour) { 
			$("div#boiteFlux").modal('hide');
			listerObjects();
		  return false;
		} 
	});
	return false;
}
