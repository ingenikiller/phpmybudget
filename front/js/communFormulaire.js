
var ERRINTEGER = "Le champ saisi comporte des caractères non numériques, veuillez le ressaisir SVP";

/* Contrôle sur le format chiffre
*/
function isDigit (c) 
{
	return ((c >= "0") && (c <= "9"));
}

/*
 Contrôle sur le format double avec possiblité de saisir un double négatif
*/
var errDouble = "Le champ saisi comporte des caract&egrave;res non num&eacute;riques, veuillez le ressaisir SVP";
function isDouble (s)
{
	var valeur = s.value
	if(valeur!='' && !$.isNumeric(valeur)){
		alert(ERRINTEGER);
		return false;
	}
	return true;
}

/**
 * fonction de validation des formulaire
 */
function validForm(pForm) {
	for (var i=0; i < pForm.elements.length; i++) {
		var e = pForm.elements[i];
		if((e.className.indexOf("obligatoire")!=-1 || e.className.indexOf("numerique_obligatoire")!=-1)  && e.value =='') {
			alert('Champs obligatoire!!!');
			return false;
		}
		
		if(e.className.indexOf("numerique")!=-1 || e.className.indexOf("numerique_obligatoire")!=-1) {
			if(!isDouble(e)) {
				return false;
			}
		}
	}
	return true;
}

