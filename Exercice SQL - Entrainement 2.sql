/*
Dataseito - Entrainement SQL supplementaire

Objectif :
- refaire les bases sans regarder le corrige
- pratiquer les filtres, agregations, jointures et UNION
- ecrire les requetes sous chaque consigne
*/



---------------------------------------------------------------------------- COMMANDES DE BASE ------------------------------------------------------------------------

-- Se positionner sur la base de donnees [MonEntreprise]
USE [MonEntreprise];
GO

-- Selectionner toutes les colonnes de la table Vente
select * 
from vente;

-- Selectionner uniquement les colonnes VenteID, ClientID et VentesEuro
Select VenteID, ClientID, VentesEuro
from vente;

-- Afficher les 10 premieres ventes
select top 10 *
from vente;

-- Afficher les ventes du client CLIENT_4
select *
from vente
where clientID = 'client_4';

-- Afficher les ventes qui ne concernent pas le produit PROD_1
select *
from vente
where produitID != 'prod_1';

-- Afficher les ventes du produit PROD_2 pour le client CLIENT_3
select venteID, produitID, clientID
from vente
where produitID = 'PROD_2' and clientID = 'CLIENT_3';


-- Afficher les ventes des clients CLIENT_1, CLIENT_5 et CLIENT_9
select *
from vente
where clientID in ('CLIENT_1', 'CLIENT_5', 'CLIENT_9');

-- Afficher les ventes qui ne concernent pas les clients CLIENT_1, CLIENT_2 et CLIENT_3
select * 
from vente
where clientID not in ('CLIENT_1', 'CLIENT_2', 'CLIENT_3')


-- Afficher les ventes dont le montant VentesEuro est superieur a 10 000
select * 
from vente
where VentesEuro > 10000;

-- Afficher les ventes dont le montant VentesEuro est compris entre 1 000 et 5 000
select *
from vente
where VentesEuro between 1000 and 5000;

-- Afficher les ventes dont le ProduitID commence par PROD_1
select *
from vente
where ProduitID like 'PROD_1'

-- Afficher les ventes triees par VentesEuro du plus grand au plus petit
select *
from vente
order by VentesEuro desc;

-- Afficher les ventes du client CLIENT_1 triees par DateFacturation puis par VentesEuro decroissant
select *
from vente
where clientID = 'CLIENT_1'
order by DateFacturation, VentesEuro desc;

-- Afficher la liste des produits uniques vendus
select distinct produitID
from vente;

-- Afficher la liste des points de vente uniques
select distinct PointDeVenteID
from vente;

---------------------------------------------------------------------------- AGREGATIONS ------------------------------------------------------------------------

-- Compter le nombre total de ventes
select count(*)
from vente;

-- Calculer le chiffre d'affaires total
select sum(VentesEuro)
from vente

-- Calculer le chiffre d'affaires total par client
select clientID ,sum(VentesEuro) as chiffre_daffaires 
from vente
group by clientID
order by clientID; 

-- Calculer le chiffre d'affaires total par produit
select produitID, sum(VentesEuro) as chiffre_affaire
from vente
group by produitID
order by chiffre_affaire desc

-- Calculer le chiffre d'affaires total par client et par produit
select clientID, produitID, sum(VentesEuro) as chiffre_affaire
from vente
group by clientID, produitID
order by chiffre_affaire desc; 

-- Calculer le montant moyen d'une vente par client
select clientID, avg(VentesEuro) as moy_CA
from vente
group by clientID
order by moy_CA desc;


-- Compter le nombre de ventes par produit
select produitID, count(*) as nombre_vente
from vente
group by produitID
order by nombre_vente desc;

-- Trouver la vente la plus elevee par client
select clientID, max(VentesEuro) as max_vente
from vente
group by clientID
order by max_vente desc;

-- Trouver la vente la plus faible par client
select clientID, min(VentesEuro) as min_vente
from vente
group by clientID
order by min_vente;

-- Afficher uniquement les clients dont le chiffre d'affaires total depasse 500 000
select clientID, sum(VentesEuro) as chiffre_affaires
from vente
group by clientID
having sum(VentesEuro) > 500000


-- Afficher uniquement les produits vendus plus de 300 fois
select produitID, count(venteID) as nombre_vente
from vente
group by produitID
having count(venteID) > 300


-- Afficher le chiffre d'affaires par date de facturation
select DateFacturation, sum(VentesEuro) as chiffre_affaires
from vente
group by DateFacturation
order by DateFacturation desc;
---------------------------------------------------------------------------- JOINTURES MONENTREPRISE ------------------------------------------------------------------------

-- Se positionner sur la base de donnees [MonEntreprise]
use MonEntreprise
go

-- Afficher les ventes avec le nom du client
select
    c.ClientID,
    c.ClientNom,
    v.VenteID
from dbo.Client c
join dbo.Vente v
on c.ClientID = v.ClientID;

-- Afficher les ventes avec le nom du produit
select 
    c.ProduitID,
    c.Produit,
    count(v.VenteID) as vente

from dbo.Vente AS v
join dbo.CatalogueProduit as c
on v.ProduitID = c.ProduitID 

group by c.produit, c.produitID
order by vente desc;

-- Afficher les ventes avec le nom du point de vente
select 
    p.[PointDeVenteID],
    p.[Continent],
    count(v.[VenteID]) as vente,
    sum(v.[VentesEuro]) as CA

