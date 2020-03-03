
with cte_care_site
as
(
select cast('care_site' as varchar(50)) as tablename
from (
  SELECT top 1
  care_site_id,
  care_site_name,
  place_of_service_concept_id,
  location_id,
  care_site_source_value,
  place_of_service_source_value
  FROM
  @cdmDatabaseSchema.care_site
) CARE_SITE
),
cte_cdm_source
as
(
  select cast('cdm_source' as varchar(50)) as tablename
  from (
  select top 1
  cdm_source_name,
  cdm_source_abbreviation,
  cdm_holder
  source_description,
  source_documentation_reference,
  cdm_etl_reference,
  source_release_date,
  cdm_release_date,
  cdm_version,
  vocabulary_version
  from
  @cdmDatabaseSchema.cdm_source
) cdm_source
),
cte_cohort
as
(
  select cast('cohort' as varchar(50)) as tablename
  from (
  SELECT top 1
  cohort_definition_id,
  subject_id,
  cohort_start_date,
  cohort_end_date
  FROM
  @resultsDatabaseSchema.cohort
) cohort
),
cte_condition_era
as
(
select cast('condition_era' as varchar(50)) as tablename
from (
  SELECT top 1
  condition_era_id,
  person_id,
  condition_concept_id,
  condition_era_start_datetime,
  condition_era_end_datetime,
  condition_occurrence_count
  FROM
  @cdmDatabaseSchema.condition_era
) CONDITION_ERA
),
cte_condition_occurrence
as
(
select cast('condition_occurrence' as varchar(50)) as tablename
from (
  SELECT top 1
  condition_occurrence_id,
  person_id,
  condition_concept_id,
  condition_start_date,
  condition_start_datetime,
  condition_end_date,
  condition_end_datetime,
  condition_type_concept_id,
  condition_status_concept_id,
  stop_reason,
  provider_id,
  visit_occurrence_id,
  visit_detail_id,
  condition_source_value,
  condition_source_concept_id,
  condition_status_source_value
  FROM
  @cdmDatabaseSchema.condition_occurrence
) condition_occurrence
),
cte_cost
as
(
  select cast('cost' as varchar(50)) as tablename
  from (
    select top 1
      cost_id,
      person_id,
      cost_event_id,
      cost_event_field_concept_id,
      cost_concept_id,
      cost_type_concept_id,
      currency_concept_id,
      cost,
      incurred_date,
      billed_date,
      paid_date,
      revenue_code_concept_id,
      drg_concept_id,
      cost_source_value,
      cost_source_concept_id,
      revenue_code_source_value,
      drg_source_value,
      payer_plan_period_id
    FROM
    @cdmDatabaseSchema.cost
  ) cost
),
cte_device_exposure
as
(
select cast('device_exposure' as varchar(50)) as tablename
from (
  SELECT top 1
    device_exposure_id,
    person_id,
    device_concept_id,
    device_exposure_start_date,
    device_exposure_start_datetime,
    device_exposure_end_date,
    device_exposure_end_datetime,
    device_type_concept_id,
    unique_device_id,
    quantity,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    device_source_value,
    device_source_concept_id
  FROM
  @cdmDatabaseSchema.device_exposure
) device_exposure
),
cte_dose_era
as
(
select cast('dose_era' as varchar(50)) as tablename
from (
  SELECT top 1
  dose_era_id,
  person_id,
  drug_concept_id,
  unit_concept_id,
  dose_value,
  dose_era_start_datetime,
  dose_era_end_datetime
  FROM
  @cdmDatabaseSchema.dose_era
) dose_era
),
cte_drug_era
as
(
select cast('drug_era' as varchar(50)) as tablename
from (
  SELECT top 1
  drug_era_id,
  person_id,
  drug_concept_id,
  drug_era_start_datetime,
  drug_era_end_datetime,
  drug_exposure_count
  FROM
  @cdmDatabaseSchema.drug_era
) drug_era
),
cte_drug_exposure
as
(
select cast('drug_exposure' as varchar(50)) as tablename
from (
  SELECT top 1
    drug_exposure_id,
    person_id,
    drug_concept_id,
    drug_exposure_start_date,
    drug_exposure_start_datetime,
    drug_exposure_end_date,
    drug_exposure_end_datetime,
    verbatim_end_date,
    drug_type_concept_id,
    stop_reason,
    refills,
    quantity,
    days_supply,
    sig,
    route_concept_id,
    lot_number,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    drug_source_value,
    drug_source_concept_id,
    route_source_value,
    dose_unit_source_value
  FROM
  @cdmDatabaseSchema.drug_exposure
) drug_exposure
),
cte_fact_relationship
as
(
select cast('fact_relationship' as varchar(50)) as tablename
from (
  SELECT top 1
    domain_concept_id_1,
    fact_id_1,
    domain_concept_id_2,
    fact_id_2,
    relationship_concept_id
  FROM
  @cdmDatabaseSchema.fact_relationship
) fact_relationship
),
cte_location
as
(
select cast('location' as varchar(50)) as tablename
from (
  SELECT top 1
  location_id,
  address_1,
  address_2,
  city,
  state,
  zip,
  county,
  country,
  location_source_value,
  latitude,
  longitude
  FROM
  @cdmDatabaseSchema.location
) location
),
cte_location_history
as
(
  select cast('location_history' as varchar(50)) as tablename
  from (
    select top 1
      location_history_id,
      location_id,
      relationship_type_concept_id,
      domain_id,
      entity_id,
      start_date,
      end_date
    from
  @cdmDatabaseSchema.location_history
) location_history
),
cte_measurement
as
(
  select cast('measurement' as varchar(50)) as tablename
  from (
    select top 1
      measurement_id,
      person_id,
      measurement_concept_id,
      measurement_date,
      measurement_datetime,
      measurement_time,
      measurement_type_concept_id,
      operator_concept_id,
      value_as_number,
      value_as_concept_id,
      unit_concept_id,
      range_low,
      range_high,
      provider_id,
      visit_occurrence_id,
      visit_detail_id,
      measurement_source_value,
      measurement_source_concept_id,
      unit_source_value,
      value_source_value
    from
  @cdmDatabaseSchema.measurement
) measurement
),
cte_metadata
as
(
  select cast('metadata' as varchar(50)) as tablename
  from (
    select top 1
    metadata_concept_id,
    metadata_type_concept_id,
    name,
    value_as_string,
    value_as_concept_id,
    metadata_date,
    metadata_datetime
    FROM
    @cdmDatabaseSchema.metadata
  ) metadata
),
cte_note
as
(
  select cast('note' as varchar(50)) as tablename
  from (
    select top 1
      note_id,
      person_id,
      note_event_id,
      note_event_field_concept_id,
      note_date,
      note_datetime,
      note_type_concept_id,
      note_class_concept_id,
      note_title,
      note_text,
      encoding_concept_id,
      language_concept_id,
      provider_id,
      visit_occurrence_id,
      visit_detail_id,
      note_source_value
    FROM
    @cdmDatabaseSchema.note
  ) note
),
cte_note_nlp
as
(
  select cast('note_nlp' as varchar(50)) as tablename
  from (
    select top 1
      note_nlp_id,
      note_id,
      section_concept_id,
      snippet,
      "offset",
      lexical_variant,
      note_nlp_concept_id,
      nlp_system,
      nlp_date,
      nlp_datetime,
      term_exists,
      term_temporal,
      term_modifiers,
      note_nlp_source_concept_id
    FROM
    @cdmDatabaseSchema.note_nlp
  ) note_nlp
),
cte_observation
as
(
select cast('observation' as varchar(50)) as tablename
from (
  SELECT top 1
    observation_id,
    person_id,
    observation_concept_id,
    observation_date,
    observation_datetime,
    observation_type_concept_id,
    value_as_number,
    value_as_string,
    value_as_concept_id,
    qualifier_concept_id,
    unit_concept_id,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    observation_source_value,
    observation_source_concept_id,
    unit_source_value,
    qualifier_source_value,
    observation_event_id,
    obs_event_field_concept_id,
    value_as_datetime
  FROM
  @cdmDatabaseSchema.observation
) observation
),
cte_observation_period
as
(
select cast('observation_period' as varchar(50)) as tablename
from (
  SELECT top 1
  observation_period_id,
  person_id,
  observation_period_start_date,
  observation_period_end_date,
  period_type_concept_id
  FROM
  @cdmDatabaseSchema.observation_period
) observation_period
),
cte_payer_plan_period
as
(
select cast('payer_plan_period' as varchar(50)) as tablename
from (
  SELECT top 1
    payer_plan_period_id,
    person_id,
    contract_person_id,
    payer_plan_period_start_date,
    payer_plan_period_end_date,
    payer_concept_id,
    plan_concept_id,
    contract_concept_id,
    sponsor_concept_id,
    stop_reason_concept_id,
    payer_source_value,
    payer_source_concept_id,
    plan_source_value,
    plan_source_concept_id,
    contract_source_value,
    contract_source_concept_id,
    sponsor_source_value,
    sponsor_source_concept_id,
    family_source_value,
    stop_reason_source_value,
    stop_reason_source_concept_id
  FROM
  @cdmDatabaseSchema.payer_plan_period
) payer_plan_period
),
cte_person
as
(
select cast('person' as varchar(50)) as tablename
from (
  SELECT top 1
    person_id,
    gender_concept_id,
    year_of_birth,
    month_of_birth,
    day_of_birth,
    birth_datetime,
    death_datetime,
    race_concept_id,
    ethnicity_concept_id,
    location_id,
    provider_id,
    care_site_id,
    person_source_value,
    gender_source_value,
    gender_source_concept_id,
    race_source_value,
    race_source_concept_id,
    ethnicity_source_value,
    ethnicity_source_concept_id
  FROM
  @cdmDatabaseSchema.person
) person
),
cte_procedure_occurrence
as
(
select cast('procedure_occurrence' as varchar(50)) as tablename
from (
  SELECT top 1
    procedure_occurrence_id,
    person_id,
    procedure_concept_id,
    procedure_date,
    procedure_datetime,
    procedure_type_concept_id,
    modifier_concept_id,
    quantity,
    provider_id,
    visit_occurrence_id,
    visit_detail_id,
    procedure_source_value,
    procedure_source_concept_id,
    procedure_occurrence_id
  FROM
  @cdmDatabaseSchema.procedure_occurrence
) procedure_occurrence
),
cte_provider
as
(
select cast('provider' as varchar(50)) as tablename
from (
  SELECT top 1
    provider_id,
    provider_name,
    npi,
    dea,
    specialty_concept_id,
    care_site_id,
    year_of_birth,
    gender_concept_id,
    provider_source_value,
    specialty_source_value,
    specialty_source_concept_id,
    gender_source_value,
    gender_source_concept_id
  FROM
  @cdmDatabaseSchema.provider
) provider
),
cte_specimen
as
(
select cast('specimen' as varchar(50)) as tablename
from (
  SELECT top 1
    specimen_id,
    person_id,
    specimen_concept_id,
    specimen_type_concept_id,
    specimen_date,
    specimen_datetime,
    quantity,
    unit_concept_id,
    anatomic_site_concept_id,
    disease_status_concept_id,
    specimen_source_id,
    specimen_source_value,
    unit_source_value,
    anatomic_site_source_value,
    disease_status_source_value
  FROM
  @cdmDatabaseSchema.specimen
) specimen
),
cte_survey_conduct
as
(
select cast('survey_conduct' as varchar(50)) as tablename
from (
  SELECT top 1
    survey_conduct_id,
    person_id,
    survey_concept_id,
    survey_start_date,
    survey_start_datetime,
    survey_end_date,
    survey_end_datetime,
    provider_id,
    assisted_concept_id,
    respondent_type_concept_id,
    timing_concept_id,
    collection_method_concept_id,
    assisted_source_value,
    respondent_type_source_value,
    timing_source_value,
    collection_method_source_value,
    survey_source_value,
    survey_source_concept_id,
    survey_source_identifier,
    validated_survey_concept_id,
    validated_survey_source_value,
    survey_version_number,
    visit_occurrence_id,
    visit_detail_id,
    response_visit_occurrence_id
  FROM
  @cdmDatabaseSchema.survey_conduct
) survey_conduct
),
cte_visit_detail
as
(
select cast('visit_detail' as varchar(50)) as tablename
from (
  SELECT top 1
    visit_detail_id,
    person_id,
    visit_detail_concept_id,
    visit_detail_start_date,
    visit_detail_start_datetime,
    visit_detail_end_date,
    visit_detail_end_datetime,
    visit_detail_type_concept_id,
    provider_id,
    care_site_id,
    discharge_to_concept_id,
    admitted_from_concept_id,
    admitted_from_source_value,
    visit_detail_source_value,
    visit_detail_source_concept_id,
    discharge_to_source_value,
    preceding_visit_detail_id,
    visit_detail_parent_id,
    visit_occurrence_id
  FROM
  @cdmDatabaseSchema.visit_detail
) visit_detail
),
cte_visit_occurrence
as
(
select cast('visit_occurrence' as varchar(50)) as tablename
from (
  SELECT top 1
    visit_occurrence_id,
    person_id,
    visit_concept_id,
    visit_start_date,
    visit_start_datetime,
    visit_end_date,
    visit_end_datetime,
    visit_type_concept_id,
    provider_id,
    care_site_id,
    visit_source_value,
    visit_source_concept_id,
    admitted_from_concept_id,
    admitted_from_source_value,
    discharge_to_source_value,
    discharge_to_concept_id,
    preceding_visit_occurrence_id
  FROM
  @cdmDatabaseSchema.visit_occurrence
) visit_occurrence
),
cte_all
as
(
  select tablename from cte_care_site
  union all
  select tablename from cte_cdm_source
  union all
  select tablename from cte_condition_era
  union all
  select tablename from cte_condition_occurrence
  union all
  select tablename from cte_cost
  union all
  select tablename from cte_device_exposure
  union all
  select tablename from cte_dose_era
  union all
  select tablename from cte_drug_era
  union all
  select tablename from cte_drug_exposure
  union all
  select tablename from cte_fact_relationship
  union all
  select tablename from cte_location
  union all
  select tablename from cte_location_history
  union all
  select tablename from cte_measurement
  union all
  select tablename from cte_metadata
  union all
  select tablename from cte_note
  union all
  select tablename from cte_note_nlp
  union all
  select tablename from cte_observation
  union all
  select tablename from cte_observation_period
  union all
  select tablename from cte_payer_plan_period
  union all
  select tablename from cte_person
  union all
  select tablename from cte_procedure_occurrence
  union all
  select tablename from cte_provider
  union all
  select tablename from cte_specimen
  union all
  select tablename from cte_survey_conduct
  union all
  select tablename from cte_visit_detail
  union all
  select tablename from cte_visit_occurrence
  union all
  select tablename from cte_cohort
)
select tablename
from cte_all;
