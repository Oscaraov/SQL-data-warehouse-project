/* 
--------------------------
Script for loading data from 'bronze' layer to 'silver' layer
--------------------------

*/

INSERT INTO silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname, -- Delete unwanted spaces
TRIM(cst_lastname) AS cst_lastname, -- Delete unwanted spaces
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	 ELSE 'n/a'
END cst_marital_status, -- Normalize marital status values to readable format
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	 ELSE 'n/a'
END cst_gndr, -- Normalize gender values to readable format
cst_create_date
FROM 
(
	SELECT
	*,
	ROW_NUMBER() OVER (Partition BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag_last = 1 -- Select te most recent record for every customer

-- Continue with bronze.crm_prd_info
