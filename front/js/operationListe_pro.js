/**
	chargement de la page
*/

var listeRecFlux='';

$(document).ready(function() {
	afficheFluxSelectMulti('recFlux', $('#numeroCompte').val(), '');
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	getSoldeCompte($('#numeroCompte').val(), 'solde');
	getListeOpeRecurrente($('#numeroCompte').val());
	listerObjects();
});

/**
	fonction d'init des zones date
*/
 $(function() {
	$( "#dateOperation" ).datepicker();
	$.datepicker.regional['fr'] = {
			closeText: 'Fermer',
			prevText: '&#x3c;Pr?c',
			nextText: 'Suiv&#x3e;',
			currentText: 'Courant',
			monthNames: ['Janvier','F&eacute;vrier','Mars','Avril','Mai','Juin',
			'Juillet','Ao&ucirc;t','Septembre','Octobre','Novembre','D&eacute;cembre'],
			monthNamesShort: ['Jan','F?v','Mar','Avr','Mai','Jun',
			'Jul','Ao?','Sep','Oct','Nov','D?c'],
			dayNames: ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'],
			dayNamesShort: ['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'],
			dayNamesMin: ['Di','Lu','Ma','Me','Je','Ve','Sa'],
			weekHeader: 'Sm',
			dateFormat: 'yy-mm-dd',
			firstDay: 1,
			isRTL: false,
			showMonthAfterYear: false,
			yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['fr']);
	$( "#date" ).datepicker();
	
	$( "#recDate" ).datepicker();
});

/**

*/
$(function() {
	$('#libelle').autocomplete({
		source : function(requete, reponse){ // les deux arguments représentent les données nécessaires au plugin
		$.ajax({
			url : 'index.php?domaine=operation&service=reclibelle', // on appelle le script JSON
				dataType : 'json', // on spécifie bien que le type de données est en JSON
				data : {
				debLibelle : $('#libelle').val(), // on donne la chaîne de caractère tapée dans le champ de recherche
				mode : 'libelleOperation',
				numeroCompte : document.getElementById('numeroCompte').value,
				maxRows : 15
			},
			success : function(donnee){
				reponse($.map(donnee.racine.ListeLibelles.data, function(objet){
					return objet.libelle; // on retourne cette forme de suggestion
				}));
			}
		});
	},
	minLength : 3
	});
});


/*
	Edition d'une opération
*/
function editerOperation(numeroCompte, operationId){

	var params = "numeroCompte="+numeroCompte;
	var largeur = 620;

	if(operationId!='') {
		params+="&operationId="+operationId;

		$.getJSON(
			"index.php?domaine=operation&service=getone",
			data=params,
			function(json){
				var operation = json.racine.ListeOperations.data[0];
				$('#service').val('update');
				$('#operationId').val(operation.operationId);
				$('#noReleve').val(operation.noReleve);
				$('#libelle').val(operation.libelle);
				$('#montant').val(operation.montant.replace(',',''));
				$('#montanttva').val(operation.montanttva.replace(',',''));
				$('#fluxId').val(operation.fluxId);
				if($('#fluxId').find(':selected').attr('compteid') == numeroCompte) {
					$('#fluxId').prop('disabled', false);
				} else {
					$('#fluxId').prop('disabled', true);
				}
				$('#modePaiementId').val(operation.modePaiementId);
				$('#dateOperation').val(operation.dateOperation);
				$('#noncomptabilisee').prop('checked', operation.noncomptabilisee==1?true:false);
				$("div#divOpeRec").hide();
				var myModal = new bootstrap.Modal(document.getElementById('boiteOperation'), {
					backdrop: 'static',
					keyboard: false
				});
				myModal.show();
			}
		);
	} else {
		$('#operationrecurrenteId').val('');
		$('#service').val('create');
		$('#operationId').val('');
		$('#noReleve').val('');
		$('#libelle').val('');
		$('#montant').val('');
		$('#montanttva').val('0');
		$('#fluxId').val('');
		$('#modePaiementId').val('');
		$('#noncomptabilisee').prop('checked', false);
		$("div#divOpeRec").show();
		var myModal = new bootstrap.Modal(document.getElementById('boiteOperation'), {
			backdrop: 'static',
			keyboard: false
		});
		myModal.show();
	}
	initFormOperation();
	return false;
}

/*
	réinitialise le formulaire de recherche pour lancer une nouvelle recherche
*/
function rechercherOperations(form){
	listerObjects();
	return false;
}

