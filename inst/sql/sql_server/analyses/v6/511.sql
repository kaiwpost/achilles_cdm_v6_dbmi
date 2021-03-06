-- 511	Distribution of time from death to last condition

--HINT DISTRIBUTE_ON_KEY(count_value)
select 511 as analysis_id,
	cast(null as varchar(255)) as stratum_1, 
	cast(null as varchar(255)) as stratum_2, 
	cast(null as varchar(255)) as stratum_3, 
	cast(null as varchar(255)) as stratum_4, 
	cast(null as varchar(255)) as stratum_5,
	count_big(count_value) as count_value,
	min(count_value) as min_value,
	max(count_value) as max_value,
	CAST(avg(1.0*count_value) AS FLOAT) as avg_value,
	CAST(stdev(count_value) AS FLOAT) as stdev_value,
	max(case when p1<=0.50 then count_value else -9999 end) as median_value,
	max(case when p1<=0.10 then count_value else -9999 end) as p10_value,
	max(case when p1<=0.25 then count_value else -9999 end) as p25_value,
	max(case when p1<=0.75 then count_value else -9999 end) as p75_value,
	max(case when p1<=0.90 then count_value else -9999 end) as p90_value
into @scratchDatabaseSchema@schemaDelim@tempAchillesPrefix_dist_511
from
(
  select datediff(dd, O.observation_datetime, t0.max_date) as count_value,
  	1.0*(row_number() over (order by datediff(dd, O.observation_datetime, t0.max_date)))/(COUNT_BIG(*) over () + 1) as p1
  from @cdmDatabaseSchema.observation O
  join @cdmDatabaseSchema.person P on O.person_id = P.person_id
  join
	(
		select person_id, max(condition_start_datetime) as max_date
		from @cdmDatabaseSchema.condition_occurrence
		group by person_id
	) t0 on O.person_id = t0.person_id
	where O.observation_concept_id = 4306655 -- death concept id
) t1
;