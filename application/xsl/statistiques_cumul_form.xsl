<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="statistiques_commun.xsl"/>
	<xsl:import href="template_name.xsl"/>
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/statistiques.js" type="text/javascript"/>
		<script language="JavaScript" src="application/js/statistiquesCumul.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="Contenu">
		<xsl:call-template name="boiteDetail"/>
		
			<a href="index.php?domaine=statistique&amp;numeroCompte={$NUMEROCOMPTE}">Retour</a><br/>
		<center>
			
			
			<form class="form-group row"  method="POST" action="#" onsubmit="return soumettreCumul(this);" name="formulaire" id="formulaire">
				<div class="row">
					<div class="col-xs-4"/>
					<div class="col-xs-4">
							<input name="numeroCompte" id="numeroCompte" type="hidden" value="{$NUMEROCOMPTE}"/>
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
							
					</div>
				</div>			
							
				<div class="row">
					<div class="col-xs-3"/>
					<div class="col-xs-2">
						<select name="from[]" id="multiselect" class="form-control" size="8" multiple="multiple"/>
					</div>
					
					<div class="col-xs-2">
						<button type="button" id="multiselect_rightAll" class="btn btn-block"><i class="glyphicon glyphicon-forward"></i></button>
						<button type="button" id="multiselect_rightSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
						<button type="button" id="multiselect_leftSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-left"></i></button>
						<button type="button" id="multiselect_leftAll" class="btn btn-block"><i class="glyphicon glyphicon-backward"></i></button>
					</div>
					
					<div class="col-xs-2">
						<select name="to[]" id="multiselect_to" class="form-control" size="8" multiple="multiple"></select>
					</div>
				</div>
				
				<div class="row">
					<div class="col-xs-2"/>
					<div class="form-group row">
						<div class="col-sm-offset-1 col-sm-10">
							<button type="submit" class="btn btn-secondary">Valider</button>
						</div>
					</div>
				</div>
			</form>
			<table id="tableResultat" name="tableResultat" class="formulaire"/>
			<br/>
		</center>
	</xsl:template>
	<xsl:template match="ListeAnnee">
		<xsl:param name="name"/>
		<xsl:param name="obligatoire"/>
		<select name="{$name}" id="{$name}">
			<xsl:if test="$obligatoire='O'">
				<xsl:attribute name="class">obligatoire</xsl:attribute>
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
