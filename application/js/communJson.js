/*********************************************************
	récupère la liste des comptes sous format Json
 *********************************************************/
function getListeComptes(fonctionSuccess){
	$.ajax({
		url: "index.php?domaine=compte&service=getliste",
		dataType: 'json',
		success: fonctionSuccess
	});
}

/*********************************************************
	récupère la liste des flux sous format Json
 *********************************************************/
function getListeFlux(params, fonctionSuccess){
	$.ajax({
		url: "index.php?domaine=flux&service=getliste",
		dataType: 'json',
		data: params,
		success: fonctionSuccess
	});
}

/*********************************************************
	récupère la liste des flux sous format Json
 *********************************************************/
function getFlux(params, fonctionSuccess){
	$.ajax({
		url: "index.php?domaine=flux&service=getone",
		dataType: 'json',
		data: params,
		success: fonctionSuccess
	});
}

/*********************************************************
	parse le tableau Json et génère le tableau graphique
 *********************************************************/
function afficheFluxSelect(nomChamp, compte, chaineParams, valeur) {
	var taille = $('#'+nomChamp+'>option').length;
	$('#'+nomChamp).empty();
	$('#'+nomChamp).append(new Option('','',true,true));
	var params = 'comptePrincipal='+compte+'&'+chaineParams;
	
	$.ajax({
		url: "index.php?domaine=flux&service=getliste",
		dataType: 'json',
		data: params,
		success: function (resultat){
			var nb=resultat[0].nbLine;
			var tabJson = resultat[0].tabResult;
			var i=0;
			for(i=0; i<nb; i++) {
				$('#'+nomChamp).append(new Option(tabJson[i].flux, tabJson[i].fluxId, false, false));
			}
		}
	});
}

function traiteRetourJSON(retour){
	retour = $.parseJSON(retour);
	if(retour[0].status=="KO"){
		alert(retour[0].message);
	}
	return false;
}
