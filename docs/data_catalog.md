Data Dictionary for Gold Layer
The gold layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimenson tables and fact tables for specific business metrics.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. gold.dim_customers
Purpose: Store customer details enriched with demograpich and geographic data.
Coulumns:

Column name      Data type      Description
customer_key     INT            Surrogate key uniquely identifying each customer record in the dimension table.
customer_id      INT            Unique numerical identifier assigned to each customer.
customer_number  NVARCHAR(50)
first_name       NVARCHAR(50)
last_name        NVARCHAR(50)
country          NVARCHAR(50)
marital_status   NVARCHAR(50)
gender           NVARCHAR(50)
birthdate        DATE
create_date      DATE

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

2. gold.dim_products
Purpose: Store product data.
Coulumns:

Column name      Data type      Description
product_key      INT            ...
product_id       INT
product_number   NVARCHAR(50)
product_name     NVARCHAR(50)
category_id      NVARCHAR(50)
category         NVARCHAR(50)
subcategory      NVARCHAR(50)
maintenance      NVARCHAR(50)
product_cost     INT
product_line     NVARCHAR(50)
start_date       DATE

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

3. gold.fact_sales
Purpose: Store sales data.
Coulumns:

Column name      Data type      Description
order_number     NVARCHAR(50)   ...
product_key      INT
customer_key     INT
order_date       DATE
shipping_date    DATE
due_date         DATE
sales_amount     INT
quantity         INT
price            INT
