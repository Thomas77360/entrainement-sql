# Entrainement SQL

Exercices SQL bases sur le repo Dataseito `video-apprendre-sql-pour-debutant`.

Le projet contient :

- `Exercice SQL.sql` : mes reponses aux exercices
- `Script SQL - Creation base de donnees Jointure.sql` : creation de la base `Jointure`
- `MonEntreprise.bak` : sauvegarde SQL Server de la base `MonEntreprise`
- `Vente.csv` : donnees de la table `Vente`

## Prerequis

- Visual Studio Code
- Extension VS Code `SQL Server (mssql)`
- Docker Desktop, ou SQL Server installe localement

## Demarrage rapide

Pour preparer SQL Server automatiquement :

```bash
chmod +x setup-sqlserver.sh
./setup-sqlserver.sh
```

Le script fait tout le setup :

- lance SQL Server avec Docker
- restaure la base `MonEntreprise`
- cree la table `Vente` depuis `Vente.csv`
- cree la base `Jointure`
- verifie que les bases sont disponibles

Ensuite, ouvrir `Exercice SQL.sql` dans VS Code et executer les requetes une par une.

Connexion VS Code :

```text
Server: localhost,1433
Authentication: SQL Login
User: sa
Password: Password123!
Database: master
Trust server certificate: true
```

## Setup manuel

Les etapes ci-dessous servent si le script automatique ne peut pas etre utilise.

### Lancer SQL Server avec Docker

```bash
docker run --platform linux/amd64 \
  -e 'ACCEPT_EULA=Y' \
  -e 'MSSQL_SA_PASSWORD=Password123!' \
  -p 1433:1433 \
  --name sqlserver \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

Si le conteneur existe deja :

```bash
docker start sqlserver
```

Connexion VS Code :

```text
Server: localhost,1433
Authentication: SQL Login
User: sa
Password: Password123!
Database: master
Trust server certificate: true
```

### Restaurer la base MonEntreprise

Copier le fichier `.bak` dans le conteneur :

```bash
docker exec sqlserver mkdir -p /var/opt/mssql/backup
docker cp MonEntreprise.bak sqlserver:/var/opt/mssql/backup/MonEntreprise.bak
```

Restaurer la base :

```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Password123!' -C \
  -Q "RESTORE DATABASE MonEntreprise FROM DISK = '/var/opt/mssql/backup/MonEntreprise.bak' WITH MOVE 'MonEntreprise' TO '/var/opt/mssql/data/MonEntreprise.mdf', MOVE 'MonEntreprise_log' TO '/var/opt/mssql/data/MonEntreprise_log.ldf', REPLACE"
```

### Creer la table Vente

La sauvegarde contient `Client`, `CatalogueProduit` et `PointDeVente`.
La table `Vente` est creee depuis `Vente.csv`.

```bash
docker cp Vente.csv sqlserver:/var/opt/mssql/backup/Vente.csv
```

```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Password123!' -C -d MonEntreprise \
  -Q "IF OBJECT_ID('dbo.Vente', 'U') IS NOT NULL DROP TABLE dbo.Vente; CREATE TABLE dbo.Vente (VenteID int NOT NULL, ClientID varchar(50) NOT NULL, PointDeVenteID varchar(50) NOT NULL, ProduitID varchar(50) NOT NULL, QuantitesVendues int NOT NULL, PrixVenteUnitaire decimal(18,2) NOT NULL, VentesEuro decimal(18,2) NOT NULL, DateFacturation date NOT NULL); SET DATEFORMAT dmy; BULK INSERT dbo.Vente FROM '/var/opt/mssql/backup/Vente.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '0x0a'); SELECT COUNT(*) AS NbVentes FROM dbo.Vente;"
```

La table doit contenir `2120` lignes.

### Creer la base Jointure

Dans VS Code, ouvrir :

```text
Script SQL - Creation base de donnees Jointure.sql
```

Puis executer le fichier complet.

Si les tables existent deja et que le script a ete lance plusieurs fois, supprimer/recharger les donnees :

```sql
USE Jointure;
GO

DELETE FROM dbo.TableA;
DELETE FROM dbo.TableB;
DELETE FROM dbo.TableC;
DELETE FROM dbo.TableD;
GO

INSERT INTO dbo.TableA VALUES (1), (2), (3), (50), (70), (NULL);
INSERT INTO dbo.TableB VALUES (1), (2), (3), (40), (60);
INSERT INTO dbo.TableC VALUES (1, 'Victor'), (2, 'Marie'), (3, 'Pierre'), (4, 'Esther');
INSERT INTO dbo.TableD VALUES (4, 'Esther'), (5, 'Jonathan'), (6, 'Lucie');
GO
```

## Tester

Tester `MonEntreprise` :

```sql
USE MonEntreprise;
GO

SELECT TOP (5) *
FROM dbo.Vente;
```

Tester `Jointure` :

```sql
USE Jointure;
GO

SELECT *
FROM dbo.TableA;
```

## Faire les exercices

Ouvrir :

```text
Exercice SQL.sql
```

Puis executer les requetes une par une dans VS Code avec l'extension `SQL Server (mssql)`.
