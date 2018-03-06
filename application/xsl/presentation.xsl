<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--regle principal-->
	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
		<html lang="fr">
			<xsl:call-template name="Header">
				<xsl:with-param name="HeadTitre"><xsl:value-of select="/root/titre"/></xsl:with-param>
			</xsl:call-template>
			<body lang="fr">
				<xsl:attribute name="onload">
					<xsl:call-template name="onLoadTemplate"/>
				</xsl:attribute>

				<xsl:variable name="affMenu">
					<xsl:call-template name="controleMenu"/>
				</xsl:variable>
				<!-- affichage barre de navigation -->
				<xsl:if test="$affMenu='O'">
					<xsl:call-template name="menu">
						<xsl:with-param name="niveau1"><xsl:value-of select="/root/titre"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<!-- affichage du contenu -->
				<div class="container contenu">
					<xsl:choose>
						<xsl:when test="$affMenu='O'">
							<xsl:attribute name="class">container contenu</xsl:attribute>
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
	<!--header de la page-->
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
				<xsl:choose>
					<xsl:when test="$HeadTitre!=''">
						<xsl:value-of select="$HeadTitre"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'PhpMyBudget'"/>
					</xsl:otherwise>
				</xsl:choose>
			</title>
			
			<link href="front/bootstrap/bootstrap-{$BOOTSTRAP-VERSION}-dist/css/bootstrap.min.css" rel="stylesheet"/>
			<!--link href="front/bootstrap/bootstrap-{$BOOTSTRAP-VERSION}-dist/css/bootstrap-theme.min.css" rel="stylesheet"/-->
			<link href="front/font/css/open-iconic-bootstrap.css" rel="stylesheet" type="text/css"/>
			
			<link href="front/jquery/jquery-ui-{$JQUERY-VERSION}.custom/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
			
			<script type="text/javascript" src="front/jquery/jquery-ui-{$JQUERY-VERSION}.custom/external/jquery/jquery.js" charset="UTF-8">&#160;</script>
			<!--script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script-->
    
			<script type="text/javascript" src="front/bootstrap/bootstrap-{$BOOTSTRAP-VERSION}-dist/js/bootstrap.min.js" charset="UTF-8">&#160;</script>
			<script type="text/javascript" src="front/jquery/jquery-ui-{$JQUERY-VERSION}.custom/jquery-ui.min.js" charset="UTF-8">&#160;</script>

			<script type="text/javascript" src="front/js/commun.js" charset="UTF-8">&#160;</script>
			<script type="text/javascript" src="front/js/communFormulaire.js" charset="UTF-8">&#160;</script>
			<script type="text/javascript" src="front/js/dateFormat.js" charset="UTF-8">&#160;</script>
			<script type="text/javascript" src="front/js/communJson.js" charset="UTF-8">&#160;</script>
			<script type="text/javascript" src="front/core/session.js" charset="UTF-8">&#160;</script>
			<script type="text/javascript" src="front/js/core_ajax.js" charset="UTF-8">&#160;</script>
			
			<!-- plugins -->
			<link href="front/css/jquery.multiselect.css" rel="stylesheet" type="text/css"/>
			<script type="text/javascript" src="front/js/jquery.multiselect.js" charset="UTF-8">&#160;</script>

			<link href="front/css/bootstrap-force.css" rel="stylesheet" type="text/css"/>
			<link href="front/css/phpmybudget.css" rel="stylesheet" type="text/css"/>
			<xsl:call-template name="js.module.sheet"/>
		</head>
	</xsl:template>
	<!-- banniere -->
	<xsl:template name="menu">
		<xsl:param name="niveau1"/>
		<div class="row justify-content-md-center">
			<div class="col-sm-10">
		
			<nav class="navbar navbar-expand-lg navbar-light bg-light">
				<!--p class="navbar-brand" style="color: white;">PhpMybudget</p>
				<xsl:if test="$niveau1!=''">
						<p class="navbar-text" style="color: white;">/</p>
						<p class="navbar-text" style="color: white;"><xsl:value-of select="$niveau1"/></p>
					</xsl:if-->
				<!--div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button-->
					<!--a class="navbar-brand" href="#">PhpMybudget</a-->
					<!--pan class="icon-bar">PhpMybudget</span-->
					<!--p class="navbar-text" style="color: white;">PhpMybudget</p>
					
					<xsl:if test="$niveau1!=''">
						<p class="navbar-text" style="color: white;">/</p>
						<p class="navbar-text" style="color: white;"><xsl:value-of select="$niveau1"/></p>
					</xsl:if-->
					
					<!--ol class="breadcrumb">
					  <li>PhpMybudget</li>
					  <li><a href="#">Library</a></li>
					  <li class="active">Data</li>
					</ol-->
					
				<!--/div-->
				<div class="collapse navbar-collapse ml-auto" id="navbarNavAltMarkup">
					<!--div class="navbar-nav">
					<a class="nav-item nav-link active" href="index.php?domaine=compte&amp;service=getpage">
						<xsl:value-of select="$LBL.COMPTES"/>
					</a>
					  <a class="nav-item nav-link active" href="#">Features</a>
					  <a class="nav-item nav-link active" href="#">Pricing</a>
					  <a class="nav-item nav-link active" href="#">Disabled</a>
					</div-->
					<p class="navbar-brand" style="color: white;">PhpMybudget</p>
							<xsl:if test="$niveau1!=''">
							<p class="navbar-text" style="color: white;">/</p>
							<p class="navbar-text" style="color: white;"><xsl:value-of select="$niveau1"/></p>
					</xsl:if>
					<!--ul class="navbar-nav mr-auto">
						<li class="nav-item active">
							<p class="navbar-brand" style="color: white;">PhpMybudget</p>
							<xsl:if test="$niveau1!=''">
							<p class="navbar-text" style="color: white;">/</p>
							<p class="navbar-text" style="color: white;"><xsl:value-of select="$niveau1"/></p>
							</xsl:if>
						</li>
					</ul-->
					<ul class="navbar-nav ml-auto">
						<li class="nav-item">
							<a class="nav-item nav-link active" href="index.php?domaine=compte&amp;service=getpage" style="color: white;">
								<xsl:value-of select="$LBL.COMPTES"/>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-item nav-link active" href="index.php?domaine=flux&amp;service=getpage" style="color: white;">
								<xsl:value-of select="$LBL.FLUX"/>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-item nav-link active" href="index.php?domaine=segment" style="color: white;">
								<xsl:value-of select="$LBL.PARAMETRAGE"/>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-item nav-link active blanc" href="index.php?domaine=periode" style="color: white;">
								<xsl:value-of select="$LBL.PERIODE"/>
							</a>
						</li>
					</ul>
				  </div>
				<!--div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
					<ul class="navbar-nav mr-auto mt-2 mt-lg-0">
						<li class="nav-item active">
							<a href="index.php?domaine=compte&amp;service=getpage">
								<xsl:value-of select="$LBL.COMPTES"/>
							</a>
						</li>
						<li class="nav-item active">
							<a href="index.php?domaine=flux&amp;service=getpage">
								<xsl:value-of select="$LBL.FLUX"/>
							</a>
						</li>
						<li class="nav-item active">
							<a href="index.php?domaine=segment">
								<xsl:value-of select="$LBL.PARAMETRAGE"/>
							</a>
						</li>
						<li class="nav-item active">
							<a href="index.php?domaine=periode">
								<xsl:value-of select="$LBL.PERIODE"/>
							</a>
						</li>
					</ul>
				</div-->
			
		</nav>
			</div>
			</div>
	</xsl:template>
	<xsl:template name="controleMenu">O</xsl:template>
	<xsl:template name="onLoadTemplate"/>
</xsl:stylesheet>
