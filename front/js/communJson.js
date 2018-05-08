/*********************************************************
	récupère la liste des comptes sous format Json
 *********************************************************/
function getListeComptes(fonctionSuccess){
	//appel asynchrone de l'ajax
	$.ajax({
		url: "index.php?domaine=compte&service=getliste",
		dataType: 'json',
		success: fonctionSuccess
	});
	
	return true;
}

/*********************************************************
	alimente une combo avec la liste des compte
 *********************************************************/
function alimenteListeCompte(objetListe, compteDefaut){
 	var json = getListeComptes();
 	
 	//objetListe.options[objetListe.length] = new Option('','',true,true);
 	objetListe.append(new Option('','',true,true));
 	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		objetListe.append(new Option(tabJson[i].libelle, tabJson[i].numeroCompte, false, false));
	}
 	
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
	var params = 'comptePrincipal='+compte+'&'+chaineParams;
	$.ajax({
		url: "index.php?domaine=flux&service=getliste",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			var taille = $('#'+nomChamp+'>option').length;
			$('#'+nomChamp).empty();
			$('#'+nomChamp).append(new Option('','',true,true));
			
			//var liste = getListeFlux(params);
			var nb=resultat[0].nbLine;
			var tabJson = resultat[0].tabResult;
			var i=0;
			for(i=0; i<nb; i++) {
				$('#'+nomChamp).append(new Option(tabJson[i].flux, tabJson[i].fluxId, false, false));
			}
			$('#'+nomChamp).val(valeur);
		}
	});
}

/*********************************************************
	parse le tableau Json et génère le tableau graphique
 *********************************************************/
function afficheFluxSelectMulti(nomChamp, compte, chaineParams, valeur) {
	var params = 'comptePrincipal='+compte+'&'+chaineParams;
	$.ajax({
		url: "index.php?domaine=flux&service=getliste",
		dataType: 'json',
		data: params,
		success: function(resultat) {
			var taille = $('#'+nomChamp+'>option').length;
			$('#'+nomChamp).empty();
			//$('#'+nomChamp).append(new Option('','',true,true));
			
			//var liste = getListeFlux(params);
			var nb=resultat[0].nbLine;
			var tabJson = resultat[0].tabResult;
			var i=0;
			for(i=0; i<nb; i++) {
				$('#'+nomChamp).append(new Option(tabJson[i].flux, tabJson[i].fluxId, false, false));
			}
			
			$('#'+nomChamp).multiselect({
				columns: 1,
				placeholder: 'Sélection flux',
				search: true,
				maxHeight: 350,
				/*searchOptions: {
					'default': 'Sélection flux'
				},*/
				selectAll: true
			});
			
			
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
