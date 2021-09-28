
USE Tonehouse;

CREATE PROCEDURE spAll
AS
BEGIN
SELECT * 
FROM Bookings
SELECT*
FROM Customers
SELECT *
FROM ServiceCategory
END

SELECT * 
FROM Bookings

SELECT *
FROM Customers

SELECT *
FROM ServiceCategory

--Question 1 - List the top spenders

SELECT c.First_Name, c.Last_Name, SUM(b.Appointment_Price) AS 'Amount_Spent'
FROM Bookings b
JOIN Customers c
ON b.Customer_ID = c.Customer_ID
GROUP BY c.First_Name, c.Last_Name
Order BY SUM(b.Appointment_Price) DESC

--Question 2 - List the top frequent customers

SELECT c.First_Name, c.Last_Name, COUNT(*) AS Number_Of_Studio_Bookings
FROM Bookings b
JOIN Customers c
ON b.Customer_ID = c.Customer_ID
GROUP BY c.First_Name, c.Last_Name
ORDER BY COUNT(*) DESC

--Question 3 Relationship between top spenders and most frequent customers and hours used

SELECT c.First_Name, c.Last_Name, COUNT(*) AS Number_Of_Studio_Bookings, SUM(b.Appointment_Price) AS 'Amount_Spent', SUM(Number_Of_Hours) AS 'Total_Hours'
FROM Bookings b
JOIN Customers c
ON b.Customer_ID = c.Customer_ID
GROUP BY c.First_Name, c.Last_Name
ORDER BY SUM(b.Appointment_Price) DESC


--Question 4 Total revenue earned

SELECT SUM(Appointment_Price) AS 'Total_Revenue'
FROM Bookings


--Question 5 Revenue and Hours booked, By Service Type

SELECT s.Service_Name, SUM(b.Appointment_Price) AS 'Revenue', SUM(b.Number_Of_Hours) AS 'Hours', COUNT(*) AS 'Number_Of_Bookings'
FROM Bookings b
JOIN ServiceCategory s
ON b.Service_ID = s.Service_ID
GROUP BY s.Service_Name
ORDER BY SUM(b.Appointment_Price) DESC




--Question 6 Revenue By Month
SELECT DATENAME(M, Start_Time) + ' ' + DATENAME(YY, Start_Time) AS 'Month', SUM(Appointment_Price) As Sales, COUNT(*) AS 'Total_Number_Of_Bookings'
FROM Bookings
GROUP BY DATENAME(M, Start_Time) + ' ' + DATENAME(YY, Start_Time)



--Question 7 - The most common number of hours per booking, by Service Type

SELECT DISTINCT s.Service_Name, b.Number_Of_Hours, COUNT(*) AS 'Total_Bookings'
FROM Bookings b
JOIN ServiceCategory s
ON b.Service_ID = s.Service_ID
GROUP BY s.Service_Name, b.Number_Of_Hours
ORDER BY s.Service_Name


--Question 8 - Most frequently booked day of the week

SELECT DATENAME(DW, Start_Time) AS 'Day', SUM(Number_Of_Hours) As 'Total_Hours', COUNT(*) AS 'Total_Number_Of_Bookings'
FROM Bookings
GROUP BY DATENAME(DW, Start_Time)
ORDER BY COUNT(*) DESC


--Question 9 - Most frequently booked day of the month

SELECT DAY(Start_Time) AS 'DAY', SUM(Number_Of_Hours) As 'Total_Hours', COUNT(*) AS 'Total_Number_Of_Bookings'
FROM Bookings
GROUP BY DAY(Start_Time)
ORDER BY DAY(Start_Time)



--Question 10 - Total Number Of Hours and Revenue and bookings by service by month

SELECT DATENAME(M, Start_Time) + ' ' + DATENAME(YY, Start_Time) AS 'Month', 
		s.Service_Name, SUM(b.Appointment_Price) AS 'Revenue', 
		 SUM(b.Number_Of_Hours) AS 'Hours', 
		  COUNT(*) AS 'Number_Of_Bookings'
FROM Bookings b
JOIN ServiceCategory s
ON b.Service_ID = s.Service_ID
GROUP BY DATENAME(M, Start_Time) + ' ' + DATENAME(YY, Start_Time), s.Service_Name
ORDER BY DATENAME(M, Start_Time) + ' ' + DATENAME(YY, Start_Time)


--Question 11 - Top earning day ever

SELECT CONVERT(date, Start_Time) AS 'Date', DATENAME(DW, Start_Time) AS 'Day', SUM(Appointment_Price) AS 'Total_Revenue'
FROM Bookings
GROUP BY CONVERT(date, Start_Time), DATENAME(DW, Start_Time)
ORDER BY SUM(Appointment_Price) DESC


--Still Question11 - wanted to find out the booking details in the top 5 days
WITH yo
AS (SELECT CONVERT(date, Start_Time) AS 'Date', Appointment_Price, Number_Of_Hours, Customer_ID, Service_ID
	FROM Bookings)
SELECT y.Date, y.Appointment_Price, y.Number_Of_Hours, s.Service_Name, c.First_Name, C.Last_Name
FROM yo y
JOIN ServiceCategory s
ON y.Service_ID = s.Service_ID
JOIN Customers c
ON y.Customer_ID = c.Customer_ID
WHERE y.Date IN ('2021-03-13', '2021-03-11', '2021-01-31', '2021-03-06', '2021-02-20')
ORDER BY y.Date




