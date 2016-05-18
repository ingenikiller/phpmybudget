<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--xsl:variable name="NUMEROPAGE">
		<xsl:choose>
			<xsl:when test="/root/request/numeroPage">
				<xsl:value-of select="/root/request/numeroPage"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable-->
	<!--xsl:template name="pagination">
		<xsl:param name="pageActuelle"/>
		<xsl:param name="nbPage"/>
		<xsl:param name="url"/>
		<xsl:if test="$nbPage!=1">
			<table>
				<tr>
					<td>
						<xsl:choose>
							<xsl:when test="$pageActuelle!=1">
								<a href="#" onclick="document.recherche.numeroPage.value={number($pageActuelle -1)};document.recherche.submit();">
									<img border="0" alt="del" src="{$IMG_ROOT}previous.gif"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<img border="0" alt="del" src="{$IMG_ROOT}previous_grey.gif"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<xsl:if test="$nbPage!=0">
						<td>
							<input name="rch_page" id="rch_page" type="text" size="4" maxlength="4" value="{$pageActuelle}"/>/<input name="max_page" id="max_page" type="text" size="4" maxlength="4" value="{$nbPage+1}" readonly="readonly"/>
							<input name="submit" type="submit" value="OK" onclick="pagination()"/>
						</td>
					</xsl:if>
					<td>
						<xsl:choose>
							<xsl:when test="$pageActuelle!=$nbPage+1 and $nbPage!=0">
								<a href="#" onclick="document.recherche.numeroPage.value={number($pageActuelle +1)};document.recherche.submit();">
									<img border="0" alt="del" src="{$IMG_ROOT}next.gif"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<img border="0" alt="del" src="{$IMG_ROOT}next_grey.gif"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template-->
	<xsl:template name="paginationJson">
		<xsl:param name="formulairePrincipal"/>
		<xsl:param name="formPagination" select="'formPagination'"></xsl:param>
		<table>
			<tr>
				<td>
					<a href="#" onclick="javascript:changePage('{$formulairePrincipal}', '-1')"  id="lienPrecedant">
						<img border="0" alt="precedent" src="{$IMG_ROOT}previous.gif"/>
					</a>
				</td>
				<td>
					<form method="post" onsubmit="return pagination('{$formulairePrincipal}')" name="{$formPagination}" id="{$formPagination}">
						<input name="rch_page" id="rch_page" type="text" size="4" maxlength="4" value="1"/>/<input name="max_page" id="max_page" type="text" size="4" maxlength="4" value="" readonly="readonly"/>
						<input name="submit" type="submit" value="OK"/>
					</form>
				</td>
				<td>
					<a href="#" onclick="changePage('{$formulairePrincipal}', '1')" disabled="" id="lienSuivant">
						<img border="0" alt="suivant" src="{$IMG_ROOT}next.gif"/>
					</a>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="formulaireJson">
		<input name="numeroPage" id="numeroPage" type="hidden" value="1"/>
	</xsl:template>
</xsl:stylesheet>
