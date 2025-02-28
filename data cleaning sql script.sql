-- viewing database
use hr_analytics;

-- viewing datsets

select* from adviti_hr_data;

-- Data Cleaning Process

-- Viewing columns
SELECT Department, COUNT(*)
FROM adviti_hr_data
GROUP BY Department;

SELECT Age, COUNT(*)
FROM adviti_hr_data
GROUP BY Age
ORDER BY AGE DESC;

SELECT Attrition, COUNT(*)
FROM adviti_hr_data
GROUP BY Attrition;

SELECT Employee_Engagement_Score, COUNT(*)
FROM adviti_hr_data
GROUP BY Employee_Engagement_Score;

select years_of_service, count(*)
from adviti_hr_data
group by years_of_service
order by years_of_service desc;

select employee_id from adviti_hr_data 
group by employee_id
order by employee_id desc;

--  viewing employees at different positions
select position, count(*) 
from adviti_hr_data
group by position
order by position desc;

-- viewing column in desc order
select position, count(*) 
from adviti_hr_data
group by position
order by count(*) desc;

-- updating column
update adviti_hr_data 
set position = 'interns'
where position ='%interns%';

-- duplicate values : data analyst and account executive 
update adviti_hr_data 
set position = 
case when position like '%Account%' and position like '%Exec%' then 'Account executive'
	when  position like '%data%Analyst%' then 'data analyst'
    else position
end;
--  checking null values and updating

select * from adviti_hr_data where department is null or department ='';
-- updating the null values with management 

update adviti_hr_data
set department ='management'
where department is null or department= '';

-- viewing and updating gender column 

select gender, count(*) from adviti_hr_data
group by gender;
      
update adviti_hr_data 
set Gender=
   case 
      When Gender IN  ('M', 'Male') then 'Male'
      When Gender IN ('F','Female') then 'Female'
	ELSE 'NA' 
    END;
    


-- inserting grouped attributes for age, engagement_score, years of exp, salary, dist from work, absentissm , 
-- this will help to understand data better and collect all scattered data in specific groups

alter table adviti_hr_data
add column rating_group varchar(20),
add column age_bracket varchar(20),
add column engagement_bracket varchar(20),
add column exp_years varchar(20),
add column salary_bracket varchar(20),
add column distance varchar(20),
add column absent_bracket varchar(20);

alter table adviti_hr_data drop rating_group;
alter table adviti_hr_data add column rating_bracket int;
alter table adviti_hr_data modify rating_bracket varchar(20);


update adviti_hr_data
set rating_bracket= 
	case 
        when performance_rating =5 then'high'
	else 'low'
	end;

update adviti_hr_data 
set age_bracket=
      case 
           WHEN age BETWEEN 20 AND 30 then '20-30 years'
           WHEN age BETWEEN 31 and 40 then '31-40 years'
           WHEN age BETWEEN 41 and 50 then '41-50 years'
           WHEN age>50 then '50+'
	else 'under 20 years' 
end;

update adviti_hr_data 
set engagement_bracket =
     case 
          when employee_engagement_score> 4 then 'high'
          when employee_engagement_score between 2 and 4 then 'moderate'
	else 'low' 
end;

update adviti_hr_data 
set exp_years= 
  case
       when years_of_service between 0 and 5 then '0-5 years'
       when years_of_service between 6 and 10 then '6-10 years'
       when years_of_service between 11 and 15 then '11-15 years'
       when years_of_service >15 then '15 plus exp'
    else 'Not Applicable'
end;

select salary from adviti_hr_data
group by salary 
order by salary desc;

update adviti_hr_data 
set salary_bracket =
  case 
       when salary <= 500000 THEN '0-500K'
       when salary > 500000 and salary <= 1000000 then '5-10 lpa'
       when salary >1000000 and salary <= 2000000 then '10-20 lpa'
       when salary >2000000 and salary <= 5000000 then '20-30 lpa'
       when salary >5000000 and salary <=10000000 then '50-100 lpa'
       else '1 crore'
end;

select distance_from_work from adviti_hr_data
group by distance_from_work
order by distance_from_work desc;

update adviti_hr_data 
set distance =
    case 
         when distance_from_work <=10 then 'short'
         when distance_from_work >10 and distance_from_work <=25 then 'medium'
         when distance_from_work >25 and distance_from_work <= 40 then 'distant'
         when distance_from_work >40 then 'highly distant'
	else 'NA'
