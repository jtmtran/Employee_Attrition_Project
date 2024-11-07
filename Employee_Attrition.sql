DROP DATABASE IF EXISTS employee_data;
CREATE DATABASE employee_data;
use employee_data;
create table employee_attrition(
EmployeeNumber int primary key,
Age int,
Attrition varchar(3),
BusinessTravel varchar(50),
DailyRate int,
Department varchar(50),
DistanceFromHome int,
Education int,
EducationField varchar(50),
EmployeeCount int,
EnvironmentSatisfaction int,
Gender varchar(6),
HourlyRate int,
JobInvolvement int,
JobLevel int,
JobRole varchar(100),
JobSatisfaction int,
MaritalStatus varchar(20),
MonthlyIncome int,
MonthlyRate int,
NumCompaniesWorked int,
Over18 varchar(1),
OverTime varchar(10),
PercentSalaryHike int,
PerformanceRating int,
RelationshipSatisfaction int,
StandardHours int,
StockOptionLevel int,
TotalWorkingYear int,
TrainingTimesLastYear int,
WorkLifeBalance int,
YearsAtCompany int,
YearsInCurrentRole int,
YearsSinceLastPromotion int,
YearsWithCurrManager int);

select * from employee_attrition limit 10;

#No employee number 6
select * from employee_attrition
where EmployeeNumber = 6;

describe employee_attrition;

select distinct Attrition
from employee_attrition;

select distinct BusinessTravel from employee_attrition;
select distinct Department from employee_attrition;
select distinct EducationField from employee_attrition;

select * from employee_attrition
where Age is null or MonthlyIncome is null;

select * from employee_attrition
where MonthlyIncome is null;

select * from employee_attrition
where Attrition is null or Attrition = '';

#check for duplicate rows
select EmployeeNumber, count(*)
from employee_attrition
group by EmployeeNumber
having count(*) > 1;

#How many employees have a Yes or No
select Attrition,count(*) from employee_attrition
group by Attrition;

#calculate the attrition rate (percentage of people who left the company)
select
	(select count(*) from employee_attrition where Attrition = 'yes')/count(*) *100 as AttritionRate
from employee_attrition;

#average monthly income
select avg(MonthlyIncome) as AvgMonthlyIncome
from employee_attrition;

#find the department with the highest attrition
select Department, count(*) as AttritionCount
from employee_attrition
where Attrition = 'yes'
group by Department
order by AttritionCount desc;

#Job satisfied by department
select Department, avg(JobSatisfaction) as AvgJobSatisfaction
from employee_attrition
group by Department;
#Although R&D has the highest number of employees who left the company, the HR department ranks lowest in job satisfaction, despite having the fewest attritions.

#Compare the total number of employees in each department versus those who left, and calculate the attrition rate for each deparment:
select Department, JobSatisfaction,
	count(*) as TotalEmployees,
	sum(case when Attrition = 'yes' then 1 else 0 end) as AttritionCount,
    (select count(*) from employee_attrition where Attrition ='yes')/count(*) *100 as AttritionRate
from employee_attrition
group by Department, JobSatisfaction
order by JobSatisfaction asc, AttritionRate asc;

SELECT Department, JobSatisfaction, COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate,
       AVG(MonthlyIncome) AS AvgIncome
FROM employee_attrition
GROUP BY Department, JobSatisfaction
ORDER BY JobSatisfaction ASC, AttritionRate ASC;

#Performance rating by JobRole:
select JobRole, avg(PerformanceRating) as AvgPerformanceRating
from employee_attrition
group by JobRole
order by AvgPerformanceRating desc;

#Explore if there's a relationship between employee attrition and average monthly income
select Attrition, avg(MonthlyIncome) as AvgIncome
from employee_attrition
group by Attrition;

#Analyze years at company versus attrition
select YearsAtCompany, count(*) as NumEmployees,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition
from employee_attrition
group by YearsAtCompany
order by YearsAtCompany;
#High attrition in the early years (0-5yrs)
#Stabilize after 5 yrs
#Very low attrition for long-tenured employees (15+ yrs)

#Investigate overtime work and attrition
select OverTime, count(*) as NumEmployees,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (select sum(case when Attrition ='yes' then 1 else 0 end)) / count(*) *100 as AttritionPercentage
from employee_attrition
group by OverTime;

#Analyze Attrition by Deparment and Income
select Department,
	Attrition,
    count(*) as NumEmployees,
    avg(MonthlyIncome) as AvgIncome
from employee_attrition
group by Department, Attrition
order by Department, Attrition desc;

#Analyze Attrition by Job Role and Income
select JobRole,
	Attrition,
    count(*) as NumEmployees,
    avg(MonthlyIncome) as AvgIncome
from employee_attrition
group by JobRole, Attrition
order by JobRole, Attrition;

