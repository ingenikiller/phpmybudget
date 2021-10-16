<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="statistiques_commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:template name="js.module.sheet">
		<script type="text/javascript" src="front/js/statistiques.js" charset="iso-8859-1">&#160;</script>
	</xsl:template>
	<xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="Contenu">
		<xsl:call-template name="boiteDetail"/>
			<div class="row justify-content-md-center">
				<a href="index.php?domaine=statistique&amp;numeroCompte={$NUMEROCOMPTE}">Retour</a><br/>
			</div>
			<div class="row justify-content-md-center">
				<div class="col col-lg-4">
					<form method="POST" action="#" onsubmit="return soumettreRelevesAnnee(this);" name="formulaire" id="formulaire">
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
							<div class="form-group row justify-content-md-center">
								<div class="text-center">
									<button type="submit" class="btn btn-primary">Valider</button>
								</div>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
		<center>
			<table id="tableResultat" class="table table-bordered"/>
		</center>
	</xsl:template>
</xsl:stylesheet>
