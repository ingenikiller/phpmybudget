<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:param name="CLESEG" select="/root/request/cleseg"/>
	<xsl:variable name="TABLEAU">
		<xsl:choose>
			<xsl:when test="$CLESEG = 'CONF'">tableSegments</xsl:when>
			<xsl:otherwise>detail_segment</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:output indent="no" encoding="UTF-8" method="xml"/>
	<xsl:template match="/">
		<tbody>
			<tr>
				<th>
					<xsl:value-of select="$LBL.FLUX"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<th class="text-center">
						<xsl:value-of select="periode"/>
					</th>
				</xsl:for-each>
				<th class="text-center">
					<xsl:value-of select="/root/data/Periodes/Periode[1]/annee"/>
				</th>
			</tr>
			<xsl:apply-templates select="/root/data/ListeFlux/Dynamic[depense='O']"/>
			<tr>
				<th>
					<xsl:value-of select="$LBL.TOTALPREVISIONS"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<td class="text-right recap">
						<xsl:value-of select="format-number(sum(associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/montant),$FORMAT_MNT)"/>
					</td>
				</xsl:for-each>
				<th>
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/montant),$FORMAT_MNT)"/>
				</th>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="$LBL.TOTALDEPENSES"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<td class="text-right recap">
						<xsl:value-of select="format-number(sum(associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/total),$FORMAT_MNT)"/>
					</td>
				</xsl:for-each>
				<th class="text-right">
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/total),$FORMAT_MNT)"/>
				</th>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="$LBL.DIFFERENCE"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<td class="text-right recap">
						<xsl:value-of select="format-number(sum(associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/total) - sum(associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/montant),$FORMAT_MNT)"/>
					</td>
				</xsl:for-each>
				<td class="text-right recap">
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/total) - sum(/root/data/Periodes/Periode/associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/montant),$FORMAT_MNT)"/>
				</td>
			</tr>
			<xsl:apply-templates select="/root/data/ListeFlux/Dynamic[depense!='O']"/>
			<tr>
				<th>
					<xsl:value-of select="$LBL.TOTALPREVISIONS"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<td class="text-right recap">
						<xsl:value-of select="format-number(sum(associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
					</td>
				</xsl:for-each>
				<th class="text-right">
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
				</th>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="$LBL.TOTALRECETTES"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<td class="text-right recap">
						<xsl:value-of select="format-number(sum(associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
					</td>
				</xsl:for-each>
				<th class="text-right">
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/total),$FORMAT_MNT)"/>
				</th>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="$LBL.DIFFERENCE"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<td class="text-right recap">
						<xsl:value-of select="format-number(sum(associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/total) - sum(associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
					</td>
				</xsl:for-each>
				<td  class="text-right recap">
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/total) - sum(/root/data/Periodes/Periode/associatedObjet/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
				</td>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="$LBL.TOTAL"/>
				</th>
				<xsl:for-each select="/root/data/Periodes/Periode">
					<xsl:variable name="somme" select="format-number(sum(associatedObjet/Previsions/Prevision/montant),$FORMAT_MNT)"/>
					<td>
						<xsl:choose>
							<xsl:when test="$somme &gt;= 0">
								<xsl:attribute name="class">text-right positif</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">text-right negatif</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="$somme"/>
					</td>
				</xsl:for-each>
				<td class="text-right recap">
					<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/Previsions/Prevision/montant),$FORMAT_MNT)"/>
				</td>
			</tr>
		</tbody>
	</xsl:template>
	<xsl:template match="Dynamic">
		<xsl:variable name="fluxId" select="fluxId"/>
		<tr class="l{@index mod 2}">
			<!-- libelle du flux -->
			<th rowspan="2">
				<xsl:value-of select="flux"/>
			</th>
			<!-- chaque noreleve -->
			<xsl:call-template name="case">
				<xsl:with-param name="fluxId" select="$fluxId"/>
			</xsl:call-template>
			<td class="text-right">
				<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/Previsions/Prevision[fluxId=$fluxId]/montant),$FORMAT_MNT)"/>
			</td>
		</tr>
		<tr class="l{@index mod 2}">
			<xsl:for-each select="/root/data/Periodes/Periode">
				<td class="text-right">
					<xsl:if test="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total">
						<a href="javascript:afficheDetail('numeroCompte={$NUMEROCOMPTE}&amp;mode=mois&amp;recDate={periode}&amp;recFlux={$fluxId}')">
							<xsl:value-of select="format-number(associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total,$FORMAT_MNT)"/>
						</a>
					</xsl:if>
				</td>
			</xsl:for-each>
			<td class="text-right">
				<xsl:value-of select="format-number(sum(/root/data/Periodes/Periode/associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total),$FORMAT_MNT)"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="case">
		<xsl:param name="fluxId"/>
		<xsl:for-each select="/root/data/Periodes/Periode">
			<td class="text-right ">
				<xsl:if test="associatedObjet/Previsions/Prevision[fluxId=$fluxId]/montant">
					<xsl:if test="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total!='' and number(associatedObjet/Previsions/Prevision[fluxId=$fluxId]/montant)!=number(associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total)">
						<a href="#" onclick="javascript:equilibrerPrevision('{$NUMEROCOMPTE}','{associatedObjet/Previsions/Prevision[fluxId=$fluxId]/ligneId}')">
							<img border="0" src="{$IMG_ROOT}icone_balance_agee_detail.gif" alt="{$LBL.EQUILIBRER}" title="{$LBL.EQUILIBRER}"/>
						</a>
					</xsl:if>
					<a href="#" onclick="javascript:afficheUnitaire('{$NUMEROCOMPTE}','{associatedObjet/Previsions/Prevision[fluxId=$fluxId]/ligneId}')">
						<xsl:value-of select="format-number(associatedObjet/Previsions/Prevision[fluxId=$fluxId]/montant,$FORMAT_MNT)"/>
					</a>
				</xsl:if>
			</td>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
