<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="commun.xsl"/>
    <xsl:template name="controleMenu">N</xsl:template>
	<xsl:template name="js.module.sheet">
        <script type="text/javascript" src="front/js/login.js" charset="iso-8859-1">&#160;</script>
    </xsl:template>
    <xsl:template name="Contenu">
        <br/>
        <br/>
        <br/>
        <br/>
        <form method="post" id="formconnexion">
            <div class="row">
                <div class="col-sm-offset-4 col-xs-4">
                    <fieldset>
                        <legend>
                            <xsl:value-of select="$LBL.LOGIN"/>
                        </legend>
                        <br/>
                        <div class="form-group row">
                            <label for="nom" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.LOGIN"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" name="nom" id="nom" required="required"/>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="motDePasse" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.MOTDEPASSE"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control" id="motDePasse" name="motDePasse" type="password" required="required"/>
                            </div>
                        </div>
						<br/>
                        <div class="form-group row">
                            <div class="col-sm-offset-4 col-sm-4">
                                <button type="submit" class="btn btn-primary">
									<xsl:value-of select="$LBL.SECONNECTER"/>
								</button>
                            </div>
                        </div>
                        <br/>
                    </fieldset>
                </div>
            </div>
        </form>
        <br/>
        <br/>
        <br/>
    </xsl:template>
</xsl:stylesheet>