#Compare Income and Attrition by Department
select Department,
	count(*) as NumEmployees,
    sum(case when Attrition ='yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition ='yes' then 1 else 0 end))/count(*) *100 as AttritionRate,
    avg(MonthlyIncome) as AvgIncome
from employee_attrition
group by Department
order by AttritionRate Desc;

#Compare Income and Attrition by JobRole
select JobRole,
	count(*) as NumEmployees,
    sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition ='yes' then 1 else 0 end))/count(*) *100 as AttritionRate,
    avg(MonthlyIncome) as AvgIncome
from employee_attrition
group by JobRole
order by AttritionRate desc;

#Attrition by demographic factor
select Age, count(*) as NumEmployee,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by Age
order by AttritionRate desc;

select JobRole,JobSatisfaction, count(*) as NumEmployee,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by JobRole,JobSatisfaction
order by AttritionRate desc;

select EnvironmentSatisfaction, count(*) as NumEmployee,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by EnvironmentSatisfaction
order by AttritionRate desc;

#Income vs JobSatisfaction:
select JobRole, JobSatisfaction, count(*) as NumEmployees,
	avg(MonthlyIncome) as AvgIncome,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by JobRole, JobSatisfaction
order by JobSatisfaction asc, AttritionRate asc;

#JobStability vs JobSatisfaction:
select JobRole, JobSatisfaction, count(*) as NumEmployees,
	avg(YearsAtCompany) as AvgYearsAtCompany,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by JobRole, JobSatisfaction
order by JobSatisfaction asc, AttritionRate desc;

#EnvironmentSatisfaction vs JobSatisfaction:
select JobRole, JobSatisfaction, EnvironmentSatisfaction, count(*) as NumEmployees,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by JobRole, JobSatisfaction, EnvironmentSatisfaction
order by JobSatisfaction asc, EnvironmentSatisfaction asc;

#1. WorkLifeBalance vs JobSatisfaction for HR and Sales:
SELECT Department, WorkLifeBalance, COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM employee_attrition
WHERE Department IN ('Sales', 'Human Resources')
GROUP BY Department, WorkLifeBalance
ORDER BY WorkLifeBalance;

#1. Attrition vs JobSatisfaction for HR:
SELECT Department, COUNT(*) AS NumEmployees,
		JobSatisfaction,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate,
       avg(MonthlyIncome) as AvgIncome
FROM employee_attrition
WHERE Department = 'Human Resources'
GROUP BY Department, JobSatisfaction
ORDER BY AttritionRate DESC;

#1. Attrition vs JobSatisfaction for Sales:
SELECT Department, COUNT(*) AS NumEmployees,
		JobSatisfaction,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate,
       avg(MonthlyIncome) as AvgIncome
FROM employee_attrition
WHERE Department = 'Sales'
GROUP BY Department, JobSatisfaction
ORDER BY AttritionRate DESC;

#1. Overtime vs JobSatisfaction:
SELECT Department, COUNT(*) AS NumEmployees, 
		sum(case when Overtime = 'Yes' then 1 else 0 end) as NumOverTime,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM employee_attrition
WHERE Department IN ('Sales', 'Human Resources')
GROUP BY Department
ORDER BY AttritionRate DESC;

#1. PerformanceRating vs Attrition:
SELECT Department, PerformanceRating, COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM employee_attrition
WHERE Department IN ('Sales', 'Human Resources')
GROUP BY Department, PerformanceRating
ORDER BY AttritionRate DESC;

#2. JobSatisfaction in Research & Development:
select Department, JobSatisfaction, RelationshipSatisfaction,
	count(*) as NumEmployees,
    sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
where Department = 'Research & Development'
group by Department, JobSatisfaction, RelationshipSatisfaction
order by JobSatisfaction;

#2. Explore professional development within the R&D department
select Department, TrainingTimesLastYear, count(*) as NumEmployees,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
where Department = 'Research & Development'
group by Department, TrainingTimesLastYear
order by TrainingTimesLastYear desc;

#2. Explore career growth opportunities within the R&D department
select Department, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
where Department = 'Research & Development'
group by Department, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion
having (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 > 40
order by AttritionRate desc;

#3. Identify High-Retention for HR and Sales:
SELECT Department, YearsAtCompany, JobSatisfaction,
		COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
       (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM employee_attrition
WHERE Department IN ('Sales', 'Human Resources')
GROUP BY Department, YearsAtCompany, JobSatisfaction
having (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 > 40
ORDER BY AttritionRate DESC;

select * from employee_attrition limit 3;

select YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
where Department = 'Research & Development'
group by Department, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion
having (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 > 40
order by AttritionRate desc;

select TrainingTimesLastYear, count(*) as NumEmployees,
	sum(case when Attrition = 'yes' then 1 else 0 end) as NumAttrition,
    (sum(case when Attrition = 'yes' then 1 else 0 end))/count(*) *100 as AttritionRate
from employee_attrition
group by TrainingTimesLastYear
order by TrainingTimesLastYear;