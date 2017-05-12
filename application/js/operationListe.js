/*
	chargement de la page
*/

var listeRecFlux='';

$(document).ready(function() {
	//afficheFluxSelect('recFlux', $('#numeroCompte').val(), '');
	var ms = $('#recFlux').magicSuggest({
				placeholder:'Liste des flux',
				id:'testFluxId',
				data: function(q){
    var e = q || '', r=[], c = ['Paris', 'New York', 'Gotham'];

		var retour = getListeFlux('flux='+q);

    /*for(var i=0; i<c.length; i++){
      if(c[i].toLowerCase().indexOf(e.toLowerCase()) > -1)
        r.push({id: i, name: c[i]});
    }*/
    return retour[0].tabResult;
  },
				//'index.php?domaine=flux&service=getliste',
				allowFreeEntries: false,
				valueField: 'fluxId',
				displayField: 'flux'

		});

		/*$(ms).on('load', function(e,m){
  		alert('finished loading!');
			//this.setData(data[0].tabResult);
		});*/
		
	/*$(ms).on('selectionchange', function(){
		var json = this.getSelection();
		for (var i = 0; i<json.length; i++){
			if(i==0){
				listeRecFlux = json[i].fluxId;
			} else {
				listeRecFlux += ',' + json[i].fluxId;
			}
		}
		//alert(JSON.stringify(this.getSelection()));
		alert(listeRecFlux);
		
	});*/

	$(ms).on('selectionchange', function(e,m){
		listeRecFlux= this.getValue();
	});
	
	
	afficheFluxSelect('fluxId', $('#numeroCompte').val(), 'fluxMaitre=N&recFluxOperations=O');
	getSoldeCompte($('#numeroCompte').val(), 'solde');
	listerObjects();

	//$("#recFlux").customselect();
	//$("#recFlux").chosen({max_selected_options: 1});

		/*$('#recFlux').magicSuggest({
	        data: 'get_countries.php',
	        valueField: 'idCountry',
	        displayField: 'countryName'
	    });*/

});

/**
	fonction d'init des zones date
*/
 $(function() {
	$( "#date" ).datepicker();
	//$( "#date" ).datepicker( "option", "dateFormat", "yyyy-mm-dd" );
	$.datepicker.regional['fr'] = {
			closeText: 'Fermer',
			prevText: '&#x3c;Pr�c',
			nextText: 'Suiv&#x3e;',
			currentText: 'Courant',
			monthNames: ['Janvier','F&eacute;vrier','Mars','Avril','Mai','Juin',
			'Juillet','Ao�t','Septembre','Octobre','Novembre','D&eacute;cembre'],
			monthNamesShort: ['Jan','F�v','Mar','Avr','Mai','Jun',
			'Jul','Ao�','Sep','Oct','Nov','D�c'],
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
	Edition d'une opération
*/
function editerOperation(numeroCompte, operationId){

	var params = "numeroCompte="+numeroCompte;

	var hauteur = 370;
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
	r�initialise le formulaire de recherche pour lancer une nouvelle recherche
*/
function rechercherOperations(form){
	//$('#numeroPage').val(1);
	//alert('toto');
	listerObjects();
	return false;
}

/*
	exécute une requete Json et alimente le tableau des t�sultats
*/
function listerObjects(){

	var params = "numeroCompte="+$('#numeroCompte').val()+'&numeroPage='+$('#numeroPage').val();
	if(listeRecFlux!='') {
		params+="&recFlux="+listeRecFlux;
	}
	//$($('#testFluxId').magicSuggest())
	//$($('#testFluxId').magicSuggest()).getSelection();
	/*if( $('#recFlux').getSelection() != null){
			params+="&recFlux="+($('#recFlux').getSelection())[0].fluxId;
	}*/

	if($('#recNoReleve').val()!='') {
		params+="&recNoReleve="+$('#recNoReleve').val();
	}
	if($('#recDate').val()!='') {
		params+="&recDate="+$('#recDate').val();
	}
	if($('#recMontant').val()!='') {
		params+="&recMontant="+$('#recMontant').val();
	}

	//appel synchrone de l'ajax
	var jsonObjectInstance = $.parseJSON(
	    $.ajax({
	         url: "index.php?domaine=operation&service=getliste",
	         async: false,
	         dataType: 'json',
	         data: params
	        }
	    ).responseText
	);

	//alert(jsonObjectInstance);
	parseListeJson(jsonObjectInstance);
	return false;
}

/*
	parse le tableau Json et g�n�re le tableau
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
		row.append($('<td class="text-right"/>').text(tabJson[i].montant.replace(',','')));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));

		var image='';
		if(tabJson[i].verif=='checked') {
			image='checked';
		} else {
			image='unchecked';
		}
		//cell6.innerHTML='<img src="./application/images/'+image+'.jpg">';

		row.append($('<td class="text-center"/>').append('<img src="./application/images/'+image+'.jpg">'));
		row.append($('<td class="text-center"/>').append('<a href="#" onclick="editerOperation(\''+ tabJson[i].nocompte +'\','+ tabJson[i].operationId +')"><span class="glyphicon glyphicon-pencil"/></a>'));
		$("#tbodyResultat").append(row);
	}
}
