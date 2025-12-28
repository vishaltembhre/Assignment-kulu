{{ config(materialized='table', schema='solution') }}

select
    transaction_date,
    count(*) as transaction_count,
    sum(amount) as total_amount,
    avg(amount) as average_amount,
    median(amount) as median_amount,
    min(amount) as min_amount,
    max(amount) as max_amount
from {{ ref('fct_transactions') }}
group by transaction_date
order by transaction_date desc