from [dbo].[PointDeVente] as p
join [dbo].[Vente] as v
on v.[PointDeVenteID] = p.[PointDeVenteID]

group by p.[PointDeVenteID], p.[Continent];

-- Afficher VenteID, ClientNom, ProduitNom, VentesEuro
select
    v.[VenteID],
    c.[ClientNom],
    p.[Produit] as ProduitNom,
    sum(v.[VentesEuro]) as chiffre_affaire

from [dbo].[Vente] as v
join [dbo].[CatalogueProduit] as p
    on v.[ProduitID] = p.[ProduitID]
join [dbo].[Client] as c
    on v.[ClientID] = c.[ClientID]

group by c.ClientNom, v.VenteID, p.Produit
order by chiffre_affaire desc;

-- Afficher le chiffre d'affaires total par nom de client
select
    c.[ClientNom],
    c.[ClientID],
    sum(v.[VentesEuro]) as chiffre_affaires

from [dbo].[Vente] as v
join [dbo].[Client] as c
    on v.[ClientID] = c.[ClientID]

group by [ClientNom], c.[ClientID]
order by chiffre_affaires desc;

-- Afficher le chiffre d'affaires total par nom de produit
select
    c.[ProduitID],
    c.[Produit],
    sum([VentesEuro])as chiffre_affaires

from [dbo].[CatalogueProduit] as c
join [dbo].[Vente] as v
    on c.[ProduitID] = v.[ProduitID]

group by 
    c.ProduitID, 
    c.Produit

order by chiffre_affaires desc;

-- Afficher le chiffre d'affaires total par pays client
select
    c.[Pays],
    sum(v.[VentesEuro]) as chiffre_affaires

from [dbo].[Client] as c
join [dbo].[Vente] as v
    on c.[ClientID] = V.[ClientID]

group by 
    c.[Pays]
    
order by chiffre_affaires desc;

-- Afficher les clients meme s'ils n'ont pas de vente
select
    c.[ClientID],
    c.[ClientNom],
    coalesce(sum(v.[VentesEuro]), 0) as ventes

from [dbo].[Client] as c
left join [dbo].[Vente] as v
    on c.[ClientID] = v.[ClientID]

group by 
    c.[ClientID],
    c.[ClientNom]

order by
    ventes desc

-- Afficher les produits meme s'ils n'ont pas de vente
SELECT
    p.[Produit],
    p.[ProduitID],
    COALESCE(SUM(v.[VentesEuro]),0) as chiffre_affaires
FROM [dbo].[CatalogueProduit] as p
LEFT JOIN [dbo].[Vente] as v
    ON p.[ProduitID] = v.[ProduitID]
GROUP BY 
    p.[Produit],
    p.[ProduitID]

---------------------------------------------------------------------------- JOINTURES BASE JOINTURE ------------------------------------------------------------------------



-- Se positionner sur la base de donnees [Jointure]
USE Jointure
Go

-- Afficher toutes les lignes de TableA
select *
from [dbo].[TableA];

-- Afficher toutes les lignes de TableB
select * 
from tableB;

-- Faire un INNER JOIN entre TableA et TableB
select TableA_ID, TableB_ID
from TableA
inner join TableB
ON TableA.TableA_ID = TableB.TableB_ID;

-- Faire un LEFT JOIN entre TableA et TableB
select TableA_ID, TableB_ID
from TableA
LEFT join TableB
ON TableA.TableA_ID = TableB.TableB_ID;

-- Faire un RIGHT JOIN entre TableA et TableB
SELECT *
FROM [dbo].[TableA] as a
RIGHT JOIN [dbo].[TableB] as b
    ON a.[TableA_ID] = b.[TableB_ID]

-- Faire un FULL OUTER JOIN entre TableA et TableB
SELECT *
FROM [dbo].[TableA] as a
FULL OUTER JOIN [dbo].[TableB] as b
    ON a.[TableA_ID] = b.[TableB_ID];

-- Faire un CROSS JOIN entre TableA et TableB
SELECT *
FROM [dbo].[TableA] as a
CROSS JOIN [dbo].[TableB] as b
    
-- Afficher uniquement les valeurs presentes dans TableA mais absentes de TableB
SELECT
    a.*
FROM [dbo].[TableA] AS a
LEFT JOIN [dbo].[TableB] AS b
    ON a.[TableA_ID] = b.[TableB_ID]
WHERE b.[TableB_ID] IS NULL;

-- Afficher uniquement les valeurs presentes dans TableB mais absentes de TableA
SELECT
    b.*
FROM [dbo].[TableB] as b
LEFT JOIN [dbo].[TableA] as a
    ON [TableB_ID] = [TableA_ID]
WHERE a.[TableA_ID] IS NULL;

-- Afficher les valeurs communes entre TableA et TableB
SELECT *
FROM [dbo].[TableA] AS a
INNER JOIN [dbo].[TableB] as b
    ON a.[TableA_ID] = b.[TableB_ID];



---------------------------------------------------------------------------- UNION ------------------------------------------------------------------------



-- Afficher les enregistrements de TableC et TableD avec suppression des doublons


-- Afficher les enregistrements de TableC et TableD sans suppression des doublons


-- Afficher uniquement les prenoms presents dans les deux tables TableC et TableD


-- Afficher uniquement les prenoms presents dans TableC mais absents de TableD


/*
Fin de la feuille d'entrainement.
*/
