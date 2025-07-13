--CSI'25-ID:- CT_CSI_SQ_1310
--Name:-Laxman Chetla
--Domain :- SQL Domain
--Celebal Summer Internship Week 8 Assignment (Task D)
--Task Description:-

/*Level D Task:-
Write a Stored Procedure that populates
a table with certain date attributes. 
The data would be populated for 1 year.
For example the date 14-07-2020 is passed 
as an input parameter,then the stored procedure
will populate those attributes for all the dates 
present within the year 2020. The primary 
key for this table would be date column. 
In order to find sample data and list of
attributes please click on the link.
Constraint: More than one insert statement 
cannot be used */






--Table

CREATE TABLE CalendarAttributes (
    SKDate INT PRIMARY KEY,
    KeyDate DATE,
    [Date] DATE,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarQuarter INT,
    CalendarYear INT,
    DayNameLong VARCHAR(15),
    DayNameShort VARCHAR(5),
    DayNumberOfWeek INT,
    DayNumberOfYear INT,
    DaySuffix VARCHAR(5),
    FiscalWeek INT,
    FiscalPeriod INT,
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalYearPeriod INT
);

--Stored Procedure
CREATE PROCEDURE PopulateCalendarAttributes @InputDate DATE
AS
BEGIN
    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);

    -- Recursive CTE to generate all dates in the year
    WITH DateSequence AS (
        SELECT @StartDate AS DateValue
        UNION ALL
        SELECT DATEADD(DAY, 1, DateValue)
        FROM DateSequence
        WHERE DateValue < @EndDate
    )

    INSERT INTO CalendarAttributes (
        SKDate, KeyDate, [Date], CalendarDay, CalendarMonth, CalendarQuarter, CalendarYear,
        DayNameLong, DayNameShort, DayNumberOfWeek, DayNumberOfYear, DaySuffix,
        FiscalWeek, FiscalPeriod, FiscalQuarter, FiscalYear, FiscalYearPeriod
    )
    SELECT
        CAST(CONVERT(VARCHAR(8), DateValue, 112) AS INT),
        DateValue, DateValue,
        DAY(DateValue), MONTH(DateValue), DATEPART(QUARTER, DateValue), YEAR(DateValue),
        DATENAME(WEEKDAY, DateValue), LEFT(DATENAME(WEEKDAY, DateValue), 3),
        DATEPART(WEEKDAY, DateValue), DATEPART(DAYOFYEAR, DateValue),
        CAST(DAY(DateValue) AS VARCHAR) + CASE
            WHEN DAY(DateValue) IN (1, 21, 31) THEN 'st'
            WHEN DAY(DateValue) IN (2, 22) THEN 'nd'
            WHEN DAY(DateValue) IN (3, 23) THEN 'rd'
            ELSE 'th'
        END,
        DATEPART(WEEK, DateValue), MONTH(DateValue),
        DATEPART(QUARTER, DateValue), YEAR(DateValue),
        CAST(YEAR(DateValue) AS VARCHAR) + RIGHT('0' + CAST(MONTH(DateValue) AS VARCHAR), 2)
    FROM DateSequence
    OPTION (MAXRECURSION 400);
END;


--Execution 

EXEC PopulateCalendarAttributes '2020-07-15';
--truncate table CalendarAttributes;
--select * from CalendarAttributes;
