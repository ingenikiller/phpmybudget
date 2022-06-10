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
			/*$('#mois').empty();

			var tabJson = json.racine.ListePeriodeMois.data;
			
			for(var i=0; i<tabJson.length; i++) {
				$('#mois').append(new Option(tabJson[i].periode, tabJson[i].periode, false, false));
			}*/
            affichageLignesBudget(json);
		}
	);    
}

function affichageLignesBudget(json) {
    var tableau=$('#tabListeBudget');
    tableau.empty();

    var total=0;
    var totalEncours=0;
    var tabFlux=json.racine.ListeFlux.data;
    for(var i=0; i<tabFlux.length; i++) {
        var ligne=$('<tr/>');
        ligne.append('<th>'+tabFlux[i].flux+'</th>');
        
        //
        var tabAnnee=tabFlux[i].ListeAnnees.data
        ligne.append('<td class="text-end">'+tabAnnee[0].total+'</td>');

        //
        var totalAnneePassee=Number(tabAnnee[1].total);
        ligne.append('<td class="text-end">'+tabAnnee[1].total+'</td>');
        
        //
        var actuelle = Number(tabFlux[i].ListeActuelle.data[0].montant);
        var diffEncours=totalAnneePassee-actuelle;
        
        var classeMontant= diffEncours<=0?'positif':'negatif';
        ligne.append('<td class="text-end '+classeMontant+'">'+(diffEncours).toFixed(2)+'</td>');
        totalEncours+=diffEncours;
        
        //
        ligne.append('<td class="text-end"><a href="#" onclick="editerLigne('+(tabFlux[i].ListeActuelle.data[0].lignebudgetid)+')" >'+(actuelle).toFixed(2)+'</a></td>');

        //
        var totalAnneeEnCours=Number(tabAnnee[2].total);
        
        //
        var classeMontant= (totalAnneeEnCours-actuelle)>=0?'positif':'negatif';
        ligne.append('<td class="text-end '+classeMontant+'">'+(totalAnneeEnCours-actuelle).toFixed(2)+'</td>');
        //
        ligne.append('<td class="text-end">'+totalAnneeEnCours.toFixed(2)+'</td>');
        
        
        //
        
        total+=totalAnneeEnCours-actuelle;
        

        tableau.append(ligne);
    }

    var pied=$('<tr/>');
    pied.append('<th>Total</th><td colspan=2/><td class="text-end">'+totalEncours.toFixed(2)+'</td><td/>');
    pied.append('<td class="text-end">'+total.toFixed(2)+'</td>');
    pied.append('<td/>');
    tableau.append(pied);
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