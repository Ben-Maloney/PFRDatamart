--- See all possible Incident_Status
-- SELECT DISTINCT 
--     i.[Incident_Status]
-- FROM 
--     [Elite_DWPortland].[DwEms].[Dim_Incident] i
-- ORDER BY 
--     i.[Incident_Status];

/*
Auto Posted
CQI Reviewed
Crew Documentation Finished
Crew Edits Complete
Exported To State
Flag For CQI Followup
Imported
In Progress
Needs Crew Attention
Not Visible (Confidential)
*/

SELECT
    SUBSTRING(i.[Incident_Crew_Member_Name_Completing_This_Report], 
        1, 
        CHARINDEX(' ', i.[Incident_Crew_Member_Name_Completing_This_Report] + ' ') - 1) AS fname,
    SUBSTRING(i.[Incident_Crew_Member_Name_Completing_This_Report],
        CHARINDEX(' ', i.[Incident_Crew_Member_Name_Completing_This_Report] + ' ') + 1,
        LEN(i.[Incident_Crew_Member_Name_Completing_This_Report])) AS lname,
    COUNT(*) AS 'Total Charts',
    COUNT(CASE WHEN i.[Incident_Status] = 'Auto Posted' THEN 1 END) AS 'Auto Posted',
    COUNT(CASE WHEN i.[Incident_Status] = 'CQI Reviewed' THEN 1 END) AS 'CQI Reviewed',
    COUNT(CASE WHEN i.[Incident_Status] = 'Crew Documentation Finished' THEN 1 END) AS 'Crew Documentation Finished',
    COUNT(CASE WHEN i.[Incident_Status] = 'Crew Edits Complete' THEN 1 END) AS 'Crew Edits Complete',
    COUNT(CASE WHEN i.[Incident_Status] = 'Exported To State' THEN 1 END) AS 'Exported To State',
    COUNT(CASE WHEN i.[Incident_Status] = 'Flag For CQI Followup' THEN 1 END) AS 'Flag For CQI Followup',
    COUNT(CASE WHEN i.[Incident_Status] = 'Imported' THEN 1 END) AS 'Imported',
    COUNT(CASE WHEN i.[Incident_Status] = 'In Progress' THEN 1 END) AS 'In Progress',
    COUNT(CASE WHEN i.[Incident_Status] = 'Needs Crew Attention' THEN 1 END) AS 'Needs Crew Attention',
    COUNT(CASE WHEN i.[Incident_Status] = 'Not Visible (Confidential)' THEN 1 END) AS 'Not Visible (Confidential)'
FROM
    [Elite_DWPortland].[DwEms].[Dim_Incident] i
WHERE
    i.[CreatedOn] >= '2024-01-01'
 AND i.[Incident_Crew_Member_Name_Completing_This_Report] NOT LIKE '*Paramedic%'
    AND i.[Agency_ID_Internal] = '6DC7BA46-6723-EB11-A95E-001DD8B72424' -- 'portlandfi' agency (filter out demo agency, etc... but don't bother about a join cuz we don't need it)
GROUP BY 
    i.[Incident_Crew_Member_Name_Completing_This_Report]
ORDER BY
    lname, fname;