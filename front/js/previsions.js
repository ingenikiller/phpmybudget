/*********************************************************
	fonction d'initialisation
 *********************************************************/
$(document).ready(function() {
	$( "#radio" ).controlgroup({
      icon: false
    });
	
	$('input:radio[name="radioChoixType"]').on("change", function(event) {
		refreshWindow();
	});
		
	//
	refreshWindow();
	
});


/*********************************************************
	affiche les prévisions de l'année
 *********************************************************/
function affichePrevisions(idTableau, periode, numeroCompte) {
	$.ajax({ 
	    url: "index.php?domaine=prevision&service=getlisteannee",
	    data: { "edition":"edition",
	    	"periode":periode,
	    	"numeroCompte": numeroCompte,
			"flagPinel": $('input:radio[name="radioChoixType"]:checked').val()
		}, 
	    success: function(retour) { 
			var xml = $.parseXML(retour)
			$('table#'+idTableau).html(retour);
			return false;
	    }
	});
	
}

/*********************************************************
	recharge la fenêtre au changement d'année
 *********************************************************/
function refreshWindow() {
	var flagPinel = $('input:radio[name="radioChoixType"]:checked').val()
	var paramPinel='';
	if(flagPinel == 'complet') {
		//
	} else if(flagPinel == 'sans') {
		paramPinel='&fluxMaitreExclu=101';
	} else if(flagPinel == 'pinel') {
		paramPinel='&fluxMaitreId=101';
	}
	
	afficheListePeriode();	
	affichePrevisions('liste', $('#annee').val(), $('#numeroCompte').val());
	afficheEstimation('estimation', $('#numeroCompte').val());
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N'+paramPinel);
	afficheFluxSelect('fluxIdEntete', $('#numeroCompte').val(), 'fluxMaitre=N'+paramPinel);
}

function afficheListePeriode() {
	var annee = $('#annee').val();
	$.getJSON(
		"index.php?domaine=periode&service=getlistemois",
		{"annee": annee },
		function(json){
			$('#mois').empty();

			var nb=json[0].nbLine;
			var tabJson = json[0].tabResult;
			var i=0;
			for(i=0; i<nb; i++) {
				$('#mois').append(new Option(tabJson[i].periode, tabJson[i].periode, false, false));
			}
		}
	);
}


/*********************************************************
	affichage d'une prévision
 *********************************************************/
function afficheUnitaire(compte, idLigne){
	if(idLigne!= '') {
		$.getJSON(
			"index.php?domaine=prevision&service=getone",
			{"ligneId": idLigne },
			function(json){
				document.editionPrevisionUnitaire.service.value='update';
				document.editionPrevisionUnitaire.montant.value=json[0].montant;
				document.editionPrevisionUnitaire.fluxId.value=json[0].fluxId;
				document.editionPrevisionUnitaire.mois.value=json[0].mois;
				document.editionPrevisionUnitaire.ligneId.value=json[0].ligneId;
			}
		);
	} else {
		document.editionPrevisionUnitaire.service.value='create';
		document.editionPrevisionUnitaire.fluxId.value='';
		document.editionPrevisionUnitaire.mois.value='';
	    document.editionPrevisionUnitaire.ligneId.value='';
	}
	
	var myModal = new bootstrap.Modal(document.getElementById('boite'), {
		backdrop: 'static',
		keyboard: false
	});
	myModal.show();
}

/*********************************************************
	modification de prévision
 *********************************************************/
function modifierPrevision(form) {
	if(!validForm(form)) {
		return false;
	}
	
	var service = form.service.value;
	
	$.ajax({ 
		url: "index.php?domaine=prevision&service="+service,
		data: { "ligneId": form.ligneId.value,
				"noCompte": form.numeroCompte.value,
				"fluxId": form.fluxId.value,
				"mois": form.mois.value,
				"typenr": form.typenr.value,
				'montant': form.montant.value,
				'annee': $('#annee').val()
		}, 
		success: function(retour) { 
			affichePrevisions('liste',$('#annee').val(), form.numeroCompte.value);
			$("div#boite").modal('hide');

			afficheEstimation('estimation', $('#numeroCompte').val());
			return false;
		} 
	});

	return false;
}


/***********************************************************************
 * affiche la popup de saisie d'une entête de prévision
 *	-compte: numéro de compte
 ***********************************************************************/
function afficheEntete(compte) {
	document.editionEnteteUnitaire.service.value='create';
	document.editionEnteteUnitaire.fluxIdEntete.value='';
	document.editionEnteteUnitaire.periodicite.value='';
	document.editionEnteteUnitaire.nomEntete.value='';
	document.editionEnteteUnitaire.montantPeriode.value='';
	document.editionEnteteUnitaire.ligneId.value='';

	var myModal = new bootstrap.Modal(document.getElementById('boiteEntete'), {
		backdrop: 'static',
		keyboard: false
	});
	myModal.show();
}

/***********************************************************************
 *
 *
 ***********************************************************************/
