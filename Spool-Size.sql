SELECT MONTH(dtTimeStamp) as Mth, DAY(dtTimeStamp) as Dy, COUNT(1) as Num
FROM Spool (NOLOCK)
WHERE YEAR(dtTimeStamp) = 2014
GROUP BY MONTH(dtTimeStamp),DAY(dtTimeStamp)
ORDER BY Mth, Dy