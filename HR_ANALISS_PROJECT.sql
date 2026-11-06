
CREATE TABLE hr_data (
    satisfaction_level NUMERIC(5,2),
    last_evaluation NUMERIC(5,2),
    number_project INTEGER,
    average_montly_hours INTEGER,
    time_spend_company INTEGER,
    Work_accident INTEGER,
   
    promotion_last_5years INTEGER,
    Department VARCHAR(100),
    salary VARCHAR(50)
);

SELECT * FROM hr_data;

COPY hr_data( satisfaction_level, last_evaluation, number_project,average_montly_hours, time_spend_company,   Work_accident,  promotion_last_5years, Department,salary)
from 'D:\30 Day - SQL Practice Files\HR_capstone_dataset.csv'
delimiter ','
csv header;

-- Basic SQL – Top 12 Interview Queries
-- Pehle ye 12 queries practice karein. Ye basic SQL interview aur real-world HR analysis dono ke liye useful hain.
-- Query 1. Total Employees Count
SELECT count(*) as total_emp
FROM  hr_data;

-- Concept: COUNT(), Aggregate Function.
SELECT * FROM hr_data;
-- Query 2. Department-wise Employees
-- Question: Har department mein kitne employees hain?
SELECT department,
count(*) as total_dept_emp
FROM hr_data
GROUP BY department;


-- Query 3 Employee Attrition Rate
-- Question: Company ka employee attrition rate calculate karein.

SELECT
    COUNT(*) FILTER (WHERE last_evaluation = 1) AS employees_left,
    COUNT(*) AS total_employees,
    ROUND(
        COUNT(*) FILTER (WHERE last_evaluation = 1) * 100.0
        / COUNT(*), 2
    ) AS attrition_rate
FROM hr_data;

-- Query 4. Average Employee Satisfaction
-- Question: Employees ka average satisfaction level kya hai
SELECT  round(avg(satisfaction_level),2) as satisfaction_lrvrl
FROM hr_data;

-- Query 5. Department-wise Average Salary Category Count
-- Question: Har department mein low, medium aur high salary wale kitne employees hain
SELECT * FROM hr_data;

SELECT department,salary,
count(*) as dept_avg_Salary
FROM hr_data
GROUP BY department,salary;


-- uery 8. Employees Working More Than 250 Hours
-- Question: Kaun se employees 250 hours se zyada monthly work karte hain?
SELECT * FROM  hr_data
WHERE average_montly_hours>250;

-- Query 9. Employees Who Received Promotion
-- Question: Last 5 years mein kitne employees ko promotion mila?
SELECT count(*) as promtion_emp
FROM hr_data
WHERE  promotion_last_5years = 1;

-- Query 10. Average Working Hours by Department
-- Question: Har department ke employees average kitne hours work karte hain?
SELECT * FROM  hr_data


SELECT
    Department,
    ROUND(AVG(average_montly_hours), 2)
    AS avg_working_hours
FROM hr_data
GROUP BY Department
ORDER BY avg_working_hours DESC;

-- Query 11. Employees with Low Satisfaction
-- Question: 0.40 se kam satisfaction level wale employees find karein.

SELECT
    Department,
    satisfaction_level,
    salary,
    time_spend_company
FROM hr_data
WHERE satisfaction_level < 0.40
ORDER BY satisfaction_level ASC;

-- Query 12. Department-wise Attrition Rate
-- Question: Kis department ka attrition rate sabse zyada hai?

SELECT
    Department,
    COUNT(*) AS total_employees
FROM hr_data
GROUP BY Department
ORDER BY total_employees DESC;

-- Query 14. Salary-wise Employee Attrition
-- Question: Low, medium aur high salary category mein attrition kitna hai?


SELECT
    salary,
    COUNT(*) AS total_employees,
    SUM(satisfaction_level) AS employees_left,
    ROUND(
        SUM(satisfaction_level) * 100.0 / COUNT(*), 2
    ) AS attrition_rate
FROM hr_data
GROUP BY salary
ORDER BY attrition_rate DESC;

-- Query 15. Find Employees with Above Average Satisfaction
-- Question: Average company satisfaction se zyada satisfaction wale employees find karein

SELECT
    satisfaction_level,
    Department,
    salary,
    last_evaluation
FROM hr_data
WHERE satisfaction_level >
    (SELECT AVG(
WITH department_attrition AS (
    SELECT
        "Department",
        COUNT(*) AS total_employees,
        SUM(left) AS employees_left,
        ROUND(
            SUM(left) * 100.0 / COUNT(*), 2
        ) AS attrition_rate
    FROM hr_data
    GROUP BY "Department"
)
SELECT *
FROM department_attrition
ORDER BY attrition_rate DESC
LIMIT 3;
)
     FROM hr_data)
ORDER BY satisfaction_level DESC;


-- Query 16. Employee Performance Classification
-- Question: Employees ko performance evaluation ke basis par classify karein.
SELECT department,
last_evaluation,
case 
when last_evaluation <0.80 then 'high_perfomance'
when last_evaluation <0.40 then 'low_perfomance'
ELSE 'Avg_perfomance'
end as prefomance_evaltoion
from hr_data;


-- Query 17. Rank Departments by Employee Count
-- Question: Employee count ke basis par departments ki ranking karein.
SELECT department,
count(*) as total_emp,
RANK() OVER( ORDER BY count(*) DESC) AS dept_rank
FROM hr_data
GROUP BY department;


-- Query 18. Find Top 3 Departments by Attrition Rate Using CTE
-- Question: Highest attrition rate wale top 3 departments find karein.

WITH department_attrition AS (
    SELECT
        Department,
        COUNT(*) AS total_employees,
        SUM(satisfaction_level) AS employees_left,
        ROUND(
            SUM(satisfaction_level) * 100.0 / COUNT(*), 2
        ) AS attrition_rate
    FROM hr_data
    GROUP BY Department
)
SELECT *
FROM department_attrition
ORDER BY attrition_rate DESC
LIMIT 3;

-- Query 19. Rank Employees Within Each Department
-- Question: Har department mein satisfaction level ke basis par employees ko rank karein
.
SELECT
    Department,
    satisfaction_level,
    salary,
    RANK() OVER (
        PARTITION BY Department
        ORDER BY satisfaction_level DESC
    ) AS satisfaction_rank
FROM hr_data;

-- Query 20. Employee Attrition Risk Classification
-- Question: Satisfaction, working hours aur evaluation ke basis par employees ko risk categories mein classify karein.

SELECT
    Department,
    average_montly_hours,
    last_evaluation,
    CASE
        WHEN satisfaction_level < 0.20
             AND average_montly_hours > 250
            THEN 'High Risk'
        WHEN satisfaction_level < 0.40
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS attrition_risk
FROM hr_data;



