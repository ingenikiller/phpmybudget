<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="template_name.xsl"/>
	<xsl:import href="commun.xsl"/>
	
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/periodeListe.js" type="text/javascript"/>
		<!--script language="JavaScript" src="application/js/jquery_opertation_edition.js" type="text/javascript"/-->
	</xsl:template>
	<xsl:template name="Contenu">
		<center>
		<form method="POST" name="recherche" id="recherche" onsubmit="return rechercherOperations(this);">
			<xsl:call-template name="formulaireJson"/>
		</form>
		
		<table class="formulaire" name="tableauResultat" id="tableauResultat">
			<tr>
				<th align="center" width="10%">
					<xsl:value-of select="$LBL.ANNEES"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.NBMOIS"/>
				</th>
			</tr>
		</table>
		<br/>
		
		<form id="creationperiode" onsubmit="return creerPeriode(this);">
			<table class="formulaire">
				<tr>
					<th>
						<xsl:value-of select="$LBL.ANNEE"/>
					</th>
					<td>
						<input type="text" id="nouvelleannee" size="4" maxlength="4" class="obligatoire"/>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="{$LBL.CREER}"/>
					</td>
				</tr>
			</table>
		
		</form>
		
		<br/>
		</center>
	</xsl:template>
</xsl:stylesheet>
