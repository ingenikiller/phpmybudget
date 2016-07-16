<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="boiteDetail">
		<div id="boiteDetail" title="{$LBL.LISTEOPERATION}" style="display: none;">
			<form method="post" action="" name="recherche" id="recherche" onsubmit="listerObjects();">
				<xsl:call-template name="formulaireJson"/>
				<input type="hidden" id="params" name="params"/>
			</form>
			<table class="table table-bordered"  table-striped="" id="tableauResultat">
				<thead>
					<tr>
						<th>
							<xsl:value-of select="$LBL.DATE"/>
						</th>
						<th>
							<xsl:value-of select="$LBL.LIBELLE"/>
						</th>
						<th class="text-center">
							<xsl:value-of select="$LBL.MONTANT"/>
						</th>
						<th class="text-center">
							<xsl:value-of select="$LBL.FLUX"/>
						</th>
					</tr>
				</thead>
				<tbody id="tbodylisteoperation"/>
				<!--xsl:apply-templates select="/root/data/ListeOperations/Operation"/-->
			</table>
			
			
			<xsl:call-template name="paginationJson">
				<xsl:with-param name="formulairePrincipal" select="'recherche'"/>
			</xsl:call-template>
			
		</div>
	</xsl:template>
</xsl:stylesheet>
