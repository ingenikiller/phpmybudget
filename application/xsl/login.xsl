<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="commun.xsl"/>
    <xsl:template name="controleMenu">N</xsl:template>
    <xsl:template name="onLoadTemplate">
        <xsl:if test="/root/user/userId!=''">
            document.location.href='index.php?domaine=compte&amp;service=getpage';
        </xsl:if>
    </xsl:template>

    <xsl:template name="Contenu">
        <br/>
        <br/>
        <br/>
        <br/>
        <xsl:if test="/root/dial/messages/erreur!=''">
            <p class="erreur">
                <xsl:value-of select="/root/dial/messages/erreur"/>
            </p>
        </xsl:if>
        <form method="post" onsubmit="return connexion();">
            <div class="row">
                <div class="col-xs-4"/>
                <div class="col-xs-4">
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
                                <input class="form-control" type="text" name="nom" id="nom"/>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="motDePasse" class="col-sm-6 form-control-label">
                                <xsl:value-of select="$LBL.MOTDEPASSE"/>
                            </label>
                            <div class="col-sm-6">
                                <input class="form-control" id="motDePasse" name="motDePasse" type="password"/>
                            </div>
                        </div>
						<br/>
                        <div class="form-group row">
                            <div class="col-sm-offset-5 col-sm-5">
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
