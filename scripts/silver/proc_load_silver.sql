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

-------------------------------------------------------------------
	
INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
	prd_id,
	REPLACE(SUBSTRING (prd_key, 1, 5), '-','_') AS cat_id, -- Ersätter - med _ och transformerar för att kunna joina tabeller
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Behåller allt efter kategori ID för att kunna joina tabeller
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost, -- NULL ersätts med 0
	CASE UPPER(TRIM(prd_line))
		WHEN 'S' THEN 'Other Sales'
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
		END AS prd_line, -- Ersätter kortnamn med läsbara namn och NULL med n/a
	CAST(prd_start_dt AS DATE) AS prd_start_dt, -- Transformerar till DATE för att fåp bort onödig timestamp
	CAST(
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 
		AS DATE
	) AS prd_end_dt -- Ersätter slutdatum med dagen före nästa startdatum och transformerar till DATE för att fåp bort onödig timestamp
FROM bronze.crm_prd_info

-- Continue with bronze.crm_sales_details
