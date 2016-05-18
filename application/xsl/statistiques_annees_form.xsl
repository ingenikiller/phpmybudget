<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="statistiques_commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/statistiques.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="Contenu">
		<xsl:call-template name="boiteDetail"/>
		<center>
			<a href="index.php?domaine=statistique&amp;numeroCompte={$NUMEROCOMPTE}">Retour</a><br/>
			<form method="POST" action="#" onsubmit="return soumettreRelevesAnnee(this);" name="formulaire" id="formulaire">
				<input name="numeroCompte" id="numeroCompte" type="hidden" value="{$NUMEROCOMPTE}"/>
				<table class="formulaire">
					<tr>
						<td>
							<xsl:value-of select="$LBL.PREMIEREANNEE"/>
						</td>
						<td>
							<xsl:apply-templates select="/root/data/ListeAnnee">
								<xsl:with-param name="name" select="'premiereAnnee'"/>
								<xsl:with-param name="obligatoire" select="'O'"/>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="$LBL.DERNIEREANNEE"/>
						</td>
						<td>
							<xsl:apply-templates select="/root/data/ListeAnnee">
								<xsl:with-param name="name" select="'derniereAnnee'"/>
							</xsl:apply-templates>
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td colspan="2" rowspan="1">
							<input name="valider" value="Valider" type="submit"/>
						</td>
					</tr>
				</table>
				<!--<iframe name="frame_resultat" id="frame_resultat" src="" width="100%" height="500"/>-->
				<table id="tableResultat" name="tableResultat" class="formulaire"/>
			</form>
		</center>
	</xsl:template>
	<xsl:template match="ListeAnnee">
		<xsl:param name="name"/>
		<xsl:param name="obligatoire"/>
		<select name="{$name}" id="{$name}">
			<xsl:if test="$obligatoire='O'">
				<xsl:attribute name="class">obligatoire</xsl:attribute>
			</xsl:if>
			<option/>
			<xsl:apply-templates select="Dynamic"/>
		</select>
	</xsl:template>
	<xsl:template match="Dynamic">
		<option value="{annee}">
			<xsl:value-of select="annee"/>
		</option>
	</xsl:template>
</xsl:stylesheet>
