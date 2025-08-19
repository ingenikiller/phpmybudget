/*********************************************************
	fonction d'initialisation
 *********************************************************/
    $(document).ready(function() {
        
            
        //
        refreshWindow();
    });
    
    /*********************************************************
	recharge la fenêtre au changement d'année
 *********************************************************/
function refreshWindow() {
	afficheListeFluxBudget();
}

function afficheListeFluxBudget() {
	var annee = $('#annee').val();
    var numeroCompte = $('#numeroCompte').val();
	$.getJSON(
		"index.php?domaine=budget&service=getliste",
		{"annee": annee,
         "numeroCompte": numeroCompte },
		function(json){
			affichageLignesBudget(json);
		}
	);    
}

function affichageLignesBudget(json) {
    var tableau=$('#tabListeBudget');
    tableau.empty();

    var totalPrevu=0;
	var bilanAnnee2=0;
	var bilanAnnee1=0;
	var bilanAnnee=0;
	var diff2=0;
	var totalAnneeEncours=0;
    var tabFlux=json.racine.ListeFlux.data;

    var anneeEncours=Number($('#annee').val());
    var numeroCompte = $('#numeroCompte').val();
    
    for(var i=0; i<tabFlux.length; i++) {
        var ligne=$('<tr/>');
        ligne.append('<th>'+tabFlux[i].flux+'</th>');
        var fluxId=tabFlux[i].fluxid;
        
		
		//Annee -2
        var tabAnnee=tabFlux[i].ListeAnnees.data
        ligne.append("<td class=\"text-end\"><a href=\"javascript:afficheDetail('numeroCompte="+numeroCompte+"&amp;mode=annee&amp;recFlux="+fluxId+"&amp;recDate="+(anneeEncours-2)+"')\">"+tabAnnee[0].total+'</a></td>');
        bilanAnnee2+=Number(tabAnnee[0].total);
        
		
		var totalAnneePassee=Number(tabAnnee[1].total);
        
        ligne.append("<td class=\"text-end\"><a href=\"javascript:afficheDetail('numeroCompte="+numeroCompte+"&amp;mode=annee&amp;recFlux="+fluxId+"&amp;recDate="+(anneeEncours-1)+"')\">"+tabAnnee[1].total+'</a></td>');
        bilanAnnee1+=totalAnneePassee;
		
		
		
		//diff en cours
        var actuelle = Number(tabFlux[i].ListeActuelle.data[0].montant);
        var diffEncours=actuelle-totalAnneePassee;
        bilanAnnee+=actuelle;
        var classeMontant= getClasseMontant(diffEncours);
        ligne.append('<td class="text-end '+classeMontant+'">'+(diffEncours).toFixed(2)+'</td>');
        bilanAnnee+=diffEncours;
        
		
		
        //prévu
        ligne.append('<td class="text-end"><a href="#" onclick="editerLigne('+(tabFlux[i].ListeActuelle.data[0].lignebudgetid)+')" >'+(actuelle).toFixed(2)+'</a></td>');
        var totalAnneeEnCours=Number(tabAnnee[2].total);
		totalPrevu+=actuelle;
		
        //diff 2
        var classeMontant= getClasseMontantInverse(totalAnneeEnCours-actuelle);
        ligne.append('<td class="text-end '+classeMontant+'">'+(totalAnneeEnCours-actuelle).toFixed(2)+'</td>');
		diff2+=(totalAnneeEnCours-actuelle);
        
		//Année en cours
        ligne.append("<td class=\"text-end\"><a href=\"javascript:afficheDetail('numeroCompte="+numeroCompte+"&amp;mode=annee&amp;recFlux="+fluxId+"&amp;recDate="+(anneeEncours)+"')\">"+totalAnneeEnCours.toFixed(2)+'</a></td>');
        totalAnneeEncours+=totalAnneeEnCours;
        
        tableau.append(ligne);
    }

    var pied=$('<tr/>');
    pied.append('<th>Total</th><td class="text-end">'+bilanAnnee2.toFixed(2)+'</td><td class="text-end">'+bilanAnnee1.toFixed(2)+'</td><td class="text-end">'+bilanAnnee.toFixed(2)+'</td>');
    pied.append('<td class="text-end">'+totalPrevu.toFixed(2)+'</td>');
    pied.append('<td class="text-end" >'+diff2.toFixed(2)+'</td><td class="text-end">'+totalAnneeEncours.toFixed(2)+'</td>');
    tableau.append(pied);
}

