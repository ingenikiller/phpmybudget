/*********************************************************
	fonction d'init
 *********************************************************/
$(document).ready(function() {
	//
	affichePrevisions('liste', $('#annee').val(), $('#numeroCompte').val());
	recupereListeEntetes('listeEntete', $('#annee').val(), $('#numeroCompte').val());
	afficheEstimation('estimation', $('#numeroCompte').val());
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N');
});


/*********************************************************
	affiche les prévisions de l'année
 *********************************************************/
function affichePrevisions(idTableau, periode, numeroCompte) {
	
	$.ajax({ 
	    url: "index.php?domaine=prevision&service=getlisteannee",
	    data: { "edition":"edition",
	    	"periode":periode,
	    	"numeroCompte": numeroCompte
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
	document.location.href='index.php?domaine=prevision&numeroCompte='+$('#numeroCompte').val()+'&annee='+$('#annee').val();
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
				//alert("JSON Data: " +  json.users[3].name);
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
	$("div#boite").dialog({
            resizable: false,
            height:190,
            width:620,
            modal: true
            });
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
				'annee': document.getElementById('annee').value
		}, 
		success: function(retour) { 
			affichePrevisions('liste',document.getElementById('annee').value, form.numeroCompte.value);
			$("div#boite").dialog('close');
			afficheEstimation('estimation', $('#numeroCompte').val());
			return false;
		} 
	});
	return false;
}


/***********************************************************************
 affiche la popup de saisie d'une entete de prévision
	-compte: numéro de compte
 ***********************************************************************/
function afficheEntete(compte) {
	document.editionEnteteUnitaire.service.value='create';
	document.editionEnteteUnitaire.fluxId.value='';
	document.editionEnteteUnitaire.periodicite.value='';
	document.editionEnteteUnitaire.nomEntete.value='';
	document.editionEnteteUnitaire.montant.value='';
	document.editionEnteteUnitaire.ligneId.value='';
	$("div#boiteEntete").dialog({
		resizable: false,
		width:400,
		modal: true
	});
}

/***********************************************************************
 *
 *
 ***********************************************************************/
function creerEntete(form) {
	
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
		url: "index.php?domaine=previsionentete&service="+form.service.value,
		data:{
			"ligneId": form.ligneId.value,
			"noCompte": form.numeroCompte.value,
			"fluxId": form.fluxId.value,
			"typenr": form.typenr.value,
			'nomEntete': form.nomEntete.value,
			'annee': $('#annee').val(),
			'periodicite': $('#periodicite').val(),
			'montant': form.montant.value,
			'annee': $('#annee').val()
		}, 
		success: function(retour) { 
			form.ligneId.value = retour[0].ligneId;
			$("div#boiteEntete").dialog('close');
			affichePrevisions('liste', $('#annee').val(), $('#numeroCompte').val());
			recupereListeEntetes('listeEntete', $('#annee').val(), $('#numeroCompte').val());
			return false;
		} 
	});
	return false;
}


/***********************************************************************
 * récupère la liste des entêtes pour une année
 *
 ***********************************************************************/
function recupereListeEntetes(objet, annee, numeroCompte) {
	
	var params="noCompte="+numeroCompte+"&typenr=E&annee="+annee;
	document.getElementById(objet).innerHTML=null;
	$.getJSON(
		 "index.php?domaine=previsionentete&service=getlisteentete",
	    data=params,
		function(json){
			var obj=document.getElementById(objet);
			var nb=json[0].nbLine;
			var tabJson = json[0].tabResult;
			var i=0;
			obj.options[obj.length] = new Option('','',true,true);
			for(i=0; i<nb; i++) {
				obj.options[obj.length] = new Option(tabJson[i].flux, tabJson[i].fluxid, false, false);
			}
			return false;
		}
	);
}


function afficheListeGroupe(fluxId){
	var annee =  $('#annee').val();
	var numeroCompte = $('#numeroCompte').val();
	var params = "noCompte="+numeroCompte+"&annee="+annee+"&fluxId="+fluxId;
	
	//appel synchrone de l'ajax
	$.ajax({
		url: "index.php?domaine=previsionentete&service=getone",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			parseListePrevisionJson(resultat);

			$("div#boiteListeEntete").dialog({
				resizable: false,
				width:400,
				modal: true,
				title : 'Edition prévision pour '+$("#listeEntete").find("option:selected").text()
			});

			$('#listeEntete').val('');
		}
	});
	return false;
}

/*
	parse le tableau Json et génère le tableau
*/
function parseListePrevisionJson(json) {
	tab = document.getElementById('tabListeEntete');
	$('tr[typetr=prevision]').remove();
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="prevision"/>');
		row.append($('<td/>').text(tabJson[i].mois));
		row.append($('<td/>').append('<input class="text-right" type="text" id="montant-'+(i+1)+'" ligneid="'+tabJson[i].ligneId+'" onblur="return isDouble(this);" value="'+tabJson[i].montant+'" size="10" />'));
		//row.append($('<td/>').append('<input type="button" id="btnpropag-'+(i+1)+'" index="'+(i+1)+'" onclick="return propagerMontant(this);"></input>'));
		row.append($('<td class="text-center"/>').append('<button class="ui-button ui-widget ui-corner-all ui-button-icon-only" title="" id="btnpropag-'+(i+1)+'" index="'+(i+1)+'" onclick="return propagerMontant(this);"><span class="ui-icon ui-icon-arrowthick-1-s"></span></button>'));
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
 * mets à jour la prévision avec la somme des montants poir un mois 
 * et un flux
 ***********************************************************************/
 function equilibrerPrevision(numeroCompte, ligneId) {
 	$.ajax({ 
		url: "index.php?domaine=prevision&service=equilibrerprevision",
		data: { "ligneId": ligneId,
			"mode": "equilibrer"
		}, 
		success: function(retour) {
			affichePrevisions('liste',document.getElementById('annee').value, numeroCompte);
			return false;
		} 
	});
}

function enregistreListeLignes(form){
	var params = "";
	var i = 1;
	while($('#montant-'+i).length){
		params+='&ligneId-'+i+'='+$('#montant-'+i).attr('ligneid')+'&montant-'+i+'='+$('#montant-'+i).val();
		i+=1;
	}
	params+='&nbligne='+(i-1)+"&render=json";
	$.ajax({
		url: "index.php?domaine=previsionentete&service=update",
		dataType: 'json',
		data: params,
		success: function(data) {
			$("div#boiteListeEntete").dialog('close');
			affichePrevisions('liste',document.getElementById('annee').value, form.numeroCompte.value);
		}
		}
	);
	return false;
}

function afficheEstimation(champs, nocompte){
	var params = "noCompte="+nocompte;
	$.ajax({
		url: "index.php?domaine=prevision&service=estimationreste",
		dataType: 'json',
		data: params,
		success: function (data) {
			$('#estimation').text(data[0][1]);
		}
	});
}
