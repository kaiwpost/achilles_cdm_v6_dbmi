-- 525	Number of death records, by condition_source_concept_id

--HINT DISTRIBUTE_ON_KEY(stratum_1)
select 525 as analysis_id,
       cast(condition_source_concept_id AS varchar(255)) AS stratum_1,
       cast(null AS varchar(255)) AS stratum_2,
       cast(null as varchar(255)) as stratum_3,
       cast(null as varchar(255)) as stratum_4,
       cast(null as varchar(255)) as stratum_5,
       count_big(*) AS count_value
  into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_525 
  from @cdmDatabaseSchema.observation O
  join @cdmDatabaseSchema.person P on O.person_id = P.person_id
    and P.death_datetime = O.observation_datetime
  join @cdmDatabaseSchema.condition_occurrence C on P.death_datetime = C.condition_start_datetime
  where O.observation_concept_id = 4306655 -- death concept id
 group by C.condition_source_concept_id;
