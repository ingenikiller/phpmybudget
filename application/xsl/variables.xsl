<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- version de jQuery -->
<xsl:variable name="JQUERY-VERSION" select="'1.12.0'"/>

<!-- version de Bootstrap -->
<xsl:variable name="BOOTSTRAP-VERSION" select="'3.3.7'"/>

<xsl:variable name="BLANK">application/xsl/blank.html</xsl:variable>

<xsl:variable name="UTI.DROITS">
	<xsl:value-of select="/root/user/droits"/>
</xsl:variable>

<xsl:param name="NUMEROCOMPTE">
		<xsl:value-of select="/root/request/numeroCompte"/>
</xsl:param>

</xsl:stylesheet>
