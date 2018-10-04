<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:variable name="LIENCREATION">
		<a href="javascript:editerFlux('')">
			<xsl:value-of select="$LBL.FLUX"/>
		</a>
	</xsl:variable>
	<xsl:template name="js.module.sheet">
		<script src="front/js/fluxListe.js">&#160;</script>
	</xsl:template>
	<xsl:template name="Contenu">
		<br/>
		<div class="row">
			<aside class="col formulaire">
				<form method="post" name="recherche" id="recherche" onsubmit="return rechercherFlux(this);">
					<br/>
					<xsl:call-template name="formulaireJson"/>
					<div class="btn-toolbar justify-content-between" role="toolbar" aria-label="Toolbar with button groups">
						<div class="btn-group" role="group" aria-label="First group">
							<button type="submit" class="btn btn-primary">Rechercher</button>
						</div>
						<div class="btn-group" role="group" aria-label="Third group" style="float:right;">
							<button type="button" class="btn btn-primary" id="editerFlux" name="editerFlux" onclick="editerFlux('');" style="font-size:20px;">
								<span class="oi oi-plus"/>
							</button>
						</div>
					</div>
					<div class="form-group">
						<label for="comptePrincipal" class="form-control-label">
							<xsl:value-of select="$LBL.COMPTEPRINCIPAL"/>
						</label>
						<select class="form-control" id="comptePrincipal">&#160;</select>
					</div>
					<div class="form-group">
						<label for="compteDestination" class="form-control-label">
							<xsl:value-of select="$LBL.COMPTEDESTINATION"/>
						</label>
						<select class="form-control" id="compteDestination">&#160;</select>
					</div>
				</form>
				<br/>
			</aside>
			<div class="col-10">
				<table class="table table-striped table-bordered" id="tableauResultat">
					<thead>
						<tr class="entete">
							<th>
								<xsl:value-of select="$LBL.FLUX"/>
							</th>
							<th>
								<xsl:value-of select="$LBL.DESCRIPTION"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.COMPTEPRINCIPAL"/>
							</th>
							<th class="text-center">
								<xsl:value-of select="$LBL.COMPTEDESTINATION"/>
							</th>
							<th colspan="2" class="text-center">
								<xsl:value-of select="$LBL.ACTIONS"/>
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
		<xsl:call-template name="FluxEdition"/>
	</xsl:template>
	<xsl:template name="FluxEdition">
		<div id="boiteFlux" title="{$LBL.EDITIONFLUX}" style="display: none;">
			<form method="POST" action="#" onsubmit="return enregistreFlux(this);" name="operation" id="operation">
				<input type="hidden" name="service" id="service"/>
				<input type="hidden" name="fluxId" id="fluxId"/>
				
				<div class="container popup_operation">
					<div class="col-lg-12">
						<div class="form-group row">
							<label for="flux" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.FLUX"/></label>
							<div class="col-sm-6">
								<input class="form-control obligatoire" type="text" name="flux" id="flux"/>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="description" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.DESCRIPTION"/></label>
							<div class="col-sm-6">
								<input class="form-control" type="text" name="description" id="description"/>
							</div>
						</div>
					
						<div class="form-group row">
							<label for="modePaiementId" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.MODEDEPAIEMENTDEF"/></label>
							<div class="col-sm-6">
								<xsl:call-template name="ModifSelect">
									<xsl:with-param name="value" select="/root/data/Operation/modePaiementId"/>
									<xsl:with-param name="Node" select="/root/paramFlow/MODPAI"/>
									<xsl:with-param name="nom" select="'modePaiementId'"/>
									<xsl:with-param name="defaultValue" select="''"/>
									<xsl:with-param name="defaultDisplay" select="'obligatoire'"/>
									<xsl:with-param name="optionVide" select="'O'"/>
								</xsl:call-template>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="compteId" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.COMPTEPRINCIPAL"/></label>
							<div class="col-sm-6">
								<select class="form-control obligatoire" name="compteId" id="compteId" onchange="afficheFluxSelect('fluxMaitreId', $(this).val(), 'fluxMaitre=O')">&#160;</select>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="compteDest" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.COMPTEDESTINATION"/></label>
							<div class="col-sm-6">
								<select class="form-control" name="compteDest" id="compteDest">&#160;</select>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="fluxMaitre" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.STATUTMAITRE"/></label>
							<div class="col-sm-6">
								<input class="form-control form-control-checkbox" type="checkbox" id="fluxMaitre" name="fluxMaitre"/>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="fluxMaitreId" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.FLUXMAITRE"/></label>
							<div class="col-sm-6">
								<select class="form-control" name="fluxMaitreId" id="fluxMaitreId">&#160;</select>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="entreeEpargne" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.ENTREEEPARGNE"/></label>
							<div class="col-sm-6">
								<input class="form-control form-control-checkbox" type="checkbox" id="entreeEpargne" name="entreeEpargne"/>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="sortieEpargne" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.SORTIEEPARGNE"/></label>
							<div class="col-sm-6">
								<input class="form-control form-control-checkbox" type="checkbox" id="sortieEpargne" name="sortieEpargne"/>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="depense" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.DEPENSE"/></label>
							<div class="col-sm-6">
								<select class="form-control" name="depense" id="depense">
									<option value="O">
										<xsl:value-of select="$LBL.OUI"/>
									</option>
									<option value="N">
										<xsl:value-of select="$LBL.NON"/>
									</option>
								</select>
							</div>
						</div>
						
						<div class="row justify-content-md-center">
							<button type="submit" class="btn btn-primary">Enregristrer</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</xsl:template>
		
</xsl:stylesheet>
