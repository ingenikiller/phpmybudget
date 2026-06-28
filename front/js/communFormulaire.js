(function () {
  'use strict'

  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  var forms = document.querySelectorAll('.needs-validation')
	console.log('go');
  // Loop over them and prevent submission
  Array.prototype.slice.call(forms)
    .forEach(function (form) {
      form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }

        form.classList.add('was-validated')
      }, false)
    })
})()




var ERRINTEGER = "Le champ saisi comporte des caract�res non num�riques, veuillez le ressaisir SVP";

/* Contr�le sur le format chiffre
*/
function isDigit (c) 
{
	return ((c >= "0") && (c <= "9"));
}

/*
 Contr�le sur le format double avec possiblit� de saisir un double n�gatif
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

function controleMontant(element) {
	var value = $(element).val();
	console.log ('valeur:'+value);
	if(value!='' && !$.isNumeric(value)) {
		$(element).addClass('erreur');
	} else {
		$(element).removeClass('erreur');
	}
}