/*
Dataseito - Entrainement SQL supplementaire

Objectif :
- refaire les bases sans regarder le corrige
- pratiquer les filtres, agregations, jointures et UNION
- ecrire les requetes sous chaque consigne
*/



---------------------------------------------------------------------------- COMMANDES DE BASE ------------------------------------------------------------------------



-- Se positionner sur la base de donnees [MonEntreprise]


-- Selectionner toutes les colonnes de la table Vente


-- Selectionner uniquement les colonnes VenteID, ClientID et VentesEuro


-- Afficher les 10 premieres ventes


-- Afficher les ventes du client CLIENT_4


-- Afficher les ventes qui ne concernent pas le produit PROD_1


-- Afficher les ventes du produit PROD_2 pour le client CLIENT_3


-- Afficher les ventes des clients CLIENT_1, CLIENT_5 et CLIENT_9


-- Afficher les ventes qui ne concernent pas les clients CLIENT_1, CLIENT_2 et CLIENT_3


-- Afficher les ventes dont le montant VentesEuro est superieur a 10 000


-- Afficher les ventes dont le montant VentesEuro est compris entre 1 000 et 5 000


-- Afficher les ventes dont le ProduitID commence par PROD_1


-- Afficher les ventes triees par VentesEuro du plus grand au plus petit


-- Afficher les ventes du client CLIENT_1 triees par DateFacturation puis par VentesEuro decroissant


-- Afficher la liste des produits uniques vendus


-- Afficher la liste des points de vente uniques



---------------------------------------------------------------------------- AGREGATIONS ------------------------------------------------------------------------



-- Compter le nombre total de ventes


-- Calculer le chiffre d'affaires total


-- Calculer le chiffre d'affaires total par client


-- Calculer le chiffre d'affaires total par produit


-- Calculer le chiffre d'affaires total par client et par produit


-- Calculer le montant moyen d'une vente par client


-- Compter le nombre de ventes par produit


-- Trouver la vente la plus elevee par client


-- Trouver la vente la plus faible par client


-- Afficher uniquement les clients dont le chiffre d'affaires total depasse 500 000


-- Afficher uniquement les produits vendus plus de 300 fois


-- Afficher le chiffre d'affaires par date de facturation



---------------------------------------------------------------------------- JOINTURES MONENTREPRISE ------------------------------------------------------------------------



-- Se positionner sur la base de donnees [MonEntreprise]


-- Afficher les ventes avec le nom du client


-- Afficher les ventes avec le nom du produit


-- Afficher les ventes avec le nom du point de vente


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

