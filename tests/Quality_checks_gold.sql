--------------------------
--Check for Duplicates in customer info
-- Expected results: None
--------------------------

SELECT cst_id, COUNT(*) FROM
	(SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
		FROM Silver.crm_cust_info ci
		LEFT JOIN silver.erp_cust_az12 ca
		ON	ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 la
		ON	ci.cst_key = la.cid
	)t GROUP BY cst_id
	HAVING COUNT(*) > 1

----------------------
-- Ceck for correct gender status
--xpected results: Correct format in new_gen column where cst_gndr is Master.
	----------------------

SELECT DISTINCT
		ci.cst_gndr,
		ca.gen,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM är master för könsinfo
		ELSE COALESCE(ca.gen, 'n/a')
		END AS new_gen
		FROM Silver.crm_cust_info ci
		LEFT JOIN silver.erp_cust_az12 ca
		ON	ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 la
		ON	ci.cst_key = la.cid
ORDER BY 1,2


------------------------
-- Foreign key Integrity (Dimensions)
------------------------

SELECT * FROM gold.fact_sales sa
LEFT JOIN gold.dim_products pr
ON sa.product_key = pr.product_key
LEFT JOIN gold.dim_customers cu
ON sa.customer_key = cu.customer_key
WHERE sa.product_key IS NULL
