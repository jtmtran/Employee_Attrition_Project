# Employee Attrition Analysis Using IBM HR Analytics Dataset
Dataset Source
[Kaggle](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)

## Introduction
<br>This project investigates the factors driving employee attrition within various departments at a fictional company. The goal is to identify key drivers, such as job satisfaction, income, work-life balance, and performance, and propose actionable recommendations for improving employee retention.

## Analysis of Factors - SQL Analysis
<br>**1. High Attrition in Human Resources with Low Job Satisfaction**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql
SELECT Department, COUNT(*) AS NumEmployees,
  JobSatisfaction,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition,
  (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate,
  AVG(MonthlyIncome) AS AvgIncome
FROM employee_attrition
WHERE Department = 'Human Resources'
GROUP BY Department, JobSatisfaction
ORDER BY AttritionRate DESC;  
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/High%20Attrition%20in%20Human%20Resources%20with%20Low%20Job%20Satisfaction.png)
<br>•	High turnover suggests that dissatisfaction in HR is driven by factors beyond salary, such as workplace environment or lack of engagement.

<br>**2. Sales Department: High Income, Yet High Attrition**
<br>•	Sales employees with job satisfaction = 1 have a 26.74% attrition rate, even with the highest average income of $6,993.
```sql
SELECT Department, COUNT(*) AS NumEmployees,
  JobSatisfaction,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
  (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate,
  AVG(MonthlyIncome) AS AvgIncome
FROM employee_attrition
WHERE Department = 'Sales'
GROUP BY Department, JobSatisfaction
ORDER BY AttritionRate DESC;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Sales%20Department%3A%20High%20Income%2C%20Yet%20High%20Attrition.png)
<br>•	Elevated attrition across multiple satisfaction levels points to workload stress and performance pressure as possible contributors.

<br>**3. Research & Development (R&D): Strong Link Between Satisfaction and Retention**
<br>•	R&D exhibits lower attrition rates, with attrition decreasing steadily as job satisfaction improves (from 19.79% at satisfaction = 1 to 9.49% at satisfaction = 4).
```sql
SELECT Department, JobSatisfaction, RelationshipSatisfaction,
  COUNT(*) AS NumEmployees,
  SUM(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END) AS NumAttrition,
  (SUM(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END))/COUNT(*) *100 AS AttritionRate
FROM employee_attrition
WHERE Department = 'Research & Development'
GROUP BY Department, JobSatisfaction, RelationshipSatisfaction
ORDER BY JobSatisfaction;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Research%20%26%20Development%20(R%26D)%3A%20Strong%20Link%20Between%20Satisfaction%20and%20Retention.png)
<br>•	Conclusion: Job satisfaction plays a crucial role in retention in R&D.

<br>**4. Work-Life Balance and Overtime Impact on Sales and HR**
<br>•	In Sales, poor work-life balance (rated 1) leads to an attrition rate of 37.5%.
<br>•	For HR, attrition decreases from 28.57% (work-life balance = 2) to 10% (work-life balance = 4).
```sql
SELECT Department, WorkLifeBalance, COUNT(*) AS NumEmployees, 
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
  (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM employee_attrition
WHERE Department IN ('Sales', 'Human Resources')
GROUP BY Department, WorkLifeBalance
ORDER BY WorkLifeBalance;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Work-Life%20Balance%20and%20Overtime%20Impact%20on%20Sales%20and%20HR.png)
<br>•	Conclusion: Improving work-life balance can be an effective retention strategy in both departments.

<br>**5. Performance Rating: Higher Performers More Likely to Stay**
<br>•	Sales employees with performance rating = 4 have an attrition rate of 16.39%, lower than those with a rating of 3 (21.30%).
```sql
SELECT Department, PerformanceRating, COUNT(*) AS NumEmployees, 
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition, 
  (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate
FROM employee_attrition
WHERE Department IN ('Sales', 'Human Resources')
GROUP BY Department, PerformanceRating
ORDER BY AttritionRate DESC;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Performance%20Rating.png)
<br>•	Conclusion: Engaged and high-performing employees exhibit lower turnover, indicating that investing in career growth can improve retention.

## Key Insights
<br>**Income vs. Attrition**
<br>•	Employees who left the company earned an average of $4,787, significantly lower than those who stayed ($6,832).
```sql
SEKECT Attrition,
  AVG(MonthlyIncome) AS AvgIncome
FROM employee_attrition
GROUP BY Attrition;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/0b0dd43e967bc6696a1888b157c4ddf33199b7ef/Incomevs.Attrition.png)
<br>•	Conclusion: Higher income contributes to retention, but it’s not the sole factor. Addressing non-monetary factors such as work-life balance and stress is essential.

<br>**Training and Development**
<br>•	Employees who received 5-6 training sessions per year showed lower attrition rates (as low as 4.26%).
<br>•	Those with no training had the highest attrition rate of 21.05%.
```sql
SELECT Department,TrainingTimesLastYear, COUNT(*) AS NumEmployees,
  SUM(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END) AS NumAttrition,
  (SUM(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END))/COUNT(*) *100 AS AttritionRate
FROM employee_attrition
GROUP BY Department,TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/f69f89de8e5bfe9e08cb5f8a91efd99631efd40b/Training%20and%20Development%20vs%20Attrition.png)
<br>•	Conclusion: Regular training contributes to employee retention by fostering growth and engagement.

<br>**Years at Company and Attrition**
<br>•	The highest attrition occurs in the first few years of employment, indicating potential onboarding or engagement challenges.
```sql
SELECT YearsAtCompany, COUNT(*) AS NumEmployees,
	SUM(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END) AS NumAttrition,
  (SUM(CASE WHEN Attrition = 'yes' THEN 1 ELSE 0 END))/COUNT(*)*100 AS AttritionRate
FROM employee_attrition
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Years%20at%20Company%20and%20Attrition.png)
<br>•	Conclusion: Focusing on early retention strategies and enhancing the employee experience during the first year can reduce turnover.

## Recommendations
<br>**1. Human Resources and Sales: Address Work-Life Balance and Stress**
<br>•	Implement flexible work arrangements and time-off policies to improve work-life balance, especially in Sales and HR.
<br>•	Consider reducing overtime or offering additional compensation for extra hours.
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/112fa2ddd9288b142485fc208f227f6c5f97120a/Work%20life%20balance.png)

<br>**2. Focus on Career Development**
<br>•	Provide career growth opportunities and promotions to prevent attrition in long-tenured employees.
<br>•	Offer mentorship programs for employees who have been with the company for 5+ years.
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/112fa2ddd9288b142485fc208f227f6c5f97120a/Yrs%20at%20comp.png)

<br>**3. Implement Training Programs**
<br>•	Ensure that employees receive regular training (5-6 times per year) to improve engagement and satisfaction.
<br>•	Align training with career goals to encourage employees to stay with the company.
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/112fa2ddd9288b142485fc208f227f6c5f97120a/Training%20time%20and%20Attrition.png)

<br>**4. Tailor Compensation Reviews for Low-Income Roles**
<br>•	Review compensation packages for low-income roles such as Sales Representatives and HR to improve retention.
<br>•	Offer raises or financial incentives to reduce turnover in these groups.
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/112fa2ddd9288b142485fc208f227f6c5f97120a/Income%20Dist%20by%20Department.png)

## Conclusion
<br>By focusing on improving job satisfaction, work-life balance, and career development opportunities, companies can significantly reduce attrition. Implementing regular training and aligning employee development with long-term career goals will lead to higher retention rates and a more engaged workforce.
