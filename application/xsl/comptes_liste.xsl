<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:template name="js.module.sheet">
        <script src="front/js/compteEdition.js">&#160;</script>
    </xsl:template>
    <xsl:template name="Contenu">
        <div class="row justify-content-md-center">
            <div class="col-lg-10">

                <h1>
                    <xsl:value-of select="$LBL.LISTEDESCOMPTES"/>
                </h1>
                <form name="recComptes" id="recComptes">
                    <xsl:call-template name="formulaireJson"/>
                </form>
                <button type="button" class="btn btn-primary" id="editerCompte" name="editerCompte" onclick="editerCompte('');">
                    <span class="oi oi-plus"/>
                </button>
                <br/>
                <table class="table table-striped table-bordered" name="tableauResultat" id="tableauResultat">
                    <thead>
                        <tr>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.COMPTE"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.DESCRIPTION"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.SOLDEBASE"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.SOLDE"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.EDITER"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.OPERATIONS"/>
                            </th>
							<th class="text-center">
                                <xsl:value-of select="$LBL.OPERATIONSRECURRENTES"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.STATISTIQUES"/>
                            </th>
                            <th class="text-center">
                                <xsl:value-of select="$LBL.PREVISIONS"/>
                            </th>
                        </tr>
                    </thead>
                    <tbody id="tbodyResultat"/>
                </table>
                <xsl:call-template name="paginationJson">
                    <xsl:with-param name="formulairePrincipal" select="'recComptes'"/>
                </xsl:call-template>
            </div>
        </div>
        <xsl:call-template name="compteEdition"/>
    </xsl:template>
</xsl:stylesheet>
