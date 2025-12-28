{{ config(materialized='table', schema='solution') }}

with daily_counts as (
    select
        onboarding_date as kyc_date,
        count(*) as completion_count
    from {{ ref('fct_onboarding') }}
    where status in ('kyc_done', 'completed')
    group by 1
),

with_lag as (
    select
        kyc_date,
        completion_count,
        lag(completion_count, 7) over (order by kyc_date) as prev_week_count
    from daily_counts
)

select
    kyc_date,
    completion_count,
    prev_week_count,
    cast(coalesce(
        case 
            when prev_week_count is null or prev_week_count = 0 then null
            else round(((completion_count - prev_week_count) / prev_week_count::double) * 100, 2)
        end,
        null
    ) as varchar) as wow_growth_percentage
from with_lag
order by kyc_date desc