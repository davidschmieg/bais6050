--David Schmieg

--Compound query that returns the store code for any stores that are open 24 hours every day, but are not located in Chicago.
SELECT StoreCode
FROM HOURS
GROUP BY StoreCode
HAVING SUM(Hours)=168
INTERSECT
SELECT StoreCode
FROM STORES
WHERE City != 'Chicago';

--Join query that returns the store code, full address, number of days open, and the population density of the zip code where the store is located.
SELECT STORES.StoreCode, STORES.StreetAddress ||', '|| STORES.City ||', '|| STORES.State ||' '|| STORES.Zip AS Address, COUNT(HOURS.Day) AS DaysOpen, ZIPS.Density
FROM STORES JOIN HOURS
ON STORES.StoreCode = HOURS.StoreCode
JOIN ZIPS
ON STORES.Zip = ZIPS.ZipCode
GROUP BY STORES.StoreCode, STORES.StreetAddress ||', '|| STORES.City ||', '|| STORES.State ||' '|| STORES.Zip, ZIPS.Density  
HAVING COUNT(HOURS.Day)<7;

--Case query that categorizes zip codes based on the number of Dunkin’ locations per capita.
SELECT ZIPS.ZipCode, COUNT(STORES.StoreCode) AS Locations, TO_CHAR(ZIPS.Population, '999,999,999') AS PopulationAlt, CASE
WHEN COUNT(STORES.StoreCode)/ZIPS.Population > 0.001 THEN 'High'
WHEN COUNT(STORES.StoreCode)/ZIPS.Population > 0.0001 THEN 'Medium'
WHEN COUNT(STORES.StoreCode)/ZIPS.Population > 0 THEN 'Low'
ELSE 'None'
END AS LocationsPerCapita
FROM ZIPS LEFT JOIN STORES
ON ZIPS.ZipCode = STORES.Zip
WHERE Population IS NOT NULL
GROUP BY ZIPS.ZipCode, ZIPS.Population
ORDER BY TO_CHAR(ZIPS.Population, '999,999,999') DESC;

--Subquery that calculates the marginal proportion of stores in each state that have a drive thru.
SELECT STORES.State, Total, ROUND(COUNT(StoreCode)/Total,3) AS DriveThru
FROM STORES JOIN
(SELECT State, COUNT(StoreCode) AS Total
FROM STORES
GROUP BY State) S
ON STORES.State=S.State
WHERE DriveThru='Y'
GROUP BY STORES.State, Total;

--Subquery that returns the store code, city, state, and store type for stores that are not full-service (FS) locations and always have 18+ daily hours.
SELECT StoreCode, City, State, StoreType
FROM STORES
WHERE StoreType != 'FS' AND StoreCode NOT IN
(SELECT StoreCode
FROM HOURS
WHERE Hours < 18);
