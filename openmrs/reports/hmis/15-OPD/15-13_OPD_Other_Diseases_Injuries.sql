(SELECT 
DISTINCT(first_answers.answer_name) AS 'ICD name',first_answers.icd10_code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS 'FEMALE PATIENT',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END),0) AS 'MALE PATIENT'
FROM
(SELECT 
    CASE WHEN concept_full_name IN ('Acute abdomen pain','Other and unspecified abdominal pain')
    THEN 'Abdominal Pain' ELSE concept_full_name END AS answer_name,
    CASE WHEN icd10_code IN ('R10.0','R10.4')
 THEN 'R10' ELSE icd10_code END AS icd10code,
         icd10_code
    FROM
        diagnosis_concept_view
    WHERE
        icd10_code IN ('R10.0','R10.4')) first_answers
        
        LEFT OUTER JOIN
		
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('R10.0','R10.4')
    WHERE p.voided = 0) first_concept ON first_concept.icd10_code = first_answers.icd10_code
	
        LEFT OUTER JOIN
		
    (SELECT DISTINCT
    (person.person_id) AS person_id,
            visit.visit_id AS visit_id,
            person.gender AS gender
   FROM person 
     JOIN visit  ON person_id = visit.patient_id 
     JOIN visit_type vt ON visit.visit_type_id = vt.visit_type_id AND vt.name != 'IPD'

    WHERE
        cast(visit.date_started AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON first_concept.person_id = second_concept.person_id
		-- ON 
		-- first_concept.person_id = second_concept.person_id 
		and first_concept.visit_id = second_concept.visit_id
)
union
-- ================================================================liver cerrhosis=======================================
(SELECT 
DISTINCT(first_answers.answer_name) AS 'ICD name',first_answers.icd10code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS 'FEMALE PATIENT',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END),0) AS 'MALE PATIENT'
FROM
(SELECT 
    CASE WHEN concept_full_name IN ('Alcoholic cirrhosis of liver','Primary biliary cirrhosis','Secondary biliary cirrhosis','Biliary cirrhosis, unspecified')
	THEN 'Cirrhosis of liver' ELSE concept_full_name END AS answer_name,
    CASE WHEN icd10_code IN ('K70.3','K74.3','K74.4','K74.5') 
	THEN 'L74' ELSE icd10_code END AS icd10code,icd10_code
    FROM diagnosis_concept_view
    WHERE icd10_code IN ('K70.3','K74.3','K74.4','K74.5')) first_answers
        
        LEFT OUTER JOIN
		
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('K70.3','K74.3','K74.4','K74.5')
    WHERE p.voided = 0) first_concept ON first_concept.icd10_code = first_answers.icd10_code
	
        LEFT OUTER JOIN
		
    (SELECT DISTINCT
    (person.person_id) AS person_id,
            visit.visit_id AS visit_id,
            person.gender AS gender
   FROM person 
     JOIN visit  ON person_id = visit.patient_id 
     JOIN visit_type vt ON visit.visit_type_id = vt.visit_type_id AND vt.name != 'IPD'

    WHERE
        cast(visit.date_started AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON first_concept.person_id = second_concept.person_id
		-- ON 
		-- first_concept.person_id = second_concept.person_id 
		and first_concept.visit_id = second_concept.visit_id
)

UNION
(SELECT 
DISTINCT(first_answers.answer_name) AS 'ICD name',first_answers.icd10_code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS 'FEMALE PATIENT',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END),0) AS 'MALE PATIENT'
FROM
    (SELECT concept_full_name answer_name,
         icd10_code
    FROM
        diagnosis_concept_view
    WHERE
        icd10_code IN ('N17','N18','N05','N04','R51','R50','K29','W57','T30','T65','W54','A25','X20','W59','Z73')) first_answers        
        LEFT OUTER JOIN
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('N17','N18','N05','N04','R51','R50','K29','W57','T30',
'T65','W54','A25','X20','W59','Z73')
    WHERE p.voided = 0) first_concept ON first_concept.icd10_code = first_answers.icd10_code
        LEFT OUTER JOIN
    (SELECT DISTINCT(person.person_id) AS person_id,
            visit.visit_id AS visit_id,
            person.gender AS gender
   FROM person 
     JOIN visit  ON person_id = visit.patient_id 
     JOIN visit_type vt ON visit.visit_type_id = vt.visit_type_id AND vt.name != 'IPD'
    WHERE
        cast(visit.date_started AS DATE) BETWEEN DATE('#startDate#') AND DATE('#endDate#')) second_concept ON first_concept.person_id = second_concept.person_id
        AND first_concept.visit_id = second_concept.visit_id
GROUP BY first_answers.icd10_code)
