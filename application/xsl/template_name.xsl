<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
        Modif select
    -->
    <xsl:template name="ModifSelect">
        <xsl:param name="value" select="''"/>
        <xsl:param name="Node"/>
        <xsl:param name="nom"/>
        <xsl:param name="defaultValue"/>
        <xsl:param name="defaultDisplay"/>
        <xsl:param name="onChange" select="''"/>
        <xsl:param name="class" select="''"/>
        <xsl:param name="tabindex" select="''"/>
        <xsl:param name="optionVide" select="'O'"/>
        <select class="form-control {$class}" name="{$nom}" id="{$nom}">
            <xsl:if test="$onChange!=''">
                <xsl:attribute name="onchange">
                    <xsl:value-of select="$onChange"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$tabindex!=''">
                <xsl:attribute name="tabindex">
                    <xsl:value-of select="$tabindex"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$optionVide='O'">
                <option/>
            </xsl:if>
            <xsl:if test="$defaultValue!=''">
                <option value="{$defaultValue}">
                    <xsl:value-of select="$defaultDisplay"/>
                </option>
            </xsl:if>
            <xsl:for-each select="$Node/Segment">
                <xsl:choose>
                    <xsl:when test="$value=codseg">
                        <option value="{codseg}" selected="selected">
                            <xsl:value-of select="liblong"/>
                        </option>
                    </xsl:when>
                    <xsl:otherwise>
                        <option value="{codseg}">
                            <xsl:value-of select="liblong"/>
                        </option>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </select>
    </xsl:template>
    <!--
        liste mois
    -->
    <xsl:template name="SelectMois">
        <xsl:param name="name"/>
        <xsl:param name="obligatoire" select="'N'"/>
        <select name="{$name}" id="{$name}" class="form-control">
            <xsl:if test="$obligatoire='O'">
                <xsl:attribute name="class">form-control obligatoire</xsl:attribute>
            </xsl:if>
            <option/>
            <option value="01">Janvier</option>
            <option value="02">Février</option>
            <option value="03">Mars</option>
            <option value="04">Avril</option>
            <option value="05">Mai</option>
            <option value="06">Juin</option>
            <option value="07">Juillet</option>
            <option value="08">Aoùt</option>
            <option value="09">Septembre</option>
            <option value="10">Octobre</option>
            <option value="11">Novembre</option>
            <option value="12">Décembre</option>
        </select>
    </xsl:template>
    <!--
        édition d'une opération
    -->
    <xsl:template name="operationEdition">
        <xsl:param name="numeroCompte"/>
        <div id="boiteOperation" title="{$LBL.EDITIONOPERATION}" style="display: none;">

            <form method="POST" action="#" onsubmit="return soumettre(this);" name="operation" id="operation">
                <input type="hidden" name="service" id="service"/>
                <input type="hidden" id="noCompte" name="noCompte" value="{$numeroCompte}"/>
                <input type="hidden" name="operationId" id="operationId" value=""/>
                <div class="container popup_operation">
                    <div class="col-lg-12">
                        <div class="form-group row">
                            <label for="noReleve" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.NUMERORELEVE"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control" size="12" name="noReleve" id="noReleve" tabindex="10"/>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="date" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.DATE"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" name="date" id="date" size="11" maxlength="10"
                                       tabindex="20"/>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="libelle" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.LIBELLE"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" size="40" id="libelle" tabindex="30"/>
                            </div>
                        </div>


                        <div class="form-group row">
                            <label for="fluxId" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.FLUX"/>
                            </label>
                            <div class="col-sm-6">
                                <select class="form-control obligatoire" name="fluxId" id="fluxId" onchange="return getModeReglementDefaut(this, this.form.modePaiementId)" tabindex="40">&#160;</select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="modePaiementId" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.MODEDEPAIEMENT"/>
                            </label>
                            <div class="col-sm-6">
                                <xsl:call-template name="ModifSelect">
                                    <xsl:with-param name="value" select="/root/data/Operation/modePaiementId"/>
                                    <xsl:with-param name="Node" select="/root/paramFlow/MODPAI"/>
                                    <xsl:with-param name="nom" select="'modePaiementId'"/>
                                    <xsl:with-param name="defaultValue" select="''"/>
                                    <xsl:with-param name="defaultDisplay" select="''"/>
                                    <xsl:with-param name="optionVide" select="'O'"/>
                                    <xsl:with-param name="tabindex" select="'50'"/>
                                </xsl:call-template>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="fluxId" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.MONTANT"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control obligatoire numerique" size="7" name="montant" id="montant"
                                       onblur="return isDouble(this);" tabindex="60"/>
                            </div>
                        </div>

                        <div class="row justify-content-md-center">
                            <div class="form-group row">
                                <div class="col-md-auto">
                                    <button type="submit" class="btn btn-primary">Valider</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </xsl:template>

    <!--
        édition d'un compte
    -->
    <xsl:template name="compteEdition">
        <div id="boiteCompte" title="{$LBL.EDITIONCOMPTE}" style="display: none;">
            <!--br/-->
            <form method="POST" action="#" onsubmit="return soumettre(this);">
                <input type="hidden" name="service" id="service"/>
                <div class="container popup_operation">
					<div class="form-group row">
						<label for="numeroCompte" class="col-sm-6 form-control-label">
							<xsl:value-of select="$LBL.NUMEROCOMPTE"/>
						</label>
						<div class="col-sm-6">
							<input class="form-control" size="12" name="numeroCompte" id="numeroCompte" tabindex="10" required="required"/>
						</div>
					</div>
					<div class="form-group row">
						<label for="libelle" class="col-sm-6 form-control-label">
							<xsl:value-of select="$LBL.DESCRIPTION"/>
						</label>
						<div class="col-sm-6">
							<input class="form-control" type="text" name="libelle" id="libelle" size="11" maxlength="40" tabindex="20"/>
						</div>
					</div>
					<div class="form-group row">
						<label for="solde" class="col-sm-6 form-control-label">
							<xsl:value-of select="$LBL.SOLDEBASE"/>
						</label>
						<div class="col-sm-6">
							<input class="form-control numerique" type="numeric" name="solde" id="solde" size="10" tabindex="30" required="required"/>
						</div>
					</div>
					<div class="row justify-content-md-center">
						<div class="col-lg-offset-4 col-lg-4" style="text-align:center;">
							<button type="submit" class="btn btn-primary">Valider</button>
						</div>
					</div>
                    
                </div>
            </form>
        </div>
    </xsl:template>

    <!--
        édition d'un segment
    -->
    <xsl:template name="segmentDetailEdition">
        <div id="boiteSegmentDetail" title="{$LBL.EDITIONSEGMENT}" style="display: none;">
            <center>
                <br/>
                <form method="POST" action="#" onsubmit="return soumettreDetail(this, 'formulaireDetail');"
                      name="segmentDetailForm" id="segmentDetailForm">
                    <input type="hidden" name="service" id="service"/>
                    <div class="container popup_operation">
                        <div class="col-lg-12">
                            <div class="form-group row">
                                <label for="numeroCompte" class="col-sm-6 form-control-label">
                                    <xsl:value-of select="$LBL.SEGMENT"/>
                                </label>
                                <div class="col-sm-6">
                                    <input class="form-control" size="12" name="cleseg" id="cleseg" tabindex="10"
                                           readonly="readonly"/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="libelle" class="col-sm-6 form-control-label">
                                    <xsl:value-of select="$LBL.CLE"/>
                                </label>
                                <div class="col-sm-6">
                                    <input class="form-control" type="text" name="codseg" id="codseg" size="11"
                                           readonly="readonly"/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="solde" class="col-sm-6 form-control-label">
                                    <xsl:value-of select="$LBL.LIBCOURT"/>
                                </label>
                                <div class="col-sm-6">
                                    <input class="form-control" name="libcourt" id="libcourt" size="12"/>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="solde" class="col-sm-6 form-control-label">
                                    <xsl:value-of select="$LBL.LIBLONG"/>
                                </label>
                                <div class="col-sm-6">
                                    <input class="form-control" name="liblong" id="liblong" size="40"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-4"/>
                                <div class="form-group row">
                                    <div class="col-sm-offset-5 col-sm-5">
                                        <button type="submit" class="btn btn-primary">Valider</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </center>
        </div>
    </xsl:template>
</xsl:stylesheet>