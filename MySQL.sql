CREATE DATABASE HR_ANALYSIS;

USE HR_ANALYSIS;

DESC hr_1;
DESC hr_2;

SHOW TABLES;

SELECT * FROM hr_1;

SELECT * FROM hr_2;

-------------------------------------------------------------------
/* 1-- Average Attrition Rate for All Department -- */

SELECT a.Department, CONCAT(FORMAT(AVG(a.attrition_y)*100,2),'%') AS Attrition_Rate
FROM  
( SELECT department,attrition,
CASE WHEN attrition='Yes'
THEN 1
ELSE 0
END AS attrition_y FROM hr_1 ) AS a
GROUP BY a.department;

-------------------------------------------------------------------------
/*  2-- Average Hourly Rate for Male Research Scientist --*/

SELECT JobRole, FORMAT(AVG(hourlyrate),2) AS Average_HourlyRate,Gender
FROM hr_1
WHERE UPPER(jobrole)= 'RESEARCH SCIENTIST' and UPPER(gender)='MALE'
GROUP BY jobrole,gender;

-------------------------------------------------------------------------
/* 3-- AttritionRate VS MonthlyIncomeStats against department-- */

SELECT a.department, CONCAT(FORMAT(AVG(a.attrition_rate) * 100, 2), '%') AS Average_attrition, 
FORMAT(AVG(b.MonthlyIncome), 2) AS Average_Monthly_Income
FROM ( SELECT department,attrition,employeenumber,
CASE WHEN attrition = 'Yes' THEN 1
ELSE 0
END AS attrition_rate FROM hr_1) AS a
INNER JOIN hr_2 AS b ON b.employeeid = a.employeenumber
GROUP BY a.department;

-----------------------------------------------------------------------
/* 4-- Average Working Years for Each Department -- */
SELECT a.department, FORMAT(AVG(b.TotalWorkingYears),1) AS Average_Working_Year
FROM hr_1 as a
INNER JOIN hr_2 AS b ON b.EmployeeID=a.EmployeeNumber
GROUP BY a.department;

--------------------------------------------------------------------------
/* 5-- Job Role VS Work Life Balance -- */
SELECT a.JobRole,
SUM(CASE WHEN  performancerating = 1 THEN 1 ELSE 0 END) AS 1st_Rating_Total,
SUM(CASE WHEN performancerating = 2 THEN 1 ELSE 0 END) AS 2nd_Rating_Total,
SUM(CASE WHEN performancerating = 3 THEN 1 ELSE 0 END) AS 3rd_Rating_Total,
SUM(CASE WHEN performancerating = 4 THEN 1 ELSE 0 END) AS 4th_Rating_Total, 
COUNT(b.performancerating) AS Total_Employee, FORMAT(AVG(b.WorkLifeBalance),2) AS Average_WorkLifeBalance_Rating
FROM hr_1 AS a
INNER JOIN hr_2 AS b ON b.EmployeeID = a.Employeenumber
GROUP BY a.jobrole;

---------------------------------------------------------------------
/* 6-- Attrition Rate Vs Year Since Last Promotion Relation Against Job Role -- */

SELECT a.JobRole,CONCAT(FORMAT(AVG(a.attrition_rate)*100,2),'%') AS Average_Attrition_Rate,
FORMAT(AVG(b.YearsSinceLastPromotion),2) AS Average_YearsSinceLastPromotion
FROM ( SELECT JobRole,attrition,employeenumber,
CASE WHEN attrition = 'yes' THEN 1
ELSE 0
END AS attrition_rate FROM hr_1) AS a
INNER JOIN hr_2 AS b ON b.employeeid = a.employeenumber
GROUP BY a.JobRole;
