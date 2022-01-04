4select * from CUSTOMER;
select * from charter;
--5. Write a stored procedure named checkCustomerBal_grpX that takes a customer code @cus_code as input 
--and prints a message (not a table) of whether the customer has an outstanding balance along with the amount
--or no outstanding balance.

CREATE  PROCEDURE checkCustomerBal
@c_code INT
AS
DECLARE @c_balance FLOAT(8);
SET @c_balance = (SELECT CUS_BALANCE FROM CUSTOMER WHERE CUS_CODE = @c_code)
IF @c_balance = 0 
PRINT 'This customer has no outstanding balance'
Else
PRINT concat ('This customer has an outstanding balance of ', @c_balance)
GO

EXEC checkCustomerBal 10011;
EXEC checkCustomerBal 10012;

/*6.	Write a stored procedure named getnbChartersCus_grpX that takes a customer code as input and returns the number
 of charters the customer has booked.
Use the return statement so the stored procedure returns a value. 
If the customer code is not existing in the customer table, print a message 'invalid customer code' and return 0. 
*/
CREATE PROCEDURE getnbChartersCus_grp2
@c_code INT
AS
	DECLARE @c_count INT;
	SET @c_count = (SELECT COUNT(*) FROM CHARTER WHERE CUS_CODE = @c_code GROUP BY CUS_CODE)
	IF @c_code <> 0 
	RETURN @c_count
	ELSE
	PRINT 'invalid customer code'
	RETURN 0
GO

DROP PROCEDURE getnbChartersCus_grp2;

declare @count int;
exec @count = getnbChartersCus_grp2 10011;
print @count;
  

/*7.	Write a stored procedure named checkConsumptionv1_grpX that takes no input and show the charter trip, destination, 
fuel consumption (CHAR_FUEL_GALLONS), the average fuel consumption of charters of the same destination, 
and an additional column named 'statis'  with the values: 
 'consumed more than the average fuel consumption for that destination' 
or 'consumed less than the average fuel consumption for that destination'. 
*/
CREATE PROCEDURE checkConsumptionv1_grp2
AS
    SELECT CHAR_TRIP, CHAR_DESTINATION, CHAR_FUEL_GALLONS,  
        (SELECT AVG(CHAR_FUEL_GALLONS) FROM CHARTER WHERE CHAR_DESTINATION = C.CHAR_DESTINATION) AS avgFuelConsDes,
        'status' = CASE
            WHEN CHAR_FUEL_GALLONS > (SELECT AVG(CHAR_FUEL_GALLONS) FROM CHARTER WHERE CHAR_DESTINATION = C.CHAR_DESTINATION)
            THEN 'consumed more than the average fuel consumption for that destination'
            ELSE 'consumed less than the average fuel consumption for that destination'
            END
    FROM CHARTER C
GO

exec checkConsumptionv1_grp2;

select * from charter;
/*8.	Write a stored procedure named checkConsumptionv2_grpX that takes a charter trip code as input, and output a message saying : 
"This charter has consumed more than the average fuel consumption compared to other charters flying to the same destination" or less otherwise. */
SELECT * FROM CHARTER;

CREATE PROCEDURE checkConsumptionv2_grp2
	@trip_code INT
AS
	DECLARE @avg_Fuel FLOAT(8);
	SELECT @avg_Fuel = (SELECT AVG(CHAR_FUEL_GALLONS) FROM CHARTER WHERE CHAR_DESTINATION = CHARTER.CHAR_DESTINATION) FROM CHARTER WHERE CHAR_TRIP = @trip_code
	DECLARE @char_Fuel FLOAT(8);
	SELECT @char_Fuel = CHAR_FUEL_GALLONS FROM CHARTER WHERE CHAR_TRIP = @trip_code
	BEGIN
	IF @char_Fuel > @avg_Fuel
	PRINT 'This charter has consumed more than the average fuel consumption compared to other charters flying to the same destination'
	ELSE
	PRINT 'This charter has consumed less than the average fuel consumption compared to other charters flying to the same destination'
	END
GO

EXEC checkConsumptionv2_grp2 10001;
EXEC checkConsumptionv2_grp2 10002;
