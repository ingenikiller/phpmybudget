<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="onLoadTemplate">
		<xsl:if	test="/root/user/userId!=''">
			document.location.href='index.php?domaine=compte&amp;service=getpage';
		</xsl:if>
	</xsl:template>
		
	<xsl:template name="Contenu">
		<center>
			<br/>
			<br/>
			<br/>
			<br/>
			<xsl:if test="/root/dial/messages/erreur!=''">
				<p class="erreur">
					<xsl:value-of select="/root/dial/messages/erreur"/>
				</p>
			</xsl:if>
			<form method="post" action="index.php?domaine=technique&amp;service=connexion">
				<table class="formulaire">
					<tbody>
						<tr>
							<th align="left">
								<xsl:value-of select="$LBL.LOGIN"/>
							</th>
							<td colspan="1" rowspan="1">
								<input name="nom"/>
							</td>
						</tr>
						<tr>
							<th align="left">
								<xsl:value-of select="$LBL.MOTDEPASSE"/>
							</th>
							<td colspan="1" rowspan="1">
								<input name="motDePasse" type="password"/>
							</td>
						</tr>
						<tr>
							<td colspan="2" rowspan="1" align="center">
								<input class="bouton" type="submit" value="Connexion" name="valider"/>
							</td>
						</tr>
					</tbody>
				</table>
				<br/>
				<br/>
				<br/>
			</form>
		</center>
	</xsl:template>
</xsl:stylesheet>
