<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:variable name="LIENCREATION">
		<a href="javascript:editerFlux('')">
			<xsl:value-of select="$LBL.FLUX"/>
		</a>
	</xsl:variable>
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/fluxListe.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="Contenu">
		<p>
			<xsl:call-template name="message">
				<xsl:with-param name="label" select="$LBL.CREERNOUVEAU"/>
				<xsl:with-param name="param1" select="$LIENCREATION"/>
			</xsl:call-template>
		</p>
		<xsl:call-template name="FluxEdition"/>
		<center>
			<br/>
			<form method="post" name="recherche" id="recherche" onsubmit="return rechercherFlux(this);">
				<!--input name="numeroPage" id="numeroPage" type="hidden" value="1"/-->
				<xsl:call-template name="formulaireJson"/>
				<table class="formulaire">
					<tr>
						<th>
							<xsl:value-of select="$LBL.COMPTEPRINCIPAL"/>
						</th>
						<th>
							<xsl:value-of select="$LBL.COMPTEDESTINATION"/>
						</th>
					</tr>
					<tr>
						<td>
							<select name="comptePrincipal" id="comptePrincipal"/>
						</td>
						<td>
							<select name="compteDestination" id="compteDestination"/>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="center">
							<input type="submit" class="bouton" value="Rechercher"/>
						</td>
					</tr>
				</table>
			</form>
			<table class="liste" name="tableauResultat" id="tableauResultat">
				<tr class="entete">
					<th>
						<xsl:value-of select="$LBL.FLUX"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.DESCRIPTION"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.COMPTEPRINCIPAL"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.COMPTEDESTINATION"/>
					</th>
					<th colspan="2">
						<xsl:value-of select="$LBL.ACTIONS"/>
					</th>
				</tr>
				<xsl:apply-templates select="/root/data/ListeFlux/Flux"/>
			</table>
			<br/>
			<center>
			<xsl:call-template name="paginationJson">
				<xsl:with-param name="formulairePrincipal" select="'recherche'"/>
			</xsl:call-template>
		</center>
		</center>
	</xsl:template>
	<xsl:template name="FluxEdition">
		<div id="boiteFlux" title="{$LBL.EDITIONFLUX}" style="display: none;">
			<center>
				<form method="POST" action="#" onsubmit="return enregistreFlux(this);" name="operation" id="operation">
					<input type="hidden" name="service" id="service"/>
					<input type="hidden" name="fluxId" id="fluxId"/>
					<table class="formulaire">
					<tr>
						<th>
							<xsl:value-of select="$LBL.FLUX"/>
						</th>
						<td>
							<input type="text" name="flux" id="flux" value="" class="obligatoire"/>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$LBL.DESCRIPTION"/>
						</th>
						<td>
							<input type="text" name="description" id="description" value=""/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.MODEDEPAIEMENTDEF"/>
						</th>
						<td>
							<xsl:call-template name="ModifSelect">
								<xsl:with-param name="Node" select="/root/paramFlow/MODPAI"/>
								<xsl:with-param name="nom" select="'modePaiementId'"/>
								<xsl:with-param name="defaultValue" select="''"/>
								<xsl:with-param name="defaultDisplay" select="''"/>
								<xsl:with-param name="class" select="'obligatoire'"/>
								<xsl:with-param name="optionVide" select="'O'"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.COMPTEPRINCIPAL"/>
						</th>
						<td>
							<select name="compteId" id="compteId" class="obligatoire" onchange="afficheFluxSelect('fluxMaitreId', $(this).val(), 'fluxMaitre=O')"/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.COMPTEDESTINATION"/>
						</th>
						<td>
							<select name="compteDest" id="compteDest"/>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$LBL.STATUTMAITRE"/>
						</th>
						<td>
							<input type="checkbox" id="fluxMaitre" name="fluxMaitre"/>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$LBL.FLUXMAITRE"/>
						</th>
						<td>
							<select name="fluxMaitreId" id="fluxMaitreId"/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.ENTREEEPARGNE"/>
						</th>
						<td>
							<input type="checkbox" name="entreeEpargne" id="entreeEpargne" value="" checked=""/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.SORTIEEPARGNE"/>
						</th>
						<td>
							<input type="checkbox" name="sortieEpargne" id="sortieEpargne" value="" checked=""/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.DEPENSE"/>
						</th>
						<td>
							<select name="depense" id="depense">
								<option value="O">
									<xsl:value-of select="$LBL.OUI"/>
								</option>
								<option value="N">
									<xsl:value-of select="$LBL.NON"/>
								</option>
							</select>
						</td>
					</tr>
					<tr align="center">
						<th colspan="2" rowspan="1">
							<input type="submit" class="bouton" name="valider" value="Valider"/>
						</th>
					</tr>
				</table>
				</form>
			</center>
		</div>
	</xsl:template>
		
</xsl:stylesheet>
