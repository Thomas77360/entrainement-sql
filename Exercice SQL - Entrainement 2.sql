/*
Dataseito - Entrainement SQL supplementaire

Objectif :
- refaire les bases sans regarder le corrige
- pratiquer les filtres, agregations, jointures et UNION
- ecrire les requetes sous chaque consigne
*/



---------------------------------------------------------------------------- COMMANDES DE BASE ------------------------------------------------------------------------



-- Se positionner sur la base de donnees [MonEntreprise]
use MonEntreprise
go;

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
