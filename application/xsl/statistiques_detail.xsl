<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="template_name.xsl"/>
	<xsl:import href="commun.xsl"/>
	<xsl:template match="/">
		<table class="formulaire">
			<tr>
				<td>terst</td>
			</tr>
			
			<xsl:for-each select="/root/data/ListeFlux/Dynamic">
				<xsl:variable name="fluxIdref" select="fluxId"/>
				<tr>
					<td>
						<xsl:value-of select="concat(fluxId, ' ',flux)"/>
					</td>
					<xsl:for-each select="/root/data/ListePeriodes/Dynamic">
						<td>
							f<xsl:value-of select="associatedObjet/ListeMontantFlux/Dynamic[fluxId=$fluxIdref]/total"/>
						</td>
					</xsl:for-each>
					
				</tr>
			
			
			</xsl:for-each>
			
		</table>
	</xsl:template>
</xsl:stylesheet>