/*
	exécute une requête Json et alimente le tableau des résultats
*/
function listerObjects(){

	$('#numeroPage').val($.isNumeric($('#numeroPage').val())? $('#numeroPage').val():1);

	var params = "numeroCompte="+$('#numeroCompte').val()+'&numeroPage='+$('#numeroPage').val();
	if($('#recFlux').val()!='' && $('#recFlux').val()!=null) {
		params+="&recFlux="+$('#recFlux').val();
	}
	
	if($('#recDate').val()!='') {
		params+="&recDate="+$('#recDate').val();
	}
	if($('#recMontant').val()!='') {
		params+="&recMontant="+$('#recMontant').val();
	}

	//appel synchrone du service
	$.ajax({
		url: "index.php?domaine=operation&service=getliste",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			parseListeJson(resultat);
		}
	});

	afficheTVA();
	return false;
}

/*
	parse le tableau Json et génère le tableau
*/
function parseListeJson(json) {
	tab = document.getElementById('tableauResultat');
	$('tr[typetr=operation]').remove();

	var tabJson = json.racine.ListeOperations.data;
	
	var nbpage = json.racine.ListeOperations.totalPage;

	$('#numeroPage').val(json.racine.ListeOperations.page);
	$('#rch_page').val(json.racine.ListeOperations.page);
	$('#max_page').val(nbpage);
	
	for(var i=0; i<tabJson.length; i++) {
		
		var style=tabJson[i].noncomptabilisee==1?'style="background-color:yellow"':'';
		
		var row = $('<tr typetr="operation" '+style+'/>');
		//row.append($('<td class="text-center"/>').text(tabJson[i].noReleve));
		row.append($('<td class="text-center"/>').text(tabJson[i].dateOperation));
		row.append($('<td/>').text(tabJson[i].libelle));
		var classeMontant='';
		if(Number(tabJson[i].montant.replace(',','')) >= 0) {
			classeMontant='positif';
		} else {
			classeMontant='negatif';
		}

		row.append($('<td class="text-end"/>').append($('<span class="'+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].montant.replace(',',''))))));
		row.append($('<td class="text-end"/>').append($('<span class="'+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].montanttva.replace(',',''))))));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerOperation(\''+ tabJson[i].nocompte +'\','+ tabJson[i].operationId +')"><span class="oi oi-pencil"/></a>'));
		
		$("#tbodyResultat").append(row);
	}
}

function afficheTVA() {
	tab = document.getElementById('tbodyTva');
	$('tr[typetr=lignetva]').remove();

	var params = "numeroCompte="+$('#numeroCompte').val();
	
	//appel synchrone du service
	$.ajax({
		url: "index.php?domaine=operation&service=gettvamois",
		dataType: 'json',
		data: params,
		success: function(json) {
			//parseListeJson(resultat);
			var tabJson = json.racine.LigneTvaMois.data;
			for(var i=0; i<tabJson.length; i++) {
				var row = $('<tr typetr="lignetva"/>');
				row.append($('<td class="text-center"/>').text(tabJson[i].periode));
				var classeMontant='';
				row.append($('<td class="text-end"/>').append($('<span class="'+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].payee.replace(',',''))))));
				row.append($('<td class="text-end"/>').append($('<span class="'+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].collectee.replace(',',''))))));

				var diff = Number(tabJson[i].collectee.replace(',',''))+Number(tabJson[i].payee.replace(',',''));
				row.append($('<td class="text-end"/>').append($('<span class="'+classeMontant+'"/>').text( formatNumerique(diff))));
				$("#tbodyTva").append(row);
			}

		}
	});
	return false;	
}

/*********************************************************
	récupère la liste des opé récurrentes pour le compte
	en cours et alimente la combo de choix
 *********************************************************/
function getListeOpeRecurrente(numeroCompte) {
	var params = "numeroCompte="+numeroCompte;
	$.ajax({
		url: "index.php?domaine=operationrecurrente&service=getliste",
		dataType: 'json',
		data: params,
		success: function(json) {
			var tabJson = json.racine.ListeOperationsRecurrentes.data;
			var i=0;
			$('#operationrecurrenteId').append(new Option("", false,false));
			for(var i=0; i<tabJson.length; i++) {
				$('#operationrecurrenteId').append(new Option(tabJson[i].libelle + " " +tabJson[i].montant, tabJson[i].operationrecurrenteId, false, false));
			}
		}
	});
}
