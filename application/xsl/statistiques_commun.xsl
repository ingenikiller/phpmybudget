<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="boiteDetail">
		
		<div class="modal fade bd-example-modal-lg" tabindex="-1" id="boiteDetail" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">
							<xsl:value-of select="$LBL.LISTEOPERATION"/>
						</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
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
						</table>
						<xsl:call-template name="paginationJson">
							<xsl:with-param name="formulairePrincipal" select="'recherche'"/>
						</xsl:call-template>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="ListeAnnee">
		<xsl:param name="name"/>
		<xsl:param name="obligatoire"/>
		<select name="{$name}" id="{$name}">
			<xsl:choose>
				<xsl:when test="$obligatoire='O'">
					<xsl:attribute name="class">form-select form-select-sm obligatoire</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">form-select form-select-sm</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<option/>
			<xsl:apply-templates select="Dynamic"/>
		</select>
	</xsl:template>
	<xsl:template match="Dynamic">
		<option value="{annee}">
			<xsl:value-of select="annee"/>
		</option>
	</xsl:template>
</xsl:stylesheet>
