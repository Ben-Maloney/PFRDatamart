with [results] as (
select top 100000 row_number() over(
order by [Dim_Incident_One_To_One___Response_Incident_Number] asc
) as 'row', *
from (
select
[Dim_Incident_One_To_One].[Response_Incident_Number] as [Dim_Incident_One_To_One___Response_Incident_Number], [Dim_Incident].[Incident_Date_Time] as [Dim_Incident___Incident_Date_Time], [Fact_Incident].[Incident_Validity_Score] as [Fact_Incident___Incident_Validity_Score], [Dim_Response].[Response_EMS_Unit_Call_Sign] as [Dim_Response___Response_EMS_Unit_Call_Sign], [Dim_Disposition].[Disposition_Crew_Disposition] as [Dim_Disposition___Disposition_Crew_Disposition], [Dim_Disposition].[Disposition_Incident_Patient_Disposition] as [Dim_Disposition___Disposition_Incident_Patient_Disposition], [Dim_Disposition].[Disposition_Transport_Disposition] as [Dim_Disposition___Disposition_Transport_Disposition], [Dim_Narrative].[Narrative] as [Dim_Narrative___Narrative]
from [DwEms].[Fact_Incident]
LEFT join [DwEms].[Dim_Incident] as [Dim_Incident] on [Fact_Incident].[Dim_Incident_FK] = [Dim_Incident].[Dim_Incident_PK]
LEFT join [DwEms].[Dim_Response] as [Dim_Response] on [Fact_Incident].[Dim_Response_FK] = [Dim_Response].[Dim_Response_PK]
LEFT join [DwEms].[Dim_Disposition] as [Dim_Disposition] on [Fact_Incident].[Dim_Disposition_FK] = [Dim_Disposition].[Dim_Disposition_PK]
LEFT join [DwEms].[Dim_Permission_AllAgency] as [Dim_Permission_AllAgency] on [Fact_Incident].[Dim_Agency_FK] = [Dim_Permission_AllAgency].[Dim_Agency_PK] and Dim_Permission_AllAgency.Performer_ID_Internal = 'bdaec584-fe1b-43ae-bd07-7dc1f1cbc67e'
LEFT join [DwEms].[Dim_Permission_MyEMS] as [Dim_Permission_MyEMS] on [Fact_Incident].[Fact_Incident_PK] = [Dim_Permission_MyEMS].[Fact_Incident_PK] and Dim_Permission_MyEMS.Performer_ID_Internal = 'bdaec584-fe1b-43ae-bd07-7dc1f1cbc67e'
LEFT join [DwEms].[Dim_Narrative] as [Dim_Narrative] on [Fact_Incident].[Dim_Narrative_FK] = [Dim_Narrative].[Dim_Narrative_PK]
LEFT join [DwEms].[Dim_Incident_One_To_One] as [Dim_Incident_One_To_One] on [Fact_Incident].[Dim_Incident_One_To_One_PK] = [Dim_Incident_One_To_One].[Dim_Incident_One_To_One_PK]
LEFT join [DwEms].[Dim_Permission_EliteViewer_City] as [Dim_Permission_EliteViewer_City] on [Fact_Incident].[Incident_Elite_Viewer_City_GNIS] = [Dim_Permission_EliteViewer_City].[City_GNIS] and Dim_Permission_EliteViewer_City.Performer_ID_Internal = 'bdaec584-fe1b-43ae-bd07-7dc1f1cbc67e'
LEFT join [DwEms].[Dim_Permission_EliteViewer_Facility] as [Dim_Permission_EliteViewer_Facility] on [Fact_Incident].[Incident_Elite_Viewer_Facility_ID_Internal] = [Dim_Permission_EliteViewer_Facility].[Facility_ID_Internal] and Dim_Permission_EliteViewer_Facility.Performer_ID_Internal = 'bdaec584-fe1b-43ae-bd07-7dc1f1cbc67e'
LEFT join [DwEms].[Dim_Permission_EliteViewer_County] as [Dim_Permission_EliteViewer_County] on [Fact_Incident].[Incident_Elite_Viewer_State_County_GNIS] = [Dim_Permission_EliteViewer_County].[State_County_GNIS] and Dim_Permission_EliteViewer_County.Performer_ID_Internal = 'bdaec584-fe1b-43ae-bd07-7dc1f1cbc67e'
LEFT join [DwEms].[Dim_Permission_EliteViewer_AreasOfOperation] as [Dim_Permission_EliteViewer_AreasOfOperation] on [Fact_Incident].[AreaOfOperation_ID] = [Dim_Permission_EliteViewer_AreasOfOperation].[AreaOfOperation_ID] and Dim_Permission_EliteViewer_AreasOfOperation.Performer_ID_Internal = 'bdaec584-fe1b-43ae-bd07-7dc1f1cbc67e'
  where (Dim_Permission_AllAgency.Performer_ID_Internal is not null or Dim_Permission_MyEMS.Performer_ID_Internal is not null or Dim_Permission_EliteViewer_City.Performer_ID_Internal is not null or Dim_Permission_EliteViewer_County.Performer_ID_Internal is not null or Dim_Permission_EliteViewer_Facility.Performer_ID_Internal is not null or Dim_Permission_EliteViewer_AreasOfOperation.Performer_ID_Internal is not null or Fact_Incident.Incident_Transaction_GUID_Internal is null ) and (Dim_Incident.Incident_Type = 'EMS' or [Fact_Incident].[Fact_Incident_PK] is null)
and (
[Dim_Response].[Response_EMS_Unit_Call_Sign] like '%CHAT%')
) innerSelect where 1=1   )
select *
from [results]