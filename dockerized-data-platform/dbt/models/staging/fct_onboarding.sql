{{ config(materialized='view', schema='staging') }}

with source as (
    select * from {{ source('raw_layer', 'onboarding') }} where onboarding_id is not null
)

select
    onboarding_id,
    user_id,
    role,
    status,
    try_cast(onboarding_date as date) as onboarding_date
from source
