/*
	chargement de la page
*/	
$(document).ready(function() {
	afficheFluxSelect('recFlux', $('#numeroCompte').val(), '');
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	getSoldeCompte($('#numeroCompte').val(), 'solde');
	listerObjects();
});

/**
	fonction d'init des zones date
*/
 $(function() {
	$( "#date" ).datepicker();
	//$( "#date" ).datepicker( "option", "dateFormat", "yyyy-mm-dd" );
	$.datepicker.regional['fr'] = {
			closeText: 'Fermer',
			prevText: '&#x3c;Préc',
			nextText: 'Suiv&#x3e;',
			currentText: 'Courant',
			monthNames: ['Janvier','F&eacute;vrier','Mars','Avril','Mai','Juin',
			'Juillet','Ao&ucirc;t','Septembre','Octobre','Novembre','D&eacute;cembre'],
			monthNamesShort: ['Jan','Fév','Mar','Avr','Mai','Jun',
			'Jul','Aoû','Sep','Oct','Nov','Déc'],
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
	édition d'une opération
*/
function editerOperation(numeroCompte, operationId){
	
	var params = "numeroCompte="+numeroCompte;
	
	var hauteur = 300;
	var largeur = 620;
	
	if(operationId!='') {
		params+="&operationId="+operationId;
	
	
		$.getJSON(
			"index.php?domaine=operation&service=getone",
			data=params,
			function(json){
				document.operation.service.value='update';
				document.operation.operationId.value=json[0].tabResult[0].operationId;
				document.operation.noReleve.value=json[0].tabResult[0].noReleve;
				document.operation.libelle.value=json[0].tabResult[0].libelle;
				document.operation.montant.value=json[0].tabResult[0].montant.replace(',','');
				document.operation.fluxId.value=json[0].tabResult[0].fluxId;
				document.operation.modePaiementId.value=json[0].tabResult[0].modePaiementId;
				document.operation.date.value=json[0].tabResult[0].date;
				
				$("div#boiteOperation").dialog({
					resizable: false,
					height:hauteur,
					width:largeur,
					modal: true
				});
			}
		);
	} else {
		document.operation.service.value='create';
		document.operation.operationId.value='';
		document.operation.noReleve.value='';
		document.operation.libelle.value='';
		document.operation.montant.value='';
		document.operation.fluxId.value='';
		document.operation.modePaiementId.value='';
		//document.operation.date.value=;
		
		$("div#boiteOperation").dialog({
			resizable: false,
			height:hauteur,
			width:largeur,
			modal: true
		});
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
	exécute une requete Json et alimente le tableau des tésultats
*/
function listerObjects(){
	
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
	
	//appel synchrone de l'ajax
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
	document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;
	
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = $('<tr typetr="operation"/>');
		row.append($('<td/>').text(tabJson[i].noReleve));
		row.append($('<td/>').text(tabJson[i].date));
		row.append($('<td/>').text(tabJson[i].libelle));
		var classeMontant='';
		if(Number(tabJson[i].montant) >= 0) {
			classeMontant='positif';
		} else {
			classeMontant='negatif';
		}
		
		row.append($('<td class="text-right '+classeMontant+'"/>').text(tabJson[i].montant.replace(',','')));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerOperation(\''+ tabJson[i].nocompte +'\','+ tabJson[i].operationId +')"><span class="glyphicon glyphicon-pencil"/></a>'));
		$("#tbodyResultat").append(row);
	}
}

