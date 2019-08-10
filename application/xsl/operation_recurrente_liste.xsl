<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:template name="js.module.sheet">
        <script src="front/js/operation_recurrente.js">&#160;</script>
    </xsl:template>
    <xsl:template name="Contenu">
		<br/>
		<div class="row">
			<input type="hidden" id="retour" name="retour"/>
			<form method="post" action="#" onsubmit="return rechercherOperations(this);" name="recherche" id="recherche">
				<xsl:call-template name="formulaireJson"/>
				<input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
				<aside class="col formulaire">
					<br/>
					<div class="btn-toolbar justify-content-between" role="toolbar" aria-label="Toolbar with button groups">
						<div class="btn-group" role="group" aria-label="First group">
							<button type="submit" class="btn btn-primary">Rechercher</button>
						</div>
  
						<div class="btn-group" role="group" aria-label="Third group" style="float:right;">
							<button type="button" class="btn btn-primary" id="editerOperationBtn" name="editerOperationBtn" onclick="editerOperation('{$NUMEROCOMPTE}','');" style="font-size:20px;">
								<span class="oi oi-plus">&#160;</span>
							</button>
						</div>
					</div>
					<div class="form-group">
						<label for="recFlux" class="form-control-label">
							<xsl:value-of select="$LBL.FLUX"/>
						</label>
						<select name="recFlux" id="recFlux" class="form-control" multiple="multiple">&#160;</select>
					</div>
					<div class="form-group">
						<label for="recMontant" class="form-control-label">
							<xsl:value-of select="$LBL.MONTANT"/>
						</label>
						<input type="text" id="recMontant" name="recMontant" class="form-control numerique" size="8"/>
					</div>
					<br/>
				</aside>
			</form>
			<div class="col-10">
				<table class="table table-striped table-bordered" id="tableauResultat">
					<thead>
						<tr>
							<th class="text-center">
								<xsl:value-of select="$LBL.LIBELLE"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.FLUX"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.MONTANT"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.ACTION"/>
							</th>
						</tr>
					</thead>
					<tbody id="tbodyResultat"/>
				</table>
				<xsl:call-template name="paginationJson">
					<xsl:with-param name="formulairePrincipal" select="'recherche'"/>
				</xsl:call-template>
			</div>
		</div>
		<xsl:call-template name="operationRecurrenteEdition">
			<xsl:with-param name="numeroCompte" select="$NUMEROCOMPTE"/>
		</xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
