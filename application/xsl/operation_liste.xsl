<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:param name="RECRELEVE">
        <xsl:value-of select="/root/request/recNoReleve"/>
    </xsl:param>
    <!--xsl:param name="RECFLUX">
        <xsl:value-of select="/root/request/recFlux"/>
    </xsl:param-->
    <xsl:template name="js.module.sheet">
        <script language="JavaScript" src="application/js/operationListe.js" type="text/javascript"/>
        <script language="JavaScript" src="application/js/jquery_opertation_edition.js" type="text/javascript"/>
    </xsl:template>
    <xsl:template name="Contenu">
      <br/>
        <div class="row">
            <div class="col-lg-offset-1 col-lg-10">
				<input type="hidden" id="retour" name="retour"/>
                <xsl:call-template name="operationEdition">
                    <xsl:with-param name="numeroCompte" select="$NUMEROCOMPTE"/>
                </xsl:call-template>
                <br/>
				<form method="POST" action="#" onsubmit="return rechercherOperations(this);" name="recherche" id="recherche" class="inline-form">
					<xsl:call-template name="formulaireJson"/>
					<input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
					<div class="search">
						<div class="container">
							<div class="row">
								<div class="col-md-10 col-md-offset-1">
									<div class="form-section">
										<div class="row">
											<div class="col-md-2 barre_recherche_element">
												<input type="text" id="recNoReleve" name="recNoReleve" class="form-control numerique barre_recherche_input" size="8" placeholder="N° rélévé"/>
											</div>
											<div class="col-md-4 barre_recherche_element">
												<!--select name="recFlux" id="recFlux" class="form-control barre_recherche_input" placeholder="Flux">
												</select-->
												<div id="recFlux"></div>
											</div>
											<div class="col-md-1 barre_recherche_element">
												<div class="input-group">
													<input class="form-control" type="text" name="recDate" id="recDate" size="11" maxlength="10" placeholder="Date"/>
												</div>
											</div>
											<div class="col-md-2 barre_recherche_element">
												<input type="text" id="recMontant" name="recMontant" class="form-control numerique barre_recherche_input" size="8" placeholder="{$LBL.MONTANT}"/>
											</div>
											<div class="col-md-2 barre_recherche_element">
												<button type="submit" class="btn btn-primary right-rounded">Rechercher</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
            </div>
        </div>
        <button type="button" class="btn btn-primary" id="" name="" value="{$LBL.CREER}" onclick="editerOperation('{$NUMEROCOMPTE}','');">
            <span class="glyphicon glyphicon-plus"/>
        </button>
		<table class="table table-striped table-bordered" name="tableauResultat" id="tableauResultat">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="$LBL.NUMERORELEVE"/>
					</th>
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
					<th class="text-center">
						<xsl:value-of select="$LBL.VERIFICATION"/>
					</th>
					<th class="text-center">
						<xsl:value-of select="$LBL.ACTION"/>
					</th>
				</tr>
			</thead>
			<tbody id="tbodyResultat"/>
		</table>
        <br/>

        <xsl:call-template name="paginationJson">
            <xsl:with-param name="formulairePrincipal" select="'recherche'"/>
        </xsl:call-template>

        <br/>
    </xsl:template>
</xsl:stylesheet>