function creerEntete(form) {
	$.getJSON({ 
		url: "index.php?domaine=previsionentete&service="+form.service.value,
		data: { "ligneId": form.ligneId.value,
				"noCompte": form.numeroCompte.value,
				"fluxId": form.fluxIdEntete.value,
				"typenr": form.typenr.value,
				'nomEntete': form.nomEntete.value,
				'periodicite': $('#periodicite').val(),
				'montant': form.montantPeriode.value,
				'annee': $('#annee').val()
		}, 
		success: function(retour) { 
			if(traiteRetourAjax(retour)){
				form.ligneId.value = retour[0].ligneId;
				$("div#boiteEntete").modal('hide');
				affichePrevisions('liste', $('#annee').val(), $('#numeroCompte').val());
			}
			return false;
		} 
	});
	return false;
}


/***********************************************************************
 * affiche les prévisions pour un flux
 ***********************************************************************/
function afficheListeGroupe(fluxId){
	var annee =  $('#annee').val();
	var numeroCompte = $('#numeroCompte').val();
	var params = "noCompte="+numeroCompte+"&annee="+annee+"&fluxId="+fluxId;
	
	//appel synchrone de l'ajax
	$.getJSON({
		url: "index.php?domaine=previsionentete&service=getone",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			parseListePrevisionJson(resultat);

			var myModal = new bootstrap.Modal(document.getElementById('boiteListeEntete'), {
				backdrop: 'static',
				keyboard: false
			});
			myModal.show();
			$('#listeEntete').val('');
		}
	});
	return false;
}

/*
	parse le tableau Json et génère le tableau
*/
function parseListePrevisionJson(json){
	tab = document.getElementById('tabListeEntete');
	$('tr[typetr=prevision]').remove();
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="prevision"/>');
		row.append($('<td/>').text(tabJson[i].mois));
		row.append($('<td/>').append('<input class="form-control numerique" type="text" id="montant-'+(i+1)+'" ligneid="'+tabJson[i].ligneId+'" onblur="return isDouble(this);" value="'+tabJson[i].montant+'" size="10" />'));
		row.append($('<td class="text-center"/>').append('<button class="ui-button ui-widget ui-corner-all" title="" id="btnpropag-'+(i+1)+'" index="'+(i+1)+'" onclick="return propagerMontant(this);"><span class="oi oi-arrow-bottom"></span></button>'));

		$("#tbodylisteentete").append(row);
	}
}


function propagerMontant(btn){
	var index = $(btn).attr('index');
	var montant=$('#montant-'+index).val();
	var i = Number(index)+1;
	while($('#montant-'+i).length){
		$('#montant-'+i).val(montant);
		i+=1;
	}
	return false;
}

/***********************************************************************
 * met à jour la prévision avec la somme des montants pour un mois 
 * et un flux
 ***********************************************************************/
 function equilibrerPrevision(numeroCompte, ligneId){
 	$.getJSON({ 
		url: "index.php?domaine=prevision&service=equilibrerprevision",
		data: { "ligneId": ligneId,
			"mode": "equilibrer"
		}, 
		
		success: function(retour) {
			if(traiteRetourAjax(retour)){
				affichePrevisions('liste',$('#annee').val(), numeroCompte);
				afficheEstimation('estimation', $('#numeroCompte').val());
			}
			return false;
		} 
	});
}

/***********************************************************************
 * permet d'enregistrer les modifications d'une liste de prévisions
 ***********************************************************************/
function enregistreListeLignes(form){
	var params = "";
	var i = 1;
	while($('#montant-'+i).length) {
		params+='&ligneId-'+i+'='+$('#montant-'+i).attr('ligneid')+'&montant-'+i+'='+$('#montant-'+i).val();
		i+=1;
	}
	params+='&nbligne='+(i-1)+"&render=json";
	$.ajax({
		url: "index.php?domaine=previsionentete&service=update",
		dataType: 'json',
		data: params
	});
	$("div#boiteListeEntete").modal('hide');
	affichePrevisions('liste',$('#annee').val(), form.numeroCompte.value);
	return false;
}

/***********************************************************************
 * calcule le reste après imputation des prévisions
 ***********************************************************************/
function afficheEstimation(champs, nocompte){
	var params = "noCompte="+nocompte;
	$.getJSON({
		url: "index.php?domaine=prevision&service=estimationreste",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			$('#estimation').text(resultat[0][1]);
		}
	});
}

/***********************************************************************
 * permet de créer des prévisions pour un flux pour l'année suivante
 ***********************************************************************/
function reporterAnneeSuivante(nocompte, flux, anneeAReporter){
	var params = "noCompte="+nocompte+"&fluxid="+flux+"&anneeAReporter="+anneeAReporter;
	$.getJSON({
		url: "index.php?domaine=previsionentete&service=reporter",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			if(resultat[0].status=='OK') {
				alert('Prévisions créées!');
			} else {
				alert(resultat[0].message);
			}
		}
	});
}
