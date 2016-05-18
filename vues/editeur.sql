select * from stat_flux where nocompte='90063454011';


select fluxid, sum(total) from stat_flux where nocompte='90063454011' and mois like '2012%' group by fluxid;


SELECT nocompte, fluxOpe.fluxId AS fluxId, DATE_FORMAT(operation.date,'%Y-%m') as mois, sum(operation.montant) AS total
  FROM operation, flux fluxOpe
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre='N'
    AND fluxOpe.fluxMaitreId = 0
    GROUP by nocompte, mois;

SELECT nocompte, fluxMaitre.fluxId AS fluxId, DATE_FORMAT(operation.date,'%Y-%m')as mois, sum(operation.montant) AS total
  FROM operation, flux fluxOpe, flux fluxMaitre
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre = 'N'
    AND fluxOpe.fluxMaitreid = fluxMaitre.fluxid
    AND fluxmaitre.fluxmaitre='O'
GROUP by nocompte, mois;

update flux set fluxmaitre='N';

select substr(stat_flux.mois,1,4) ,sum(stat_flux.total), flux.flux from stat_flux, flux where nocompte='90063454011' and mois like '2012%' and stat_flux.fluxId = flux.fluxId group by flux.flux order by flux.flux;


select * from operation where operation.nocompte='2'
union
select * from operation where operation.nocompte='90063454011'
;

SELECT nocompte, fluxOpe.fluxId AS fluxId, DATE_FORMAT(operation.date,'%Y-%m') as mois, sum(operation.montant) AS total
  FROM operation, flux fluxOpe
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre='N'
    AND fluxOpe.fluxMaitreId = 0
    GROUP BY fluxid, DATE_FORMAT(operation.date,'%Y-%m');




 SELECT operation.fluxId AS fluxId, DATE_FORMAT(operation.date,'%Y-%m')as mois, sum(operation.montant) AS total
  FROM operation, flux
  WHERE
    1=1
    AND operation.fluxId = flux.fluxId
    AND flux.fluxMaitre=0;
  
  UNION ALL
  
  /*SELECT fluxOpe.fluxId AS fluxId, DATE_FORMAT(operation.date,'%Y-%m') as mois, sum(operation.montant) AS total
  FROM operation, flux fluxOpe
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre != 0*/
  SELECT fluxMaitre.fluxId AS fluxId, DATE_FORMAT(operation.date,'%Y-%m') as mois, sum(operation.montant) AS total
  FROM operation, flux fluxOpe, flux fluxMaitre
  WHERE
    1=1
    AND operation.fluxId = fluxOpe.fluxId
    AND fluxOpe.fluxMaitre=fluxMaitre.fluxId
    AND fluxMaitre.fluxMaitre = 0
  GROUP BY fluxid, DATE_FORMAT(operation.date,'%Y-%m');