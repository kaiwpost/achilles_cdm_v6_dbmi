-- 1610	Number of records by revenue_code_concept_id

{DEFAULT @analysisId = 1610}
{DEFAULT @costEventFieldConceptId = 1147810}

--HINT DISTRIBUTE_ON_KEY(stratum_1)
select 
  @analysisId as analysis_id, 
	CAST(co.revenue_code_concept_id AS VARCHAR(255)) as stratum_1,
	cast(null as varchar(255)) as stratum_2, 
	cast(null as varchar(255)) as stratum_3, 
	cast(null as varchar(255)) as stratum_4, 
	cast(null as varchar(255)) as stratum_5,
	COUNT_BIG(co.cost_id) as count_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_@analysisId
from @cdmDatabaseSchema.cost co
join @cdmDatabaseSchema.procedure_occurrence po 
  on co.cost_event_id = po.procedure_occurrence_id
where co.revenue_code_concept_id is not null
  and co.cost_event_field_concept_id = @costEventFieldConceptId
group by co.revenue_code_concept_id
;
