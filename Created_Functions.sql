USE Northwind;

-- Create the function in a separate batch
GO

CREATE FUNCTION TruncateDate (@date datetime, @truncPart nvarchar(50))
RETURNS datetime
AS
BEGIN
  DECLARE @result datetime;

  SELECT @result = 
    CASE @truncPart
      WHEN 'year' THEN DATEADD(year, DATEPART(year, @date) - 1, CONVERT(date, '1900-01-01'))
      WHEN 'quarter' THEN DATEADD(month, (DATEPART(month, @date) - 1) / 3 * 3, CONVERT(date, '1900-01-01'))
      WHEN 'month' THEN DATEADD(day, -DAY(DATEADD(day, -1, @date)), @date)
      WHEN 'week' THEN DATEADD(day, 
        CASE @@DATEFIRST 
          WHEN 1 THEN -DATEPART(dw, @date) 
          ELSE -DATEPART(dw, @date) + (CASE WHEN DATEPART(dw, @date) = 0 THEN 6 ELSE 0 END) 
        END, @date)
      WHEN 'day' THEN CONVERT(date, @date)
      WHEN 'hour' THEN DATEADD(hour, -DATEPART(hour, @date), @date)
      WHEN 'minute' THEN DATEADD(minute, -DATEPART(minute, @date), @date)
      WHEN 'second' THEN DATEADD(second, -DATEPART(second, @date), @date)
      ELSE NULL
    END;

  -- Valid RETURN statement
  RETURN @result;
END;


