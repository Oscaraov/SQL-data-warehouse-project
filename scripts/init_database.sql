/*
=========================================================
Create Database and Schemas
=========================================================
Scipt purpose:
  This script creates a new database name 'DataWarehouse' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas within the database: 'bronze'. 'silver', and 'gold'.

WARNING:
  Running this script will drop the entire 'DataWarehouse' database if it exists.
  All data in the database will be permanently deleted. Proceed with caution and ensure you have propoer backups before running this script.
*/

USE master:
GO
  
-- drop and recreate the DataWarehouse' database
IF EXISTS  (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse
END;
GO

-- create the 'DataWarehouse' database 
USE DataWarehouse
GO

USE DataWarehouse;
GO

-- Create Schemas  
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
