<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="commun.xsl"/>
<xsl:template match="/">
<html>
<xsl:call-template name="Header">
	<xsl:with-param name="HeadTitre">Application test</xsl:with-param>
</xsl:call-template>
<body>

<div id="menu">
	<br/>
	
	<br/>
	<a href="index.php?page=GEN_TABLES&amp;cinematic=create" target="accueil_contenu">Interpréteur SQL</a>
	<br/>
	<br/>
	
</div>
	
</body>
</html>
</xsl:template>
</xsl:stylesheet>