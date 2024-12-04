
-- SELECT 
--     'NFIRS' AS report,
--     fq.created_on,
--     fq.agency,
--     fq.score,
--     fq.status,
--     fq.unique_record_id,
--     fq.alarm_time as time,
--     fq.RP,
--     dar.Apparatus_Resource_Vehicle_Call_Sign AS unit

-- FROM (

--     SELECT 
--         Fact_Fire.CreatedOn AS created_on,
--         Fact_Fire.Agency_Shortname as agency,
--         Fact_Fire.Basic_Incident_Validity_Score AS score,
--         CASE 
--             WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
--             WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
--             WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
--             ELSE Dim_Basic.Basic_Incident_Status 
--         END AS status,
--         'Exposure ' + CONVERT(VARCHAR(255), Dim_Basic.Basic_Exposure) AS unique_record_id,
--         Dim_Basic.Basic_Incident_Alarm_Time AS alarm_time,
--         Dim_Basic.Basic_Incident_Number as RP

--     FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
--     INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] 
--         ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
-- ) fq -- Alias for the subquery

-- INNER JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ApparatusResources] bfar ON fq.created_on = bfar.CreatedOn 
-- INNER JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] dar ON bfar.Dim_ApparatusResources_PK = dar.Dim_ApparatusResources_PK

-- ;

-- -- WHERE Fact_Fire.CreatedOn >= '2024-08-19'
-- -- AND Fact_Fire.Agency_shortname = 'portlandfi';


SELECT

    dar.ModifiedOn as 'modified on',
    dar.Apparatus_Resource_Vehicle_Call_Sign as 'apparatus',
    dar.Apparatus_Resource_Primary_Action_Taken as 'primary action taken',
    dar.Apparatus_Resource_Narrative as 'app narrative',
    dar.Apparatus_Resource_Actions_Taken_List as 'other actions taken list',

    -- TIMES
    dar.Apparatus_Resource_Dispatch_Date_Time as 'dispatch',
    dar.Appratus_Resource_Enroute_Date_Time as 'enroute',
    dar.Apparatus_Resource_Staging_Date_Time as 'staging',
    dar.Apparatus_Resource_Arrival_Date_Time as 'on scene',
    dar.Apparatus_Resource_Leave_Scene_Date_Time as 'leave scene',
    dar.Apparatus_Resource_Arrival_At_Hospital_Time as 'transport complete',
    dar.Apparatus_Resource_Clear_Date_Time as 'clear',
    dar.Apparatus_Resource_In_Quarters_Date_Time as 'in quarters',

    -- crew name list
    dar.Apparatus_Personnel_Name_List as 'crew names',


    dar.Apparatus_Resource_Use as 'app use',
    dar.Apparatus_Resource_Vehicle_Category_Type as 'vehicle category',
    dar.Apparatus_Resource_Vehicle_Mutual_Response_Type as 'mutual response type',



    -- FACT TABLE AND DIM TABLES
    'Responder Tab' AS report,
    Fact_Fire.CreatedOn AS created_on,
    Fact_Fire.Agency_Shortname as agency,

    -- status
    Fact_Fire.Basic_Incident_Validity_Score AS score,
    CASE 
        -- This means finished, there's no 'Exported To State' status after a successfull schematron validation
        --- ... but there is an odd edge case where it still happens
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Documentation Finished' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Exported To State' THEN 'Finished'
        WHEN Dim_Basic.Basic_Incident_Status = 'Crew Edits Complete' THEN 'Finished'
        ELSE Dim_Basic.Basic_Incident_Status 
    END AS status,

    -- Unique Record
    'Exposure ' + CONVERT(VARCHAR(255), Dim_Basic.Basic_Exposure) AS unique_record_id,

    -- incident details
    Dim_Basic.Basic_Incident_Alarm_Time AS alarm_time,
    Dim_Basic.Basic_Incident_Number as RP,
    Dim_Fire.Fire_Initial_CAD_Incident_Type_Description as 'EMD - desc',
    Dim_Basic.Basic_Apparatus_Call_Sign_List as 'Responding Units',
    Dim_Basic.Basic_Shift_Or_Platoon as shift,
    CASE
        WHEN COALESCE(Dim_Basic.Basic_Primary_Station_Name, '') = '' THEN '?'
        ELSE Dim_Basic.Basic_Primary_Station_Name
    END as FMA,
    Dim_Basic.Basic_Incident_Full_Address as address,

    -- crew member / author
    Dim_Basic.Basic_Authorization_Member_Making_Report_Name as 'author',

    -- disposition
    Dim_Basic.Basic_Primary_Action_Taken as 'disposition',

    -- URL
    Fact_Fire.Basic_Incident_Form_Number AS form_number,
    Fact_Fire.Incident_ID_Internal AS url_incident,
    'https://portland.imagetrendelite.com/Elite/Organizationportland/Agencyportlandfi/FireRunForm#/Incident' 
    + CONVERT(VARCHAR(255), Fact_Fire.Incident_ID_Internal) 
    + '/Form' 
    + CONVERT(VARCHAR(255), Fact_Fire.Basic_Incident_Form_Number) AS link


FROM [Elite_DWPortland].[DwFire].[Fact_Fire]
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Basic] ON Fact_Fire.Dim_Basic_FK = Dim_Basic.Dim_Basic_PK
INNER JOIN [Elite_DWPortland].[DwFire].[Dim_Fire] ON Fact_Fire.Dim_Fire_FK = Dim_Fire.Dim_Fire_PK
JOIN [Elite_DWPortland].[DwFire].[Bridge_Fire_ApparatusResources] bfar ON Fact_Fire.Fact_Fire_PK = bfar.Fact_Fire_PK
JOIN [Elite_DWPortland].[DwFire].[Dim_ApparatusResources] dar ON bfar.Dim_ApparatusResources_PK = dar.Dim_ApparatusResources_PK

WHERE Fact_Fire.CreatedOn >= '2024-08-19'
AND Fact_Fire.Agency_shortname = 'portlandfi'
--AND Fact_Fire.Agency_shortname = 'demoagency'
AND dar.Apparatus_Resource_Actions_Taken_List LIKE '%trauma%'

--- IGNORE THESE UNIT RESPONCES
AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'M%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'PSR%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign not LIKE 'LZ%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE '[B][0-9]%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHAT%'
AND dar.Apparatus_Resource_Vehicle_Call_Sign NOT LIKE 'CHS%'
