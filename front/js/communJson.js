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
/*function alimenteListeCompte(objetListe, compteDefaut){
 	var json = getListeComptes();
 	
 	//objetListe.options[objetListe.length] = new Option('','',true,true);
 	objetListe.append(new Option('','',true,true));
 	var nb=json[0].nbLine;
	var tabJson = json[0].tabResult;
	var i=0;
	for(i=0; i<nb; i++) {
		objetListe.append(new Option(tabJson[i].libelle, tabJson[i].numeroCompte, false, false));
	}
 	
}*/

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
			var tabJson = resultat.racine.ListeFlux.data;
			var nb=tabJson.length;
			
			for(var i=0; i<nb; i++) {
				var option = new Option(tabJson[i].flux, tabJson[i].fluxId, false, false);
				option.setAttribute('compteId', tabJson[i].compteId);
				$('#'+nomChamp).append(option);
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
			
			var tabJson = resultat.racine.ListeFlux.data;
			var nb=tabJson.length;
			for(var i=0; i<nb; i++) {
				$('#'+nomChamp).append(new Option(tabJson[i].flux, tabJson[i].fluxId, false, false));
			}
			
			$('#'+nomChamp).multiselect(
				{
					includeSelectAllOption: true,
					enableFiltering: true,
					includeFilterClearBtn: false,
					maxHeight: 400,
					dropUp: true,
					widthSynchronizationMode: 'always',
					buttonWidth: '175px'
				}
			);

			/*{
				columns: 1,
				placeholder: 'Sélection flux',
				search: true,
				maxHeight: 350,
				
				selectAll: true
			}*/
			
			
		}
	});	
}

function traiteRetourJSON(retour){
	retour = $.parseJSON(retour);
	if(retour.racine.status=="KO"){
		alert(retour.racine.message);
	}
	return false;
}

/*********************************************************
	recherche le mode de règlement par défaut d'un flux
 *********************************************************/
function getModeReglementDefaut(flux, modePaiement){
	var params = '&fluxId='+flux.value;
	var fonctionSuccess = function(resultat) {
		modePaiement.value = resultat.racine.Flux.modePaiementId;
	}
	getFlux(params, fonctionSuccess);
}
