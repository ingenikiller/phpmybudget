<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
	<xsl:import href="template_name.xsl"/>
	<xsl:import href="commun.xsl"/>
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/compteEdition.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="Contenu">
		<xsl:call-template name="compteEdition"/>
		<br/>
		<br/>
		<h1>
			<xsl:value-of select="$LBL.LISTEDESCOMPTES"/>
		</h1>
		<center>
			<form name="recComptes" id="recComptes">
				<xsl:call-template name="formulaireJson"/>
			</form>
		
			<table class="liste" name="tableauResultat" id="tableauResultat">
				<tr>
					<th>
						<xsl:value-of select="$LBL.COMPTE"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.DESCRIPTION"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.SOLDEBASE"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.SOLDE"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.OPERATIONS"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.EDITER"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.STATISTIQUES"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.PREVISIONS"/>
					</th>
				</tr>
			</table>
			<xsl:call-template name="paginationJson">
				<xsl:with-param name="formulairePrincipal" select="'recComptes'"/>
			</xsl:call-template>
		</center>
		<br/>
		<br/>
		<p>Créer un <a href="javascript:editerCompte('')" class="lienNavigation">nouveau compte</a>.</p>
	</xsl:template>
</xsl:stylesheet>
