/* 
8.	Show all charter trip codes, the charter distance and whether the distance is less than 1000 miles or larger than 1000 miles. 
use IIF function, https://www.w3schools.com/sql/func_sqlserver_iif.asp
*/

SELECT CHAR_TRIP, CHAR_DISTANCE, 
IIF(CHAR_DISTANCE<1000, '<=1000', '>1000') as 'LESS_OR_MORE'
FROM CHARTER;

/*
9.	Count the number of charters whose distance is less than 1000 and those that have a distance larger than 1000. 
Then calculate the proportions of the charters in each bin.  
-- cast the count as float so you get the ratio instead of 0.
*/
SELECT IIF(CHAR_DISTANCE<1000, '<=1000', '>1000') AS 'DISTANCE',ROUND(CAST(COUNT(*)AS FLOAT)/(SELECT COUNT(*) FROM CHARTER),2) AS PORTION
FROM CHARTER
GROUP BY IIF(CHAR_DISTANCE<1000, '<=1000', '>1000')



/*
10.	Show the total fuel consumption, the total distance traveled, and the total hours flown per aircraft 
for aircrafts whose total hours flown is more than 15 hours.
*/

SELECT AC_NUMBER, SUM(CHAR_FUEL_GALLONS) as TOTAL_FUEL_CONSUMPTION, SUM(CHAR_DISTANCE) as TOTAL_DISTANCE, SUM(CHAR_HOURS_FLOWN) as TOTAL_HOURS_FLOWN
FROM CHARTER
GROUP BY AC_NUMBER
HAVING SUM(CHAR_HOURS_FLOWN) > 15
