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
		source : function(requete, reponse){ // les deux arguments repr�sentent les donn�es n�cessaires au plugin
		$.ajax({
			url : 'index.php?domaine=operation&service=reclibelle', // on appelle le script JSON
				dataType : 'json', // on sp�cifie bien que le type de donn�es est en JSON
				data : {
				debLibelle : $('#libelle').val(), // on donne la cha�ne de caract�re tap�e dans le champ de recherche
				mode : 'libelleOperation',
				numeroCompte : document.getElementById('numeroCompte').value,
				maxRows : 15
			},
			success : function(donnee){
				reponse($.map(donnee[0].tabResult, function(objet){
					return objet.libelle; // on retourne cette forme de suggestion
				}));
			}
		});
	},
	minLength : 3
	});
});


/*
	Edition d'une op�ration
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
				$('#service').val('update');
				$('#operationId').val(json[0].tabResult[0].operationId);
				$('#noReleve').val(json[0].tabResult[0].noReleve);
				$('#libelle').val(json[0].tabResult[0].libelle);
				$('#montant').val(json[0].tabResult[0].montant.replace(',',''));
				$('#fluxId').val(json[0].tabResult[0].fluxId);
				$('#modePaiementId').val(json[0].tabResult[0].modePaiementId);
				$('#dateOperation').val(json[0].tabResult[0].dateOperation);

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
		$('#fluxId').val('');
		$('#modePaiementId').val('');
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
	r?initialise le formulaire de recherche pour lancer une nouvelle recherche
*/
function rechercherOperations(form){
	listerObjects();
	return false;
}

/*
	ex?cute une requ?te Json et alimente le tableau des r?sultats
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
		row.append($('<td/>').text(tabJson[i].noReleve));
		row.append($('<td/>').text(tabJson[i].dateOperation));
		row.append($('<td/>').text(tabJson[i].libelle));
		var classeMontant='';
		if(Number(tabJson[i].montant.replace(',','')) >= 0) {
			classeMontant='positif';
		} else {
			classeMontant='negatif';
		}

		row.append($('<td class="text-end '+classeMontant+'"/>').text( formatNumerique(Number(tabJson[i].montant.replace(',','')))));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerOperation(\''+ tabJson[i].nocompte +'\','+ tabJson[i].operationId +')"><span class="oi oi-pencil"/></a>'));
		row.append($('<td class="text-center"/>').append('<div href="#" class="soldeoperation" ><span class="oi oi-question-mark" noCompte="'+ tabJson[i].nocompte +'" operationId="'+ tabJson[i].operationId +'" soldeoperation="O"/></div>'));
		
		$("#tbodyResultat").append(row);
	}
	
	$( ".soldeoperation span" ).tooltip({
		track:true,
		open: function(evt, ui) {
			var elem = $(this);
			var numeroCompte = $(elem).attr('noCompte');
			var operationId = $(elem).attr('operationId');
			
			$.getJSON('index.php?domaine=operation&service=getsoldeoperation&numeroCompte='+numeroCompte+'&operationId='+operationId).always(function(resultat) {
				elem.tooltip('option', 'content', 'Solde= '+resultat[0].valeur.toFixed(2)+' ?');
			 });
		}
    });
	
	$(".soldeoperation span").mouseout(function(){
	   $(this).attr('title','Please wait...');
	   $(this).tooltip();
	   $('.ui-tooltip').hide();
	 });
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
			var nb=json[0].nbLine;
			var tabJson = json[0].tabResult;
			var i=0;
			$('#operationrecurrenteId').append(new Option("", false,false));
			for(i=0; i<nb; i++) {
				$('#operationrecurrenteId').append(new Option(tabJson[i].libelle + " " +tabJson[i].montant, tabJson[i].operationrecurrenteId, false, false));
			}
		}
	});
}