end;

select absenteeism from adviti_hr_data
group by absenteeism 
order by absenteeism desc;


alter table  adviti_hr_data drop absentesim_bracket;
alter table adviti_hr_data add column absent_bracket varchar(20);
select* from adviti_hr_data;

update adviti_hr_data
set absent_bracket=
   case 
         when absenteeism <=10 then 'low'
         when absenteeism between 10 and 15 then 'mod'
	     when absenteeism > 15 then 'high'
	else '20+'
end;

-- satisfaction rate analysis [ -- satisfaction rate = ((satisfaction_score/5)+ (sum(binary column)/5))/2*100]
alter table adviti_hr_data 
add column satisfactionrate varchar(20);

update adviti_hr_data                                                               
set satisfactionrate = round(
(satisfaction_score/5)+
((JobSatisfaction_PeerRelationship +
JobSatisfaction_WorkLifeBalance + 
JobSatisfaction_Compensation+
JobSatisfaction_Management +
JobSatisfaction_JobSecurity)/5)/2*100,
2
);

-- employee benefit score 
alter table adviti_hr_data 
add column empbenefitrate varchar(20);

update adviti_hr_data                                                               
set empbenefitrate = round(
(employee_engagement_score/5)+
((EmployeeBenefit_HealthInsurance+
EmployeeBenefit_PaidLeave+
EmployeeBenefit_RetirementPlan+
EmployeeBenefit_GymMembership+
EmployeeBenefit_ChildCare)/5)/2*100,
2
);


--  Exploratory Data Analysis [EDA] contrary with 
-- 1. Attrition rate

select* from adviti_hr_data;

-- gender and attrition rate  analysis : this attribute of the data is comparable hence not considered as major factor.

select gender attrition , COUNT(*) AS attrition_count 
from adviti_hr_data
group by  gender, attrition 
order by attrition_count desc;

-- age and attrition : the data shows some variables which can tell us how age factor affected the people leaving the company. i.e in age fifty there is high attrition count
select age_bracket,count(*) as totalemployee, 
SUM(case when attrition='yes' then 1 else 0 end) AS attrition_count,
(SUM(case when attrition = 'yes' then 1 else 0 end)*100/ count(*)) as attritionrate_percentage
from adviti_hr_data
group by  age_bracket 
order by attritionrate_percentage desc;

-- experience: It is visible that employees tend to leave the companies in the initial years and with less experience switch to take good opportunity
select  exp_years,
  count(*) as attrition_count from adviti_hr_data 
  where attrition = 'yes'
group by exp_years
order by attrition_count desc;

-- position : SD1 have high attrition % as they tend to leave the organisation for better opportunities
select position ,count(*) as position_of_emp, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by position
order by attrition_count_percentage desc;

-- department : if we look into departments , operations area is at lowest attrition rate while management  have a zero rate
select department,count(*) as deptcount, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by department
order by attrition_count_percentage desc; 


-- salary-- 20-30  lpa salary employee tend to leave mostly. 
select salary_bracket, count(*) as salarycount, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by salary_bracket
order by attrition_count_percentage desc; 


-- impact of work hours 
select exp_years, round(avg(work_hours)) as empworkhours, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by exp_years   -- mostly employees in initial years tend to leave due to working hours 
order by attrition_count_percentage desc; 

select age_bracket, round(avg(work_hours)) as empworkhours, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by age_bracket   -- employees  tend to leave due to age factor 
order by attrition_count_percentage desc; 

select salary_bracket, round(avg(work_hours)) as empworkhours, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by salary_bracket    -- employees having salary between 20-30 lpa tend to move more
order by attrition_count_percentage desc; 

select distance, round(avg(work_hours)) as empworkhours, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by distance             -- employees who live to highly distant places tend to leave more
order by attrition_count_percentage desc; 

-- distance analysis 

select distance, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by distance 
order by attrition_count_percentage desc;

-- promotion analysis
select exp_years, promotion, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
group by exp_years, promotion
order by attrition_count_percentage desc;

select exp_years, promotion, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_count_percentage
from adviti_hr_data 
where exp_years = '0-5 years' and promotion!= 'intern'
group by exp_years, promotion
order by attrition_count_percentage desc;

