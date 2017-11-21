<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="commun.xsl"/>
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="statistiques_commun.xsl"/>
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
    <!-- template js -->
    <xsl:template name="js.module.sheet">
        <script type="text/javascript" src="front/js/previsions.js" charset="UTF-8">&#160;</script>
		<script type="text/javascript" src="front/js/statistiques.js" charset="UTF-8">&#160;</script>
    </xsl:template>
    <xsl:template name="Contenu">
        
        <div class="row">
            <div class="col-lg-offset-4">
				<div class="col-lg-4">
					<div class="form-group row">
						<label for="annee" class="col-sm-6 form-control-label">
							<xsl:value-of select="$LBL.ANNEE"/>
						</label>
						<div class="col-sm-6">
							<select name="annee" id="annee" class="form-control" onchange="refreshWindow()">
                                <xsl:apply-templates select="/root/data/ListeAnnees/Dynamic">
                                    <xsl:with-param name="anneeSelect" select="$ANNEE"/>
                                </xsl:apply-templates>
                            </select>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div id="radio">
						<input type="radio" id="radio1" name="radioChoixType" value="complet" checked="checked"/><label for="radio1">Complet</label>
						<input type="radio" id="radio2" name="radioChoixType" value="pinel"/><label for="radio2">Avec Pinel</label>
						<input type="radio" id="radio3" name="radioChoixType" value="sans"/><label for="radio3">Sans</label>
					</div>
				</div>
			</div>
            <div class="col-lg-offset-4 col-lg-4">
                <table class="table table-bordered">
					<tr>
                        <th>
							<xsl:value-of select="$LBL.ENTETE"/>
						</th>
						<td>
                            <input type="button" id="boutonEntete" name="boutonEntete" value="Entete" onclick="afficheEntete('{$NUMEROCOMPTE}');"/>
                            <select name="listeEntete" id="listeEntete" onchange="afficheListeGroupe(this.value)">&#160;</select>
                        </td>
                    </tr>
                    <tr>
                        <th>
							<xsl:value-of select="$LBL.CREER"/>
						</th>
						<td>
                            <input type="button" id="afficheUnitaire" value="Unitaire" onclick="afficheUnitaire('{$NUMEROCOMPTE}','');"/>
                        </td>
                    </tr>
					<tr>
                        <th>
							<xsl:value-of select="$LBL.SOLDE"/>
						</th>
                        <td>
                            <xsl:value-of select="format-number(number(/root/data/SommeOperations/Dynamic/total) + number(/root/data/Comptes/solde), $FORMAT_MNT)"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
							<xsl:value-of select="$LBL.ESTIMATION"/>
						</th>
                        <td>
                            <span id="estimation">&#160;</span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        
        <table class="table table-bordered" id="liste">&#160;</table>
        
		<xsl:call-template name="boiteUnitaire"/>
        <xsl:call-template name="boiteDetail"/>
        <xsl:call-template name="boiteListeEntete"/>
    </xsl:template>
    <xsl:template name="boiteUnitaire">
        <div id="boite" title="{$LBL.EDITIONPREVISION}" style="display: none;">
            <form method="POST" name="editionPrevisionUnitaire" id="editionPrevisionUnitaire" action="index.php"
                  onsubmit="return modifierPrevision(this)">
                <input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
                <input type="hidden" id="typenr" name="typenr" value="L"/>
                <input type="hidden" id="ligneId" name="ligneId" value=""/>
                <input type="hidden" id="service" name="service"/>
                <div class="container popup_operation">
                    <div class="col-lg-12">
                        <div class="form-group row">
                            <label for="noReleve" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.FLUX"/>
                            </label>
                            <div class="col-sm-6">
                                <select class="form-control obligatoire" name="fluxId" id="fluxId" tabindex="5">&#160;</select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="date" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.PERIODE"/>
                            </label>
                            <div class="col-sm-6">
                                <select name="mois" id="mois" tabindex="10" class="form-control">
                                    <option/>
                                    <xsl:for-each select="/root/data/ListePeriodes/Periode">
                                        <option value="{periode}">
                                            <xsl:value-of select="periode"/>
                                        </option>
                                    </xsl:for-each>
                                </select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="fluxId" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.MONTANT"/>
                            </label>
                            <div class="col-sm-6">
                                <input size="7" name="montant" id="montant" class="form-control obligatoire"
                                       onblur="return isDouble(this);" tabindex="15"/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group row">
                                <div class="col-sm-offset-5 col-sm-5">
                                    <button type="submit" class="btn btn-primary"><xsl:value-of select="$LBL.MODIFIER"/></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div id="boiteEntete" title="Edition" style="display: none;">
            <!--
                formulaire entete
            -->
            <form method="POST" name="editionEnteteUnitaire" id="editionEnteteUnitaire" action="#" onsubmit="return creerEntete(this)">
				<input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
                <input type="hidden" id="typenr" name="typenr" value="E"/>
                <input type="hidden" id="ligneId" name="ligneId" value=""/>
                <input type="hidden" id="service" name="service" value="create"/>
                <div class="container popup_operation">
					<div class="form-group row">
						<label for="nomEntete" class="col-sm-6 form-control-label">Titre</label>
						<div class="col-sm-6">
							<input class="form-control obligatoire" id="nomEntete" tabindex="1" required="required"/>
						</div>
					</div>
					<div class="form-group row">
						<label for="noReleve" class="col-sm-6 form-control-label">
							<xsl:value-of select="$LBL.FLUX"/>
						</label>
						<div class="col-sm-6">
							<select class="form-control obligatoire" id="fluxIdEntete" tabindex="5">&#160;</select>
						</div>
					</div>
					<div class="form-group row">
						<label for="noReleve" class="col-sm-6 form-control-label">Périodicité</label>
						<div class="col-sm-6">
							<select name="periodicite" id="periodicite" class="form-control obligatoire" tabindex="10" required="required">
                                <option/>
                                <option value="M">Mensuelle</option>
                                <option value="T1">Trimestre début</option>
                                <option value="T3">Trimestre fin</option>
                            </select>
						</div>
					</div>
					<div class="form-group row">
						<label for="fluxId" class="col-sm-6 form-control-label">
							<xsl:value-of select="$LBL.MONTANT"/>
						</label>
						<div class="col-sm-6">
							<input size="7" id="montantPeriode" class="form-control obligatoire" type="text" tabindex="15" required="required" onblur="return isDouble(this);"/>
						</div>
					</div>
					<div class="row">
						<div class="form-group row">
							<div class="col-sm-offset-5 col-sm-5">
								<button type="submit" class="btn btn-primary"><xsl:value-of select="$LBL.MODIFIER"/></button>
							</div>
						</div>
					</div>
				</div>
            </form>
        </div>
    </xsl:template>
    <!--
        template boite de dialogue liste des prévisions par entête
    -->
    <xsl:template name="boiteListeEntete">
        <div id="boiteListeEntete" title="{$LBL.EDITIONLISTEPREVISION}" style="display: none;">
            <form method="post" action="" onsubmit="return enregistreListeLignes(this);">
                <input type="hidden" id="numeroCompte" name="numeroCompte" value="{$NUMEROCOMPTE}"/>
                <table id="tabListeEntete" name="tabListeEntete" width="80%" align="center" class="table table-striped table-bordered">
                    <thead>
						<tr>
							<th><xsl:value-of select="$LBL.MOIS"/></th>
							<th><xsl:value-of select="$LBL.MONTANT"/></th>
							<th><xsl:value-of select="$LBL.PROPAGER"/></th>
						</tr>
                    </thead>
                    <tbody id="tbodylisteentete"/>
                    <tfoot>
                        <tr>
                            <td style="text-align:center;" colspan="3">
                                <input type="submit" class="bouton" id="" value="{$LBL.MODIFIER}"/>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </form>
        </div>
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
</xsl:stylesheet>
