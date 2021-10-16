-- -*- mode: sql; sql-product: postgres; -*-

-- questions:

-- 1. What is the variance of the number of use of force reports per
-- capita accross units?

-- 2. Per capita, are veteran police officers more likely to acquire a
-- use of force complaint than less experienced ones?

-- 3. What is the correlation between salary and complaints?

-- 4. Do some units of the police force fire more bullets per officer
-- on average in incidents?

-- 5. Does seniority affect the type of force an active officer might
-- use?

-- helper tables section
DROP TABLE IF EXISTS officer_unit ;
CREATE TEMP TABLE officer_unit AS
SELECT DISTINCT id officer_id,
       last_unit_id unit_id
FROM data_officer ;

DROP TABLE IF EXISTS unit_officer_counts ;
CREATE TEMP TABLE unit_officer_counts AS
SELECT unit_id,
       COUNT(DISTINCT officer_id) cnt_oid_all
FROM officer_unit
GROUP BY unit_id ;

DROP TABLE IF EXISTS cnt_reports ;
CREATE TEMP TABLE cnt_reports AS
SELECT COUNT(DISTINCT officer_id) cnt_oid_trr,
       officer_unit_id unit_id
FROM trr_trr
GROUP BY officer_unit_id ;

DROP TABLE IF EXISTS officer_shots ;
CREATE TEMP TABLE officer_shots AS
SELECT total_number_of_shots num_shots,
       officer_id,
       officer_unit_id unit_id
FROM trr_trr
WHERE total_number_of_shots != 0
;

DROP TABLE IF EXISTS officer_seniority ;
CREATE TEMP TABLE officer_seniority AS
SELECT DISTINCT officer_id,
       YEAR - EXTRACT(YEAR FROM org_hire_date) empl_years
FROM data_salary dos
JOIN data_officer dof
ON dos.officer_id = dof.id
;

DROP TABLE IF EXISTS trr_force_type ;
CREATE TEMP TABLE trr_force_type AS
SELECT id,
       officer_id,
       CASE
       WHEN firearm_used THEN 1 -- firearm
       WHEN taser        THEN 2 -- taser
       ELSE 0                   -- no force
       END force_type
FROM trr_trr
;

DROP TABLE IF EXISTS officer_force_counts ;
CREATE TEMP TABLE officer_force_counts AS
SELECT no_force.officer_id,
       no_force.count "#no_force",
       firearm.count "#firearm",
       taser.count "#taser"
FROM (SELECT COUNT(officer_id), officer_id
             FROM trr_force_type
             WHERE force_type = 0
             GROUP BY officer_id) no_force
JOIN (SELECT COUNT(officer_id), officer_id
             FROM trr_force_type
             WHERE force_type = 1
             GROUP BY officer_id) firearm
ON no_force.officer_id = firearm.officer_id
JOIN (SELECT COUNT(officer_id), officer_id
             FROM trr_force_type
             WHERE force_type = 2
             GROUP BY officer_id) taser
ON no_force.officer_id = taser.officer_id
;

-- 1. What is the variance of the number of use of force per capita
-- reports accross units?
DROP TABLE IF EXISTS q1 ;
CREATE TEMP TABLE q1 AS
SELECT VARIANCE(cnt_oid_trr / cnt_oid_all) use_force_var
-- SELECT cr.*, cnt_oid_all
FROM cnt_reports cr
JOIN unit_officer_counts uoc
ON cr.unit_id = uoc.unit_id
;

-- 2. Are veteran police officers more likely to acquire a use of force complaint than less experienced ones?
DROP TABLE IF EXISTS q2 ;
CREATE TEMP TABLE q2 AS
SELECT corr(year - EXTRACT(YEAR from org_hire_date), (allegation_name LIKE 'Excessive Force%')::int)
FROM data_salary
JOIN data_officer
ON data_officer.id =  data_salary.officer_id
JOIN data_officerallegation
ON data_officerallegation.officer_id = data_officer.id
JOIN data_allegation
ON data_allegation.crid = data_officerallegation.allegation_id
JOIN data_allegationcategory
ON data_allegationcategory.id = data_allegation.most_common_category_id
;

-- 3. What is the correlation between salary and complaints?
DROP TABLE IF EXISTS q3 ;
CREATE TEMP TABLE q3 AS
SELECT CORR(salary, YEAR - EXTRACT(YEAR FROM org_hire_date))
FROM data_salary
;

-- 4. Do some units of the police force fire more bullets per officer
-- on average in incidents?
DROP TABLE IF EXISTS q4 ;
CREATE TEMP TABLE q4 AS
WITH avg_off AS (
SELECT AVG(num_shots) avg_shots,
       officer_id,
       unit_id
FROM officer_shots
GROUP BY officer_id, unit_id)
SELECT AVG(avg_shots) avg_shots,
       unit_id
FROM avg_off
GROUP BY unit_id
ORDER BY avg_shots DESC
;

-- 5. Does seniority affect the type of force an active officer might
-- use?
DROP TABLE IF EXISTS q5 ;
CREATE TEMP TABLE q5 AS
SELECT CORR(os.empl_years, "#no_force") "CORR(no_force)",
       CORR(os.empl_years, "#firearm") "CORR(firearm)",
       CORR(os.empl_years, "#taser") "CORR(taser)"
FROM officer_seniority os
JOIN officer_force_counts fc
ON os.officer_id = fc.officer_id
;
