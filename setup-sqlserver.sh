#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="sqlserver"
SA_PASSWORD="Password123!"
IMAGE="mcr.microsoft.com/mssql/server:2022-latest"
BACKUP_DIR="/var/opt/mssql/backup"
SQLCMD="/opt/mssql-tools18/bin/sqlcmd"

cd "$(dirname "$0")"

echo "Starting SQL Server..."

if docker ps --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  echo "Container '$CONTAINER_NAME' is already running."
elif docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  docker start "$CONTAINER_NAME" >/dev/null
else
  docker run --platform linux/amd64 \
    -e 'ACCEPT_EULA=Y' \
    -e "MSSQL_SA_PASSWORD=${SA_PASSWORD}" \
    -p 1433:1433 \
    --name "$CONTAINER_NAME" \
    -d "$IMAGE" >/dev/null
fi

echo "Waiting for SQL Server to accept connections..."
for _ in {1..60}; do
  if docker exec "$CONTAINER_NAME" "$SQLCMD" -S localhost -U sa -P "$SA_PASSWORD" -C -Q "SELECT 1" >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

docker exec "$CONTAINER_NAME" mkdir -p "$BACKUP_DIR"

echo "Copying source files into the container..."
docker cp "MonEntreprise.bak" "$CONTAINER_NAME:$BACKUP_DIR/MonEntreprise.bak"
docker cp "Vente.csv" "$CONTAINER_NAME:$BACKUP_DIR/Vente.csv"
docker cp "Script SQL - Création base de données Jointure.sql" "$CONTAINER_NAME:$BACKUP_DIR/jointure.sql"

echo "Restoring MonEntreprise..."
docker exec "$CONTAINER_NAME" "$SQLCMD" \
  -S localhost -U sa -P "$SA_PASSWORD" -C \
  -Q "RESTORE DATABASE MonEntreprise FROM DISK = '$BACKUP_DIR/MonEntreprise.bak' WITH MOVE 'MonEntreprise' TO '/var/opt/mssql/data/MonEntreprise.mdf', MOVE 'MonEntreprise_log' TO '/var/opt/mssql/data/MonEntreprise_log.ldf', REPLACE"

echo "Creating Vente table from Vente.csv..."
docker exec "$CONTAINER_NAME" "$SQLCMD" \
  -S localhost -U sa -P "$SA_PASSWORD" -C -d MonEntreprise \
  -Q "IF OBJECT_ID('dbo.Vente', 'U') IS NOT NULL DROP TABLE dbo.Vente; CREATE TABLE dbo.Vente (VenteID int NOT NULL, ClientID varchar(50) NOT NULL, PointDeVenteID varchar(50) NOT NULL, ProduitID varchar(50) NOT NULL, QuantitesVendues int NOT NULL, PrixVenteUnitaire decimal(18,2) NOT NULL, VentesEuro decimal(18,2) NOT NULL, DateFacturation date NOT NULL); SET DATEFORMAT dmy; BULK INSERT dbo.Vente FROM '$BACKUP_DIR/Vente.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ';', ROWTERMINATOR = '0x0a');"

echo "Recreating Jointure..."
docker exec "$CONTAINER_NAME" "$SQLCMD" \
  -S localhost -U sa -P "$SA_PASSWORD" -C \
  -Q "IF DB_ID('Jointure') IS NOT NULL BEGIN ALTER DATABASE Jointure SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE Jointure; END"

docker exec "$CONTAINER_NAME" "$SQLCMD" \
  -S localhost -U sa -P "$SA_PASSWORD" -C \
  -i "$BACKUP_DIR/jointure.sql"

echo "Checking setup..."
docker exec "$CONTAINER_NAME" "$SQLCMD" \
  -S localhost -U sa -P "$SA_PASSWORD" -C \
  -Q "SELECT name FROM sys.databases WHERE name IN ('MonEntreprise', 'Jointure') ORDER BY name; SELECT COUNT(*) AS NbVentes FROM MonEntreprise.dbo.Vente;"

echo
echo "Setup complete."
echo "VS Code connection:"
echo "  Server: localhost,1433"
echo "  User: sa"
echo "  Password: $SA_PASSWORD"
echo "  Database: master"
echo "  Trust server certificate: true"

