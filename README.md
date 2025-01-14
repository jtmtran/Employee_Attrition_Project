# Employee Attrition Analysis Using IBM HR Analytics Dataset
![employee-churn](https://github.com/user-attachments/assets/bc9cbf6e-62d7-4c3c-8b67-42e91f9a34c6)

## Overview
<br>This project analyzes employee attrition data to uncover key trends and provide actionable insights for reducing turnover. Using SQL for data cleaning and analysis, combined with Tableau for interactive dashboards, we deliver valuable insights to support HR decision-making.

## Key Insights
- High-risk departments: The Sales department experiences the highest attrition rates (22%).
- Top influencing factors: Low job satisfaction and long working hours significantly increase attrition risk.
- Critical demographics: Employees aged 25-35 are most at risk, particularly in mid-level roles.
- Recommended actions: Improving job satisfaction and work-life balance could reduce attrition by 15%.

## Interactive Dashboard

Explore the visualized insights through the Tableau dashboard: [Interactive Dashboard](https://public.tableau.com/views/Employee_Attrition_and_Retention_Insights/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/10ff88cad450dc4c6cd8b1911d57767a77689deb/Dashboard%201.png)

The dashboard allows users to explore attrition patterns across various dimensions, such as job roles, departments, and demographics.

## Project Workflow

### 1. Data Overview
- Dataset: [IBM HR Analytics Employee Attrition Dataset](https://www.kaggle.com/pavansubhasht/ibm-hr-analytics-attrition-dataset).
- Structure: Includes information on employee demographics, job roles, and attrition status.
- Goal: Identify factors contributing to attrition and provide actionable recommendations.

### 2. SQL Analysis
The SQL queries used for data analysis are available in the Employee_Attrition.sql.
SQL was used extensively for data cleaning, exploration, and analysis. Below are some highlights:

**Key Queries:**
- High Attrition in Human Resources with Low Job Satisfaction**
	- Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
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

- Sales Department: High Income, Yet High Attrition
	- Sales employees with job satisfaction = 1 have a 26.74% attrition rate, even with the highest average income of $6,993.
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
Key takeaway: Elevated attrition across multiple satisfaction levels points to workload stress and performance pressure as possible contributors.

- Research & Development (R&D): Strong Link Between Satisfaction and Retention
	- R&D exhibits lower attrition rates, with attrition decreasing steadily as job satisfaction improves (from 19.79% at satisfaction = 1 to 9.49% at satisfaction = 4).
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
Key takeaway: Job satisfaction plays a crucial role in retention in R&D.

- Work-Life Balance and Overtime Impact on Sales and HR
	- In Sales, poor work-life balance (rated 1) leads to an attrition rate of 37.5%.
 	- For HR, attrition decreases from 28.57% (work-life balance = 2) to 10% (work-life balance = 4).
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
Key takeaway: Improving work-life balance can be an effective retention strategy in both departments.

- Performance Rating: Higher Performers More Likely to Stay
	- Sales employees with performance rating = 4 have an attrition rate of 16.39%, lower than those with a rating of 3 (21.30%).
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
Key takeaway: Engaged and high-performing employees exhibit lower turnover, indicating that investing in career growth can improve retention.

## 3. Tableau Visualizations

**Key visualizations included:**

**- Attrition Rate by Department:**

  <img width="286" alt="Screenshot 2025-01-13 at 10 25 41 PM" src="https://github.com/user-attachments/assets/19ec7178-11f3-4e94-9cfa-366fe67d2a1c" />

Insight:
- The **Sales department** has the highest attrition rate at 20.63%, indicating a need for targeted retention efforts.
- The **Human Resources department** also shows a high attrition rate of 19.05%, suggesting potential internal challenges.
- The **Research & Development department** has the lowest attrition rate at 13.84%, indicating better employee retention practices.
 
**- Attrition by Job Role:**

<img width="1361" alt="Screenshot 2025-01-13 at 10 29 50 PM" src="https://github.com/user-attachments/assets/20e87c7b-a5d2-431b-b362-c88b072d9c80" />

Insight: **Sales Executives and Laboratory Technicians** show the highest rates of attrition.

**- Attrition by Job Satisfaction:**
<img width="1354" alt="Screenshot 2025-01-13 at 10 39 56 PM" src="https://github.com/user-attachments/assets/70943307-f40f-4d9b-b72d-68ceb5efea0a" />

Insight: Employees with lower job satisfaction (rated 1 or 2) are more likely to leave.

**- Attrition by Age and Gender:**
<img width="1366" alt="Screenshot 2025-01-13 at 11 02 19 PM" src="https://github.com/user-attachments/assets/19c0f951-45e5-4ee3-a293-1e28607311fa" />

Insights:
- Females: High attrition is observed in younger employees aged 18–22 and spikes again around age 58.
- Males: Younger employees aged 18–22 and employees close to retirement (around age 58) also exhibit higher attrition rates.
- Middle Age: Attrition rates stabilize across genders for ages 30–50.
  
Color Legend:
- Red: High attrition rate (>50%).
- Blue: Stable attrition rate (25–50%).
- Green: Low attrition rate (<25%).

**- Attrition by Monthly Income:**

<img width="325" alt="Screenshot 2025-01-13 at 10 37 20 PM" src="https://github.com/user-attachments/assets/e173b105-9f3f-4aa2-a083-e62c32fd5063" />

Insight: Employees in the lowest income quartile are more likely to leave.

## How to Use
1. Access SQL Queries: All SQL scripts are available in the sql_queries/ folder.
2. View the Dashboard: Visit the Tableau dashboard link provided above.
3. Download the Dataset: Dataset can be downloaded from [Kaggle](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset).
 
## Results
**- Attrition Prediction:** Identified departments and roles most at risk.

**- Recommendations:**
- Focus retention efforts on the Sales department.
- Implement flexible work policies to improve work-life balance.
- Provide targeted programs for employees aged 25-35.

## Conclusion
<br> This project demonstrates how SQL and Tableau can be used to analyze employee attrition effectively. The findings provide actionable insights for HR teams to proactively address employee turnover.
 
## Contact
- **Name**: Jennie Tran
- **Email**: jennie.tmtran@gmail.com
- **LinkedIn**: [jennietmtran](www.linkedin.com/in/jennietmtran)
- **GitHub**: [jtmtran](https://github.com/jtmtran)
