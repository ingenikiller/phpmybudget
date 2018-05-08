<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="template_name.xsl"/>
    <xsl:import href="commun.xsl"/>
    <xsl:template name="Contenu">
        <div class="row justify-content-md-center">
            <div class="col-6">
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
                    <form id="creationperiode" onsubmit="return creerPeriode(this);" class="form-inline">
					
						<label for="nouvelleannee"><xsl:value-of select="$LBL.ANNEE"/></label>
						<input class="form-control mb-2 mr-sm-2 obligatoire" type="text" name="nouvelleannee" id="nouvelleannee" size="4" maxlength="4"/>
						<button type="submit" class="btn btn-primary mb-2"><xsl:value-of select="$LBL.CREER"/></button>
							
                            <!--div class="form-row align-items-center">
							<div class="col-auto">
                                <label for="flux" class="col-sm-6 form-control-label">
                                    <xsl:value-of select="$LBL.ANNEE"/>
                                </label>
								</div>
								<div class="col-auto">
								
									<div class="form-control mb-2">
										<input class="form-control obligatoire" type="text" name="nouvelleannee" id="nouvelleannee" size="4" maxlength="4"/>
									</div>
								</div>
								
								<div class="col-auto">
								<button type="submit" class="btn btn-primary">
                                            <xsl:value-of select="$LBL.CREER"/>
                                        </button>
								</div>
                            </div-->
                            <!--div class="row">
                                <div class="form-group row">
                                    
                                        <button type="submit" class="btn btn-primary">
                                            <xsl:value-of select="$LBL.CREER"/>
                                        </button>
                                   
                                </div>
                            </div-->
                        
                    </form>
					
					<form>
					  <div class="form-row align-items-center">
						<div class="col-sm-3 my-1">
						  <label class="sr-only" for="inlineFormInputName">Name</label>
						  <input type="text" class="form-control" id="inlineFormInputName" placeholder="Jane Doe"/>
						</div>
						<div class="col-sm-3 my-1">
						  <label class="sr-only" for="inlineFormInputGroupUsername">Username</label>
						  <div class="input-group">
							<div class="input-group-prepend">
							  <div class="input-group-text">@</div>
							</div>
							<input type="text" class="form-control" id="inlineFormInputGroupUsername" placeholder="Username"/>
						  </div>
						</div>
						<div class="col-auto my-1">
						  <div class="form-check">
							<input class="form-check-input" type="checkbox" id="autoSizingCheck2"/>
							<label class="form-check-label" for="autoSizingCheck2">
							  Remember me
							</label>
						  </div>
						</div>
						<div class="col-auto my-1">
						  <button type="submit" class="btn btn-primary">Submit</button>
						</div>
					  </div>
					</form>
					
					
                </fieldset>
                <br/>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="js.module.sheet">
        <script type="text/javascript" src="front/js/periodeListe.js" charset="iso-8859-1">&#160;</script>
    </xsl:template>
</xsl:stylesheet>
