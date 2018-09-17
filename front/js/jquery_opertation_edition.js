//fonction d'initialisation
function initFormOperation() {
	//
	var service=document.operation.service.value;
	if(service=='create'){
		initFormCreation();
	}

	if(document.getElementById('dateOperation')!= null){
		document.getElementById('dateOperation').setAttribute('readonly', 'readonly');
	}

	document.operation.libelle.focus();
}

//initialisation du formulaire
function initFormCreation() {
	//
	var champNoReleve = document.operation.noReleve;
	//champ date
	var champDate = document.operation.date;
	//si le champs est vide
	if(champNoReleve.value=='') {
		var date = new Date();
		jour = date.getDate();
		champDate.value = date.dateFormat('Y-m-d');

		if(jour>7) {
			date.setMonth((date.getMonth()+1));
		}
		champNoReleve.value = date.getFullYear() + (parseInt(date.getMonth()+1) < 10 ? '0' : '')+parseInt(date.getMonth()+1);
	}
}
/*********************************************************
	soumission du formulaire des opérations
 *********************************************************/
function soumettre(form) {
	if(!validForm(form)) {
		return false;
	}

	var service = form.service.value;
	$.ajax({
		url: "index.php?domaine=operation&service="+service,
		data: { "noCompte": form.noCompte.value,
				"operationId": form.operationId.value,
				"noReleve": form.noReleve.value,
				"date": form.date.value,
				"libelle": form.libelle.value,
				"fluxId": form.fluxId.value,
				'modePaiementId': form.modePaiementId.value,
				'montant': form.montant.value
		}, 
		success: function(retour) {
			getSoldeCompte(form.noCompte.value, 'solde');
			//si on est en création, on garde la popup ouverte, sinon, on la ferme
			if(service=='create') {
				form.libelle.value='';
				form.fluxId.value='';
				form.modePaiementId.value='';
				form.montant.value='';
				form.libelle.focus();
			} else {
				$("div#boiteOperation").dialog('close');
			}
			
			//maj de la liste des opérations
			pagination('recherche');
			return false;
		}
	});
	return false;
}

/*********************************************************
	calcul le solde d'un compte et alimente un champ html
 *********************************************************/
function getSoldeCompte(numeroCompte, nomChampSolde){
	var params = "noCompte="+ numeroCompte;
	$.getJSON(
	   "index.php?domaine=compte&service=soldecompte",
	    data=params,
		function(json) {
			compte=json[0].solde;
			somme=json[1].tabResult[0].total;
			total=Number(compte)+Number(somme);
			$('#'+nomChampSolde).val(total.toFixed(2));
		}
	);
}

/*********************************************************
	recherche le mode de règlement par défaut d'un flux
 *********************************************************/
function getModeReglementDefaut(flux, modePaiement){
	var params = '&fluxId='+flux.value;
	var fonctionSuccess = function(resultat) {
		modePaiement.value = resultat[0].modePaiementId;
	}
	getFlux(params, fonctionSuccess);
}
