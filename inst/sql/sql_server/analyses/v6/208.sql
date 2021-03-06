--208	Number of visit records outside valid observation period


select 208 as analysis_id,  
	cast(null as varchar(255)) as stratum_1, cast(null as varchar(255)) as stratum_2, cast(null as varchar(255)) as stratum_3, cast(null as varchar(255)) as stratum_4, cast(null as varchar(255)) as stratum_5,
	COUNT_BIG(vo1.PERSON_ID) as count_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_208
from
	@cdmDatabaseSchema.visit_occurrence vo1
	left join @cdmDatabaseSchema.observation_period op1
	on op1.person_id = vo1.person_id
	and vo1.visit_start_datetime >= op1.observation_period_start_date
	and vo1.visit_start_datetime <= op1.observation_period_end_date
where op1.person_id is null
;
