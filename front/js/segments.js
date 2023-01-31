$(document).ready(function() {
	//
	afficheListe('CONF', 'tableSegments');
});

var tabListe = 'tableSegments';
var tabSegment = 'detail_segment';


/*function afficheDetail(cleseg, idTableau) {	
	$.ajax({ 
	    url: "index.php?page=SEGMENT_D&cinematic=display",
	    data: { "edition":"edition",
	    	"cleseg":cleseg		    	
		}, 
	    async: false, 
	    success: function(retour) { 
			//fonctionne sous IE
			//var xml = $.parseXML(retour)
			//$('table#'+idTableau).html($(xml).find('tbody'));
			//
			
			var xml = $.parseXML(retour)
			$('table#'+idTableau).html(retour);
			
			return false;
	    }
	});
}*/

function afficheListe(cleseg, idTableau) {
	
	var params = "cleseg="+cleseg;
	
	//appel synchrone de l'ajax
	$.ajax({
		url: "index.php?domaine=segment&service=getsegment",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			parseListeJson(resultat, cleseg, idTableau);
		}
	});
	return false;
}

/*
	parse le tableau Json et g�n�re le tableau
*/
function parseListeJson(json, cleseg, idTableau) {
	tab = document.getElementById(idTableau);
	$('tr[typetr='+idTableau+']').remove();
	

	//var total = json[0].nbLineTotal;
	//var nbpage = Math.ceil(total/json[0].nbLine);
	/*document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;*/
	//alert(cleseg);
	
	//var nb=json[0].nbLine;
	var tabJson = json.racine.Segments.data;
	
	for(var i=0; i<tabJson.length; i++) {

		var row = $('<tr typetr="'+idTableau+'"/>');
		row.append($('<td/>').text(tabJson[i].codseg));
		row.append($('<td/>').text(tabJson[i].libcourt));
		row.append($('<td/>').text(tabJson[i].liblong));

		if (cleseg!='CONF') {
			row.append($('<td class="text-center"/>').append('<a href="#" onclick="editionDetail(\''+tabJson[i].cleseg+'\', \''+tabJson[i].codseg+'\')">Editer</a>'));
		} else {
			row.append($('<td class="text-center"/>').append('<a href="#" onclick="afficheListe(\''+tabJson[i].codseg+'\', \'detail_segment\')">Lister</a>'));
			row.append($('<td class="text-center"/>').append('<a href="#" onclick="editionDetail(\''+tabJson[i].cleseg+'\', \''+tabJson[i].codseg+'\')">Editer</a>'));
		}
		$('#'+idTableau+'Liste').append(row);
	}
}

/*************************************
	
 *************************************/
function soumettreDetail(form, tabElement) {
	if(!validForm(form)) {
		return false;
	}
		
	//constitution de la hashmap
	var params = constitueParams(form, tabElement);
	//var params = "cle=toto";
	$.ajax({ 
	    url: "index.php?domaine=segment&service="+form.service.value,
	    data: {
			segment: JSON.stringify(params)
		},
	    dataType: 'json',
	    success: function(retour) { 
			if(form.cleseg.value=='CONF'){
				afficheListe('CONF', tabListe);
			} else {
				afficheListe(form.cleseg.value, tabSegment);
			}
			$("div#boiteSegmentDetail").dialog('close');
	      return false;
	    }
	});
	return false;
}




function enregistreSegment(tableau, form) {
	if(!validForm(form)) {
		return false;
	}
	//récupération du tableau de chaine
	var tabElement = form.elements['champs'].value.split(',');
	
	//constitution de la hashmap
	var params = constitueParamsListe(form, tabElement);
	//var params = "cle=toto";
	$.ajax({ 
	    url: "index.php?page=SEGMENT_D&cinematic=update",
	    data: params,
	    //data: {"edition":"edition"},
	    dataType: "text",
	    success: function(retour) { 
			return false;
	    }
	});
	return false;
}

/******************************
	
*******************************/
/*function constitueParamsListe(formulaire, tabElement) {
	var dataJson=[];
	var params='';
	
	for	(var i in tabElement) {
		var j=1;
		var ligne = new Object();
		while( typeof(formulaire.elements[tabElement[i]+'-' +j]) != "undefined") {
			params += tabElement[i]+'-' +j +'='+ formulaire.elements[tabElement[i]+'-' +j].value+'&';
			ligne[tabElement[i]]=formulaire.elements[tabElement[i]+'-' +j].value;
			j++;
		}
		dataJson[i]=ligne;
	}
	return dataJson;
}*/

function constitueParams(formulaire, tabElement) {
	//var params='';
	var ligne = new Object();
	//for	(var i in tabElement) {
	for (var i=0; i < formulaire.elements.length; i++) {
		
		if( typeof(formulaire.elements[i]) != "undefined") {
			//params += formulaire.elements[i].id +'='+ formulaire.elements[i].value+'&';
			ligne[formulaire.elements[i].id]=formulaire.elements[i].value;
		}
	}
	return ligne
}


/*************************************
	
 *************************************/
function editionDetail(cleseg, codseg){
	var hauteur = 300;
	var largeur = 620;

	if(codseg!='') {
		var params="&cleseg="+cleseg+"&codseg="+codseg;
	
	
		$.getJSON(
			"index.php?domaine=segment&service=getone",
			data=params,
			function(json){
				var objet = json.racine.Segment;
				document.segmentDetailForm.service.value='update';
				document.segmentDetailForm.cleseg.value=objet.cleseg;
				document.segmentDetailForm.codseg.value=objet.codseg;
				document.segmentDetailForm.libcourt.value=objet.libcourt;
				document.segmentDetailForm.liblong.value=objet.liblong;
				
				$("div#boiteSegmentDetail").dialog({
					resizable: false,
					height: hauteur,
					width:largeur,
					modal: true
				});
			}
		);
	} else {
		document.segmentDetailForm.service.value='create';
		document.segmentDetailForm.cleseg.value='';
		document.segmentDetailForm.codseg.value='';
		document.segmentDetailForm.libcourt.value='';
		document.segmentDetailForm.liblong.value='';
		
		$("div#boiteSegmentDetail").dialog({
			resizable: false,
			height: hauteur,
			width: largeur,
			modal: true
		});
	}
	return false;
}
