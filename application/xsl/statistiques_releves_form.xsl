<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="commun.xsl"/>
	<xsl:import href="statistiques_commun.xsl"/>
	<xsl:template name="js.module.sheet">
		<script language="JavaScript" src="application/js/statistiques.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="Contenu">
		<xsl:call-template name="boiteDetail"/>
		
		
			<a href="index.php?domaine=statistique&amp;numeroCompte={$NUMEROCOMPTE}">Retour</a><br/>
			<div class="row">
				<div class="col-xs-4"/>
				<div class="col-xs-4">
					<form class="form-group row"  method="POST" action="#" onsubmit="return soumettreRelevesMois(this);" name="formulaire" id="formulaire">
						<input name="numeroCompte" id="numeroCompte" type="hidden" value="{$NUMEROCOMPTE}"/>
						<fieldset>
							<div class="form-group row">
								<label for="premierReleve" class="col-sm-9 form-control-label"><xsl:value-of select="$LBL.PREMIERRELEVE"/></label>
								<div class="col-sm-3">
									<xsl:apply-templates select="/root/data/ListeReleves">
								<xsl:with-param name="name" select="'premierReleve'"/>
							</xsl:apply-templates>
								</div>
							</div>
							
							<div class="form-group row">
								<label for="dernierReleve" class="col-sm-9 form-control-label"><xsl:value-of select="$LBL.DERNIERRELEVE"/></label>
								<div class="col-sm-3">
									<xsl:apply-templates select="/root/data/ListeReleves">
								<xsl:with-param name="name" select="'dernierReleve'"/>
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
			<!--form method="POST" action="#" onsubmit="return soumettreRelevesMois(this);" name="formulaire" id="formulaire">
				<input name="numeroCompte" id="numeroCompte" type="hidden" value="{$NUMEROCOMPTE}"/>
				<table class="formulaire">
					<tr>
						<td>
							<xsl:value-of select="$LBL.PREMIERRELEVE"/>
						</td>
						<td>
							<xsl:apply-templates select="/root/data/ListeReleves">
								<xsl:with-param name="name" select="'premierReleve'"/>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="$LBL.DERNIERRELEVE"/>
						</td>
						<td>
							<xsl:apply-templates select="/root/data/ListeReleves">
								<xsl:with-param name="name" select="'dernierReleve'"/>
							</xsl:apply-templates>
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td colspan="2" rowspan="1">
							<input name="valider" value="Valider" type="submit"/>
						</td>
					</tr>
				</table>
				
			</form-->
			<table id="tableResultat" name="tableResultat" class="table table-bordered table-hover"/>
	</xsl:template>
	<xsl:template match="ListeReleves">
		<xsl:param name="name"/>
		<xsl:param name="obligatoire"/>
		<select name="{$name}" id="{$name}">
			<xsl:choose>
				<xsl:when test="$obligatoire='O'">
					<xsl:attribute name="class">form-control obligatoire</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">form-control</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<option/>
			<xsl:apply-templates select="Dynamic"/>
		</select>
	</xsl:template>
	<xsl:template match="Dynamic">
		<option value="{noreleve}">
			<xsl:value-of select="noreleve"/>
		</option>
	</xsl:template>
</xsl:stylesheet>
