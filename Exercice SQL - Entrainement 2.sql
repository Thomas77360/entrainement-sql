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
SELECT *
FROM [dbo].[Vente];


-- Selectionner uniquement les colonnes VenteID, ClientID et VentesEuro
SELECT [VenteID], [ClientID], [VentesEuro]
FROM [dbo].[Vente];


-- Afficher les 10 premieres ventes
SELECT TOP (10) *
FROM [dbo].[Vente]
ORDER BY [VenteID];


-- Afficher les ventes du client CLIENT_4
SELECT *
FROM [dbo].[Vente]
WHERE [ClientID] = 'CLIENT_4';


-- Afficher les ventes qui ne concernent pas le produit PROD_1
SELECT *
FROM [dbo].[Vente]
WHERE [ProduitID] <> 'PROD_1';


-- Afficher les ventes du produit PROD_2 pour le client CLIENT_3
SELECT *
FROM [dbo].[Vente]
WHERE [ProduitID] = 'PROD_2'
  AND [ClientID] = 'CLIENT_3';


-- Afficher les ventes des clients CLIENT_1, CLIENT_5 et CLIENT_9
SELECT *
FROM [dbo].[Vente]
WHERE [ClientID] IN ('CLIENT_1', 'CLIENT_5', 'CLIENT_9');


-- Afficher les ventes qui ne concernent pas les clients CLIENT_1, CLIENT_2 et CLIENT_3
SELECT *
FROM [dbo].[Vente]
WHERE [ClientID] NOT IN ('CLIENT_1', 'CLIENT_2', 'CLIENT_3');


-- Afficher les ventes dont le montant VentesEuro est superieur a 10 000
SELECT *
FROM [dbo].[Vente]
WHERE [VentesEuro] > 10000;


-- Afficher les ventes dont le montant VentesEuro est compris entre 1 000 et 5 000
SELECT *
FROM [dbo].[Vente]
WHERE [VentesEuro] BETWEEN 1000 AND 5000;


-- Afficher les ventes dont le ProduitID commence par PROD_1
SELECT *
FROM [dbo].[Vente]
WHERE [ProduitID] LIKE 'PROD[_]1%';


-- Afficher les ventes triees par VentesEuro du plus grand au plus petit
SELECT *
FROM [dbo].[Vente]
ORDER BY [VentesEuro] DESC;


-- Afficher les ventes du client CLIENT_1 triees par DateFacturation puis par VentesEuro decroissant
SELECT *
FROM [dbo].[Vente]
WHERE [ClientID] = 'CLIENT_1'
ORDER BY [DateFacturation], [VentesEuro] DESC;


-- Afficher la liste des produits uniques vendus
SELECT DISTINCT [ProduitID]
FROM [dbo].[Vente]
ORDER BY [ProduitID];


-- Afficher la liste des points de vente uniques
SELECT DISTINCT [PointDeVenteID]
FROM [dbo].[Vente]
ORDER BY [PointDeVenteID];



---------------------------------------------------------------------------- AGREGATIONS ------------------------------------------------------------------------



-- Compter le nombre total de ventes
SELECT COUNT(*) AS [Nombre total de ventes]
FROM [dbo].[Vente];


