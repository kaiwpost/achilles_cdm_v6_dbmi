-- 1600	Number of procedure cost records with invalid procedure exposure id

{DEFAULT @analysisId = 1600}
{DEFAULT @costEventFieldConceptId = 1147810}

select 
  @analysisId as analysis_id,  
  cast(null as varchar(255)) as stratum_1, 
  cast(null as varchar(255)) as stratum_2, 
  cast(null as varchar(255)) as stratum_3, 
  cast(null as varchar(255)) as stratum_4, 
  cast(null as varchar(255)) as stratum_5,
	COUNT_BIG(co.cost_id) as count_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_@analysisId
from @cdmDatabaseSchema.cost co
left join @cdmDatabaseSchema.procedure_occurrence po
  on co.cost_event_id = po.procedure_occurrence_id
where po.procedure_occurrence_id is null
  and co.cost_event_field_concept_id = @costEventFieldConceptId
;
