<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:template match="/">
		<html>
			<xsl:call-template name="Header">
				<xsl:with-param name="HeadTitre">Application test</xsl:with-param>
			</xsl:call-template>
			<body>
				<xsl:if test="contains(/root/request/cinematic,'create')">
					<xsl:attribute name="onload">
						document.location.href='?page=UTI_M&amp;cinematic=display&amp;intervenantid=<xsl:value-of select="/root/data/Intervenants/intervenantid"/>';
					</xsl:attribute>
				</xsl:if>
				<center>
					<br/>
					<table class="formulaire">
						<tr>
							<th><xsl:value-of select="$LBL.LOGIN"/></th>
							<th colspan="2"><xsl:value-of select="$LBL.IDENTITE"/></th>
						</tr>
						<xsl:apply-templates select="/root/data/IntervenantsListe/Intervenants"/>
					</table>
					<br/>
					<xsl:call-template name="New"/>
				</center>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Intervenants">
		<tr>
			<td>
				<a href="index.php?page=UTI_M&amp;cinematic=display&amp;intervenantid={intervenantid}">
					<xsl:value-of select="login"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="prenom"/>
			</td>
			<td>
				<xsl:value-of select="nom"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="New">
		<form method="post" action="?page=UTI_L&amp;cinematic=create;display">
			<table class="formulaire">
				<tr>
					<th colspan="3"><xsl:value-of select="$LBL.NOUVELINTERVENANT"/></th>
				</tr>
				<tr>
					<th><xsl:value-of select="$LBL.PRENOM"/></th>
					<th><xsl:value-of select="$LBL.NOM"/></th>
					<th/>
				</tr>
				<tr>
					<td>
						<input name="nprenom" type="text" size="15"/>
					</td>
					<td>
						<input name="nnom" type="text" size="15"/>
					</td>
					<td>
						<input type="image" border="0" src="front/images/icone_creer.gif"/>
					</td>
				</tr>
			</table>
		</form>
	</xsl:template>
</xsl:stylesheet>
