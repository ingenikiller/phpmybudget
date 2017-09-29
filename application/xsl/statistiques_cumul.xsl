<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:param name="TYPE">
		<xsl:value-of select="/root/request/type"/>
	</xsl:param>
	<xsl:template match="/">
		<data>
			<thead>
				<tr class="enteteLigneStat">
					<th/>
					<th>
						<xsl:value-of select="$LBL.FLUX"/>
					</th>
					<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
						<th>
							<xsl:value-of select="annee"/>
						</th>
					</xsl:for-each>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="/root/data/ListeFlux/Dynamic">
					<xsl:variable name="fluxId" select="fluxId"/>
					<tr class="enteteLigneStat l{@index mod 2}">
						<th>
							<xsl:if test="fluxMaitre='O'">
								<a onclick="javascript:deplieDetail(this);" replie="O" fluxid="{$fluxId}">
									<img src="{$IMG_ROOT}ftv1plastnode.gif"/>
								</a>
							</xsl:if>
						</th>
						<!-- 
							libelle du flux
						-->
						<th>
							<xsl:value-of select="flux"/>
							<xsl:if test="operationRecurrente='checked'">(*)</xsl:if>
						</th>
						<!-- chaque noreleve -->
						<xsl:call-template name="case">
							<xsl:with-param name="fluxId" select="$fluxId"/>
						</xsl:call-template>
					</tr>
					<!--
						cas des flux fils
					-->
					<xsl:for-each select="associatedObjet/ListeFluxFils/Dynamic">
						<xsl:variable name="fluxFils" select="fluxId"/>
						<tr class="cumul" fluxid="{$fluxId}">
							<!--
								affichage de l'icone d'entete
							-->
							<td>
								<xsl:choose>
									<xsl:when test="position()=last()">
										<img src="{$IMG_ROOT}ftv2lastnode.gif"/>
									</xsl:when>
									<xsl:otherwise>
										<img src="{$IMG_ROOT}ftv2node.gif"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<!--
								nom du flux
							-->
							<td>
								<xsl:value-of select="flux"/>
							</td>
							<!--
								pour chaque année
							-->
							<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
								<xsl:variable name="annee" select="annee"/>
								<xsl:variable name="valeur" select="/root/data/ListeFlux/Dynamic[fluxId=$fluxId]/associatedObjet/ListeFluxFils/Dynamic[fluxId=$fluxFils]/associatedObjet/MontantFluxFils/Dynamic/total"/>
								<td class="text-right">
									<xsl:if test="$valeur!=''">
										<a href="javascript:afficheDetail('numeroCompte={$NUMEROCOMPTE}&amp;mode=cumal&amp;recFlux={$fluxFils}&amp;recIntervalle={annee}')">
										<xsl:value-of select="format-number($valeur,$FORMAT_MNT)"/>
										</a>
									</xsl:if>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
				</tbody>
				</data>
	</xsl:template>
	<xsl:template name="case">
		<xsl:param name="fluxId"/>
		<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
			<td class="text-right">
				<!--<xsl:if test="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total">
					<xsl:value-of select="format-number(associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total,$FORMAT_MNT)"/>
				</xsl:if>-->
				<a href="javascript:afficheDetail('numeroCompte={$NUMEROCOMPTE}&amp;mode=cumul&amp;recFlux={$fluxId}&amp;recIntervalle={annee}')">
					<xsl:if test="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total">
						<xsl:value-of select="format-number(associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total,$FORMAT_MNT)"/>
					</xsl:if>
				</a>
			</td>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
