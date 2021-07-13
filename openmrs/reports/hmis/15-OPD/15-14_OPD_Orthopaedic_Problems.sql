(SELECT 
DISTINCT(first_answers.answer_name) AS 'ICD name',first_answers.icd10code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS 'FEMALE PATIENT',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END),0) AS 'MALE PATIENT'
FROM
(SELECT 
    CASE WHEN concept_full_name IN ('Unspecified fall','Fall on and from stairs and steps','Fall on and from ladder','Fall from, out of or through building or structure','Fall from tree','Fall from cliff',
'Other and unspecified injuries of head','Other birth injuries','Superficial injury of head','Superficial injury of scalp','Crushing injury of head, part unspecified',
'Injury of muscle and tendon of head','Multiple injuries of head','Unspecified injury of head','Injury of heart, unspecified','Unspecified multiple injuries',
'Superficial injury of trunk, level unspecified','Injury of spinal cord, level unspecified','Fracture, unspecified','Fracture of mandible','Malunion of fracture','Fracture of skull and facial bones',
'Fracture of sternum','Multiple fractures of ribs','Fracture of patella','Fractures involving multiple body regions','Fracture of spine, level unspecified',
'Fracture of upper limb, level unspecified','Fracture of lower limb, level unspecified')
	THEN 'Falls/ injuries/ fractures' ELSE concept_full_name END AS answer_name,
    CASE WHEN icd10_code IN ('W19','W10','W11','W13','W14','W15','S09','P15','S00','S00.0','S07.9','S09.1',
'S09.7','S09.9','S26.9','T07','T09.0','T09.3','T14.2','S02.6','M84.0','S02','S22.2','S22.4','S82.0','T02','T08','T10','T12')
 THEN 'T14' ELSE icd10_code END AS icd10code,icd10_code
    FROM diagnosis_concept_view
    WHERE icd10_code IN ('W19','W10','W11','W13','W14','W15','S09','P15','S00','S00.0','S07.9','S09.1',
'S09.7','S09.9','S26.9','T07','T09.0','T09.3','T14.2','S02.6','M84.0','S02','S22.2','S22.4','S82.0','T02','T08','T10','T12')) first_answers
        
        LEFT OUTER JOIN
		
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('W19','W10','W11','W13','W14','W15','S09','P15','S00','S00.0','S07.9','S09.1','S09.7','S09.9','S26.9','T07','T09.0','T09.3','T14.2','S02.6','M84.0','S02','S22.2','S22.4','S82.0','T02','T08','T10','T12')
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
        icd10_code IN ('V89','M06','I77.6','M19','M54')) first_answers        
        LEFT OUTER JOIN
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('V89','M06','I77.6','M19','M54')
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
