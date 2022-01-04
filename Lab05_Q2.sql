/* Q2 */

/* Create a trigger named addRating on EARNEDRATING table that adds the inserted rating code to PIL_RATINGS in the PILOT table. */
CREATE TRIGGER addRating
ON EARNEDRATING
AFTER INSERT 
AS
BEGIN
	DECLARE @code AS VARCHAR(6);
	SELECT @code = RTG_CODE FROM EARNEDRATING WHERE RTG_CODE = (SELECT RTG_CODE FROM inserted);

	UPDATE PILOT 
	SET PIL_RATINGS =  @code
	WHERE PILOT.EMP_NUM = (SELECT EMP_NUM FROM inserted);

END;
GO

--DROP TRIGGER addRating ON PILOT; 
DISABLE TRIGGER addRating ON PILOT;

SELECT * FROM EARNEDRATING;
SELECT * FROM PILOT;
insert into EARNEDRATING values (101, 'SES', '2021-01-01');



/* Q3 - Create a trigger named update_cusbalance that fires after a charter record is inserted in the charter table. 
The customer balance should be incremented by the charter charges 
calculated as CHAR_DISTANCE (given in inserted) * MOD_CHG_MILE 
(from the model table given the AC_number in inserted).*/

create trigger update_cusbalance
on CHARTER
after insert
as
begin
declare @code int
declare @ac_num varchar(5)
declare @distance real

declare line_cursor CURSOR
for select CUS_CODE, AC_NUMBER, CHAR_DISTANCE from inserted;
OPEN line_cursor;
FETCH NEXT FROM line_cursor INTO @code, @ac_num, @distance;
WHILE @@FETCH_STATUS = 0
BEGIN
declare @model varchar(10)
select @model = MOD_CODE from AIRCRAFT where @ac_num = AC_NUMBER
declare @miles real
select @miles = MOD_CHG_MILE from MODEL where @model = MOD_CODE
declare @balance real
select @balance = @distance* @miles

update CUSTOMER
set CUS_BALANCE = CUS_BALANCE + @balance
where @code = CUS_CODE

FETCH NEXT FROM line_cursor INTO @code, @ac_num, @distance;
END
close line_cursor;
DEALLOCATE line_cursor;
end
go

insert into CHARTER values(10019, '2012-02-09', '2778V', 'MQY', 312, 1.5, 0, 67.2, 0, 10010);

SELECT * FROM CUSTOMER WHERE CUS_CODE = 10010;

SELECT * FROM CHARTER;
SELECT * FROM MODEL;
SELECT * FROM AIRCRAFT;

