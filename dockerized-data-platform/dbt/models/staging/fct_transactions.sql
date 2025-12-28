{{ config(materialized='view', schema='staging') }}

with source as (
    select * from {{ source('raw_layer', 'transactions') }} where transaction_id is not null
)

select
    transaction_id,
    user_id,
    cast(amount as double) as amount,
    try_cast(transaction_date as date) as transaction_date
from source
