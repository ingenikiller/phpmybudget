<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="variables.xsl"/>
	<xsl:import href="libelles.xsl"/>
	<xsl:import href="presentation.xsl"/>
	<xsl:import href="pagination.xsl"/>
	<xsl:output encoding="UTF-8"/>
	
	<!--variables de configuration-->
	<xsl:variable name="IMG_ROOT" select="'application/images/'"/>
	<!-- formats-->
	<xsl:variable name="FORMAT_MNT" select="'##0.00'"/>
	<!--conrtexte-->
	<xsl:variable name="USER">
		<xsl:value-of select="/root/user/login"/>
	</xsl:variable>
	<xsl:template name="js.module.sheet"/>
	<xsl:template name="message">
		<xsl:param name="label"/>
		<xsl:param name="param1" select="''"/>
		<xsl:param name="param2" select="''"/>
		<xsl:param name="param3" select="''"/>
		<xsl:param name="param4" select="''"/>
		<xsl:choose>
			<xsl:when test="contains($label, '@1')">
				<xsl:value-of select="substring-before($label, '@1')"/>
				<xsl:copy-of select="$param1"/>
				<xsl:variable name="part2" select="substring-after($label, '@1')"/>
				<xsl:choose>
					<xsl:when test="contains($part2, '@2')">
						<xsl:value-of select="substring-before($part2, '@2')"/>
						<xsl:copy-of select="$param2"/>
						<xsl:variable name="part22" select="substring-after($part2, '@2')"/>
						<xsl:choose>
							<xsl:when test="contains($part22, '@3')">
								<xsl:value-of select="substring-before($part22, '@3')"/>
								<xsl:copy-of select="$param3"/>
								<xsl:variable name="part222" select="substring-after($part22, '@3')"/>
								<xsl:choose>
									<xsl:when test="contains($part222, '@4')">
										<xsl:value-of select="substring-before($part222, '@4')"/>
										<xsl:copy-of select="$param4"/>
										<xsl:value-of select="substring-after($part222, '@4')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$part222"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$part22"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$part2"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$label"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
