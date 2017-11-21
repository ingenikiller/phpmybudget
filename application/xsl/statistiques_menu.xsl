<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:template name="Contenu">

			<br/>
			<br/>
			<p>
		Pour afficher les statistiques suivant les relevés sous forme de tableau, cliquer <a href="index.php?domaine=statistique&amp;service=affformreleves&amp;type=tabReleves&amp;numeroCompte={$NUMEROCOMPTE}">ici</a>
			</p>
			<br/>
			<br/>
			<p>
		Pour afficher les statistiques suivant les mois sous forme de tableau, cliquer <a href="index.php?domaine=statistique&amp;service=affformmois&amp;type=tabMois&amp;numeroCompte={$NUMEROCOMPTE}">ici</a>
			</p>
			<br/>
			<br/>
			<p>
		Pour afficher les statistiques suivant les années sous forme de tableau, cliquer <a href="index.php?domaine=statistique&amp;service=affformannees&amp;type=tabTotauxAnnuels&amp;numeroCompte={$NUMEROCOMPTE}">ici</a>
			</p>
			<br/>
			<br/>
			<p>
		Pour afficher les statistiques cumulatives, cliquer <a href="index.php?domaine=statistique&amp;service=affformcumul&amp;type=tabTotauxAnnuels&amp;numeroCompte={$NUMEROCOMPTE}">ici</a>
			</p>
			<br/>
			<br/>
			<p>
		Pour afficher les statistiques par période, cliquer <a href="index.php?domaine=statistique&amp;service=affformperiode&amp;type=tabTotauxAnnuels&amp;numeroCompte={$NUMEROCOMPTE}">ici</a>
			</p>
			<br/>
			<br/>
			<p>
		Pour afficher les comptes, cliquer <a href="index.php?domaine=statistique">ici</a>
			</p>
			<br/>
			<br/>

	</xsl:template>
</xsl:stylesheet>
