<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<!-- template js -->
	<xsl:template name="js.module.sheet">
		<script type="text/javascript" src="front/js/segments.js" charset="iso-8859-1">&#160;</script>
	</xsl:template>
	<xsl:template name="Contenu">
		<center>
			<xsl:call-template name="segmentDetailEdition"/>
			<br/>
			<table class="table table-stripedtable-bordered" name="tableSegments" id="tableSegments">
				<thead>

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
						<xsl:value-of select="$LBL.AFFICHER"/>
					</th>
					<th>
						<xsl:value-of select="$LBL.EDITER"/>
					</th>
				</tr>
				</thead>
				<tbody id="tableSegmentsListe"/>
			</table>
			<br/>
			<br/>
			<table class="table table-stripedtable-bordered" name="detail_segment" id="detail_segment">
			<thead>
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
			</thead>
				<tbody id="detail_segmentListe"/>
			</table>
			<br/>
		</center>
	</xsl:template>
</xsl:stylesheet>
