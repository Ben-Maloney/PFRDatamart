
-- NOTE: The below is exported from Report Writer.
-- The intent is to reverse engineer the bridge tables and see how validation rule errors are mapped to any given report.
-- There is a one-to-many relationship between a given fact and the validation rule tables.
-- My guess is that as reports are done, entries are made in the bridge table whenver a data entry error is caught.
-- By mapping the offending rules with the report, we can display them on the watchroom report.

SET TRANSACTION ISOLATION LEVEL SNAPSHOT; 
SET DATEFIRST 7;

with [results] as (
  select top 100000 
    row_number() over(
      order by dispatched desc
    ) as 'row', *
  from (
    select
      [Dim_Incident_One_To_One].[Response_Incident_Number] as 'RP',
      [Dim_Incident].[Incident_Unit_Notified_By_Dispatch_Date_Time] as dispatched,
      [Dim_ValidationRules].[Incident_Validation_Rule_ID] as ValidationRuleID,
      [Dim_ValidationRules].[Incident_Validation_Rule_Notes] as ValidationRuleNotes, 
      [Fact_Incident].[Incident_Agency_Short_Name] as AgencyShortName, 
      [Fact_Incident].[Incident_Form_Number] as 'form number'

    from [Elite_DWPortland].[DwEms].[Fact_Incident] as [Fact_Incident]
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Incident] as [Dim_Incident] 
      on [Fact_Incident].[Dim_Incident_FK] = [Dim_Incident].[Dim_Incident_PK]
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] as [Dim_Incident_One_To_One] 
      on [Fact_Incident].[Dim_Incident_One_To_One_PK] = [Dim_Incident_One_To_One].[Dim_Incident_One_To_One_PK]
    LEFT JOIN [Elite_DWPortland].[DwEms].[Bridge_Incident_ValidationRules] as [Bridge_Incident_ValidationRules] 
      on [Fact_Incident].[Fact_Incident_PK] = [Bridge_Incident_ValidationRules].[Fact_Incident_PK]
    LEFT JOIN [Elite_DWPortland].[DwEms].[Dim_ValidationRules] as [Dim_ValidationRules] 
      on [Bridge_Incident_ValidationRules].[Dim_ValidationRules_PK] = [Dim_ValidationRules].[Dim_ValidationRules_PK]
    where ([Dim_Incident].[Incident_Type] = 'EMS' or [Fact_Incident].[Fact_Incident_PK] is null)
      and ([Dim_Incident].[Incident_Unit_Notified_By_Dispatch_Date_Time] > {ts '2024-09-01 00:00:00'})
      and [Dim_ValidationRules].[Incident_Validation_Rule_ID] is not NULL
  ) innerSelect 
  where 1=1
)
select *
from [results];



-- /* A3EEC45D-564B-40A5-A1EE-756A9D7F5391 */
-- SET TRANSACTION ISOLATION LEVEL SNAPSHOT; 
-- SET DATEFIRST 7;

-- with [results] as (
--   select top 100000 
--     row_number() over(
--       order by dispatched desc
--     ) as 'row', *
--   from (
--     select
--       [Dim_Incident_One_To_One].[Response_Incident_Number] as 'RP',
--       [Dim_Incident].[Incident_Unit_Notified_By_Dispatch_Date_Time] as dispatched,
--       [Dim_ValidationRules].[Incident_Validation_Rule_ID] as ValidationRuleID,
--       [Dim_ValidationRules].[Incident_Validation_Rule_Notes] as ValidationRuleNotes, 
--       [Fact_Incident].[Incident_Agency_Short_Name] as AgencyShortName, 
--       --[Fact_Incident].[Incident_Transaction_GUID_Internal] as [param__Fact_Incident___Incident_Transaction_GUID_Internal], 
--       [Fact_Incident].[Incident_Form_Number] as 'form number'

--     from [Elite_DWPortland].[DwEms].[Fact_Incident]
--     LEFT join [Elite_DWPortland].[DwEms].[Dim_Incident] as [Dim_Incident] 
--       on [Fact_Incident].[Dim_Incident_FK] = [Dim_Incident].[Dim_Incident_PK]
--     LEFT join [Elite_DWPortland].[DwEms].[Dim_Incident_One_To_One] as [Dim_Incident_One_To_One] 
--       on [Fact_Incident].[Dim_Incident_One_To_One_PK] = [Dim_Incident_One_To_One].[Dim_Incident_One_To_One_PK]
--     LEFT join [Elite_DWPortland].[DwEms].[Bridge_Incident_ValidationRules] as [Bridge_Incident_ValidationRules] 
--       on [Fact_Incident].[Fact_Incident_PK] = [Elite_DWPortland].[DwEms].[Bridge_Incident_ValidationRules].[Fact_Incident_PK]
--     LEFT join [Elite_DWPortland].[DwEms].[Dim_ValidationRules] as [Dim_ValidationRules] 
--       on [Bridge_Incident_ValidationRules].[Dim_ValidationRules_PK] = [Dim_ValidationRules].[Dim_ValidationRules_PK]
--     where ([Dim_Incident].[Incident_Type] = 'EMS' or [Fact_Incident].[Fact_Incident_PK] is null)
--       and ([Dim_Incident].[Incident_Unit_Notified_By_Dispatch_Date_Time] > {ts '2024-09-01 00:00:00'}
-- 	  and [Dim_ValidationRules].[Incident_Validation_Rule_ID] is not NULL)
--   ) innerSelect 
--   where 1=1
-- )
-- select *
-- from [results];
