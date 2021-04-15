SELECT distinct
pi.identifier AS 'IP',
CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name) as 'Name',
TIMESTAMPDIFF(year,p.birthdate,CURDATE()) AS age,
p.gender,
pa.city_village as 'VDC',
date(o.obs_datetime) as 'date_diagnosed',
pa.address1 as 'Ward',
pa.county_district as 'District',
(select name from concept_name where concept_id = o.value_coded AND
o.voided IS FALSE and concept_name_type = 'FULLY_SPECIFIED' and voided = '0') as Diag
FROM
person p
INNER JOIN
patient_identifier pi ON p.person_id = pi.patient_id
AND pi.identifier != 'BAH200052'
AND pi.voided = '0'
INNER JOIN
person_name pn ON pn.person_id = p.person_id
AND pn.voided = '0'
INNER JOIN
person_address pa ON pa.person_id = pn.person_id
AND pa.voided = '0'
INNER JOIN
visit v ON v.patient_id = p.person_id
INNER JOIN
obs o ON o.person_id = p.person_id
and o.voided = '0'
-- EDCD
and o.concept_id = '15' AND o.value_coded in ('8679','5499','8673','4653','8729','5498','3981','8726','8727','8728','8660','5504','8608','9375','5486','5492','8689','5505','8577') -- EDCD
-- Mental Illness
-- and o.concept_id = '15' AND o.value_coded in ('2622', '2531', '5622', '5623', '5620', '4585', '5629', '2510', '5621', '5625', '5619', '5628','5630', '5627', '586', '6175','6187') -- Mental Health
-- and o.concept_id = '15' ('5522', '5501', '5505', '4863', '5499', '5500', '4640', '6929', '5487', '5496', '4163', '4653','5486')
-- CBIMNCI
-- and o.concept_id = '15' AND o.value_coded in ('3542','3537', '3530', '3538', '3539', '3540', '3541','3507') and o.value_coded in ('5522')
where p.voided = '0'
and date(o.obs_datetime) between date('#startDate#') and date('#endDate#')
-- and pa.city_village in ('Bhimeshwar Municipality','Bocha','Babare','Susmachhemawati','Sunakhani','Lapilang','Katakuti', 'Alampu', 'Phasku','Bhirkot','Bhusaphedi', 'Bigu','Bulung', 'Chankhu','Chhetrapa', 'Chilankha','Chyama','Dandakharka','Gaurisankar','Gairimudi', 'Ghangsukathokar', 'Hawa', 'Japhe', 'Jhule', 'Jhyaku','Jiri', 'Jugu', 'Kabhre', 'Kalingchok', 'Katakuti', 'Khare', 'Khopachagu', 'Laduk', 'Lakuridada', 'Lamabagar', 'Lamidada', 'Lapilang', 'Magapauwa', 'Mali', 'Malu', 'Marbu', 'Melung', 'Mirge', 'Namdu', 'Orang', 'Pawati', 'Sahare', 'Sailungeswor', 'Sundrawati', 'Sunakhani', 'Syama', 'Dudhpokhari', 'Thulopatal', 'Rasanalu', 'Dadhuwa', 'Thulopakhar', 'Thulodhading' )
group by IP, Name, age, gender, VDC, Ward, District, Diag
ORDER BY date_diagnosed ASC;
