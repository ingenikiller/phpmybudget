/*********************************************************
	fonction exécutée au chargement de la page
 *********************************************************/
 $(document).ready(function() {
	//alimenteListesCompte();
	var fonctionSuccess = function(fluxJson){
		alimenteObjetSelectCompte($('#comptePrincipal'), null, fluxJson);
		alimenteObjetSelectCompte($('#compteDestination'), null, fluxJson);
		alimenteObjetSelectCompte($('#compteId'), null, fluxJson);
		alimenteObjetSelectCompte($('#compteDest'), null, fluxJson);
	}
	getListeComptes(fonctionSuccess);
	listerObjects();
});

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
	if($('#comptePrincipal').val()!=null) {
		params+="&comptePrincipal="+$('#comptePrincipal').val();
	}
	if($('#compteDestination').val()!=null) {
		params+="&compteDestination="+$('#compteDestination').val();
	}
	
	var fonctionSuccess = function(json) {
		parseListeJson(json)
	}
	
	//appel de l'ajax
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
	document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;
		
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="flux"/>');
		row.append($('<td/>').text(tabJson[i].flux));
		row.append($('<td/>').text(tabJson[i].description));
		row.append($('<td class="text-center"/>').text(tabJson[i].compteId));
		row.append($('<td class="text-center"/>').text(tabJson[i].compteDest));
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerFlux(\''+ tabJson[i].fluxId +'\')">Editer</a>'));
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
		$('#fluxMaitreId').empty();
	} else {
		//
		$('#service').val('update');
		var params = '&fluxId='+fluxId;
		var fonctionSuccess= function(jsonObjectInstance) {
			$('#flux').val(jsonObjectInstance[0].flux);
			$('#fluxId').val(jsonObjectInstance[0].fluxId);
			$('#description').val(jsonObjectInstance[0].description);
			$('#modePaiementId').val(jsonObjectInstance[0].modePaiementId);
			$('#compteId').val(jsonObjectInstance[0].compteId);
			
			//numéro de compte en dur car compte principal
			afficheFluxSelect('fluxMaitreId', jsonObjectInstance[0].compteId, 'fluxMaitre=O');
			
			$('#compteDest').val(jsonObjectInstance[0].compteDest);
			if(jsonObjectInstance[0].entreeEpargne=='') {
				$('#entreeEpargne').removeAttr('checked')
			} else {	
				$('#entreeEpargne').attr('checked', 'checked');
			}
			
			if(jsonObjectInstance[0].sortieEpargne=='') {
				$('#sortieEpargne').removeAttr('checked')
			} else {	
				$('#sortieEpargne').attr('checked', 'checked');
			}
			
			if(jsonObjectInstance[0].fluxMaitre=='N') {
				$('#fluxMaitre').removeAttr('checked')
			} else {	
				$('#fluxMaitre').attr('checked', 'checked');
			}
			
			$('#fluxMaitreId').val(jsonObjectInstance[0].fluxMaitreId);
			$('#depense').val(jsonObjectInstance[0].depense);
		}
		var jsonObjectInstance = getFlux(params, fonctionSuccess);
	}
	
	$("div#boiteFlux").dialog({
			resizable: false,
			height:450,
			width:620,
			modal: true
		});
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
				"entreeEpargne": $('#entreeEpargne').attr('checked')=='checked'?'checked':'',
				"sortieEpargne": $('#sortieEpargne').attr('checked')=='checked'?'checked':'',
				"fluxMaitreId": form.fluxMaitreId.value,
				"fluxMaitre": $('#fluxMaitre').is(':checked')?'O':'N',
				"depense": form.depense.value
		}, 
		success: function(retour) {
			$("div#boiteFlux").dialog('close');
			listerObjects();
			return false;
		} 
	});
	return false;
}
