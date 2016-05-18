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
	var jsonObjectInstance = $.parseJSON(
	    $.ajax({
	         url: "index.php?domaine=segment&service=getsegment",
	         async: false,
	         dataType: 'json',
	         data: params
	        }
	    ).responseText
	);
	
	//alert(jsonObjectInstance);
	parseListeJson(jsonObjectInstance, cleseg, idTableau);
	return false;
}

/*
	parse le tableau Json et génère le tableau
*/
function parseListeJson(json, cleseg, idTableau) {
	tab = document.getElementById(idTableau);
	$('tr[typetr='+idTableau+']').remove();
	
	var total = json[0].nbLineTotal;
	var nbpage = Math.ceil(total/json[0].nbLine);
	/*document.getElementById('numeroPage').value=json[0].page;
	document.getElementById('rch_page').value=json[0].page;
	document.getElementById('max_page').value=json[0].totalPage;*/
	//alert(cleseg);
	
	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		var row = tab.insertRow(i+1);
		row.setAttribute('typetr', idTableau)
		row.setAttribute('class', 'l'+i%2);
		
		var cell1=row.insertCell(0)
		cell1.innerHTML=tabJson[i].codseg;
		cell1.setAttribute('align', "center")
		
		var cell2 = row.insertCell(1);
		cell2.innerHTML=tabJson[i].libcourt;
		cell2.setAttribute('align', "center");
		
		var cell3 = row.insertCell(2);
		cell3.innerHTML=tabJson[i].liblong;
		
		
		
		var cell4 = row.insertCell(3);
		if (cleseg!='CONF') {
			cell4.innerHTML='<a href="#" onclick="editionDetail(\''+tabJson[i].cleseg+'\', \''+tabJson[i].codseg+'\')">Editer</a>';
		} else {
			cell4.innerHTML='<a href="#" onclick="afficheListe(\''+tabJson[i].codseg+'\', \'detail_segment\')">Lister</a>';
			var cell5=row.insertCell(4);
			cell5.innerHTML='<a href="#" onclick="editionDetail(\''+tabJson[i].cleseg+'\', \''+tabJson[i].codseg+'\')">Editer</a>';
			cell5.setAttribute('align', "center");
		}
		cell4.setAttribute('align', "center");
		
	}
}

/*************************************
	
 *************************************/
function soumettreDetail(form, tabElement) {
	if(!validForm(form)) {
		return false;
	}
	//
	//récupération du tableau de chaine
	//var tabElement = form.elements['champs'].value.split(',');
	
	//constitution de la hashmap
	var params = contitueParams(form, tabElement);
	//var params = "cle=toto";
	$.ajax({ 
	    url: "index.php?domaine=segment",
	    data: params,
	    //data: {"edition":"edition"},
	    dataType: "text",
	    async: false, 
	    success: function(retour) { 
			//afficheDetail(form.elements['Ncleseg'].value, tableau);
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
	var params = contitueParamsListe(form, tabElement);
	//var params = "cle=toto";
	$.ajax({ 
	    url: "index.php?page=SEGMENT_D&cinematic=update",
	    data: params,
	    //data: {"edition":"edition"},
	    dataType: "text",
	    async: false, 
	    success: function(retour) { 
			//alert('OK');
			//alert(retour);
			//$("detail_segment").html=retour;
			//document.getElementById('detail_segment').innerHTML=retour;
			//$('table#'+idTableau).html(retour);
			
	      return false;
	    }
	});
	
	
	
	return false;
}

/******************************
	
*******************************/
function contitueParamsListe(formulaire, tabElement) {
	var params='';
	
	for	(var i in tabElement) {
		var j=1;
		while( typeof(formulaire.elements[tabElement[i]+'-' +j]) != "undefined") {
			params += tabElement[i]+'-' +j +'='+ formulaire.elements[tabElement[i]+'-' +j].value+'&';
			j++;
		}
	}
	return params
}

function contitueParams(formulaire, tabElement) {
	var params='';
	
	//for	(var i in tabElement) {
	for (var i=0; i < formulaire.elements.length; i++) {
		
		if( typeof(formulaire.elements[i]) != "undefined") {
			params += formulaire.elements[i].id +'='+ formulaire.elements[i].value+'&';
	}
	}
	return params
}


/*************************************
	
 *************************************/
function editionDetail(cleseg, codseg){
	var largeur=420;
	var hauteur=240;

	if(codseg!='') {
		var params="&cleseg="+cleseg+"&codseg="+codseg;
	
	
		$.getJSON(
			"index.php?domaine=segment&service=getone",
			data=params,
			function(json){
				document.segmentDetailForm.service.value='update';
				document.segmentDetailForm.cleseg.value=json[0].cleseg;
				document.segmentDetailForm.codseg.value=json[0].codseg;
				document.segmentDetailForm.libcourt.value=json[0].libcourt;
				document.segmentDetailForm.liblong.value=json[0].liblong;
				
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
	//initFormOperation();
	return false;
}
