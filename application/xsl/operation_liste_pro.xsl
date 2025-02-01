<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:param name="RECRELEVE">
        <xsl:value-of select="/root/request/recNoReleve"/>
    </xsl:param>
    <xsl:template name="js.module.sheet">
        <script src="front/js/operationListe_pro.js">&#160;</script>
		<script src="front/js/jquery_opertation_edition_pro.js">&#160;</script>
    </xsl:template>
    <xsl:template name="Contenu">
		<br/>
		<div class="row">
			<input type="hidden" id="retour" name="retour"/>
			<div class="col-9">
			<div class="row">
			<aside class="col-3 formulaire">
				<form method="post" action="#" onsubmit="return rechercherOperations(this);" name="recherche" id="recherche">
					<xsl:call-template name="formulaireJson"/>
					<input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
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
					<div class="mb-3">
						<label for="solde" class="form-label">
							<xsl:value-of select="$LBL.SOLDE"/>
						</label>
						<input type="text" id="solde" name="solde" class="form-control numerique" readonly="readonly" size="8"/>
					</div>
					<div class="row mb-3">
						<label for="recDate" class="form-label">
							<xsl:value-of select="$LBL.DATE"/> - (YYYY-MM-DD)
						</label>
						<input type="text" id="recDate" name="recDate" class="form-control numerique" size="10"/>
					</div>
					<div class="mb-3">
						<label for="recFlux" class="form-label">
							<xsl:value-of select="$LBL.FLUX"/>
						</label>
						<select id="recFlux" multiple="multiple"/>
					</div>
					<div class="mb-3">
						<label for="recMontant" class="form-label">
							<xsl:value-of select="$LBL.MONTANT"/>
						</label>
						<input type="text" id="recMontant" name="recMontant" class="form-control numerique" size="8"/>
					</div>
					<br/>
				</form>
			</aside>
			<div class="col-9">
				<table class="table table-striped table-bordered" id="tableauResultat">
					<thead>
						<tr>
							<th class="text-center">
								<xsl:value-of select="$LBL.DATE"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.LIBELLE"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.MONTANT"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.MONTANTTVA"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.FLUX"/>
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
			</div>
			<div class="col-3">
				<table class="table table-stripped table-bordered">
			  	<thead>
			 		<tr>
			  			<th colspan="4" class="text-center">TVA</th>
					</tr>
				<tr>
					<th class="text-center">Mois</th>
					<th class="text-center">Payée</th>
					<th class="text-center">Perçue</th>
					<th class="text-center">Différence</th>
				</tr>
				</thead>
				<tbody id="tbodyTva"/>
			  </table>
			</div>
		</div>
		<xsl:call-template name="operationEditionPro">
			<xsl:with-param name="numeroCompte" select="$NUMEROCOMPTE"/>
		</xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
