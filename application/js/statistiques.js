


function soumettreRelevesAnnee(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
    url: "index.php?domaine=statistique&service=statannees",
    data: { "numeroCompte": form.numeroCompte.value,
			"premiereAnnee": form.premiereAnnee.value,
			"derniereAnnee": form.derniereAnnee.value
	}, 
    async: false, 
    success: function(retour) { 
      $('table#tableResultat').html(retour);
      return false;
    } 
	});
	return false;
}

function soumettreMois(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
	    url: "index.php?domaine=statistique&service=statmois",
	    data: { "numeroCompte": form.numeroCompte.value,
				"premiereAnnee": form.premiereAnnee.value,
				"premierMois": form.premierMois.value,
				"derniereAnnee": form.derniereAnnee.value,
				"dernierMois": form.dernierMois.value
		}, 
	    async: false, 
	    success: function(retour) { 
	      $('table#tableResultat').html(retour);
	      return false;
	    }
	});
	return false;
}

function soumettreRelevesMois(form) {
	if(!validForm(form)) {
		return false;
	}
	
	$.ajax({ 
    url: "index.php?domaine=statistique&service=statreleves",
    data: { "numeroCompte": form.numeroCompte.value,
			"premierReleve": form.premierReleve.value,
			"dernierReleve": form.dernierReleve.value
	}, 
    async: false, 
    success: function(retour) { 
      $('table#tableResultat').html(retour);
      return false;
    } 
	});
	return false;
}

function afficheDetail(params){
	$('#params').val(params);
	$('#numeroPage').val(1);
	listerObjects();
	$("div#boiteDetail").dialog({
					resizable: false,
					height:750,
					width:700,
					modal: true
				});
}

/************************
	
*************************/
function listerObjects(){
	
	var params = $('#params').val();
	//appel synchrone de l'ajax
	var jsonObjectInstance = $.parseJSON(
	    $.ajax({
	         url: "index.php?domaine=operation&service=getliste",
	         async: false,
	         dataType: 'json',
	         data: $('#params').val()+'&numeroPage='+$('#numeroPage').val()
	        }
	    ).responseText
	);
	
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
		row.append($('<td/>').text(tabJson[i].date));
		row.append($('<td/>').text(tabJson[i].libelle));
		row.append($('<td class="text-right"/>').text(tabJson[i].montant.replace(',','')));
		row.append($('<td class="text-center"/>').text(tabJson[i].flux));
		$("#tbodylisteoperation").append(row);
	}
}

function deplieDetail(lien){
	var attrReplie=lien.getAttribute('replie');
	var attrRef=lien.getAttribute('fluxid');
	if(attrReplie == "O") {
		//alert(attrReplie);
		attrReplie=lien.setAttribute('replie', 'N');
		//$('tr[idAgreg='+attrRef+']').display='table-row';
		$('tr[fluxid='+attrRef+']').show('N');
	} else {
		//alert(attrReplie);
		attrReplie=lien.setAttribute('replie', 'O');
		//$('tr[idAgreg='+attrRef+']').display='none';
		$('tr[fluxid='+attrRef+']').hide('O');
	}
}
