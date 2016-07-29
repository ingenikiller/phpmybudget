<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:template name="Contenu">
        <div class="row">
            <div class="col-lg-offset-4 col-lg-4">
                <form method="POST" name="recherche" id="recherche" onsubmit="return rechercherOperations(this);">
                    <xsl:call-template name="formulaireJson"/>
                </form>
                <table class="table table-stripedtable-bordered" name="tableauResultat" id="tableauResultat">
                    <thead>
                        <tr>
                            <th align="center" width="10%">
                                <xsl:value-of select="$LBL.ANNEES"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.NBMOIS"/>
                            </th>
                        </tr>
                    </thead>
                    <tbody id="tbodyResultat"/>
                </table>
                <br/>
                <fieldset>
                    <br/>
                    <form id="creationperiode" onsubmit="return creerPeriode(this);">
                        <div class="col-lg-12">
                            <div class="form-group row">
                                <label for="flux" class="col-sm-6 form-control-label">
                                    <xsl:value-of select="$LBL.ANNEE"/>
                                </label>
                                <div class="col-sm-6">
                                    <input class="form-control obligatoire" type="text" name="nouvelleannee"
                                           id="nouvelleannee" size="4" maxlength="4"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-4"/>
                                <div class="form-group row">
                                    <div class="col-sm-offset-5 col-sm-5">
                                        <button type="submit" class="btn btn-primary">
                                            <xsl:value-of select="$LBL.CREER"/>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </fieldset>
                <br/>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="js.module.sheet">
        <script language="JavaScript" src="application/js/periodeListe.js" type="text/javascript"/>
    </xsl:template>
</xsl:stylesheet>
