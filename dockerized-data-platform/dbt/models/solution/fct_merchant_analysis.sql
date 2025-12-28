{{ config(materialized='table', schema='solution') }}

with merchant_txns as (
    select
        t.amount,
        t.transaction_date,
        case 
        when o.status in ('kyc_done', 'completed') then 1
        when o.status = 'pending' then 2
        else 0
        end as kyc_status
    from {{ ref('fct_transactions') }} t
    join {{ ref('fct_onboarding') }} o on t.user_id = o.user_id
    where o.role = 'merchant'
),

intermediate_cte as
(select
    transaction_date,
    kyc_status,
    cast(round(case when kyc_status = 1 then sum(amount) end, 2) as varchar) as kyc_done_volume,
    cast(round(case when kyc_status = 2 then sum(amount) end, 2) as varchar) as kyc_pending_volume,
    cast(case when kyc_status = 1 then count(*) end as varchar) as kyc_done_transaction_count,
    cast(case when kyc_status = 2 then count(*) end as varchar) as kyc_pending_transaction_count,
    cast(round(case when kyc_status = 1 then avg(amount) end, 2) as varchar) as kyc_done_average_transaction_value,
    cast(round(case when kyc_status = 2 then avg(amount) end, 2) as varchar) as kyc_pending_average_transaction_value
from merchant_txns
group by transaction_date,kyc_status),

final_cte as(
select distinct
    a.transaction_date,
    coalesce(a.kyc_done_volume, b.kyc_done_volume) as kyc_done_volume,
    coalesce(a.kyc_pending_volume, b.kyc_pending_volume) as kyc_pending_volume,
    coalesce(a.kyc_done_transaction_count, b.kyc_done_transaction_count) as kyc_done_transaction_count,
    coalesce(a.kyc_pending_transaction_count, b.kyc_pending_transaction_count) as kyc_pending_transaction_count,
    coalesce(a.kyc_done_average_transaction_value, b.kyc_done_average_transaction_value) as kyc_done_average_transaction_value,
    coalesce(a.kyc_pending_average_transaction_value, b.kyc_pending_average_transaction_value) as kyc_pending_average_transaction_value
from intermediate_cte a
join intermediate_cte b
on a.transaction_date = b.transaction_date
order by a.transaction_date desc)

select distinct * from final_cte
where transaction_date is not null and kyc_done_volume is not null and 
kyc_pending_volume is not null and kyc_done_transaction_count is not null and 
kyc_pending_transaction_count is not null and 
kyc_done_average_transaction_value is not null and 
kyc_pending_average_transaction_value is not null
order by transaction_date desc