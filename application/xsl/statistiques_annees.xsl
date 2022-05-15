<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:param name="TYPE">
		<xsl:value-of select="/root/request/type"/>
	</xsl:param>
	<xsl:template match="/">
		<colgroup />
		<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
			<colgroup />
		</xsl:for-each>
		<colgroup />
	
		<thead>
		<tr class="enteteLigneStat">
			<th/>
			<th>
				<xsl:value-of select="$LBL.FLUX"/>
			</th>
			<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
				<th class="text-center">
					<xsl:value-of select="annee"/>
				</th>
			</xsl:for-each>
		</tr>
		</thead>
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
						<xsl:variable name="valeur" select="/root/data/ListeFlux/Dynamic[fluxId=$fluxId]/associatedObjet/ListeFluxFils/Dynamic[fluxId=$fluxFils]/associatedObjet/MontantFluxFils/Dynamic[date=$annee]/total"/>
						<td class="text-end">
							<xsl:if test="$valeur!=''">
								<a href="javascript:afficheDetail('numeroCompte={$NUMEROCOMPTE}&amp;mode=annee&amp;recFlux={$fluxFils}&amp;recDate={annee}')">
								<xsl:value-of select="format-number($valeur,$FORMAT_MNT)"/>
								</a>
							</xsl:if>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
		<tr>
			<th/>
			<th>   ---</th>
			<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
				<th/>
			</xsl:for-each>
		</tr>
		<tr class="l1">
			<th/>
			<th>
				<xsl:value-of select="$LBL.EPARGNE"/>
			</th>
			<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
				<td class="text-end">
					<xsl:value-of select="format-number(associatedObjet/ListeMontantEpargne/Dynamic/total,$FORMAT_MNT)"/>
				</td>
			</xsl:for-each>
		</tr>
		<tr class="l0">
			<th/>
			<th>
				<xsl:value-of select="$LBL.TOTALCREDITS"/>
			</th>
			<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
				<td class="text-end">
					<xsl:value-of select="format-number(sum(associatedObjet/ListeMontantFlux/Dynamic[total&gt;0]/total), $FORMAT_MNT)"/>
				</td>
			</xsl:for-each>
		</tr>
		<tr class="l1">
			<th/>
			<th>
				<xsl:value-of select="$LBL.TOTALDEBITS"/>
			</th>
			<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
				<td class="text-end">
					<xsl:value-of select="format-number(sum(associatedObjet/ListeMontantFlux/Dynamic[total&lt;0]/total), $FORMAT_MNT)"/>
				</td>
			</xsl:for-each>
		</tr>
		<tr class="l0">
			<th/>
			<th>
				<xsl:value-of select="$LBL.DIFFERENCE"/>
			</th>
			<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
				<xsl:variable name="difference" select="sum(associatedObjet/ListeMontantFlux/Dynamic/total)"/>
				<td class="text-end">
					<xsl:choose>
						<xsl:when test="$difference&gt;0">
							<xsl:attribute name="class">text-end positif</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">text-end negatif</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="format-number($difference, $FORMAT_MNT)"/>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>
	<xsl:template name="case">
		<xsl:param name="fluxId"/>
		<xsl:for-each select="/root/data/ListeAnnees/Dynamic">
			<td class="text-end">
				<!--<xsl:if test="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total">
					<xsl:value-of select="format-number(associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total,$FORMAT_MNT)"/>
				</xsl:if>-->
				<a href="javascript:afficheDetail('numeroCompte={$NUMEROCOMPTE}&amp;mode=annee&amp;recFlux={$fluxId}&amp;recDate={annee}')">
					<xsl:if test="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total">
						<xsl:value-of select="format-number(associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total,$FORMAT_MNT)"/>
					</xsl:if>
				</a>
			</td>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
