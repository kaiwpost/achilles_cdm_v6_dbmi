-- 1500	Number of drug cost records with invalid drug exposure id

{DEFAULT @analysisId = 1500}
{DEFAULT @costEventFieldConceptId = 1147707}

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
left join @cdmDatabaseSchema.drug_exposure de
	on co.cost_event_id = de.drug_exposure_id
where de.drug_exposure_id is null
  and co.cost_event_field_concept_id = @costEventFieldConceptId
;

