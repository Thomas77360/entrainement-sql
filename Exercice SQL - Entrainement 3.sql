/*
Dataseito - Entrainement SQL supplementaire 3

Objectif :
- renforcer les jointures
- travailler les lignes presentes / absentes entre deux tables
- pratiquer LEFT JOIN, INNER JOIN, FULL OUTER JOIN, CROSS JOIN, UNION et UNION ALL
- ecrire les requetes sous chaque consigne
*/



---------------------------------------------------------------------------- JOINTURES MONENTREPRISE ------------------------------------------------------------------------

-- Se positionner sur la base de donnees [MonEntreprise]
USE [MonEntreprise];
GO

-- Afficher toutes les ventes avec le nom du client


-- Afficher toutes les ventes avec le nom du produit
SELECT 
    v.[VenteID],
    c.[ClientID],
    v.[VentesEuro],
    p.[Produit]
FROM [dbo].[Vente] AS v
JOIN [dbo].[Client] AS c
    ON v.[ClientID] = c.[ClientID]
JOIN [dbo].[CatalogueProduit] AS p
    ON p.[ProduitID] = v.[ProduitID];

-- Afficher VenteID, ClientNom, Produit, VentesEuro
SELECT 
    v.[VenteID],
    c.[ClientNom],
    p.[Produit],
    v.[VentesEuro]
FROM [dbo].[Vente] AS v
JOIN [dbo].[Client] AS c
    ON v.[ClientID] = c.[ClientID]
JOIN [dbo].[CatalogueProduit] AS p
    ON p.[ProduitID] = v.[ProduitID];

-- Afficher le chiffre d'affaires total par client
-- Colonnes attendues : ClientID, ClientNom, chiffre_affaires
SELECT 
    v.[ClientID],
    c.[ClientNom],
    sum(v.[VentesEuro]) AS chiffre_affaires
FROM [dbo].[Vente] AS v
JOIN [dbo].[Client] AS c
    ON v.[ClientID] = c.[ClientID]
JOIN [dbo].[CatalogueProduit] AS p
    ON p.[ProduitID] = v.[ProduitID]
GROUP BY v.[ClientID], c.[ClientNom]
ORDER BY chiffre_affaires DESC;

-- Afficher le chiffre d'affaires total par produit
-- Colonnes attendues : ProduitID, Produit, chiffre_affaires
SELECT 
    c.[ProduitID], 
    c.[Produit],
    sum([VentesEuro]) AS chiffre_affaires
FROM [dbo].[CatalogueProduit] AS c
JOIN [dbo].[Vente] AS v
    ON c.[ProduitID] = v.[ProduitID]
GROUP BY 
    c.ProduitID, 
    c.Produit
ORDER BY chiffre_affaires DESC;


-- Afficher tous les clients meme s'ils n'ont pas de vente
-- Colonnes attendues : ClientID, ClientNom, chiffre_affaires
SELECT 
    c.ClientID,
    c.ClientNom,
    SUM(VentesEuro) AS chiffre_affaires
FROM dbo.client as c
LEFT JOIN dbo.vente as v
    ON c.ClientID = v.ClientID
GROUP BY
    c.ClientID,
    c.ClientNom
ORDER BY chiffre_affaires DESC;

-- Afficher uniquement les clients qui n'ont jamais achete
SELECT 
    c.ClientID,
    c.ClientNom,
    COALESCE(SUM(VentesEuro),0) AS chiffre_affaires
FROM dbo.client as c
LEFT JOIN dbo.vente as v
    ON c.ClientID = v.ClientID
GROUP BY
    c.ClientID,
    c.ClientNom
HAVING COALESCE(SUM(VentesEuro),0) = 0;

SELECT 
    c.ClientID,
    c.ClientNom
FROM dbo.client as c
LEFT JOIN dbo.vente as v
    ON c.ClientID = v.ClientID
WHERE v.ClientID IS NULL;

-- Afficher tous les produits meme s'ils n'ont pas de vente
-- Colonnes attendues : ProduitID, Produit, chiffre_affaires
SELECT 
    c.ProduitID,
    c.Produit,
    COALESCE(SUM(VentesEuro),0) AS chiffre_affaires
FROM dbo.CatalogueProduit as c
LEFT JOIN dbo.Vente as v
    ON c.ProduitID = v.ProduitID
GROUP BY
    c.ProduitID,
    c.Produit
ORDER BY chiffre_affaires DESC;

-- Afficher uniquement les produits qui n'ont jamais ete vendus
SELECT 
    c.ProduitID,
    c.Produit
FROM dbo.CatalogueProduit as c
LEFT JOIN dbo.Vente as v
    ON c.ProduitID = v.ProduitID
WHERE v.VenteID IS NULL;

-- Afficher le nombre de ventes par client, meme les clients sans vente
-- Colonnes attendues : ClientID, ClientNom, nombre_ventes
SELECT 
    v.ClientID,
    c.ClientNom,
    COUNT(v.VenteID) AS nombre_ventes
FROM dbo.Client as c
LEFT JOIN dbo.Vente as v
    ON c.ClientID = v.ClientID
GROUP BY
    v.ClientID,
    c.ClientNom
ORDER BY nombre_ventes DESC;

-- Afficher le nombre de ventes par produit, meme les produits sans vente
-- Colonnes attendues : ProduitID, Produit, nombre_ventes


-- Afficher le chiffre d'affaires total par pays client
-- Colonnes attendues : Pays, chiffre_affaires


-- Afficher le chiffre d'affaires total par point de vente
-- Colonnes attendues : PointDeVenteID, chiffre_affaires


-- Afficher toutes les combinaisons possibles entre les clients et les produits



---------------------------------------------------------------------------- JOINTURES BASE JOINTURE ------------------------------------------------------------------------

-- Se positionner sur la base de donnees [Jointure]
USE [Jointure];
GO

-- Afficher toutes les lignes de TableA


-- Afficher toutes les lignes de TableB


-- Afficher les valeurs communes entre TableA et TableB


-- Afficher toutes les valeurs de TableA avec les correspondances de TableB si elles existent


-- Afficher toutes les valeurs de TableB avec les correspondances de TableA si elles existent


-- Afficher toutes les valeurs de TableA et de TableB, meme sans correspondance


-- Afficher toutes les combinaisons possibles entre TableA et TableB


-- Afficher uniquement les valeurs presentes dans TableA mais absentes de TableB


-- Afficher uniquement les valeurs presentes dans TableB mais absentes de TableA


-- Afficher uniquement les valeurs qui ne sont pas communes entre TableA et TableB
-- Indice : utiliser FULL OUTER JOIN avec un filtre IS NULL



---------------------------------------------------------------------------- UNION ------------------------------------------------------------------------

-- Afficher les enregistrements de TableC et TableD avec suppression des doublons


-- Afficher les enregistrements de TableC et TableD sans suppression des doublons


-- Afficher uniquement les prenoms presents dans TableC mais absents de TableD


-- Afficher uniquement les prenoms presents dans TableD mais absents de TableC


-- Afficher tous les prenoms des deux tables avec une colonne source_table
-- Exemple de valeurs attendues dans source_table : 'TableC' ou 'TableD'


/*
Fin de la feuille d'entrainement 3.
*/
