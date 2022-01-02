CREATE OR REPLACE VIEW stat_flux AS 
select `operation`.`noCompte` AS `nocompte`,`fluxope`.`fluxId` AS `fluxId`,`fluxope`.`fluxMaitre` AS `fluxMaitre`,date_format(`operation`.`dateOperation`,'%Y-%m') AS `mois`,sum(`operation`.`montant`) AS `total` 
from (`operation` join `flux` `fluxope` ) 
where (
	(1 = 1) 
	and (`operation`.`fluxId` = `fluxope`.`fluxId`) 
	and (`fluxope`.`fluxMaitre` = 'N') 
	and (`fluxope`.`fluxMaitreId` = 0)
) group by `operation`.`noCompte`,`fluxope`.`fluxId`,date_format(`operation`.`dateOperation`,'%Y-%m') 


union

select `operation`.`noCompte` AS `nocompte`,`fluxmaitre`.`fluxId` AS `fluxId`,`fluxmaitre`.`fluxMaitre` AS `fluxMaitre`,date_format(`operation`.`dateOperation`,'%Y-%m') AS `mois`,sum(`operation`.`montant`) AS `total` 
from ((`operation` join `flux` `fluxope`) join `flux` `fluxmaitre` ON operation.nocompte = `fluxmaitre`.compteid) 
where (
	(1 = 1) 
	and (`operation`.`fluxId` = `fluxope`.`fluxId`) 
	and (`fluxope`.`fluxMaitre` = 'N') 
	and (`fluxope`.`fluxMaitreId` = `fluxmaitre`.`fluxId`) 
	and (`fluxmaitre`.`fluxMaitre` = 'O')
) group by `operation`.`noCompte`,`fluxmaitre`.`fluxId`,date_format(`operation`.`dateOperation`,'%Y-%m');