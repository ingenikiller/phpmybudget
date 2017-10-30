
$(function() {

    $("table").delegate('td','mouseover mouseleave', function(e) {
        if (e.type == 'mouseover') {
          $(this).parent().addClass("hover");
          $("colgroup").eq($(this).index()).addClass("hover");
        } else {
          $(this).parent().removeClass("hover");
          $("colgroup").eq($(this).index()).removeClass("hover");
        }
    });

});

/* Supprime les espaces de début d'une chaine de caractères */
function ltrim (s)
{
	s2 = s;
	if (s2.match(/^ +/))
	{
	  do
      {
	    s2 = s2.substring(1, s2.length)
	  }
	  while (s2.match(/^ +/))
	}
	return s2;
}

/* Supprime les espaces de fin d'une chaine de caractères */
function rtrim (s)
{
  s2 = s;
  if (s2)
  {
  	if (s2.charAt(s2.length - 1) == ' ')
	{
	  do
    {
  	    s2 = s2.substring(0, s2.length - 1)
	  }
  	  while (s2.charAt(s2.length - 1) == ' ')
	}
  }
  else
  {
    s2 = '';
  }
	return s2;
}

/* Supprime les espace de début et de fin de chaine */
function trim (s)
{
	return ltrim(rtrim(s));
}


function submitSupp(p_form) {
	document.forms[p_form].cinematic.value='delete';
	document.forms[p_form].submit();
}

/*********************************************************
 fonction de validation des formulaire
	- pForm: formulaire à valider
 *********************************************************/
function validForm(pForm) {
	for (var i=0; i < pForm.elements.length; i++) {
		var e = pForm.elements[i];
		if(e.className.indexOf("obligatoire")!=-1  && e.value =='') {
			alert('Champs obligatoire!!!');
			return false;
		}
	}
	
	return true;
}

/*function displayBloc(elt, table){
	//alert(elt.checked);
	if(elt.checked){
		document.getElementById(table).style.display='table';// !elt.display;
	} else {
		document.getElementById(table).style.display='none';
	}
}*/

/*********************************************************
 fonction gérant la navigation vers une page
	- form: formulaire de recherche
 *********************************************************/
function pagination(form) {
	var rch=$('#formPagination #rch_page').val();
	var max=$('#formPagination #max_page').val();
	if( Number(rch) > Number(max) || Number(rch)<1) {
		alert('Valeur inattendue!');
		return;
	}
	document.forms[form].elements['numeroPage'].value=rch;
	listerObjects();
	return false;
}

/*********************************************************
 fonction gérant le passage de page en page
	- form: formulaire de recherche
	- nbPage: sens de navigation
 *********************************************************/
function changePage(form, nbPage){
	var pageActuelle = $('#'+form+' #numeroPage').val();
	var maxPage = document.getElementById('max_page').value;
	
	if(nbPage == '-1' && pageActuelle==1){
		return false;
	}
	
	if(nbPage == '1' && pageActuelle==maxPage){
		return false;
	}
	
	$('#'+form+' #numeroPage').val(Number(pageActuelle) + Number(nbPage));
	document.forms[form].onsubmit();
	return false;
}

Number.prototype.nombreFormate = function (decimales, signe, separateurMilliers) {
var _sNombre = String(this), i, _sRetour = "", _sDecimales = "";
if (decimales == undefined) decimales = 2;
if (signe == undefined) signe = '.';
if (separateurMilliers == undefined) separateurMilliers = ' ';
function separeMilliers (sNombre) {
var sRetour = "";
while (sNombre.length % 3 != 0) {
sNombre = "0"+sNombre;
}
for (i = 0; i < sNombre.length; i += 3) {
if (i == sNombre.length-1) separateurMilliers = '';
sRetour += sNombre.substr(i, 3)+separateurMilliers;
}
while (sRetour.substr(0, 1) == "0") {
sRetour = sRetour.substr(1);
}
return sRetour.substr(0, sRetour.lastIndexOf(separateurMilliers));
}
if (_sNombre.indexOf('.') == -1) {
for (i = 0; i < decimales; i++) {
_sDecimales += "0";
}
_sRetour = separeMilliers(_sNombre)+signe+_sDecimales;
} else {
var sDecimalesTmp = (_sNombre.substr(_sNombre.indexOf('.')+1));
if (sDecimalesTmp.length > decimales) {
var nDecimalesManquantes = sDecimalesTmp.length - decimales;
var nDiv = 1;
for (i = 0; i < nDecimalesManquantes; i++) {
nDiv *= 10;
}
_sDecimales = Math.round(Number(sDecimalesTmp) / nDiv);
}
_sRetour = separeMilliers(_sNombre.substr(0, _sNombre.indexOf('.')))+String(signe)+_sDecimales;
}
return _sRetour;
}




