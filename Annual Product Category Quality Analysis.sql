-- Annual Product Category Quality Analysis
with annual_revenue as(
select
    date_part('year',od.order_purchase_timestamp) as years,
    sum(oid.price + oid.freight_value) as total_revenue_annual
from orders_dataset as od
inner join order_items_dataset as oid
    on od.order_id = oid.order_id
where order_status = 'delivered'
group by years
order by years),
annual_cancel as(
select
    date_part('year',od.order_purchase_timestamp) as years,
    count(order_status) as cancel_order_annual
from orders_dataset as od
where order_status = 'canceled'
group by years),
annual_product as(
select
    years,
    product_category_name,
    revenue_product_annual
from(    
    select
        date_part('year',od.order_purchase_timestamp) as years,
        pd.product_category_name,
        sum(oid.price + oid.freight_value) as revenue_product_annual,
        rank() over(partition by date_part('year',od.order_purchase_timestamp) order by sum(oid.price + oid.freight_value) desc) as rank
    from orders_dataset as od
    inner join order_items_dataset as oid
        on od.order_id = oid.order_id
    inner join products_dataset as pd
        on oid.product_id = pd.product_id
    group by years,pd.product_category_name) as sub5
where rank = 1),
annual_cancel_product as(
select
    years,
    product_category_name,
    most_cancel_order_product
from(    
    select
        date_part('year',od.order_purchase_timestamp) as years,
        pd.product_category_name,
        count(order_status) as most_cancel_order_product,
        rank() over(partition by date_part('year',od.order_purchase_timestamp) order by count(order_status) desc) as rank
    from orders_dataset as od
    inner join order_items_dataset as oid
        on od.order_id = oid.order_id
    inner join products_dataset as pd
        on oid.product_id = pd.product_id
    where order_status = 'canceled'
    group by years,pd.product_category_name) as sub6
where rank = 1)

select
    ar.years,
    ar.total_revenue_annual,
    ac.cancel_order_annual,
    ap.product_category_name,
    ap.revenue_product_annual,
    acp.product_category_name,
    acp.most_cancel_order_product
from annual_revenue as ar
inner join annual_cancel as ac
    on ar.years = ac.years
inner join annual_product as ap
    on ac.years = ap.years
inner join annual_cancel_product as acp
    on ap.years = acp.years;