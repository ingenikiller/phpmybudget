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
		<script language="JavaScript" src="front/js/fluxListe.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="Contenu">
		<!--p>
			<xsl:call-template name="message">
				<xsl:with-param name="label" select="$LBL.CREERNOUVEAU"/>
				<xsl:with-param name="param1" select="$LIENCREATION"/>
			</xsl:call-template>
		</p-->
		<xsl:call-template name="FluxEdition"/>
		
		<div class="row">
			<div class="col-lg-offset-2 col-lg-8">
			<fieldset>
			<form class="form-inline" method="post" name="recherche" id="recherche" onsubmit="return rechercherFlux(this);">
				<xsl:call-template name="formulaireJson"/>
				<div class="form-group">
					<label for="comptePrincipal"><xsl:value-of select="$LBL.COMPTEPRINCIPAL"/></label>
					<select class="form-control" id="comptePrincipal"/>
				</div>
				<div class="form-group">
					<label for="compteDestination"><xsl:value-of select="$LBL.COMPTEDESTINATION"/></label>
					<select class="form-control" id="compteDestination"/>
				</div>
				<button type="submit" class="btn btn-primary">Rechercher</button>
			</form>
			</fieldset>
			</div>
		</div>
		<button type="button" class="btn btn-primary" id="" name="" value="{$LBL.CREER}" onclick="editerFlux('');">
			<span class="glyphicon glyphicon-plus"/>
		</button>
		
		<table class="table table-striped table-bordered" name="tableauResultat" id="tableauResultat">
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
									<select class="form-control obligatoire" name="compteId" id="compteId" onchange="afficheFluxSelect('fluxMaitreId', $(this).val(), 'fluxMaitre=O')"/>
								</div>
							</div>
							
							<div class="form-group row">
								<label for="compteDest" class="col-sm-6 form-control-label"><xsl:value-of select="$LBL.COMPTEDESTINATION"/></label>
								<div class="col-sm-6">
									<select class="form-control" name="compteDest" id="compteDest"/>
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
									<select class="form-control" name="fluxMaitreId" id="fluxMaitreId"/>
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
							
							<div class="row">
								<div class="col-xs-4"/>
								<div class="form-group row">
									<div class="col-sm-offset-5 col-sm-5">
										<button type="submit" class="btn btn-primary">Enregristrer</button>
									</div>
								</div>
							</div>
							
							
							
						</div>
					</div>
					
					<!--table class="formulaire">
					<tr>
						<th>
							<xsl:value-of select="$LBL.FLUX"/>
						</th>
						<td>
							<input type="text" name="flux" id="flux" value="" class="obligatoire"/>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$LBL.DESCRIPTION"/>
						</th>
						<td>
							<input type="text" name="description" id="description" value=""/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.MODEDEPAIEMENTDEF"/>
						</th>
						<td>
							<xsl:call-template name="ModifSelect">
								<xsl:with-param name="Node" select="/root/paramFlow/MODPAI"/>
								<xsl:with-param name="nom" select="'modePaiementId'"/>
								<xsl:with-param name="defaultValue" select="''"/>
								<xsl:with-param name="defaultDisplay" select="''"/>
								<xsl:with-param name="class" select="'obligatoire'"/>
								<xsl:with-param name="optionVide" select="'O'"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.COMPTEPRINCIPAL"/>
						</th>
						<td>
							<select name="compteId" id="compteId" class="obligatoire" onchange="afficheFluxSelect('fluxMaitreId', $(this).val(), 'fluxMaitre=O')"/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.COMPTEDESTINATION"/>
						</th>
						<td>
							<select name="compteDest" id="compteDest"/>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$LBL.STATUTMAITRE"/>
						</th>
						<td>
							<input type="checkbox" id="fluxMaitre" name="fluxMaitre"/>
						</td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$LBL.FLUXMAITRE"/>
						</th>
						<td>
							<select name="fluxMaitreId" id="fluxMaitreId"/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.ENTREEEPARGNE"/>
						</th>
						<td>
							<input type="checkbox" name="entreeEpargne" id="entreeEpargne" value="" checked=""/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.SORTIEEPARGNE"/>
						</th>
						<td>
							<input type="checkbox" name="sortieEpargne" id="sortieEpargne" value="" checked=""/>
						</td>
					</tr>
					<tr>
						<th style="width: 266px;">
							<xsl:value-of select="$LBL.DEPENSE"/>
						</th>
						<td>
							<select name="depense" id="depense">
								<option value="O">
									<xsl:value-of select="$LBL.OUI"/>
								</option>
								<option value="N">
									<xsl:value-of select="$LBL.NON"/>
								</option>
							</select>
						</td>
					</tr>
					<tr align="center">
						<th colspan="2" rowspan="1">
							<input type="submit" class="bouton" name="valider" value="Valider"/>
						</th>
					</tr>
				</table-->
				</form>
			
		</div>
	</xsl:template>
		
</xsl:stylesheet>
