<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="template_name.xsl"/>
	<xsl:import href="commun.xsl"/>
	<xsl:param name="RECRELEVE">
		<xsl:value-of select="/root/request/recNoReleve"/>
	</xsl:param>
	<!--xsl:param name="RECFLUX">
		<xsl:value-of select="/root/request/recFlux"/>
	</xsl:param-->
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/operationListe.js" type="text/javascript"/>
		<script language="JavaScript" src="application/js/jquery_opertation_edition.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="Contenu">
		<input type="hidden" id="retour" name="retour"/>
		<xsl:call-template name="operationEdition">
			<xsl:with-param name="numeroCompte" select="$NUMEROCOMPTE"/>
		</xsl:call-template>
		<form method="POST" name="recherche" id="recherche" onsubmit="return rechercherOperations(this);">
			<xsl:call-template name="formulaireJson"/>
			<input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
			<table class="recherche" name="tableauRecherche" id="tableauRecherche">
				<tr>
					<th>
						<xsl:value-of select="$LBL.NUMEROCOMPTE"/>
					</th>
					<td>
						<xsl:value-of select="$NUMEROCOMPTE"/>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="$LBL.DESCRIPTION"/>
					</th>
					<td>
						<xsl:value-of select="/root/data/Comptes/libelle"/>
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="$LBL.SOLDE"/>
					</th>
					<td>
						<input type="text" id="solde" name="solde" readonly="readonly" size="8" class="numerique" />
					</td>
				</tr>
				<tr>
					<th>
						<xsl:value-of select="$LBL.NORELEVE"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.MONTANT"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.FLUX"/>
					</th>
				</tr>
				<tr>
					<td>
						<input type="text" id="recNoReleve" name="recNoReleve" size="6" maxlength="6" value="{$RECRELEVE}"/>
					</td>
					<td>
						<input type="text" id="recMontant" name="recMontant" value="{recMontant}" onchange="isDouble(this);"/>
					</td>
					<td>
						<select name="recFlux" id="recFlux"/>						
					</td>
				</tr>
				<tr>
					<td colspan="5" align="center">
						<input type="submit" class="bouton" value="Rechercher"/>
					</td>
				</tr>
			</table>
		</form>
		<input type="button" class="bouton" id="" name="" value="{$LBL.CREER}" onclick="editerOperation('{$NUMEROCOMPTE}','');"/>
		<table class="liste" name="tableauResultat" id="tableauResultat">
			<tr>
				<th align="center" width="10%">
					<xsl:value-of select="$LBL.NUMERORELEVE"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.DATE"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.LIBELLE"/>
				</th>
				<th align="center">
					<xsl:value-of select="$LBL.MONTANT"/>
				</th>
				<th align="center">
					<xsl:value-of select="$LBL.FLUX"/>
				</th>
				<th align="center">
					<xsl:value-of select="$LBL.VERIFICATION"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.EDITER"/>
				</th>
			</tr>
		</table>
		<br/>
		<center>
			<xsl:call-template name="paginationJson">
				<xsl:with-param name="formulairePrincipal" select="'recherche'"/>
			</xsl:call-template>
		</center>
		<br/>
	</xsl:template>
</xsl:stylesheet>
