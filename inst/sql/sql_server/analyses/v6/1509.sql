-- Distribution of ingredient cost, by drug_concept_id
{DEFAULT @analysisId = 1509}
{DEFAULT @costConceptId = 32005}
{DEFAULT @costEventFieldConceptId = 1147707}

-- raw data

--HINT DISTRIBUTE_ON_KEY(subject_id)
select 
  de.drug_concept_id as subject_id,
  co.cost as count_value
INTO #rawData_@analysisId
from @cdmDatabaseSchema.cost co
join @cdmDatabaseSchema.drug_exposure de 
  on co.cost_event_id = de.drug_exposure_id
where co.cost is not null
  and co.cost_concept_id = @costConceptId
  and de.drug_concept_id <> 0
  and co.cost_event_field_concept_id = @costEventFieldConceptId
;

-- overallStats

--HINT DISTRIBUTE_ON_KEY(stratum1_id)
select 
  subject_id as stratum1_id, 
  CAST(avg(1.0 * count_value) AS FLOAT) as avg_value,
  CAST(stdev(count_value) AS FLOAT) as stdev_value,
  min(count_value) as min_value,
  max(count_value) as max_value,
  count_big(*) as total
into #overallStats_@analysisId
from #rawData_@analysisId
group by subject_id
;

-- statsView

--HINT DISTRIBUTE_ON_KEY(stratum1_id)
select
  subject_id as stratum1_id, 
	count_value, 
  count_big(*) as total, 
	row_number() over (partition by subject_id order by count_value) as rn
into #statsView_@analysisId
from #rawData_@analysisId
group by subject_id, count_value
;

-- priorStats

--HINT DISTRIBUTE_ON_KEY(stratum1_id)
select 
  s.stratum1_id, 
  s.count_value, 
  s.total, 
  sum(p.total) as accumulated
into #priorStats_@analysisId
from #statsView_@analysisId s 
join #statsView_@analysisId p
  on s.stratum1_id = p.stratum1_id and p.rn <= s.rn
group by s.stratum1_id, s.count_value, s.total, s.rn
;

--HINT DISTRIBUTE_ON_KEY(stratum_1)
select 
  @analysisId as analysis_id,
	CAST(p.stratum1_id AS VARCHAR(255)) as stratum_1,
	cast(null as varchar(255)) as stratum_2,
	cast(null as varchar(255)) as stratum_3,
	cast(null as varchar(255)) as stratum_4,
	cast(null as varchar(255)) as stratum_5,
	o.total as count_value,
	o.min_value,
	o.max_value,
	o.avg_value,
	o.stdev_value,
	MIN(case when p.accumulated >= .50 * o.total then count_value else o.max_value end) as median_value,
	MIN(case when p.accumulated >= .10 * o.total then count_value else o.max_value end) as p10_value,
	MIN(case when p.accumulated >= .25 * o.total then count_value else o.max_value end) as p25_value,
	MIN(case when p.accumulated >= .75 * o.total then count_value else o.max_value end) as p75_value,
	MIN(case when p.accumulated >= .90 * o.total then count_value else o.max_value end) as p90_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_dist_@analysisId
from #priorStats_@analysisId p 
join #overallStats_@analysisId o on p.stratum1_id = o.stratum1_id
group by p.stratum1_id, o.total, o.min_value, o.max_value, o.avg_value, o.stdev_value
;

truncate table #rawData_@analysisId;
drop table #rawData_@analysisId;

truncate table #overallStats_@analysisId;
drop table #overallStats_@analysisId;

truncate table #statsView_@analysisId;
drop table #statsView_@analysisId;

truncate table #priorStats_@analysisId;
drop table #priorStats_@analysisId;
