/* 1.	What is the maximum charter fuel consumption per hour? Fuel consumption per hour is calculated as follows: 
fuelPerHr= CHAR_FUEL_GALLONS/ CHAR_HOURS_FLOWN. 
*/
SELECT MAX(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) as MAX_FUEL
FROM CHARTER


/* 2.	Show the charters that have the highest fuel consumption per hour. 
Fuel consumption per hour is calculated as follows:
fuelPerHr= CHAR_FUEL_GALLONS/ CHAR_HOURS_FLOWN.
-- use query 1 as subquery in a where clause.
*/

SELECT CHAR_TRIP, CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN as FUEL_PER_HR
FROM CHARTER
WHERE CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN = (SELECT MAX(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) FROM CHARTER)


/* 3.	Z-score transformation is a numerical transformation of a distribution/series of values that puts the values in a scale of [-3 3]. 
Show the charter trip and the fuel consumption per hour and the standardized fuel consumption per hour or Z-score. 
Fuel consumption per hour is calculated as follows: 
fuelPerHr= CHAR_FUEL_GALLONS/ CHAR_HOURS_FLOWN.

the standardized fuel consumption per hour or z-score is calculated as follows. 
Z-score = (fuelPerHr-avg(fuelPerHr))/stdev(fuelPerHr).
 */

 SELECT CHAR_TRIP, (CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) as FUEL_PER_HR, (CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN - (SELECT AVG(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN ) 
 FROM CHARTER))/(SELECT STDEV(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) FROM CHARTER) as Z_FUEL
 FROM CHARTER

/* 4.	Find the charters that exhibit outliers in fuel consumption per hour. Check for standardized fuel consumption per hour larger or less than -1.5 and 1.5 respectively. 
-- use query3 in a from clause
*/
SELECT CHAR_TRIP, FUEL_PER_HR, Z_FUEL
FROM (SELECT CHAR_TRIP, (CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) as FUEL_PER_HR, (CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN - (SELECT AVG(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN ) 
FROM CHARTER))/(SELECT STDEV(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) FROM CHARTER) as Z_FUEL
FROM CHARTER) CHARDIS
WHERE Z_FUEL<-1.5 or Z_FUEL>1.5

/* 
10.	Show the charters that have a fuel consumption per hour greater than the average fuel consumption of charters of the same aircraft model. 
write a subquery that calculates the avg fuel consumption given the outer query model code.
*/
SELECT * FROM CHARTER
SELECT * FROM AIRCRAFT

SELECT CHAR_TRIP, CHARTER.AC_NUMBER, AIRCRAFT.MOD_CODE, CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN as FUEL_PER_HR
FROM CHARTER
JOIN AIRCRAFT
ON (CHARTER.AC_NUMBER = AIRCRAFT.AC_NUMBER)
WHERE CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN > (SELECT AVG(CHAR_FUEL_GALLONS/CHAR_HOURS_FLOWN) FROM CHARTER)