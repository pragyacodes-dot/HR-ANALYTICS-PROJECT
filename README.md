
# HUMAN RESOURCES (HR) DATA ANALYSIS

## TABLE OF CONTENTS

- [Project Overview](#Project-Overview)
- [Data Source](#Data-Source)
- [Tools Used](#Tools-Used)
- [Data Preparation and Data Cleaning](#Data-Preparation-and-Data-Cleaning-Process-in-MySQL-Workbench)
- [Data Analysis](#Questions-Answered-in-Data-Analysis-Process-in-MySQL-Workbench)
- [Visualization in Power BI](#Visualization-in-Power-BI)
- [Findings](#Findings-from-the-Analysis)
- [Limitations](#Limitations)

### Project Overview

The aim of this HR analytics project is to gain insights into workforce dataset, derive insights to build employee engagement, optimised operations and compile the finding in coherent narrative of company leadership. This will help to take strategic and informed decisions to improve organisation efficiency.

### Data Source

This primary dataset utilised for this analysis is sourced from "project1_sql_adviti_hr_csv-file", comprising comphrehensive employee data essential for the HR analytics project.

### Tools Used

- MySQL Workbench: To clean and analyze the data.
- PowerBI Desktop: To visualize the outcomes.

### Data Preperation and Data Cleaning Process in MySQL workbench

1. **Database Creation**: Establish a database named "hr_analytics."
2. **Import Data**: Import the HR dataset from the "project1_sql_adviti_hr_dump" file into the database.
3. **Check Data Types**: Review data types of all columns using the "DESCRIBE" command.
4. **viewed datasets**: Use SQL functions to standardize date formats and convert text to date data types.
5. **Handle Special Characters**: Rename columns with special characters using the "ALTER TABLE" command.
6. **Address Missing Values**: Identify and handle missing values, particularly in date columns like "termdate."
7. **Update Data Types**: Modify data types as needed, such as changing text to date or integer.
8. **Add New Columns**: Introduce new columns like "age" for additional analysis.
9. **Calculate Derived Metrics**: Calculate metrics like age based on existing data.
10. **Ensure Data Integrity**: Validate data integrity and consistency throughout the process.


#### Note: Data cleaning and data analysis SQL files are attached for reference.

### Visualization in Power BI

- After completing data cleaning and analysis in MySQL, the results were exported to CSV files.
- These CSV files served as the basis for creating a visually appealing dashboard in Power BI.
- The purpose of this Power BI dashboard was to provide a better understanding of the outcomes derived from the SQL data analysis.
- It's important to note that the Power BI dashboard created is non-interactive; it was designed solely for visually representing the insights obtained through SQL data analysis.

### Findings from the Analysis

1. data analyst, account, executive are duplicates altered as account executive, data analyst.
2. Updated null values in department column
3. Gender and attrition rate  analysis : this attribute of the data is comparable hence not 
   considered as major factor.
4. Age and attrition : the data shows some variables which can tell us how age factor affected 
   the people leaving the company. i.e in age fifty there is high attrition count.
5. Experience: It is visible that employees tend to leave the companies in the initial years and 
   with less experience switch to take good opportunity.
6. Position : SD1 have high attrition % as they tend to leave the organisation for better 
   opportunities.
7. Department : if we look into departments , operations area is at lowest attrition rate while 
   management  have a zero rate.
8. Salary: 20-30  lpa salary employee tend to leave mostly.
9. Impact work hours: a) mostly employees in initial years tend to leave due to working hours.
                      b) employees  tend to leave due to age factor.
                      c) employees having salary between 20-30 lpa tend to move more
  
10. Distancce analysis:  employees who live to highly distant places tend to leave more.
11. Promotion years: employees have higher attrition rate in initial years while with promotion 
    employees stay at the organisation.
12. performance rating : employee having high rating , have high attrition rate.
13. employee engagement score : the attrition rate is low
14. training hours : hr, finance and sales have high attrition rate.
15. satisfaction rate analysis: 41- 50 age years have high attrition rate
16. employee benefit rate : employees with age group 41-50 years have low benefits with higher attrition rate.
17. absenteeism : the moderate absenteeism employees have high attrition rate in initial years.
18. department, engagement: management department has highest engagement score near 100 % while rest are below 2-18 %
19. absenteeism analysis:  female have higher employee engagement score than males
20. position : It support head  poition has high engagement score.

