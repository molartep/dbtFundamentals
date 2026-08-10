with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
), payments as (
    select * from {{ ref('stg_stripe__payments') }}
), order_payments as (
    select
        order_id as order_id,
        sum(payment_amount) as amount
    from
        payments
    where
        payment_status = 'success'
    group by 
        1
)
select
    orders.order_id,
    customer_id,
    amount,
    order_date
from
    orders 
        left join order_payments on order_payments.order_id = orders.order_id