--Question 12 - How long do customers book in advanced?

SELECT DATEDIFF(DAY, Date_Scheduled, Start_Time) AS 'Days', COUNT(*) AS 'Total_Bookings'
FROM Bookings
GROUP BY DATEDIFF(DAY, Date_Scheduled, Start_Time)
ORDER BY 'Total_Bookings' DESC



--Question 13 - Which day of the week do customers typically make bookings

SELECT DATENAME(DW, Date_Scheduled) AS 'DAY', COUNT(*) AS 'Total_Number_Of_Bookings'
FROM Bookings
GROUP BY DATENAME(DW, Date_Scheduled)
ORDER BY COUNT(*) DESC



--Question 14 - Which day of the month do customers typically make bookings

SELECT DAY(Date_Scheduled) AS 'DAY', COUNT(*) AS 'Total_Number_Of_Bookings'
FROM Bookings
GROUP BY DAY(Date_Scheduled)
ORDER BY DAY(Date_Scheduled)

SELECT *
FROM Bookings
WHERE Date_Scheduled LIKE '%-08 %'


--Question 15 - Revenue trend by servicetype by month

SELECT DATENAME(M, b.Start_Time) + ' ' + DATENAME(YY, b.Start_Time) AS 'Month',
		s.Service_Name,				
		 SUM(b.Appointment_Price) AS 'Revenue'
FROM Bookings b
JOIN ServiceCategory s
ON b.Service_ID = s.Service_ID
GROUP BY DATENAME(M, b.Start_Time) + ' ' + DATENAME(YY, b.Start_Time), s.Service_Name
ORDER BY DATENAME(M, b.Start_Time) + ' ' + DATENAME(YY, b.Start_Time)



--Question 16 - List the people using at least 8hrs of studio time within 31 days who did not purchase packages.

SELECT c.First_Name, c.Last_Name, s.Service_Name, SUM(b.Number_Of_Hours) AS 'Total_Hours', b.Discount_Applied
FROM Bookings b
JOIN Customers c
ON b.Customer_ID = c.Customer_ID
JOIN ServiceCategory s
ON b.Service_ID = s.Service_ID
GROUP BY c.First_Name, c.Last_Name, s.Service_Name, b.Discount_Applied
HAVING SUM(b.Number_Of_Hours) >= 8
AND b.Discount_Applied IS NULL

--Question 17 - Average Earning Per Day

SELECT AVG(Appointment_Price) AS 'Average_Revenue_Per_Day'
FROM Bookings


--Question 18 - Find the occupancy rate

WITH Total AS(
SELECT 	SUM(
		CASE
		WHEN DATENAME(DW, Date) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 12
		ELSE 16
		END) AS yo
		FROM Calendar),
	LR AS(
SELECT SUM(Number_Of_Hours) AS 'Living_Room_Hours'
FROM Bookings
WHERE Service_ID IN ('S2', 'S3', 'S4')),
	BR AS(
SELECT SUM(Number_Of_Hours) AS 'Bedroom'
FROM Bookings
WHERE Service_ID IN ('S1', 'S3', 'S4'))
SELECT Living_Room_Hours/yo AS 'Living_Room_Usage', Bedroom/yo AS 'Bedroom_Usage'
FROM Total, LR, BR

--Question 19 How much would the studio make at full capacity?

SELECT SUM(Appointment_Price)/4*10 AS 'Max_Possible_Revenue', SUM(Appointment_Price)/4*10/12 AS 'Max_Possible_Monthly'
FROM Bookings	


--Creating final output for excel

ALTER VIEW ForExcel
AS
SELECT b.Appointment_ID,
		b.Start_Time,
		 CONVERT(date, b.Start_Time) AS 'Start_Date',
		  DATENAME(M, b.Start_Time) + ' ' + DATENAME(YY, b.Start_Time) AS 'Month',
		   DATENAME(DW, b.Start_Time) AS 'StartTimeDay',
		    DAY(b.Start_Time) AS 'StartTimeDayNumeric',
		     DATEDIFF(DAY, b.Date_Scheduled, b.Start_Time) AS 'DateDiff',
			  DATENAME(DW, b.Date_Scheduled) AS 'DateScheduledDay',
			   DAY(b.Date_Scheduled) AS 'DateScheduledNumericDay',
			    CASE
			    WHEN DATENAME(DW, cal.Date) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 12/(SELECT COUNT(DISTINCT Date) FROM 
			    ELSE 16
			    END AS OperatingHours,
			     b.Appointment_Price AS 'Revenue',
				  b.Appointment_Price AS 'Spending',
				   s.Service_Name,
				    b.Number_Of_Hours,
				     c.First_Name,
					  c.Last_Name,
					   c.Customer_ID,
					    s.Service_ID,
						 cal.DateID,
						  cal.Date
FROM Bookings b
JOIN ServiceCategory s
ON b.Service_ID = s.Service_ID
JOIN Customers c
ON b.Customer_ID = c.Customer_ID
RIGHT JOIN Calendar cal
ON cal.DateID = b.Date_ID
GO

SELECT *
FROM ForExcel

SELECT *
FROM Bookings


SELECT *
FROM Calendar



EXEC spAll