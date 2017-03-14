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
                <!--fieldset-->
                    <form method="POST" action="#" onsubmit="return rechercherOperations(this);" name="recherche" id="recherche" class="inline-form">
                        <xsl:call-template name="formulaireJson"/>
                        <input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
                        <div class="search">

                                <div class="search">
                                        <div class="container">
                                          <div class="row">
                                            <div class="col-md-10 col-md-offset-1">
                                              <div class="form-section">
                                                <div class="row">
                                                    <form role="form">
                                                      <div class="col-md-2 barre_recherche_element">

                                                          <input type="text" id="recNoReleve" name="recNoReleve" class="form-control numerique barre_recherche_input" size="8" placeholder="N° rélévé"/>

                                                      </div>
                                                      <div class="col-md-4 barre_recherche_element">

                                                          <!--div class="input-group"-->
                                                            <select name="recFlux" id="recFlux" class="custom-select form-control barre_recherche_input" placeholder="Flux">
                                                            </select>
                                                          <!--/div-->

                                                      </div>
                                                      <div class="col-md-1 barre_recherche_element">

                                                          <div class="input-group">
                                                            <!--input type="text" class="form-control" id="checkout" placeholder="Check out"/>
                                                            <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span-->
                                                            <input class="form-control" type="text" name="recDate" id="recDate" size="11" maxlength="10" placeholder="Date"/>
                                                          </div>

                                                      </div>
                                                      <div class="col-md-2 barre_recherche_element">

                                                          <input type="text" id="recMontant" name="recMontant" class="form-control numerique barre_recherche_input" size="8" placeholder="{$LBL.MONTANT}"/>

                                                      </div>
                                                      <div class="col-md-2 barre_recherche_element">

                                                        <!--span class="input-group-btn"-->
                                                        <button type="submit" class="btn btn-primary right-rounded">Rechercher</button>
                                                      <!--/span-->

                                                      </div>
                                                    </form>
                                                </div>
                                              </div>
                                            </div>
                                          </div>
                                        </div>
                                      </div>




                                <!--div class="container">
                                  <div class="row">
                                    <div class="col-md-10 col-md-offset-1">
                                      <div class="form-section">
                                        <div class="row">
                                            <form role="form">
                                              <div class="col-md-2 barre_recherche_element">
                                                <div class="form-group text-left">
                                                  <input type="text" id="recNoReleve" name="recNoReleve" class="form-control numerique barre_recherche_input" size="8" placeholder="N° rélévé"/>
                                                </div>
                                              </div>
                                              <div class="col-md-2 barre_recherche_element">
                                                <div class="form-group">
                                                  <div class="input-group">
                                                    <select name="recFlux" id="recFlux" class="form-control barre_recherche_input" placeholder="Flux">
                                                    </select>
                                                  </div>
                                                </div>
                                              </div>
                                              <div class="col-md-1 barre_recherche_element">
                                                <div class="form-group">
                                                  <div class="input-group">
                                                    <input class="form-control" type="text" name="recDate" id="recDate" size="11" maxlength="10" placeholder="Date"/>
                                                  </div>
                                                </div>
                                              </div>
                                              <div class="col-md-2 barre_recherche_element">
                                                <div class="form-group">
                                                  <input type="text" id="recMontant" name="recMontant" class="form-control numerique barre_recherche_input" size="8" placeholder="{$LBL.MONTANT}"/>
                                                </div>
                                              </div>
                                              <div class="col-md-2 barre_recherche_element">
                                                <div class="form-group">
                                                <button type="submit" class="btn btn-primary right-rounded">Rechercher</button>
                                              </div>
                                              </div>
                                            </form>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                </div-->
                              </div>
                        <!--div class="row">
                            <div class="col-xs-4"/>
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
                        </div>
                        <div class="row">
                            <div class="col-xs-4"/>
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
                        </div>
                        <div class="row">
                            <div class="col-xs-4"/>
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
                            <div class="col-xs-1"/>
                            <div class="col-xs-10">
                                <div class="form-group row">
                                    <div class="col-xs-4">
                                        <label for="recNoReleve" class="col-sm-6 form-control-label">
                                            <xsl:value-of select="$LBL.NORELEVE"/>
                                        </label>
                                        <div class="col-sm-6">
                                            <input type="text" id="recNoReleve" name="recNoReleve"
                                                   class="form-control numerique" size="8"/>
                                        </div>
                                    </div>

                                    <div class="col-xs-4">
                                        <label for="recDate" class="col-sm-6 form-control-label">
                                            <xsl:value-of select="$LBL.DATE"/> - (YYYY-MM-DD)
                                        </label>
                                        <div class="col-sm-6">
                                            <input type="text" id="recDateOld" name="recDateOld"
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
                                            <select name="recFluxOld" id="recFluxOld" class="form-control"/>
                                        </div>
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
                        </div-->
                    </form>
                <!--/fieldset-->
            </div>
        </div>
        <!--div class="row">
        <div class="col-sm-8">
          <div class="form-group">
          <div class="input-group">
          <input type="text" class="form-control left-rounded"/>
          <input type="text" class="form-control" placeholder="date"/>
          <div class="input-group-btn">
            <button class="btn btn-inverse" type="submit">Rechercher</button>
          </div>
          </div>
        </div>
        </div>
      </div-->
      <!--div class="row">
        <div class="col-sm-8">
      <div class="form-group">
          <div class="input-group input-group-lg icon-addon addon-lg">
              <input type="text" placeholder="Texte" name="" id="schbox" class="form-control input-lg"/>
              <input type="text" placeholder="Texte" name="" id="schbox" class="form-control"/>

              <span class="input-group-btn">
                  <button type="submit" class="btn btn-inverse">Rechercher</button>
              </span>
          </div>
      </div>
    </div>
  </div-->

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