-- Calculer le chiffre d'affaires total
SELECT SUM([VentesEuro]) AS [Chiffre d'affaires total]
FROM [dbo].[Vente];


-- Calculer le chiffre d'affaires total par client
SELECT [ClientID], SUM([VentesEuro]) AS [Chiffre d'affaires]
FROM [dbo].[Vente]
GROUP BY [ClientID]
ORDER BY [Chiffre d'affaires] DESC;


-- Calculer le chiffre d'affaires total par produit
SELECT [ProduitID], SUM([VentesEuro]) AS [Total chiffre d'affaires]
FROM [dbo].[Vente]
GROUP BY [ProduitID]
ORDER BY [Total chiffre d'affaires] DESC;


-- Calculer le chiffre d'affaires total par client et par produit
SELECT
    [ClientID],
    [ProduitID],
    SUM([VentesEuro]) AS [Total chiffre d'affaires]
FROM [dbo].[Vente]
GROUP BY [ClientID], [ProduitID]
ORDER BY [ClientID], [ProduitID];


-- Calculer le montant moyen d'une vente par client
SELECT [ClientID], AVG([VentesEuro]) AS [Moyenne vente par client]
FROM [dbo].[Vente]
GROUP BY [ClientID]
ORDER BY [ClientID];


-- Compter le nombre de ventes par produit
SELECT [ProduitID], COUNT(*) AS [Nombre de ventes]
FROM [dbo].[Vente]
GROUP BY [ProduitID]
ORDER BY [Nombre de ventes] DESC;


-- Trouver la vente la plus elevee par client
SELECT [ClientID], MAX([VentesEuro]) AS [Vente la plus elevee par client]
FROM [dbo].[Vente]
GROUP BY [ClientID]
ORDER BY [Vente la plus elevee par client] DESC;


-- Trouver la vente la plus faible par client
SELECT [ClientID], MIN([VentesEuro]) AS [Vente la plus faible par client]
FROM [dbo].[Vente]
GROUP BY [ClientID]
ORDER BY [Vente la plus faible par client];


-- Afficher uniquement les clients dont le chiffre d'affaires total depasse 500 000
SELECT [ClientID], SUM([VentesEuro]) AS [Chiffre d'affaires]
FROM [dbo].[Vente]
GROUP BY [ClientID]
HAVING SUM([VentesEuro]) > 500000
ORDER BY [Chiffre d'affaires] DESC;


-- Afficher uniquement les produits vendus plus de 300 fois
SELECT [ProduitID], COUNT(*) AS [Nombre de ventes]
FROM [dbo].[Vente]
GROUP BY [ProduitID]
HAVING COUNT(*) > 300
ORDER BY [Nombre de ventes] DESC;


-- Afficher le chiffre d'affaires par date de facturation
SELECT [DateFacturation], SUM([VentesEuro]) AS [Chiffre d'affaires]
FROM [dbo].[Vente]
GROUP BY [DateFacturation]
ORDER BY [DateFacturation] DESC;



---------------------------------------------------------------------------- JOINTURES MONENTREPRISE ------------------------------------------------------------------------



-- Se positionner sur la base de donnees [MonEntreprise]
USE [MonEntreprise];
GO


-- Afficher les ventes avec le nom du client
SELECT
    v.[VenteID],
    v.[ClientID],
    c.[ClientNom],
    v.[VentesEuro]
FROM [dbo].[Vente] AS v
LEFT JOIN [dbo].[Client] AS c
    ON v.[ClientID] = c.[ClientID];


-- Afficher les ventes avec le nom du produit
SELECT
    v.[VenteID],
    v.[ProduitID],
    p.[Produit] AS [ProduitNom],
    v.[QuantitesVendues],
    v.[VentesEuro]
FROM [dbo].[Vente] AS v
LEFT JOIN [dbo].[CatalogueProduit] AS p
    ON v.[ProduitID] = p.[ProduitID]
ORDER BY v.[ProduitID] DESC;


-- Afficher les ventes avec le nom du point de vente
SELECT
    v.[VenteID],
    v.[PointDeVenteID],
    pt.[Ville],
    pt.[Pays],
    v.[VentesEuro]
FROM [dbo].[Vente] AS v
LEFT JOIN [dbo].[PointDeVente] AS pt
    ON v.[PointDeVenteID] = pt.[PointDeVenteID]
ORDER BY v.[PointDeVenteID] DESC;


-- Afficher VenteID, ClientNom, ProduitNom, VentesEuro


-- Afficher le chiffre d'affaires total par nom de client


-- Afficher le chiffre d'affaires total par nom de produit


-- Afficher le chiffre d'affaires total par pays client


-- Afficher les clients meme s'ils n'ont pas de vente


-- Afficher les produits meme s'ils n'ont pas de vente



---------------------------------------------------------------------------- JOINTURES BASE JOINTURE ------------------------------------------------------------------------



-- Se positionner sur la base de donnees [Jointure]


-- Afficher toutes les lignes de TableA


-- Afficher toutes les lignes de TableB


-- Faire un INNER JOIN entre TableA et TableB


-- Faire un LEFT JOIN entre TableA et TableB


-- Faire un RIGHT JOIN entre TableA et TableB


-- Faire un FULL OUTER JOIN entre TableA et TableB


-- Faire un CROSS JOIN entre TableA et TableB


-- Afficher uniquement les valeurs presentes dans TableA mais absentes de TableB


-- Afficher uniquement les valeurs presentes dans TableB mais absentes de TableA


-- Afficher les valeurs communes entre TableA et TableB



---------------------------------------------------------------------------- UNION ------------------------------------------------------------------------



-- Afficher les enregistrements de TableC et TableD avec suppression des doublons


-- Afficher les enregistrements de TableC et TableD sans suppression des doublons


-- Afficher uniquement les prenoms presents dans les deux tables TableC et TableD


-- Afficher uniquement les prenoms presents dans TableC mais absents de TableD


/*
Fin de la feuille d'entrainement.
*/
