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
	$.getJSON({ 
	    url: "index.php?domaine=prevision&service=getlisteannee",
	    data: { "edition":"edition",
	    	"periode":periode,
	    	"numeroCompte": numeroCompte,
			"flagPinel": $('input:radio[name="radioChoixType"]:checked').val()
		}, 
	    success: function(retour) { 
			//var xml = $.parseXML(retour)
			//$('table#'+idTableau).html(retour);
			genereTableau(idTableau, retour);
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

/**
 * génère le tableau des prévisions
 * @param {*} idTableau 
 * @param {*} ajax 
 */
function genereTableau(idTableau, ajax) {
	//vidage du tableau
	$('table#'+idTableau).html('');
	
	//mois en cours
	let date = new Date()
	let moisEnCours = date.getFullYear()+'-'+(date.getMonth()+1);
	
	//génération des colonnes
	$('table#'+idTableau).append('<colgroup/>')
	let listeMois=ajax[0].tabResult;
	for (let mois of listeMois) {
		if(mois.periode == moisEnCours) {
			$('table#'+idTableau).append('<colgroup class="colonnemoisencours"/>')
		} else {
			$('table#'+idTableau).append('<colgroup/>')
		}
	}


	//génération entête
	var entete = $('<tr/>');
	entete.append('<th>Flux</th>');
	for (let mois of listeMois) {
		entete.append('<th>'+mois.periode+'</th>');
	}
	entete.append('<th>'+listeMois[0].annee+'</th>');
	entete.append('<th>AS</th>');
	$('table#'+idTableau).append($('<thead/>').append(entete));

	
	// corps du tableau
	let tbody=$('<tbody/>');
	//dépenses
	let tabRelle=genereGroupe(tbody,ajax[1].tabResult, listeMois,'dépenses');
	//recettes
	let tabCredit=genereGroupe(tbody,ajax[2].tabResult, listeMois, 'recettes');

	//ligne des totaux
	let ligne=$('<tr/>');
	ligne.append('<th>Total</th>');
	let recapTotal=0;
	for(let mois of listeMois) {
		let difference = tabCredit[mois.periode]+tabRelle[mois.periode];
		ligne.append('<td class="text-end recap '+ (difference>0?'positif':'negatif') +'">'+difference.toFixed(2)+'</td>');
		recapTotal+=tabCredit[mois.periode]+tabRelle[mois.periode];
	}
	ligne.append('<td class="text-end recap '+ (recapTotal>0?'positif':'negatif') +'">'+recapTotal.toFixed(2)+'</td>');
	tbody.append(ligne);

	//ajout du tbody
	$('table#'+idTableau).append(tbody);
}

/**
 * génère les lignes pour les recettes ou dépenses
 * @param {*} tbody 
 * @param {*} listeFlux 
 * @param {*} listeMois 
 * @param {*} libelle 
 * @returns tableau de sommes de réelles
 */
function genereGroupe(tbody, listeFlux, listeMois,libelle) {
	let tabPrevisions=Array();
	let tabRelles=Array();
	let tabTotal=Array();

	//init des tableaux
	for (let mois of listeMois) {
		tabRelles[mois.periode] = 0;
		tabPrevisions[mois.periode] = 0;
	}
	
	//pour chaque flux du groupe
	for (let flux of listeFlux) {
		
		let ligne = $('<tr/>');
		ligne.append($('<th/>').append('<a href="#" onclick="afficheListeGroupe(\''+flux.fluxId+'\')"><span class="oi oi-arrow-thick-right"/> '+flux.flux+'</a>'));

		let listePrevision = flux.associatedObjet[0];
		let listeRelle = flux.associatedObjet[1];
		
		let nocompte=$('#nocompte').val();

		let sommePrevision=0;
		//génération d'une ligne de prévision
		for(let prevision of listePrevision.tabResult) {
			let montant = prevision.total == null ? '' : prevision.total;
			if(montant!=''){
				sommePrevision+=Number(montant);
				
				let lien='';
				//s'il existe une dépense pour le flux/mois en cours
				if(listeRelle.tabResult[Number(prevision.periode.substr(5))-1]!=null) {
					let relleMois = listeRelle.tabResult[Number(prevision.periode.substr(5)) -1].total;
				
					//si 
					if(relleMois!=null && Number(relleMois)!=Number(montant)) {
						lien= '<a href="#"'+
							'onclick="javascript:equilibrerPrevision(\''+nocompte+'\',\''+prevision.ligneid+'\')">'+
							'<img border="0" src="front/images/icone_balance_agee_detail.gif" alt="Equilibrer" title="Equilibrer"/>'+
							'</a>';
					}
				}
				ligne.append(`<td class="text-end">${lien} ${Number(montant).toFixed(2)}</td>`);
			} else {
				ligne.append('<td/>');
			}
			tabPrevisions[prevision.periode]+=Number(montant);
		}
		//cellule totale
		ligne.append('<td class="text-end recap">'+sommePrevision.toFixed(2)+'</td>');
		ligne.append('<a href="#" onclick="reporterAnneeSuivante(\''+nocompte+'\',\''+flux.fluxId+'\',\''+$('#annee').val()+'\');"><span class="oi oi-share"/></a>');
		tbody.append(ligne);

		//génération ligne réelle
		ligne = $('<tr/>');
		ligne.append('<th>'+'</th>');
		listeRelle = flux.associatedObjet[1];
		sommeRelle=0;
		for(let reelle of listeRelle.tabResult) {
			let montant = reelle.total == null ? '' : reelle.total;
			sommeRelle+=Number(montant);
			if(montant!='') {
				ligne.append('<td class="text-end">'+
					'<a href="javascript:afficheDetail(\'numeroCompte='+nocompte+'&amp;mode=mois&amp;recDate='+reelle.periode+'&amp;recFlux='+flux.fluxId+'\')">'+
						Number(montant).toFixed(2)+
					'</a></td>'	
				);
			} else {
				ligne.append('<td/>');
			}
			
			tabRelles[reelle.periode]+=Number(montant);
		}
		ligne.append('<td class="text-end recap">'+sommeRelle.toFixed(2)+'</td>');

		tbody.append(ligne);
	}

	// affichage des cumuls de prévisions
	let lignePrevision = $('<tr/>');
	lignePrevision.append('<th>Total prévisions</th>');
	let recapPrevision = 0;
	for (let mois of listeMois) {
		lignePrevision.append('<td class="text-end recap">'+tabPrevisions[mois.periode].toFixed(2)+'</td>');
		recapPrevision+=tabPrevisions[mois.periode];
	}
	lignePrevision.append('<td class="text-end recap">'+recapPrevision.toFixed(2)+'</td>');
	tbody.append(lignePrevision);
	
	// affichage des cumuls de réelles
	let ligneRelle = $('<tr/>');
	ligneRelle.append('<th>Total '+libelle+'</th>');
	let recapRelle=0;
	for (let mois of listeMois) {
		ligneRelle.append('<td class="text-end recap">'+tabRelles[mois.periode].toFixed(2)+'</td>');
		recapRelle+=tabRelles[mois.periode];
		tabTotal[mois.periode]=tabRelles[mois.periode];
	}
	ligneRelle.append('<td class="text-end recap">'+recapRelle.toFixed(2)+'</td>');
	tbody.append(ligneRelle);
	
	// affichage des différences
	let ligneDifference = $('<tr/>');
	ligneDifference.append('<th>Différence</th>');
	let recapDifference=0;
	for (let mois of listeMois) {
		ligneDifference.append('<td class="text-end recap">'+(tabRelles[mois.periode] - tabPrevisions[mois.periode]).toFixed(2)+'</td>');
		recapDifference+=tabRelles[mois.periode] - tabPrevisions[mois.periode];
	}
	ligneDifference.append('<td class="text-end recap">'+recapDifference.toFixed(2)+'</td>');
	tbody.append(ligneDifference);


	return tabTotal;
}



