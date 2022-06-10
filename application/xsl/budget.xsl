<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:param name="ANNEE">
        <xsl:choose>
            <xsl:when test="not(/root/request/annee)">
                <xsl:value-of select="substring(/root/date,1,4)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/root/request/annee"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:template name="js.module.sheet">
        <script src="front/js/budget.js">&#160;</script>
    </xsl:template>
    <xsl:template name="Contenu">
		<br/>
		<div class="row justify-content-md-center">
			<div class="col">
				<div class="col col-lg4 form-group">
					<label for="annee" class="col-sm-4 form-control-label">
						<xsl:value-of select="$LBL.ANNEE"/>
					</label>
					<div class="col-sm-2">
                        <input type="hidden" id="numeroCompte" value="{/root/request/numeroCompte}" />
						<select name="annee" id="annee" class="form-select form-select-sm" onchange="refreshWindow()">
							<xsl:apply-templates select="/root/data/ListeAnnees/Dynamic">
								<xsl:with-param name="anneeSelect" select="$ANNEE"/>
							</xsl:apply-templates>
						</select>
					</div>
				</div>
			</div>
		</div>
        <div class="row justify-content-md-center">
			<div class="col">
				<div class="col col-lg4 form-group">
                    <input type="button" onclick="afficheBoiteAjout();" value="Ajouter flux"/>
                </div>
            </div>
        </div>
        
            <table class="table table-bordered" id="liste">
            <thead>
                <tr>
                     <th>Flux</th>
                     <th>Année n-2</th>
                     <th>Année n-1</th>
                     <th>Diff</th>
                     <th>Prévu</th>
                     <th>Diff</th>
                     <th>Année en cours</th>
                </tr>
            </thead>
            <tbody id="tabListeBudget"/>
            </table>
		
        <xsl:call-template name="boitedialogueAjout"/>
        <xsl:call-template name="boitedialogueEdition"/>
    </xsl:template>
    <xsl:template match="Dynamic">
        <xsl:param name="anneeSelect"/>
        <option value="{annee}">
            <xsl:if test="annee=$anneeSelect">
                <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="annee"/>
        </option>
    </xsl:template>

    <xsl:template name="boitedialogueAjout">
        <div class="modal fade bd-example-modal-lg" tabindex="-1" id="boiteAjout" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Edition budget</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
                        <form method="POST" name="editionPrevisionUnitaire" id="editionPrevisionUnitaire" onsubmit="return ajouterFlux();">
                            <div class="container popup_operation">                  
                                <div class="form-group row">
                                    <label for="fluxId" class="col-sm-6 form-control-label">
                                        <xsl:value-of select="$LBL.FLUX"/>
                                    </label>
                                    <div class="col-sm-6">
                                        <select class="form-select form-select-sm obligatoire" name="nfluxId" id="nfluxId" tabindex="5" onchange="alimenteMontant();">&#160;</select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="fluxId" class="col-sm-6 form-control-label">
                                        <xsl:value-of select="$LBL.MONTANT"/>
                                    </label>
                                    <div class="col-sm-6">
                                        <input size="7" name="nmontant" id="nmontant" class="form-control obligatoire"
                                            onblur="return isDouble(this);" tabindex="15"/>
                                    </div>
                                </div>
                               <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Valider</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="boitedialogueEdition">
        <div class="modal fade bd-example-modal-lg" tabindex="-1" id="boiteEdition" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Edition ligne</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
                        <form method="POST" name="editionPrevisionUnitaire" id="editionPrevisionUnitaire" onsubmit="return modifierFlux();">
                            <input type="hidden" id="lignebudgetid" name="lignebudgetid"/>
                            <div class="container popup_operation">                  
                                <!--div class="form-group row">
                                    <label for="fluxId" class="col-sm-6 form-control-label">
                                        <xsl:value-of select="$LBL.FLUX"/>
                                    </label>
                                    <div class="col-sm-6">
                                        <select class="form-select form-select-sm obligatoire" name="nfluxId" id="nfluxId" tabindex="5" onchange="alimenteMontant();">&#160;</select>
                                    </div>
                                </div-->
                                <div class="form-group row">
                                    <label for="fluxId" class="col-sm-6 form-control-label">
                                        <xsl:value-of select="$LBL.MONTANT"/>
                                    </label>
                                    <div class="col-sm-6">
                                        <input size="7" name="mmontant" id="mmontant" class="form-control obligatoire"
                                            onblur="return isDouble(this);" tabindex="15"/>
                                    </div>
                                </div>
                               <div class="modal-footer">
                                    <button type="submit" class="btn btn-primary">Valider</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>





</xsl:stylesheet>
