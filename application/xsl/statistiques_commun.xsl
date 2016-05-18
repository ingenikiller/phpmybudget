<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="boiteDetail">
		<div id="boiteDetail" title="{$LBL.LISTEOPERATION}" style="display: none;">
			<form method="post" action="" name="recherche" id="recherche">
				<xsl:call-template name="formulaireJson"/>
				<input type="hidden" id="params" name="params"/>
			</form>
			<table class="liste" id="tableauResultat">
				<tr>
					<th>
						<xsl:value-of select="$LBL.DATE"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.LIBELLE"/>
					</th>
					<th align="center">
						<xsl:value-of select="$LBL.MONTANT"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.FLUX"/>
					</th>
				</tr>
				<xsl:apply-templates select="/root/data/ListeOperations/Operation"/>
			</table>
			
			<center>
				<xsl:call-template name="paginationJson">
					<xsl:with-param name="formulairePrincipal" select="'recherche'"/>
				</xsl:call-template>
			</center>
		</div>
	</xsl:template>
</xsl:stylesheet>
