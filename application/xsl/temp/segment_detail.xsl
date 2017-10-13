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
	<!--<xsl:variable name="CLESEG" value="/root/request/cleseg"/>-->
	<xsl:output indent="no" encoding="UTF-8" method="xml"/>
	<xsl:template match="/">
		
		<tbody style="display:table-row-group">
			<caption><xsl:value-of select="concat($LBL.SEGMENT, ' ', $CLESEG)"/></caption>
			<form method="POST" action="index.php?page=SEGMENT_M&amp;cinematic=update;display" name="modification" id="modification" onsubmit="return enregistreSegment('{$TABLEAU}',this);">	
				<xsl:choose>
					<xsl:when test="1=0">toto</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="tableauCommun"/>
					</xsl:otherwise>
				</xsl:choose>
			</form>
			<form method="POST" action="index.php?page=SEGMENT_M&amp;cinematic=create;display" onsubmit="return creerSegment('{$TABLEAU}', this)" name="NewSegment" id="NewSegment">
				<input type="hidden" id="champs" name="champs" value="Ncleseg,Ncodseg,Nlibcourt,Nliblong"/>
				<input type="hidden" name="Ncleseg" value="{$CLESEG}"/>
				<input type="hidden" name="Nnumord" value="0"/>
				<tr class="creation">
					<td>
						<input maxlength="6" size="6" name="Ncodseg" id="Ncodseg" onblur="this.value=this.value.toUpperCase();" class="obligatoire"/>
					</td>
					<td>
						<input maxlength="12" size="12" name="Nlibcourt" id="Nlibcourt" class="obligatoire"/>
					</td>
					<td>
						<input maxlength="40" size="40" name="Nliblong" id="Nliblong"/>
					</td>
					<td>
						<input type="image" border="0" src="{$IMG_ROOT}icone_creer.gif"/>
					</td>
				</tr>
			</form>
		</tbody>
		
	</xsl:template>
	
	<xsl:template name="tableauCommun">
		
		
			<input type="hidden" id="champs" name="champs" value="cleseg,codseg,libcourt,liblong"/>
			<tr>
				<th>
					<xsl:value-of select="$LBL.CLE"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.LIBCOURT"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.LIBLONG"/>
				</th>
				<th>
					<xsl:value-of select="$LBL.EDITER"/>
				</th>
			</tr>
			<xsl:apply-templates select="/root/data/Segments/Segment"/>
			<tr>
				<th colspan="4"><input type="submit" id="" name="" value="{$LBL.ENREGISTRER}"/></th>
			</tr>
		
	</xsl:template>
	
	<!-- règle générale -->
	<xsl:template match="Segment">
		<tr class="l{@index mod 2}">
			<td>
				<input type="hidden" id="cleseg-{@index}" name="cleseg-{@index}" value="{cleseg}"/>
				<input type="hidden" id="codseg-{@index}" name="codseg-{@index}" value="{codseg}"/>
				<xsl:choose>
					<xsl:when test="cleseg!='CONF'">
						<xsl:value-of select="codseg"/>
					</xsl:when>
					<xsl:otherwise>
						<a href="javascript:afficheDetail('{codseg}', 'detail_segment');" segment="{codseg}">
							<xsl:value-of select="codseg"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<input type="text" id="libcourt-{@index}" name="libcourt-{@index}" value="{libcourt}" size="12"/>
			</td>
			<td>
				<input type="text" id="liblong-{@index}" name="liblong-{@index}" value="{liblong}" size="40"/>
			</td>
			<td>
				<a href="index.php?page=SEGMENT_L&amp;cinematic=delete;display&amp;cleseg=CONF&amp;codseg={codseg}">
					<img border="0" src="{$IMG_ROOT}icone_supprimer.gif" alt="del"/>
				</a>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
