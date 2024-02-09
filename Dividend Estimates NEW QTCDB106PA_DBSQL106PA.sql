WITH temptable AS
( 
SELECT 
	Price_Close_Date,
	Identifier_Ticker,
	Dividend_Received_Until_Expiration,
	ROW_NUMBER() OVER (PARTITION BY Price_Close_Date, Identifier_Ticker ORDER BY Price_Close_Date DESC) AS rn
FROM GDS_Data_Store.dbo.T_Master_Price p 
	LEFT JOIN GDS_Data_Store.dbo.T_Master_Security_Current s ON p.cadis_id = s.cadis_id
WHERE Dividend_Received_Until_Expiration IS NOT NULL 
	AND Price_Close_Date IS NOT NULL
	AND Dividend_Received_Until_Expiration <> '0.00'
	AND Price_Close_Date BETWEEN '5/10/2023' AND '6/20/2023'
)

SELECT 
	Price_Close_Date,
	Identifier_Ticker,
	Dividend_Received_Until_Expiration
FROM temptable
WHERE rn = 1
ORDER BY Price_Close_Date