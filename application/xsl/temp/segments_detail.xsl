<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:param name="CLESEG">
		<xsl:value-of select="/root/request/cleseg"/>
	</xsl:param>
	<xsl:variable name="TITRE_TABLEAU">
		<xsl:choose>
			<xsl:when test="$CLESEG='STT'"><xsl:value-of select="$LBL.MENUSEGSTT"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$LBL.MENUSEG"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="COLSPAN">
		<xsl:choose>
			<xsl:when test="$CLESEG='STT'">7</xsl:when>
			<xsl:otherwise>5</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="js.module.sheet">
		<script type="text/javascript" src="application/js/palette.js" charset="iso-8859-1">&#160;</script>
	</xsl:template>
	<xsl:template match="/">
		<html>
			<xsl:call-template name="Header">
				<xsl:with-param name="HeadTitre">Application test</xsl:with-param>
			</xsl:call-template>
			<body>
				<br/>
				<center>
					<table class="formulaire">
						<form method="POST" action="index.php?page=SEGMENT_D" name="listeElements">
							<input type="hidden" name="cleseg" value="{$CLESEG}"/>
							<input type="hidden" name="cinematic" value="update;display"/>
							<tr>
								<xsl:call-template name="split">
									<xsl:with-param name="string">
										<xsl:value-of select="$TITRE_TABLEAU"/>
									</xsl:with-param>
								</xsl:call-template>
							</tr>
							<xsl:if test="/root/data/Segments/@total &gt; 0">
								<xsl:choose>
									<xsl:when test="$CLESEG='STT'">
										<xsl:apply-templates select="/root/data/Segments/Segment" mode="STT"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="/root/data/Segments/Segment"/>
									</xsl:otherwise>
								</xsl:choose>
								<tr>
									<td align="center" colspan="{$COLSPAN}">
										<input type="submit" name="modifier" value="Modifier"/>
									</td>
									<!--<td>
										<a href="#" onclick="submitSupp('listeElements');">
											<img border="0" src="application/images/icone_supprimer.gif" alt="del"/>
										</a>
									</td>-->
								</tr>
							</xsl:if>
						</form>
						<!-- formulaire de création -->
						<tr><td/></tr>
						<tr>
							<th colspan="{$COLSPAN +1}"><xsl:value-of select="$LBL.NOUVEAU"/></th>
						</tr>
						<xsl:call-template name="split">
									<xsl:with-param name="string">
										<xsl:value-of select="$TITRE_TABLEAU"/>
									</xsl:with-param>
								</xsl:call-template>
						<form method="POST" action="index.php?page=SEGMENT_D" onsubmit="return validForm(this)" name="creerElement">
							<input type="hidden" name="cleseg" value="{$CLESEG}"/>
							<input type="hidden" name="Ncleseg" value="{$CLESEG}"/>
							<input type="hidden" name="cinematic" value="create;display"/>
							<!--<xsl:choose>-->
								<!--<xsl:when test="$CLESEG='STT'">
									<xsl:call-template name="New">
										<xsl:with-param name="mode" value="'STT'"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="New"/>
								</xsl:otherwise>-->
								<xsl:call-template name="New">
										<xsl:with-param name="cle" select="$CLESEG"/>
									</xsl:call-template>
							<!--</xsl:choose>-->
							<!--<tr color="red">
								<td>
									<input maxlength="6" size="6" name="NCodseg" value="{NCodseg}" onblur="this.value=this.value.toUpperCase();" class="obligatoire"/>
								</td>
								<td>
									<input maxlength="12" size="12" name="NLibcourt" value="{NLibcourt}" class="obligatoire"/>
								</td>
								<td>
									<input maxlength="40" size="40" name="NLiblong" value="{NLiblong}"/>
								</td>
								<td>
									<input maxlength="2" size="2" name="NNumord" value="{NNumord}" onchange="isDouble(this);" class="obligatoire"/>
								</td>
								<td>
									<input type="image" border="0" src="application/images/icone_creer.gif"/>
								</td>
							</tr>-->
						</form>
					</table>
				</center>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="titre_tableau">
		<tr>
			<th>fd</th>
		</tr>
	</xsl:template>
	<!-- segment standard-->
	<xsl:template match="Segment">
		<tr>
			<td>
				<input type="hidden" name="cleseg-{@index}" value="{cleseg}"/>
				<input maxlength="6" size="6" name="codseg-{@index}" value="{codseg}" readonly="readonly"/>
			</td>
			<td>
				<input maxlength="12" size="12" name="libcourt-{@index}" value="{libcourt}" class="obligatoire"/>
			</td>
			<td>
				<input maxlength="40" size="40" name="liblong-{@index}" value="{liblong}"/>
			</td>
			<td>
				<input maxlength="2" size="2" name="numord-{@index}" value="{numord}" onchange="isDouble(this);"/>
			</td>
			<td>
				<!--<input type="checkbox" name="delete-{@index}"/>-->
				<a href="index.php?page=SEGMENT_D&amp;cinematic=delete;display&amp;cleseg={cleseg}&amp;codseg={codseg}">
					<img border="0" src="{$IMG_ROOT}icone_supprimer.gif" alt="del"/>
				</a>
			</td>
		</tr>
	</xsl:template>
	<!--segment STT-->
	<xsl:template match="Segment" mode="STT">
		<tr>
			<td>
				<input type="hidden" name="cleseg-{@index}" value="{cleseg}"/>
				<input maxlength="6" size="6" name="codseg-{@index}" value="{codseg}" readonly="readonly"/>
			</td>
			<td>
				<input maxlength="12" size="12" name="libcourt-{@index}" value="{libcourt}" class="obligatoire"/>
			</td>
			<td>
				<input maxlength="40" size="40" name="liblong-{@index}" value="{liblong}"/>
			</td>
			<td>
				<div id="colorpicker201" class="colorpicker201"/>
				<img src="{$IMG_ROOT}palette.gif" onclick="showColorGrid2('vcar1-{@index}','sample_{@index}');" border="0" style="cursor:pointer" alt="select color" title="select color"/>&#160;
				<input type="text" size="9" name="vcar1-{@index}" id="vcar1-{@index}" value="{vcar1}"/>&#160;
				<input type="text" id="sample_{@index}" size="1" value="">
					<xsl:attribute name="style">background-color:<xsl:value-of select="vcar1"/>;</xsl:attribute>
				</input>
			</td>
			<td>
				<input name="vcar2-{@index}" id="vcar2-{@index}" type="text" size="1" value="{vcar2}"/>
			</td>
			<td>
				<input maxlength="2" size="2" name="numord-{@index}" value="{numord}" onchange="isDouble(this);"/>
			</td>
			<td>
				<!--<input type="checkbox" name="delete-{@index}"/>-->
				<a href="index.php?page=SEGMENT_D&amp;cinematic=delete;display&amp;cleseg={cleseg}&amp;codseg={codseg}">
					<img border="0" src="{$IMG_ROOT}icone_supprimer.gif" alt="del"/>
				</a>
			</td>
		</tr>
	</xsl:template>
	<!-- template New -->
	<xsl:template name="New">
		<xsl:param name="cle"/>
		<xsl:choose>
			<xsl:when test="$cle='STT'">
				<tr color="red">
					<td>
						<input maxlength="6" size="6" name="Ncodseg" value="{NCodseg}" onblur="this.value=this.value.toUpperCase();" class="obligatoire"/>
					</td>
					<td>
						<input maxlength="12" size="12" name="Nlibcourt" value="{Nlibcourt}" class="obligatoire"/>
					</td>
					<td>
						<input maxlength="40" size="40" name="Nliblong" value="{Nliblong}"/>
					</td>
					<td>
						<div id="colorpicker201" class="colorpicker201"/>
						<img src="{$IMG_ROOT}palette.gif" onclick="showColorGrid2('Nvcar1','Nsample');" border="0" style="cursor:pointer" alt="select color" title="select color"/>&#160;
						<input type="text" size="9" name="Nvcar1" id="Nvcar1" value="{vcar1}"/>&#160;
						<input type="text" id="Nsample" size="1" value="">
							<xsl:attribute name="style">background-color:<xsl:value-of select="Nvcar1"/>;</xsl:attribute>
						</input>
					</td>
					<td>
						<input name="vcar2-{@index}" id="vcar2-{@index}" type="text" size="1" value="{vcar2}"/>
					</td>
					<td>
						<input maxlength="2" size="2" name="Nnumord" value="{Nnumord}" onchange="isDouble(this);" class="obligatoire"/>
					</td>
					<td>
						<input type="image" border="0" src="application/images/icone_creer.gif"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr color="red">
					<td>
						<input maxlength="6" size="6" name="Ncodseg" value="{NCodseg}" onblur="this.value=this.value.toUpperCase();" class="obligatoire"/>
					</td>
					<td>
						<input maxlength="12" size="12" name="Nlibcourt" value="{Nlibcourt}" class="obligatoire"/>
					</td>
					<td>
						<input maxlength="40" size="40" name="Nliblong" value="{Nliblong}"/>
					</td>
					<td>
						<input maxlength="2" size="2" name="Nnumord" value="{Nnumord}" onchange="isDouble(this);" class="obligatoire"/>
					</td>
					<td>
						<input type="image" border="0" src="application/images/icone_creer.gif"/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--template split menu-->
	<xsl:template name="split">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="contains($string,';')">
				<th>
					<xsl:value-of select="substring-before($string,';')"/>
				</th>
				<xsl:call-template name="split">
					<xsl:with-param name="string">
						<xsl:value-of select="substring-after($string,';')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<th>
					<xsl:value-of select="$string"/>
				</th>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--New-->
</xsl:stylesheet>
