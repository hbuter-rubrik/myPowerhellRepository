
-- Show files
SELECT name, physical_name AS current_file_location,(size *8) /1024 AS size_MB
FROM sys.master_files

-- Good data
SELECT * FROM AdventureWorks2016.Sales.SalesPersonQuotaHistory;

-- Uh oh....
DELETE FROM AdventureWorks2016.Sales.SalesPersonQuotaHistory;

-- It's gone all right
SELECT * FROM AdventureWorks2016.Sales.SalesPersonQuotaHistory;

-- Show files
SELECT name, physical_name AS current_file_location,(size *8) /1024 AS size_MB
FROM sys.master_files

-- Restore time
INSERT INTO AdventureWorks2016.Sales.SalesPersonQuotaHistory
SELECT * FROM SQL_LM.Sales.SalesPersonQuotaHistory;

-- Thanks, Rubrik!
SELECT * FROM AdventureWorks2016.Sales.SalesPersonQuotaHistory

-- Empty the Messages window for the next run
SET NOCOUNT ON