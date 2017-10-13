<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="commun.xsl"/>
<xsl:template match="/">
<html>
	<xsl:call-template name="Header">
		<xsl:with-param name="HeadTitre">Application test</xsl:with-param>
	</xsl:call-template>
	<head><title>Application</title></head><!-- ?page=TEST&amp;cinematic=display&amp;frame=accueil_banniere -->
	
	<frameset rows="30%,*" leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
		<frame name="segment_liste" src="?page=SEGMENT_L&amp;cinematic=display&amp;frame=segment_liste" noresize=""/>
		<frame name="segments_detail" src="{$BLANK}" noresize=""/>
	</frameset>
	
</html>
</xsl:template>

</xsl:stylesheet>
