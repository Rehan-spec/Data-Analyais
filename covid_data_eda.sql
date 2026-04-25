-----------DATABASE----------------

use covid_data

-----------SAMPLE COVID19 DATA----------

select * from sample_covid_data 

-----------TOTAL NUMBERS OF PATIENTS-----------------------

select count(*)from sample_covid_data as patients;

-----------CASES AS PER COUNTRY----------------------------

select country,count(country) as cases_per_country
from sample_covid_data 
group by country ;

------------CASES AS PER GENDER-------------------

select gender,count(gender) as cases
from sample_covid_data 
group by gender;

-------------AGE GROUP EFFECT BY COUNTRY--------------

select country,gender,
	count(case 
	when age <18 then 1
	else 0 end)as minor,

	count(case 
	when age between 18 and 60 then 1
	else 0 end)as adult,

	count(case 
	when age >60 then 1
	else 0 end)as senior
from sample_covid_data
group by country,gender
order by country;

----------gender EFFECTED BY COUNTRY--------

select country,
	count(case 
	when gender='male' then 1
	else 0 end)as 'MALE',

	count(case 
	when gender='female' then 1
	else 0 end)as 'FEMALE'

from sample_covid_data
group by country;

------------PATIENT complications BEFORE COVID--------------------------

select comorbidities,
sum(case when gender = 'male' then 1 else 0 end) as male,
sum(case when gender = 'female' then 1 else 0 end) as female,
count(*) as total
from sample_covid_data
group by comorbidities

-----------------SEVERITY_LEVEL----------------------

select severity,count(*) as patients 
from sample_covid_data 
group by severity

---------------SEVERITY_LEVEL OF GENDER AND AGE GROUP-

select gender,severity,
	sum(case 
	when age <18 then 1
	else 0 end)as minor,

	sum(case 
	when age between 18 and 60 then 1
	else 0 end)as adult,

	sum(case 
	when age >60 then 1
	else 0 end)as senior,
count(age) as total

from sample_covid_data
group by gender,severity
order by severity;

----------------- covid_SYMPTOM------------------------------------------

SELECT symptom,COUNT(*) AS patients
FROM (
    SELECT symptoms_1 AS symptom FROM sample_covid_data
    UNION all
    SELECT symptoms_2 AS symptom FROM sample_covid_data
    UNION all
    SELECT symptoms_3 AS symptom FROM sample_covid_data
) AS all_symptoms
WHERE symptom <> 'no'
GROUP BY symptom
ORDER BY patients DESC;

------------------HOSPITALIZWD PATIENTS---------------------

select count(hospitalized) as hospitalized
from sample_covid_data
where hospitalized=1

------------------ icu_admission------------------------------

select count(icu_admission) as icu_admission
from sample_covid_data
where icu_admission=1

----------------PATIRNTS IN ventilator_support-------------------------

select count(ventilator_support) as ventilator_support
from sample_covid_data
where ventilator_support=1

----------------VACCINATION STATUS AS PER AGE GROUP--

select vaccination_status,sum(case 
	when age <18 then 1
	else 0 end)as minor,

	sum(case 
	when age between 18 and 40 then 1
	else 0 end)as adult,

	sum(case 
	when age >40 then 1
	else 0 end)as senior,

count(age) as total
from sample_covid_data 
group by vaccination_status

-------------DATA RANGE IN YEARS-------------------------------------

select format(report_date,'yyyy') as data_range_in_years
from sample_covid_data 
group by format(report_date,'yyyy');

----------------PATIENTS RECOVERED-------------------------------

select count(date_of_recovery) as total_recovery
from sample_covid_data
where date_of_recovery is not null;

-----------------PATIENTS DIED------------------------------

select count(date_of_death) as total_DEATH
from sample_covid_data
where date_of_death is not null;

-----------------DURATION OF RECOVERY AND DEATH----------------------------------

select report_date,DATE_OF_RECOVERY,
DAYS_ESTIMATE_FOR_RECOVERY,
datediff(day,report_date,DATE_OF_RECOVERY) as recovered_in_days,
datediff(day,report_date,date_of_death) as died_in_days
from sample_covid_data;

-----------------CASES BY YEARS----------------------------------------------

SELECT YEAR(REPORT_DATE)AS YEARS,COUNT(patient_id)AS CASES
FROM sample_covid_data
GROUP BY  YEAR(REPORT_DATE);
