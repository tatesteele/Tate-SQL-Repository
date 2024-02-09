DECLARE @dtStart DATE = '1/1/2020'
DECLARE @dtEnd DATE = '2/7/2024'

;WITH temptable AS
(
SELECT
	e.AIMEventName,
	c.[Description],
	te.OrderNumber,
	SUM(te.Quantity) AS Qty,
	te.Side,
	MIN(te.TimestampUtc) AS TimeStampUTC
FROM IDODS_ODS.dbo.AIMTradeEvent te
	LEFT JOIN IDODS_ODS.dbo.AIMEventType e ON e.Id = te.AIMEventTypeId
	LEFT JOIN IDODS_ODS.dbo.AIMOrderReasonCode c ON c.Id = te.AIMOrderReasonCode
WHERE te.AIMEventTypeId = 9						-- ID 9 = Routed to broker timestamp
	AND AsOfDate BETWEEN @dtStart AND @dtEnd
GROUP BY 
	e.AIMEventName,
	c.[Description],
	te.OrderNumber,
	te.Side
)

SELECT 
	t.OrderNumber,
	TradeDate,
	Symbol,
	tt.Side,
	Sum(t.Quantity) AS Quantity,
	SUM(Principal/FXRate) AS USDPrincipal,
	Trader,
	tt.[Description],
	tt.AIMEventName,
	tt.TimestampUtc
FROM IDODS_ODS.dbo.Trade t
	LEFT JOIN temptable tt ON tt.OrderNumber = t.OrderNumber
WHERE SecurityType = 'Future'
	AND TradeDate BETWEEN @dtStart AND @dtEnd
	AND DATEPART(HOUR, TimestampUtc) >= 9 
	AND DATEPART(HOUR, TimestampUtc) < 12
GROUP BY 
	t.OrderNumber,
	TradeDate,
	Symbol,
	tt.Side,
	Trader,
	tt.[Description],
	tt.AIMEventName,
	tt.TimestampUtc
ORDER BY 
	TradeDate
