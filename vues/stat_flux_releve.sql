CREATE OR REPLACE VIEW stat_flux_releve AS

SELECT nocompte, fluxOpe.fluxId AS fluxId, noreleve, sum(operation.montant) AS total
  FROM operation, flux fluxOpe
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre='N'
    AND fluxOpe.fluxMaitreId = 0
    GROUP BY nocompte, fluxid, noreleve
  UNION

  SELECT nocompte, fluxMaitre.fluxId AS fluxId, noreleve, sum(operation.montant) AS total
  FROM operation, flux fluxOpe, flux fluxMaitre
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre = 'N'
    AND fluxOpe.fluxMaitreid = fluxMaitre.fluxid
    AND fluxmaitre.fluxmaitre='O'
    GROUP BY nocompte, fluxid, noreleve
  ;

