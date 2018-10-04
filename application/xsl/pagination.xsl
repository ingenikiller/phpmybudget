<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="paginationJson">
		<xsl:param name="formulairePrincipal"/>
		<xsl:param name="formPagination" select="'formPagination'"/>
		
		<div class="row justify-content-md-center">
			<!--div class="col-xs-4"/-->
			<div class="text-center">
				<form  class="form-inline" method="post" onsubmit="return pagination('{$formulairePrincipal}')" name="{$formPagination}" id="{$formPagination}">
					<div class="form-group">
						<a href="#" onclick="javascript:changePage('{$formulairePrincipal}', '-1')"  id="lienPrecedant">
							<span class="oi oi-caret-left">&#160;</span>
						</a>
					</div>
					<div class="form-group">

							<input class="form_control" name="rch_page" id="rch_page" type="text" size="4" maxlength="4" value="1"/>/<input class="form_control" name="max_page" id="max_page" type="text" size="4" maxlength="4" value="" readonly="readonly"/>
							<input name="submit" type="submit" value="OK"/>

					</div>
					<div class="form-group">
						<a href="#" onclick="changePage('{$formulairePrincipal}', '1')" id="lienSuivant">
							<span class="oi oi-caret-right">&#160;</span>
						</a>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="formulaireJson">
		<input name="numeroPage" id="numeroPage" type="hidden" value="1"/>
	</xsl:template>
</xsl:stylesheet>
