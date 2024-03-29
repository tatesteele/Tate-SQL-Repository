SELECT sg.SECID_BASE_PARENT, *
FROM [CATS_Data].[dbo].[T_TRADING_SINGLE_ARCHIVE] ta
	JOIN [CATS_Data].[dbo].[T_SUMMARY_CONTRACT] sc ON ta.SGL_SECID = sc.[CONTRACT]
	JOIN [CATS_Data].[dbo].[T_FO_SEC_GROUP] sg ON sc.[CONTRACT] = sg.[SECID_BASE]
WHERE sc.[TYPE] = 'S'
	--AND SECID_BASE_PARENT NOT IN ('CDXHY', 'CDSWP', 'TEST', 'BOVSW')
ORDER BY SGL_DATE