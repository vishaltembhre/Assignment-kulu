{{ config(materialized='view', schema='staging') }}

with source as (
    select * from {{ source('raw_layer', 'users') }} where user_id is not null
)

select
    user_id,
    name,
    email,
    phone,
    try_cast(created_at as timestamp) as created_at
from source
