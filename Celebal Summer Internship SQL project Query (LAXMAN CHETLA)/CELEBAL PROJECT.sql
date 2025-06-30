--Celebal Summer Internship SQL domain Batch 1
--CSI ID: CT_CSI_SQ_1310
--Name:LAXMAN CHETLA
--SALES REPORT GENERATION USING SQL SERVER ROLLUP









--SQL QUERY FOR THE PROJECT :

SELECT 
COALESCE(S.ProductCategory,'Total') AS ProductCategory,
COALESCE(S.ProductName,'Total') AS ProductName,
SUM(S.SaleAmount) as TotalSales 
FROM Sales AS S 
GROUP BY S.ProductCategory,S.ProductName WITH ROLLUP ;










-- Create the Sales table
CREATE TABLE Sales (
    ProductCategory VARCHAR(50),
    ProductName VARCHAR(50),
    SaleAmount DECIMAL(10, 2)
);


-- Insert the sample data
INSERT INTO Sales (ProductCategory, ProductName, SaleAmount) VALUES
('Electronics', 'Laptop', 1000.00),
('Electronics', 'Phone', 800.00),
('Electronics', 'Tablet', 500.00),
('Clothing', 'Shirt', 300.00),
('Clothing', 'Pants', 400.00),
('Furniture', 'Sofa', 1200.00),
('Furniture', 'Bed', 900.00);

select * from Sales;

