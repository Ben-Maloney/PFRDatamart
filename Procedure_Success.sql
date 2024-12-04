 
SELECT
    [Procedure_Crew_Member_Full_Name],
    --[Procedure_Crew_Member_ID],
    [Procedure_Performed_Description],
    COUNT(*) AS Procedure_Count,
    SUM(CASE WHEN [Procedure_Successful] = 'Yes' THEN 1 ELSE 0 END) AS Successful_Attempts,
    SUM(CASE WHEN [Procedure_Successful] = 'No' THEN 1 ELSE 0 END) AS Unsuccessful_Attempts,
    SUM(CASE WHEN [Procedure_Successful] IS NULL THEN 1 ELSE 0 END) AS Undetermined_Attempts,
    CASE 
        WHEN (SUM(CASE WHEN [Procedure_Successful] = 'Yes' THEN 1 ELSE 0 END) + SUM(CASE WHEN [Procedure_Successful] = 'No' THEN 1 ELSE 0 END)) > 0
        THEN CAST(ROUND(SUM(CASE WHEN [Procedure_Successful] = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
             (SUM(CASE WHEN [Procedure_Successful] = 'Yes' THEN 1 ELSE 0 END) + SUM(CASE WHEN [Procedure_Successful] = 'No' THEN 1 ELSE 0 END)), 2) AS VARCHAR) + '%'
        ELSE '0%'
    END AS Success_Rate
FROM
    [Elite_DWPortland].[DwEms].[Dim_Procedure]
WHERE
    [Procedure_Performed_Date_Time] >= '2024-01-01'
 AND [Procedure_Performed_Description] IS NOT NULL
 -- AND [Procedure_Performed_Description] LIKE 'Intubation%'
 --AND [Procedure_Performed_Description] LIKE 'IO%'
 AND [Procedure_Performed_Description] LIKE 'IV%'
GROUP BY
    [Procedure_Performed_Description],
 [Procedure_Crew_Member_Full_Name]
ORDER BY
    [Procedure_Performed_Description];

-- *Paramedic *AMR/Other Transport Agency
-- *Portland *Police
-- NULL
-- Test Paramedic
-- Test CHAT
 
 