-- performance rating : employee having high rating , have high attrition rate

select performance_rating,rating_bracket,count(*) as attrition_count from adviti_hr_data 
 where attrition= 'yes' 
 group by rating_bracket, performance_rating 
order by attrition_count desc;

-- employee engagement score : the attrition rate is low
select attrition,count(*) as attrition_count,
round(avg(engagement_bracket),2) as avgscore
from adviti_hr_data 
where exp_years = '0-5 years' and promotion!= 'intern'
group by attrition
order by attrition_count desc;

-- training hours : hr, finance and sales have high attrition rate
select department, round(avg(training_hours),2) as avghours,
SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as avg_training_hrs
from adviti_hr_data 
group by department
order by avg_training_hrs;

-- satisfaction rate analysis: 41- 50 age years have high attrition rate 
select age_bracket, round(avg(satisfactionrate),2) as avgsatisfaction,
SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as avgrate
from adviti_hr_data 
group by age_bracket
order by avgrate desc;

-- employee benefit rate : employees with age group 41-50 years have low benefits with higher attrition rate 
select age_bracket, round(avg(empbenefitrate),2) as avgebenefitrate,
SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as avgratepercentage
from adviti_hr_data 
group by age_bracket
order by avgratepercentage desc;

-- absenteeism : the moderate absenteeism employees have high attrition rate in initial years
select exp_years, absent_bracket, count(*) as totalemp, SUM(case when attrition='yes'then 1 else 0 end)as attrition_count, 
(SUM(case when attrition= 'yes' then 1 else 0 end)*100/ count(*)) as attrition_percentage
from adviti_hr_data where position!='interns'
group by absent_bracket, exp_years
order by attrition_percentage desc;


-- 2. EMPLOYEE ENGAGEMENT SCORE

 select employee_engagement_score,engagement_bracket, count(*) as scorecount from adviti_hr_data
 group by engagement_bracket, employee_engagement_score
 order by scorecount desc;
 
 --  department, absenteeism, work hours, job position
 
select employee_name, max(employee_engagement_score) as maxscore,
min(employee_engagement_score) as minscore
from adviti_hr_data
group by employee_name;

SELECT employee_name, employee_engagement_score, COUNT(*) AS frequency
FROM adviti_hr_data
GROUP BY employee_name, employee_engagement_score
ORDER BY employee_name desc;

describe adviti_hr_data;

-- department, engagement: management department has highest engagement score near 100 % while rest are below 2-18 %
select department, avg(employee_engagement_score)*100/ count(*) as engagementscore_percentage 
from adviti_hr_data
group by department
order by engagementscore_percentage desc;

-- absenteeism analysis:  female have higher employee engagement score than males
select gender,absenteeism,count(*) as absentcount,
avg(employee_engagement_score)*100/ count(*) as engagementscore_percentage 
from adviti_hr_data
group by  absenteeism, gender
order by engagementscore_percentage desc;

SELECT gender, COUNT(*) AS total_employees,
avg(employee_engagement_score)*100/count(*) AS avg_absenteeism_rate
FROM adviti_hr_data
GROUP BY gender;

-- work hours
 select work_hours, avg(employee_engagement_score), count(*) as avg_work_hours
 from adviti_hr_data
 group by work_hours
 order by avg_work_hours desc;

SELECT work_hours, 
       AVG(employee_engagement_score) AS avg_engagement, 
       COUNT(*) AS employee_count
FROM adviti_hr_data
GROUP BY work_hours
ORDER BY employee_count DESC; -- employee having less working hours tend to engage less

-- position : It support head  poition has high engagement score
select department, position, avg(employee_engagement_score) as avg_engagement
from adviti_hr_data where position!= 'intern'
group by position
order by avg_engagement desc;


 -- What is the average tenure for employees within each department?
 select  department, round(avg(years_of_service)) as avg_tenure
 from adviti_hr_data
group by department;

-- How many employees in each department are still working at the company?
select count(*) as total_employees, department
 from adviti_hr_data
 where attrition= 'no'
group by department;

-- How does job satisfaction for employees compare with different tenure levels?
select years_of_service, avg(satisfaction_score) from adviti_hr_data
group by years_of_service, satisfaction_score;