function getClasseMontant(montant) {
	var classeMontant= '';
	
	if(montant==0){
		classeMontant='';
	}else {
		if(montant>0){
			if(montant>300){
				classeMontant='positif';
			} else {
				classeMontant='positifproche';
			}
		} else {
			if(montant>-300){
				classeMontant='negatifproche';
			} else {
				classeMontant='negatif';
			}
		}
	}
	
	return classeMontant;
}

/**
 * Afichage de couleur suivant le montant
 *
 */
function getClasseMontantInverse(montant) {
	var classeMontant= '';
	
	if(montant==0){
		classeMontant='';
	}else {
		if(montant>0){
			if(montant>300){
				classeMontant='positif';
			} else {
				classeMontant='positifproche';
			}
		} else {
			if(montant>-300){
				classeMontant='negatifproche';
			} else {
				classeMontant='negatif';
			}
		}
	}
	
	return classeMontant;
}


function alimenteListeFluxNontraites(){
    var annee = $('#annee').val();
    var numeroCompte = $('#numeroCompte').val();
    $.getJSON(
		"index.php?domaine=budget&service=getlistefluxnontraites",
		{"annee": annee,
         "numeroCompte": numeroCompte },
		function(json){
			
            var tab =json.racine.listeFluxNonBudgetes.data;
            var input = $('#nfluxId');
            input.empty();
            for(var i=0; i<tab.length;i++) {
                input.append('<option value="'+tab[i].fluxid+'" montant="'+tab[i].montant+'">'+tab[i].flux+'     ('+tab[i].montant+')</option');
            }
            /*var myModal = new bootstrap.Modal(document.getElementById('boiteAjout'), {
				backdrop: 'static',
				keyboard: false
			});
			myModal.show();*/
		}
	);
}


function afficheBoiteAjout() {
    alimenteListeFluxNontraites();
    var myModal = new bootstrap.Modal(document.getElementById('boiteAjout'), {
        backdrop: 'static',
        keyboard: false
    });
    myModal.show();
}

function ajouterFlux() {
    var annee = $('#annee').val();
    var numeroCompte = $('#numeroCompte').val();
    var flux = $('#nfluxId').val();
    var montant = $('#nmontant').val();
    $.getJSON(
		"index.php?domaine=budget&service=ajoutflux",
		{"annee": annee,
         "numeroCompte": numeroCompte,
         "fluxId": flux,
         "montant": montant},
		function(json){
			alimenteListeFluxNontraites();
            refreshWindow();
		}
	);

    return false;
}

function alimenteMontant() {
    var montant=$('#nfluxId').find(":selected").attr('montant');
    $('#nmontant').val(montant);
}


function editerLigne(lignebudgetid) {
    $.getJSON(
		"index.php?domaine=budget&service=getone",
		{"lignebudgetid": lignebudgetid},
		function(json){
            $('#lignebudgetid').val(json.racine.Lignebudget.lignebudgetid);
            $('#mmontant').val(json.racine.Lignebudget.montant);
            var myModal = new bootstrap.Modal(document.getElementById('boiteEdition'), {
                backdrop: 'static',
                keyboard: false
            });
            myModal.show();

			/*alimenteListeFluxNontraites();
            refreshWindow();*/
		}
	);
}


function modifierFlux() {
    /*var annee = $('#annee').val();
    var numeroCompte = $('#numeroCompte').val();*/
    var lignebudgetid = $('#lignebudgetid').val();
    var montant = $('#mmontant').val();
    $.getJSON(
		"index.php?domaine=budget&service=update",
		{"lignebudgetid": lignebudgetid,
         "montant": montant},
		function(json){
			alimenteListeFluxNontraites();
            refreshWindow();
            $('#boiteEdition').modal('hide');
		}
	);

    return false;
}