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
	var fluxJson = getListeComptes();
	alimenteObjetSelectCompte($('#comptePrincipal'), null, fluxJson);
	alimenteObjetSelectCompte($('#compteDestination'), null, fluxJson);
	alimenteObjetSelectCompte($('#compteId'), null, fluxJson);
	alimenteObjetSelectCompte($('#compteDest'), null, fluxJson);
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
	if($('#comptePrincipal').val()!='') {
		params+="&comptePrincipal="+$('#comptePrincipal').val();
	}
	if($('#compteDestination').val()!='') {
		params+="&compteDestination="+$('#compteDestination').val();
	}
	//appel synchrone de l'ajax
	var jsonObjectInstance = getListeFlux(params);
	
	//alert(jsonObjectInstance);
	parseListeJson(jsonObjectInstance);
	return false;
}

/*********************************************************
	parse le tableau Json et génère le tableau graphique
 *********************************************************/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=operation]').remove();
	
	var total = json[0].nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);
	document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;
	
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = tab.insertRow(i+1);
		row.setAttribute('typetr', "operation")
		row.setAttribute('class', 'l'+i%2);
		
		var cell1=row.insertCell(0)
		cell1.innerHTML=tabJson[i].flux;
		
		var cell2 = row.insertCell(1);
		cell2.innerHTML=tabJson[i].description;
		
		var cell3 = row.insertCell(2);
		cell3.innerHTML=tabJson[i].compteId;
		cell3.setAttribute('align', "center");
		
		var cell4 = row.insertCell(3);
		var montant = Number(tabJson[i].montant);
		cell4.innerHTML=tabJson[i].compteDest;
		cell4.setAttribute('align', "center");
		
		var cell7 = row.insertCell(4);
		cell7.innerHTML='<a href="#" onclick="editerFlux(\''+ tabJson[i].fluxId +'\')">Editer</a>';
		cell7.setAttribute('align', "center");		
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
		var jsonObjectInstance = getFlux(params);
		//var tabJson = jsonObjectInstance[0].tabResult;
		//var i=0;
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
	
	$("div#boiteFlux").dialog({
			resizable: false,
			height:340,
			width:500,
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
    async: false, 
    success: function(retour) { 
      //alert('OK');
      return false;
    } 
	});
	
	$("div#boiteFlux").dialog('close');
	listerObjects();
	return false;
}
