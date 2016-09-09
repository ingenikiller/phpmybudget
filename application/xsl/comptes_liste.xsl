<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:template name="js.module.sheet">
        <script language="JavaScript" src="application/js/compteEdition.js" type="text/javascript"/>
    </xsl:template>
    <xsl:template name="Contenu">
        <xsl:call-template name="compteEdition"/>
        <br/>
        <br/>
        <div class="row">
            <div class="col-lg-offset-1 col-lg-10">

                <h1>
                    <xsl:value-of select="$LBL.LISTEDESCOMPTES"/>
                </h1>
                <form name="recComptes" id="recComptes">
                    <xsl:call-template name="formulaireJson"/>
                </form>
                <input type="button" class="btn btn-primary" id="" name="" value="{$LBL.CREER}" onclick="editerCompte('');"/>
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
        <br/>
        <br/>
    </xsl:template>
</xsl:stylesheet>
