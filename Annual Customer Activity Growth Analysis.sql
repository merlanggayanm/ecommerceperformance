-- Annual Customer Activity Growth Analysis
with mau_annual as(
select
    years,
    round(avg(mau),3) as avg_mau
from(
    select
        date_part('year',od.order_purchase_timestamp) as years,
        date_part('month',od.order_purchase_timestamp) as months,
        count(distinct cd.customer_unique_id) as mau
    from customers_dataset as cd
    inner join orders_dataset as od
        on cd.customer_id = od.customer_id
    group by years,months) as sub1
group by years
order by years),
new_customers as(
select
    years,
    sum(mau) as total_customer
from(
    select
        date_part('year',od.order_purchase_timestamp) as years,
        date_part('month',od.order_purchase_timestamp) as months,
        count(distinct cd.customer_unique_id) as mau
    from customers_dataset as cd
    inner join orders_dataset as od
        on cd.customer_id = od.customer_id
    group by years,months) as sub2
group by years),
cust_repeat_order as(
select
    years,
    count(customer_unique_id) as repeat_order
from(
    select
        date_part('year',od.order_purchase_timestamp) as years,
        cd.customer_unique_id,
        count(cd.customer_unique_id) as total
    from customers_dataset as cd
    inner join orders_dataset as od
        on cd.customer_id = od.customer_id
    group by years,cd.customer_unique_id
    having count(cd.customer_unique_id) > 1) as sub3
group by years),
avg_frekuensi_order_annual as(
select
    years,
    round(avg(total),3) as avg_frekuensi_order
from(
    select
        date_part('year',od.order_purchase_timestamp) as years,
        cd.customer_unique_id,
        count(cd.customer_unique_id) as total
    from customers_dataset as cd
    inner join orders_dataset as od
        on cd.customer_id = od.customer_id
    group by years,cd.customer_unique_id) as sub4
group by years)

select
    ma.years,
    ma.avg_mau,
    nc.total_customer,
    rpo.repeat_order,
    afoa.avg_frekuensi_order
from mau_annual as ma
inner join new_customers as nc
    on ma.years = nc.years
inner join cust_repeat_order as rpo
    on nc.years = rpo.years
inner join avg_frekuensi_order_annual as afoa
    on rpo.years = afoa.years;