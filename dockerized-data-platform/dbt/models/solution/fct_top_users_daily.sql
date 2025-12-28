{{ config(materialized='table', schema='solution') }}

with daily_user_txns as (
    select
        transaction_date,
        user_id,
        sum(amount) as daily_amount
    from {{ ref('fct_transactions') }}
    group by 1, 2
),

daily_totals as (
    select
        transaction_date,
        sum(amount) as total_market_amount
    from {{ ref('fct_transactions') }}
    group by 1
),

ranked as (
    select
        d.transaction_date,
        d.user_id,
        d.daily_amount,
        t.total_market_amount,
        dense_rank() over (partition by d.transaction_date order by d.daily_amount desc) as rnk
    from daily_user_txns d
    join daily_totals t on d.transaction_date = t.transaction_date
),

top_5_users as (
select
    transaction_date,
    user_id,
    daily_amount,
    round((daily_amount / total_market_amount) * 100, 2) as contribution_percentage
from ranked
where rnk <= 5
),

top_5_users_total as (
    select
        transaction_date,
        sum(daily_amount) as top_5_total_amount
    from top_5_users
    group by 1
)

select
    t.transaction_date,
    t.user_id,
    t.daily_amount,
    t.contribution_percentage,
    round((t.daily_amount / tt.top_5_total_amount) * 100, 2) as contribution_percentage_within_top_5
from top_5_users t
join top_5_users_total tt on t.transaction_date = tt.transaction_date
order by t.transaction_date desc, t.user_id desc