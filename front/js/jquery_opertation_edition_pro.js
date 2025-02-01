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
	var champDate = document.operation.dateOperation;
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
	soumission du formulaire des op?rations
 *********************************************************/
function soumettre(form) {
	if(!validForm(form)) {
		return false;
	} 

	var dataJson=new Object();
	dataJson.noCompte= form.noCompte.value;
	dataJson.operationId= form.operationId.value;
	dataJson.noReleve= form.noReleve.value;
	dataJson.dateOperation= form.dateOperation.value;
	dataJson.libelle= form.libelle.value;
	dataJson.fluxId= form.fluxId.value;
	dataJson.modePaiementId= form.modePaiementId.value;
	dataJson.montant= form.montant.value;
	dataJson.montanttva= form.montanttva.value;
	dataJson.noncomptabilisee= $('#noncomptabilisee').is(':checked')?'1':'0';

	var service = form.service.value;
	$.ajax({
		url: "index.php?domaine=operation&service="+service,
		type: "POST",
		//contentType: 'application/json; charset=utf-8',
    	dataType: 'text',
		data: {
			operation: JSON.stringify(dataJson)
		}, 	
		success: function(retour) {
			getSoldeCompte(form.noCompte.value, 'solde');
			//si on est en création, on garde la popup ouverte, sinon, on la ferme
			if(service=='create') {
				$('#operationrecurrenteId').val('');
				form.libelle.value='';
				form.fluxId.value='';
				form.modePaiementId.value='';
				form.montant.value='';
				form.montanttva.value='0';
				
				$('#noncomptabilisee').attr('checked', false);
				form.libelle.focus();
			} else {
				$('#boiteOperation').modal('hide');
			}
			
			//maj de la liste des op?rations
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
			compte=json.racine.Comptes.solde;
			somme=json.racine.SommeOperations.data[0].total;
			total=Number(compte)+Number(somme);
			$('#'+nomChampSolde).val(total.toFixed(2));
		}
	);
}

/*********************************************************
	récupère l'ope sélectionnée et alimente les champs de 
	saisie à partir d'un appel ajax
 *********************************************************/
function getInfoOpeRec(obj) {
	var opeId=$(obj).val();
	if(opeId!='false' &&opeId!=null) {
		var params="operationrecurrenteId="+opeId+"&numeroCompte="+$('#numeroCompte').val();
		$.getJSON(
			"index.php?domaine=operationrecurrente&service=getone",
			data=params,
			function(json){
				var ope = json.racine.ListeOperationsRecurrentes.data[0];
				$('#libelle').val(ope.libelle);
				$('#fluxId').val(ope.fluxId);
				$('#modePaiementId').val(ope.modePaiementId);
				$('#montant').val(ope.montant.replace(',',''));
			}
		);
	}
}
