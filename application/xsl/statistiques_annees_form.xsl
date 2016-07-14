<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="statistiques_commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/statistiques.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="Contenu">
		<xsl:call-template name="boiteDetail"/>
			<div class="row">
				<a href="index.php?domaine=statistique&amp;numeroCompte={$NUMEROCOMPTE}">Retour</a><br/>
			</div>
			<div class="row">
				<div class="col-xs-4"/>
				<div class="col-xs-4">
					<form class="form-group row"  method="POST" action="#" onsubmit="return soumettreRelevesAnnee(this);" name="formulaire" id="formulaire">
						<input name="numeroCompte" id="numeroCompte" type="hidden" value="{$NUMEROCOMPTE}"/>
						<fieldset>
							<div class="form-group row">
								<label for="premiereAnnee" class="col-sm-9 form-control-label"><xsl:value-of select="$LBL.PREMIEREANNEE"/></label>
								<div class="col-sm-3">
									<xsl:apply-templates select="/root/data/ListeAnnee">
										<xsl:with-param name="name" select="'premiereAnnee'"/>
										<xsl:with-param name="obligatoire" select="'O'"/>
									</xsl:apply-templates>
								</div>
							</div>
							
							<div class="form-group row">
								<label for="derniereAnnee" class="col-sm-9 form-control-label"><xsl:value-of select="$LBL.DERNIEREANNEE"/></label>
								<div class="col-sm-3">
									<xsl:apply-templates select="/root/data/ListeAnnee">
										<xsl:with-param name="name" select="'derniereAnnee'"/>
									</xsl:apply-templates>
								</div>
							</div>
							<div class="form-group row">
								<div class="text-center">
									<button type="submit" class="btn btn-primary">Valider</button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		<center>
			<table id="tableResultat" name="tableResultat" class="table table-bordered"  table-hover=""/>
		</center>
	</xsl:template>
	<xsl:template match="ListeAnnee">
		<xsl:param name="name"/>
		<xsl:param name="obligatoire"/>
		<select name="{$name}" id="{$name}" class="form-control">
			<xsl:if test="$obligatoire='O'">
				<xsl:attribute name="class">form-control obligatoire</xsl:attribute>
			</xsl:if>
			<option/>
			<xsl:apply-templates select="Dynamic"/>
		</select>
	</xsl:template>
	<xsl:template match="Dynamic">
		<option value="{annee}">
			<xsl:value-of select="annee"/>
		</option>
	</xsl:template>
</xsl:stylesheet>
