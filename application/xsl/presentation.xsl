<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--regle principal-->
	<xsl:template match="/">
		<html>
			<xsl:call-template name="Header">
				<xsl:with-param name="HeadTitre"><xsl:value-of select="/root/titre"/></xsl:with-param>
			</xsl:call-template>
			<body>
				<xsl:attribute name="onload">
					<xsl:call-template name="onLoadTemplate"/>
				</xsl:attribute>

				<xsl:variable name="affMenu">
					<xsl:call-template name="controleMenu"/>
				</xsl:variable>
				<!-- affichage barre de navigation -->
				<xsl:if test="$affMenu='O'">
					<xsl:call-template name="menu"/>
				</xsl:if>
				<!-- affichage deu contenu -->
				<div class="container contenu">
					<xsl:choose>
						<xsl:when test="$affMenu='O'">
							<xsl:attribute name="class">container contenu marge</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">container contenu</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="Contenu"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- template entete -->
	<xsl:template name="entete">
		<!-- banniere -->
		<xsl:call-template name="banniere"/>
		<!-- menu -->
		<xsl:variable name="affMenu">
			<xsl:call-template name="controleMenu"/>
		</xsl:variable>
		<xsl:if test="$affMenu='O'">
			<xsl:call-template name="menu"/>
		</xsl:if>
	</xsl:template>
	<!--header de la domaine-->
	<xsl:template name="Header">
		<xsl:param name="HeadTitre"/>
		<head>
			<meta content="text/html;charset=UTF-8" http-equiv="content-type"/>
			<meta NAME="DESCRIPTION" CONTENT="PhpMyBudget"/>
			<meta NAME="KEYWORDS" CONTENT="gestion compte"/>
			<meta http-equiv="Pragma" content="no-cache"/>
			<meta http-equiv="Cache-Control" content="no-cache"/>
			<meta http-equiv="Expires" content="0"/>
			<meta http-equiv="X-UA-Compatible" content="IE=8"/>
			<title>
				<xsl:value-of select="$HeadTitre"/>
			</title>
			<!--link href="application/css/dhtmlgoodies_calendar.css" rel="stylesheet" type="text/css"/-->


			<link href="application/bootstrap/bootstrap-{$BOOTSTRAP-VERSION}-dist/css/bootstrap.min.css" rel="stylesheet"/>
			<link href="application/bootstrap/bootstrap-{$BOOTSTRAP-VERSION}-dist/css/bootstrap-theme.min.css" rel="stylesheet"/>

			<link href="application/jquery/jquery-ui-{$JQUERY-VERSION}.custom/jquery-ui.min.css" rel="stylesheet" type="text/css"/>

			<!--script type="text/javascript" src="application/js/dhtmlgoodies_calendar.js" charset="iso-8859-1">&#160;</script-->
			<script type="text/javascript" src="application/jquery/jquery-ui-{$JQUERY-VERSION}.custom/external/jquery/jquery.js" charset="iso-8859-1">&#160;</script>
			<script type="text/javascript" src="application/bootstrap/bootstrap-{$BOOTSTRAP-VERSION}-dist/js/bootstrap.min.js" charset="iso-8859-1">&#160;</script>
			<script type="text/javascript" src="application/jquery/jquery-ui-{$JQUERY-VERSION}.custom/jquery-ui.min.js" charset="iso-8859-1">&#160;</script>

			<script type="text/javascript" src="application/js/commun.js" charset="iso-8859-1">&#160;</script>
			<script type="text/javascript" src="application/js/communFormulaire.js" charset="iso-8859-1">&#160;</script>
			<script type="text/javascript" src="application/js/dateFormat.js" charset="iso-8859-1">&#160;</script>
			<script type="text/javascript" src="application/js/communJson.js" charset="iso-8859-1">&#160;</script>

			<!-- plugins -->
			<script type="text/javascript" src="application/jquery/multiselect-master/js/multiselect.min.js" charset="iso-8859-1">&#160;</script>

			<link href="application/css/jquery-customselect-1.9.1.css" rel="stylesheet" type="text/css"/>
			<script type="text/javascript" src="application//js/jquery-customselect-1.9.1.min.js" charset="iso-8859-1">&#160;</script>
			<!--link href="application/jquery/multiselect-master/js/style.css" rel="stylesheet" type="text/css"/>
			<link href="application/jquery/multiselect-master/lib/google-code-prettify/prettify.css" rel="stylesheet" type="text/css"/-->

			<!--link href="application/css/principal.css" rel="stylesheet" type="text/css"/>
			<link href="application/css/style.css" rel="stylesheet" type="text/css"/-->

			<link href="application/css/bootstrap-force.css" rel="stylesheet" type="text/css"/>
			<link href="application/css/phpmybudget.css" rel="stylesheet" type="text/css"/>
			<xsl:call-template name="js.module.sheet"/>
		</head>
	</xsl:template>
	<!-- banniere -->
	<xsl:template name="menu">
			<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
				<div class="container">
					<div class="navbar-header">
		                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
		                    <span class="sr-only">Toggle navigation</span>
		                    <span class="icon-bar"></span>
		                    <span class="icon-bar"></span>
		                    <span class="icon-bar"></span>
		                </button>
		                <a class="navbar-brand" href="#">PhpMybudget</a>
		            </div>
					<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		                <ul class="nav navbar-nav navbar-right">
		                    <li>
		                        <a href="index.php?domaine=compte&amp;service=getpage">
									<xsl:value-of select="$LBL.COMPTES"/>
								</a>
		                    </li>
		                    <li>
		                        <a href="index.php?domaine=flux&amp;service=getpage">
									<xsl:value-of select="$LBL.FLUX"/>
								</a>
		                    </li>
		                    <li>
		                    	<a href="index.php?domaine=segment">
									<xsl:value-of select="$LBL.PARAMETRAGE"/>
								</a>
							</li>
							<li>
								<a href="index.php?domaine=periode">
									<xsl:value-of select="$LBL.PERIODE"/>
								</a>
							</li>
		                </ul>
		            </div>
		        </div>
            </nav>
	</xsl:template>
	<xsl:template name="controleMenu">O</xsl:template>
	<xsl:template name="onLoadTemplate"/>
</xsl:stylesheet>
