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
SELECT 
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
SELECT                          --TODO
;
