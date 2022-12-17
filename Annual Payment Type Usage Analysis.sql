-- Annual Payment Type Usage Analysis
with tabel1 as(
select
    pd.payment_type,
    count(payment_type) as total
from orders_dataset as od
inner join payments_dataset as pd
    on od.order_id = pd.order_id
group by pd.payment_type
order by total desc),
tabel2 as(
select
    payment_type,
    sum(case when years = 2016 then 1 else 0 end) as years_2016,
    sum(case when years = 2017 then 1 else 0 end) as years_2017,
    sum(case when years = 2018 then 1 else 0 end) as years_2018
from(
    select
        date_part('year',od.order_purchase_timestamp) as years,
        pd.payment_type
    from orders_dataset as od
    inner join payments_dataset as pd
        on od.order_id = pd.order_id) as sub7
group by payment_type
order by payment_type)

select
    t1.payment_type,
    years_2016,
    years_2017,
    years_2018,
    total
from tabel1 as t1
inner join tabel2 as t2
    on t1.payment_type = t2.payment_type
order by total desc;