-- Create a database and import data
CREATE DATABASE employee;

-- Import data into emp_record_table
LOAD DATA INFILE 'emp_record_table.csv'
INTO TABLE employee.emp_record_table
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import data into proj_table
LOAD DATA INFILE 'proj_table.csv'
INTO TABLE employee.proj_table
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Import data into data_science_team
LOAD DATA INFILE 'data_science_team.csv'
INTO TABLE employee.data_science_team
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Fetch Employee Details
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM employee.emp_record_table;

-- Fetch Employee Ratings
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM employee.emp_record_table
WHERE EMP_RATING < 2 OR EMP_RATING > 4 OR (EMP_RATING >= 2 AND EMP_RATING <= 4);

-- Concatenate First and Last Names in Finance Department
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM employee.emp_record_table
WHERE DEPT = 'Finance';

-- List Employees with Reports and Count
SELECT E.EMP_ID, E.FIRST_NAME, E.LAST_NAME, E.DEPT, COUNT(*) AS Num_Reports
FROM employee.emp_record_table E
JOIN employee.emp_record_table R ON E.EMP_ID = R.MANAGER_ID
GROUP BY E.EMP_ID, E.FIRST_NAME, E.LAST_NAME, E.DEPT;

-- List Employees in Healthcare and Finance using UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM employee.emp_record_table
WHERE DEPT = 'Healthcare'
UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM employee.emp_record_table
WHERE DEPT = 'Finance';

-- Employee Details Grouped by Department with Max Rating
SELECT DEPT, MAX(EMP_RATING) AS Max_Rating
FROM employee.emp_record_table
GROUP BY DEPT;

-- Min and Max Salary by Role
SELECT ROLE, MIN(SALARY) AS Min_Salary, MAX(SALARY) AS Max_Salary
FROM employee.emp_record_table
GROUP BY ROLE;

-- Assign Ranks Based on Experience
UPDATE employee.emp_record_table
SET ROLE =
    CASE
        WHEN EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
        WHEN EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
        WHEN EXP <= 10 THEN 'SENIOR DATA SCIENTIST'
        WHEN EXP <= 12 THEN 'LEAD DATA SCIENTIST'
        ELSE 'MANAGER'
    END;

-- Create View for High-Salary Employees
CREATE VIEW HighSalaryEmployees AS
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY
FROM employee.emp_record_table
WHERE SALARY > 6000;

-- Nested Query for Employees with Over 10 Years of Experience
SELECT EMP_ID, FIRST_NAME, LAST_NAME
FROM employee.emp_record_table
WHERE EXP > 10;

-- Stored Procedure for Employees with More Than 3 Years of Experience
DELIMITER //
CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT EMP_ID, FIRST_NAME, LAST_NAME
    FROM employee.emp_record_table
    WHERE EXP > 3;
END;
//
DELIMITER ;

-- Stored Function to Check Job Profiles in Data Science Team
DELIMITER //
CREATE FUNCTION CheckJobProfile(experience INT)
RETURNS VARCHAR(50)
BEGIN
    DECLARE jobProfile VARCHAR(50);
    IF experience <= 2 THEN
        SET jobProfile = 'JUNIOR DATA SCIENTIST';
    ELSEIF experience <= 5 THEN
        SET jobProfile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF experience <= 10 THEN
        SET jobProfile = 'SENIOR DATA SCIENTIST';
    ELSEIF experience <= 12 THEN
        SET jobProfile = 'LEAD DATA SCIENTIST';
    ELSE
        SET jobProfile = 'MANAGER';
    END IF;
    RETURN jobProfile;
END;
//
DELIMITER ;

-- Create an Index for Employee with FIRST_NAME 'Eric'
CREATE INDEX idx_eric_employee
ON employee.emp_record_table (FIRST_NAME);

-- Calculate Bonuses Based on Ratings and Salaries
SELECT EMP_ID, FIRST_NAME, LAST_NAME, (0.05 * SALARY * EMP_RATING) AS Bonus
FROM employee.emp_record_table;

-- Calculate Average Salary Distribution based on Continent and Country
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS Avg_Salary
FROM employee.emp_record_table
GROUP BY CONTINENT, COUNTRY;
