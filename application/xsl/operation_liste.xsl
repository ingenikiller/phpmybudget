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
            <div class="col-lg-offset-2 col-lg-8">
				<input type="hidden" id="retour" name="retour"/>
                <xsl:call-template name="operationEdition">
                    <xsl:with-param name="numeroCompte" select="$NUMEROCOMPTE"/>
                </xsl:call-template>
                <fieldset>
                    <form method="POST" action="#" onsubmit="return rechercherOperations(this);" name="recherche" id="recherche">
                        <xsl:call-template name="formulaireJson"/>
                        <input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
                        <div class="row">
                            <div class="col-xs-4">
                                <div class="form-group row">
                                    <label for="numerocompte" class="col-sm-6 form-control-label">
                                        <xsl:value-of select="$LBL.NUMEROCOMPTE"/>
                                    </label>
                                    <div class="col-sm-6">
                                        <input type="text" id="numerocompte" class="form-control" readonly="readonly"
                                               value="{$NUMEROCOMPTE}"/>
                                    </div>
                                </div>
                            </div>
							<div class="col-xs-4">
                                <div class="form-group row">
                                    <label for="description" class="col-sm-5 form-control-label">
                                        <xsl:value-of select="$LBL.DESCRIPTION"/>
                                    </label>
                                    <div class="col-sm-7">
                                        <input type="text" id="description" class="form-control" readonly="readonly"
                                               value="{/root/data/Comptes/libelle}"/>
                                    </div>
                                </div>
                            </div>
							<div class="col-xs-4">
                                <div class="form-group row">
                                    <label for="numerocompte" class="col-sm-6 form-control-label">
                                        <xsl:value-of select="$LBL.SOLDE"/>
                                    </label>
                                    <div class="col-sm-6">
                                        <input type="text" id="solde" name="solde" class="form-control numerique"
                                               readonly="readonly" size="8"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
							<div class="form-group row">
								<div class="col-xs-4">
									<label for="recDate" class="col-sm-6 form-control-label">
										<xsl:value-of select="$LBL.DATE"/> - (YYYY-MM-DD)
									</label>
									<div class="col-sm-6">
										<input type="text" id="recDate" name="recDate"
											   class="form-control numerique" size="10"/>
									</div>
								</div>
								<div class="col-xs-3">
									<label for="recMontant" class="col-sm-5 form-control-label">
										<xsl:value-of select="$LBL.MONTANT"/>
									</label>
									<div class="col-sm-7">
										<input type="text" id="recMontant" name="recMontant"
											   class="form-control numerique" size="8"/>
									</div>
								</div>
								<div class="col-xs-5">
									<label for="recFlux" class="col-sm-3 form-control-label">
										<xsl:value-of select="$LBL.FLUX"/>
									</label>
									<div class="col-sm-9">
										<select name="recFlux" id="recFlux" class="form-control"  multiple="multiple"/>
									</div>
								</div>
							</div>
                        </div>
                        <div class="row">
                            <div class="col-xs-4"/>
                            <div class="form-group row">
                                <div class="col-sm-offset-5 col-sm-5">
                                    <button type="submit" class="btn btn-primary">Rechercher</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </fieldset>
            </div>
        </div>
        <!--br/>
        <div class="row">
            <input type="hidden" id="retour" name="retour"/>
            <xsl:call-template name="operationEdition">
                <xsl:with-param name="numeroCompte" select="$NUMEROCOMPTE"/>
            </xsl:call-template>
            
            <form method="POST" action="#" onsubmit="return rechercherOperations(this);" name="recherche" id="recherche">
                <xsl:call-template name="formulaireJson"/>
                <input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
                <div class="col-lg-offset-1 col-lg-10">
                    <div class="row">
                        <div class="btn-group">
                            <button type="button" class="btn btn-primary" id="" name="" value="{$LBL.CREER}" onclick="editerOperation('{$NUMEROCOMPTE}','');">
                                <span class="glyphicon glyphicon-plus"/>
                            </button>
                        </div>
                        <div class="btn-group">
                                
                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Action <span class="caret"></span>
                            </button>
                            <div class="dropdown-menu dropdown-zone" role="zone" aria-labelledby="zone1">
                                <div class="row">
                                    <div class="col-xs-6">
                                        <label for="recDate" class="col-sm-6 form-control-label">
                                            <xsl:value-of select="$LBL.DATE"/> - (YYYY-MM-DD)
                                        </label>
                                        <input type="text" id="recDate" name="recDate" class="form-control" size="10" length="10"/>
                                    </div>
                                    <div class="col-xs-6">
                                        <label for="recNoReleve" class="col-sm-6 form-control-label">
                                            <xsl:value-of select="$LBL.NORELEVE"/>
                                        </label>
                                   
                                        <input type="text" id="recNoReleve" name="recNoReleve" class="form-control numerique" size="8"/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-xs-6">
                                        <label for="recMontant" class="col-sm-5 form-control-label">
                                            <xsl:value-of select="$LBL.MONTANT"/>
                                        </label>
                                        <input type="text" id="recMontant" name="recMontant"
                                                   class="form-control numerique" size="8"/>
                                    </div>
                                    <div class="col-xs-6">
                                        <label for="recFlux" class="col-sm-3 form-control-label">
                                            <xsl:value-of select="$LBL.FLUX"/>
                                        </label>
                                        <select name="recFlux" id="recFlux" class="form-control"/>
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        </div>
        <br/-->
		<div class="row">
			<div class="col-xs-1"/>
			<div class="col-xs-10">
				<button type="button" class="btn btn-primary" id="" name="" value="{$LBL.CREER}" onclick="editerOperation('{$NUMEROCOMPTE}','');">
					<span class="glyphicon glyphicon-plus"/>
				</button>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-1"/>
			<div class="col-xs-10">
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
								<xsl:value-of select="$LBL.ACTION"/>
							</th>
						</tr>
					</thead>
					<tbody id="tbodyResultat"/>
				</table>
			</div>
		</div>
        <br/>

        <xsl:call-template name="paginationJson">
            <xsl:with-param name="formulairePrincipal" select="'recherche'"/>
        </xsl:call-template>

        <br/>
    </xsl:template>
</xsl:stylesheet>
