(SELECT 
DISTINCT(first_answers.answer_name) AS 'ICD name',first_answers.icd10_code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS 'FEMALE PATIENT',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END),0) AS 'MALE PATIENT'
FROM
(SELECT 
    CASE WHEN concept_full_name IN ('Peptic ulcer, site unspecified','Gastritis and duodenitis','Acute haemorrhagic gastritis','Alcoholic gastritis','Chronic gastritis, unspecified','Gastritis, unspecified')
    THEN 'Acid peptic disorders' ELSE concept_full_name END AS answer_name,
    CASE WHEN icd10_code IN ('K27 ','K29.0','K29.2','K29.5','K29.7')
 THEN 'K27' ELSE icd10_code END AS icd10code,
         icd10_code
    FROM
        diagnosis_concept_view
    WHERE
        icd10_code IN ('K27 ','K29.0','K29.2','K29.5','K29.7')) first_answers
        
        LEFT OUTER JOIN
		
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('K27','K29.0','K29.2','K29.5','K29.7')
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
-- ========================================================Prostatism (BEP/BPH)========================================
(SELECT 
DISTINCT(first_answers.answer_name) AS 'ICD name',first_answers.icd10code AS 'ICD CODE',
IFNULL(SUM(CASE WHEN second_concept.gender = 'F' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END), 0) AS 'FEMALE PATIENT',
IFNULL(SUM(CASE WHEN second_concept.gender = 'M' AND second_concept.person_id IS NOT NULL THEN 1 ELSE 0 END),0) AS 'MALE PATIENT'
FROM
(SELECT 
    CASE WHEN concept_full_name IN ('Acute prostatitis','Chronic prostatitis','Prostatocystitis')
	THEN 'Prostatism (BEP/BPH)' ELSE concept_full_name END AS answer_name,
    CASE WHEN icd10_code IN ('N41.0','N41.1','N41.3') THEN 'N41' ELSE icd10_code END AS icd10code,icd10_code
    FROM diagnosis_concept_view
    WHERE icd10_code IN ('N41.0','N41.1','N41.3')) first_answers
        
        LEFT OUTER JOIN
		
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('N41.0','N41.1','N41.3')
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
        icd10_code IN ('K60.2','K60.3','K63.2','N20.0','D24','O91.2','N64.4','E88.2',
'L72.9','L05','K37','K81.0','K80','K46','N43.3','N47','K64.9','N45')) first_answers        
        LEFT OUTER JOIN
    (SELECT DISTINCT(p.person_id),dcv.concept_full_name,icd10_code,v.visit_id AS visit_id,p.gender AS gender FROM person p
    INNER JOIN visit v ON p.person_id = v.patient_id AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id AND o.voided = 0 AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN obs o1 ON o.encounter_id = o1.encounter_id AND o1.obs_group_id = o.obs_group_id AND o1.value_coded = 18
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id AND cn.concept_name_type = 'FULLY_SPECIFIED' AND cn.name IN ('Coded Diagnosis') AND o.voided = 0 AND cn.voided = 0
    JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded AND dcv.icd10_code IN ('K60.2','K60.3','K63.2','N20.0','D24','O91.2','N64.4','E88.2',
'L72.9','L05','K37','K81.0','K80','K46','N43.3','N47','K64.9','N45')
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

union 

SELECT 
'Not mentioned above and other' AS 'ANSWER NAME',
'R69' AS 'ICD CODE',
    IFNULL(SUM(CASE
                WHEN
                    second_concept.gender = 'F'
                        AND second_concept.person_id IS NOT NULL
                THEN
                    1
                ELSE 0
            END),
            0) AS 'FEMALE PATIENT',
    IFNULL(SUM(CASE
                WHEN
                    second_concept.gender = 'M'
                        AND second_concept.person_id IS NOT NULL
                THEN
                    1
                ELSE 0
            END),
            0) AS 'MALE PATIENT'
FROM
    (SELECT 
        concept_full_name AS answer_name, icd10_code
    FROM
        diagnosis_concept_view
    WHERE
        icd10_code not IN ('B05','A36.9','A37.9','A33','A35','A15.0','G83','B06','B26','B01','B16','A86','B74.9','B54','B50.9',	
      'B51','A90','B55.9','A01.0','A09.9','A06.9','A03.9','K52.9','A00.9','B82.0','R17','B15','B17.2',	
      'E86','A30.9','G03','B24','N34.3','N49.2','N89.8','R10.4','P39.1','N50.8','I88.9','A53.9','J22',	
      'J06.9','J15','J40','N39.0','N99.9','N50.9','E04.9','E46','E61','E66.9','D64.9','G62','L70.9',
      'B07','L81.1','L50.9','L30.9','L66','L80','E70.3','A60','B02','L53','L01',	'L02','L02.9','J34.0',
      'L43.9','B86','L81.9','L40.9','L04.9','H66.0','H65.2','J01.9','J03.9','J02.9','T16','T17','T18',
      'H61.2','J33.9','J34.2','H60.9','K21','K02.9','K08.8','K05.4','K12.3','K01.1','K00.9','K13.2',
      'B37.9','K13.7','H10.9','A71.9','H26','H54.0','H52.7','H40.9','H53.5','H05.2','H00.0','H00','H11.0',
      'H36.0*','H35','H02.0','H02.1','S05.9','H35.9','H50.9','H35.5','H53.6','C69.2','O00.9','O08.9','O13',
      'O14.1','O15.0','O15.1','O15.2','O21.0','O46.9','O63.0','O65.9','O71.1','O72','O73','O75.9','O85',
      'N73.9','N81.4','N92.6','N93.9','N97.9','N46','F03','F10','F20','F29','F31.9','F32','F40.9','F41.9',
      'F42.9','F44','F48.9','F79','G40','G43','F99','C50.9','C53','C34','C15.9','D13.1','C73','C22','C25',
      'C79.5','C23','C06','C85','C56','C67','C11','C76','I10','I11.0','I50','J44.9','I01.9','I09.9','I24.9',
      'J45.9','N17','N18','N05','N04','R51','R50','K29','W57','T30','T65','W54','A25','X20',	'W59','Z73','V89',
      'M06','I77.6','M19','M54','K60.2','K60.3','K63.2','N20.0','D23.9','O91.2','N64.4','E88.2','L72.9',
      'L05','K37','K81.0','K80','K46','N43.3','N47','K64.9','N45','R69','N81.9','N82.9','N84.9','J18.9',
      'J12.9','J13','J14','J15.9','J16','P23','J09','J10','J11.8','E14','E14.3†','E10.1','O24.4','E10',	
      'E11','E12','E13','J31.0','J30.4','K03.81','S02.5',	'K00.6','K07.3','S03.2','K03.8','K03.0','K03.1',
      'K03.2','K00.1','K01.0','K03.5','K03.6','K03.9','K08.1','C20','C18.9','C06','C11','C00.0','C01',
      'C02','C03','C04','C05','C07','C08','C09','C10','C14','C30','C41.0','C41.1','A43','I42.0','I42.1','I97.0',
      'O90.3','P29','R57.0','R10.0','R10.4','K70.3','K74.3','K74.4','K74.5','W19','W10','W11','W13','W14',	
      'W15','S09','P15','S00','S00.0','S07.9','S09.1','S09.7','S09.9','S26.9','T07','T09.0','T09.3','T14.2',
      'S02.6','M84.0','S02','S22.2','S22.4','S82.0','T02','T08','T10','T12','K27 ','K29',	'K29.0','K29.2','K29.5',
      'K29.7','N41.0','N41.1','N41.3')) first_answers
        LEFT OUTER JOIN
    (SELECT DISTINCT
        (p.person_id),
            dcv.concept_full_name,
            icd10_code,
            v.visit_id AS visit_id,
            p.gender AS gender
    FROM
        person p
    INNER JOIN visit v ON p.person_id = v.patient_id
        AND v.voided = 0
    INNER JOIN encounter e ON v.visit_id = e.visit_id AND e.voided = 0
    INNER JOIN obs o ON e.encounter_id = o.encounter_id
        AND o.voided = 0
        AND DATE(o.obs_datetime) BETWEEN '#startDate#' AND '#endDate#'
    INNER JOIN concept_name cn ON o.concept_id = cn.concept_id
        AND cn.concept_name_type = 'FULLY_SPECIFIED'
        AND cn.name IN ('Coded Diagnosis')
        AND o.voided = 0
        AND cn.voided = 0
     JOIN diagnosis_concept_view dcv ON dcv.concept_id = o.value_coded
        AND dcv.icd10_code not IN ('B05','A36.9','A37.9','A33','A35','A15.0','G83','B06','B26','B01','B16','A86','B74.9','B54','B50.9',	
        'B51','A90','B55.9','A01.0','A09.9','A06.9','A03.9','K52.9','A00.9','B82.0','R17','B15','B17.2',	
        'E86','A30.9','G03','B24','N34.3','N49.2','N89.8','R10.4','P39.1','N50.8','I88.9','A53.9','J22',	
        'J06.9','J15','J40','N39.0','N99.9','N50.9','E04.9','E46','E61','E66.9','D64.9','G62','L70.9',
        'B07','L81.1','L50.9','L30.9','L66','L80','E70.3','A60','B02','L53','L01',	'L02','L02.9','J34.0',
        'L43.9','B86','L81.9','L40.9','L04.9','H66.0','H65.2','J01.9','J03.9','J02.9','T16','T17','T18',
        'H61.2','J33.9','J34.2','H60.9','K21','K02.9','K08.8','K05.4','K12.3','K01.1','K00.9','K13.2',
        'B37.9','K13.7','H10.9','A71.9','H26','H54.0','H52.7','H40.9','H53.5','H05.2','H00.0','H00','H11.0',
        'H36.0*','H35','H02.0','H02.1','S05.9','H35.9','H50.9','H35.5','H53.6','C69.2','O00.9','O08.9','O13',
        'O14.1','O15.0','O15.1','O15.2','O21.0','O46.9','O63.0','O65.9','O71.1','O72','O73','O75.9','O85',
        'N73.9','N81.4','N92.6','N93.9','N97.9','N46','F03','F10','F20','F29','F31.9','F32','F40.9','F41.9',
        'F42.9','F44','F48.9','F79','G40','G43','F99','C50.9','C53','C34','C15.9','D13.1','C73','C22','C25',
        'C79.5','C23','C06','C85','C56','C67','C11','C76','I10','I11.0','I50','J44.9','I01.9','I09.9','I24.9',
        'J45.9','N17','N18','N05','N04','R51','R50','K29','W57','T30','T65','W54','A25','X20',	'W59','Z73','V89',
        'M06','I77.6','M19','M54','K60.2','K60.3','K63.2','N20.0','D23.9','O91.2','N64.4','E88.2','L72.9',
        'L05','K37','K81.0','K80','K46','N43.3','N47','K64.9','N45','R69','N81.9','N82.9','N84.9','J18.9',
        'J12.9','J13','J14','J15.9','J16','P23','J09','J10','J11.8','E14','E14.3†','E10.1','O24.4','E10',	
        'E11','E12','E13','J31.0','J30.4','K03.81','S02.5',	'K00.6','K07.3','S03.2','K03.8','K03.0','K03.1',
        'K03.2','K00.1','K01.0','K03.5','K03.6','K03.9','K08.1','C20','C18.9','C06','C11','C00.0','C01',
        'C02','C03','C04','C05','C07','C08','C09','C10','C14','C30','C41.0','C41.1','A43','I42.0','I42.1','I97.0',
        'O90.3','P29','R57.0','R10.0','R10.4','K70.3','K74.3','K74.4','K74.5','W19','W10','W11','W13','W14',	
        'W15','S09','P15','S00','S00.0','S07.9','S09.1','S09.7','S09.9','S26.9','T07','T09.0','T09.3','T14.2',
        'S02.6','M84.0','S02','S22.2','S22.4','S82.0','T02','T08','T10','T12','K27 ','K29',	'K29.0','K29.2','K29.5',
        'K29.7','N41.0','N41.1','N41.3')
    WHERE
        p.voided = 0) first_concept ON first_concept.icd10_code = first_answers.icd10_code
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
        AND first_concept.visit_id = second_concept.visit_id
