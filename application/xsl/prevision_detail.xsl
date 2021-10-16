<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="commun.xsl"/>
  <xsl:output indent="no" encoding="UTF-8" method="xml"/>
  <xsl:param name="ANNEEEDITION">
    <xsl:value-of select="/root/data/Periodes/Periode[1]/annee"/>
  </xsl:param>
  <xsl:param name="ANNEEENCOURS">
    <xsl:choose>
      <xsl:when test="not(/root/request/annee)">
        <xsl:value-of select="substring(/root/date,1,4)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/root/request/annee"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:template match="/">
    <data>
      <colgroup />
      <xsl:for-each select="/root/data/Periodes/Periode">
        <colgroup>
          <xsl:if test="periode=substring(/root/date, 0, 8)">
            <xsl:attribute name="class">colonnemoisencours</xsl:attribute>
          </xsl:if>
        </colgroup>
      </xsl:for-each>
      <colgroup />
      <thead>
        <tr>
          <th>
            <xsl:value-of select="$LBL.FLUX"/>
          </th>
          <xsl:for-each select="/root/data/Periodes/Periode">
            <th class="text-center">
              <xsl:value-of select="periode"/>
            </th>
          </xsl:for-each>
          <th class="text-center">
            <xsl:value-of select="/root/data/Periodes/Periode[1]/annee"/>
          </th>
          <xsl:if test="$ANNEEENCOURS=$ANNEEEDITION">
            <th>AS</th>
          </xsl:if>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="/root/data/ListeFlux/Dynamic[depense='O']"/>
        <tr>
          <th>
            <xsl:value-of select="$LBL.TOTALPREVISIONS"/>
          </th>
          <xsl:for-each select="/root/data/Periodes/Periode">
            <xsl:variable name="MOISENCOURS" select="periode"/>
            <td class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId and mois=$MOISENCOURS]/montant),$FORMAT_MNT)"/>
            </td>
          </xsl:for-each>
          <!-- annee -->
          <th class="text-end recap">
            <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/montant),$FORMAT_MNT)"/>
          </th>
        </tr>
        <tr>
          <th>
            <xsl:value-of select="$LBL.TOTALDEPENSES"/>
          </th>
          <xsl:for-each select="/root/data/Periodes/Periode">
            <xsl:variable name="MOISENCOURS" select="periode"/>
            <td class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId and mois=$MOISENCOURS]/total),$FORMAT_MNT)"/>
            </td>
          </xsl:for-each>
          <th class="text-end recap">
            <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/total),$FORMAT_MNT)"/>
          </th>
        </tr>
        <tr>
          <th>
            <xsl:value-of select="$LBL.DIFFERENCE"/>
          </th>
          <xsl:for-each select="/root/data/Periodes/Periode">
            <xsl:variable name="MOISENCOURS" select="periode"/>
            <td class="text-end recap">
              <xsl:value-of
                select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId and mois=$MOISENCOURS]/total) - sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId and mois=$MOISENCOURS]/montant),$FORMAT_MNT)"/>
              </td>
            </xsl:for-each>
            <td class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/total) - sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense='O']/fluxId]/montant),$FORMAT_MNT)"/>
            </td>
          </tr>
          <xsl:apply-templates select="/root/data/ListeFlux/Dynamic[depense!='O']"/>
          <tr>
            <th>
              <xsl:value-of select="$LBL.TOTALPREVISIONS"/>
            </th>
            <xsl:for-each select="/root/data/Periodes/Periode">
              <xsl:variable name="MOISENCOURS" select="periode"/>
              <td class="text-end recap">
                <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId and mois=$MOISENCOURS]/montant),$FORMAT_MNT)"/>
              </td>
            </xsl:for-each>
            <th class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
            </th>
          </tr>
          <tr>
            <th>
              <xsl:value-of select="$LBL.TOTALRECETTES"/>
            </th>
            <xsl:for-each select="/root/data/Periodes/Periode">
              <xsl:variable name="MOISENCOURS" select="periode"/>
              <td class="text-end recap">
                <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId and mois=$MOISENCOURS]/montant),$FORMAT_MNT)"/>
              </td>
            </xsl:for-each>
            <th class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/total),$FORMAT_MNT)"/>
            </th>
          </tr>
          <tr>
            <th>
              <xsl:value-of select="$LBL.DIFFERENCE"/>
            </th>
            <xsl:for-each select="/root/data/Periodes/Periode">
              <xsl:variable name="MOISENCOURS" select="periode"/>
              <td class="text-end recap">
                <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId and mois=$MOISENCOURS]/total) - sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId and mois=$MOISENCOURS]/montant),$FORMAT_MNT)"/>
              </td>
            </xsl:for-each>
            <td class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/total) - sum(/root/data/Previsions/Prevision[fluxId=/root/data/ListeFlux/Dynamic[depense!='O']/fluxId]/montant),$FORMAT_MNT)"/>
            </td>
          </tr>
          <tr>
            <th>
              <xsl:value-of select="$LBL.TOTAL"/>
            </th>
            <xsl:for-each select="/root/data/Periodes/Periode">
              <xsl:variable name="MOISENCOURS" select="periode"/>
              <xsl:variable name="somme" select="format-number(sum(/root/data/Previsions/Prevision[mois=$MOISENCOURS]/montant),$FORMAT_MNT)"/>
              <td>
                <xsl:choose>
                  <xsl:when test="$somme &gt;= 0">
                    <xsl:attribute name="class">text-end positif recap</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">text-end negatif recap</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="$somme"/>
              </td>
            </xsl:for-each>
            <!-- total ann�e -->
            <td class="text-end recap">
              <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision/montant),$FORMAT_MNT)"/>
            </td>
          </tr>
        </tbody>
      </data>
    </xsl:template>
  <xsl:template match="Dynamic">
    <xsl:variable name="fluxId" select="fluxId"/>
    <tr class="l{@index mod 2}">
      <!-- libelle du flux -->
      <th rowspan="1" class="titre">
        <a href="#" onclick="afficheListeGroupe('{fluxId}')">
          <span class="oi oi-arrow-thick-right"/> <xsl:value-of select="flux"/>
        </a>
      </th>
      <!-- chaque flux -->
      <xsl:call-template name="case">
        <xsl:with-param name="fluxId" select="$fluxId"/>
      </xsl:call-template>
      <td class="text-end recap">
        <xsl:value-of select="format-number(sum(/root/data/Previsions/Prevision[fluxId=$fluxId]/montant),$FORMAT_MNT)"/>
      </td>
      <xsl:if test="$ANNEEENCOURS=$ANNEEEDITION">
        <td>
          <a href="#" onclick="reporterAnneeSuivante('{$NUMEROCOMPTE}','{$fluxId}','{$ANNEEENCOURS}');">
            <span class="oi oi-share"/>
          </a>
        </td>
      </xsl:if>
    </tr>
    <tr class="l{@index mod 2}">
      <td/>
      <xsl:for-each select="/root/data/Periodes/Periode">
        <xsl:variable name="MOISENCOURS" select="periode"/>
        <xsl:variable name="MNTMOIS" select="/root/data/ListeMontantFlux/Dynamic[fluxId=$fluxId and mois=$MOISENCOURS]/total"/>
        <td class="text-end">
          <xsl:if test="$MNTMOIS!=''">
            <a href="javascript:afficheDetail('numeroCompte={$NUMEROCOMPTE}&amp;mode=mois&amp;recDate={periode}&amp;recFlux={$fluxId}')">
              <xsl:value-of select="format-number($MNTMOIS,$FORMAT_MNT)"/>
            </a>
          </xsl:if>
        </td>
      </xsl:for-each>
      <td class="text-end recap">
        <xsl:value-of select="format-number(sum(/root/data/ListeMontantFlux/Dynamic[fluxId=$fluxId]/total),$FORMAT_MNT)"/>
      </td>
    </tr>
  </xsl:template>
  <xsl:template name="case">
    <xsl:param name="fluxId"/>
    <xsl:for-each select="/root/data/Periodes/Periode">
      <xsl:variable name="MOISENCOURS" select="periode"/>
      <td class="text-end ">
        <xsl:variable name="MNTPREVENC" select="/root/data/Previsions/Prevision[fluxId=$fluxId and mois=$MOISENCOURS]/montant"/>
        <xsl:variable name="LIGNEID" select="/root/data/Previsions/Prevision[fluxId=$fluxId and mois=$MOISENCOURS]/ligneId"/>
        <xsl:variable name="MNTMOIS" select="/root/data/ListeMontantFlux/Dynamic[fluxId=$fluxId and mois=$MOISENCOURS]/total"/>
        <xsl:if test="$MNTPREVENC">
          <xsl:if test="$MNTMOIS!='' and number($MNTPREVENC)!=number($MNTMOIS)">
            <a href="#"
              onclick="javascript:equilibrerPrevision('{$NUMEROCOMPTE}','{$LIGNEID}')">
              <img border="0" src="{$IMG_ROOT}icone_balance_agee_detail.gif" alt="{$LBL.EQUILIBRER}" title="{$LBL.EQUILIBRER}"/>
            </a>
          </xsl:if>
          <a href="#"
            onclick="javascript:afficheUnitaire('{$NUMEROCOMPTE}','{$LIGNEID}')">
            <xsl:value-of select="format-number($MNTPREVENC,$FORMAT_MNT)"/>
          </a>
        </xsl:if>
      </td>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
