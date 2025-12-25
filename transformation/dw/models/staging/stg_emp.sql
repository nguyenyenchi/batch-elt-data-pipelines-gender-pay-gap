
WITH raw_emp AS (
	select *
	from {{ source('raw', 'employment') }}
)

select
    CAST("ANZSCO LEVEL" AS INTEGER) AS anzsco_level,
    TRIM("NFD INDICATOR 5") AS nfd_indicator,
    TRIM("CODE") AS occupation_code,
    TRIM("ANZSCO TITLE") AS occupation,
    CAST("TREND DATA FOR AUG 2025 1" AS NUMBER(18,2)) * 1000 AS emp_2025,
    ROUND(TRY_TO_NUMBER(REGEXP_REPLACE("FEMALE SHARE 2024 4 QUARTER AVG 2", '[^0-9]', '')) / 100, 2) AS female_share_2024,
    ROUND(TRY_TO_NUMBER(REGEXP_REPLACE("PART TIME SHARE 2024 4 QUARTER AVG 2", '[^0-9]', '')) / 100, 2) AS part_time_share_2024,
    ROUND(TRY_TO_NUMBER(REGEXP_REPLACE("FEMALE PART TIME SHARE 2024 4 QUARTER AVG 2", '[^0-9]', '')) / 100, 2) AS female_part_time_share_2024,
    ROUND(TRY_TO_NUMBER(REGEXP_REPLACE("MALE PART TIME SHARE 2024 4 QUARTER AVG 2", '[^0-9]', '')) / 100, 2) AS male_part_time_share_2024,
    TRY_TO_NUMBER(REGEXP_REPLACE("MEDIAN AGE 2024 2", '[^0-9]', '')) AS median_age_2024,
    TRY_TO_NUMBER(REGEXP_REPLACE("MEDIAN FEMALE AGE 2024 2", '[^0-9]', '')) AS median_female_age_2024,
    TRY_TO_NUMBER(REGEXP_REPLACE("MEDIAN MALE AGE 2024 2", '[^0-9]', '')) AS median_male_age_2024
from raw_emp