


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
		var row = tab.insertRow(i+1);
		row.setAttribute('typetr', "operation")
		row.setAttribute('class', 'l'+i%2);
		
		var cell2 = row.insertCell(0);
		cell2.innerHTML=tabJson[i].date;
		cell2.setAttribute('align', "center");
		
		var cell3 = row.insertCell(1);
		cell3.innerHTML=tabJson[i].libelle;
		
		var cell4 = row.insertCell(2);
		var montant = Number(tabJson[i].montant);
		cell4.innerHTML=tabJson[i].montant.replace(',','');
		cell4.setAttribute('align', "center");
		
		var cell5 = row.insertCell(3);
		cell5.innerHTML=tabJson[i].flux;
		cell5.setAttribute('align', "center");
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
