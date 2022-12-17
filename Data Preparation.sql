-- Create Table
create table geolocation_dataset(
    geolocation_zip_code_prefix int,
    geolocation_lat numeric,
    geolocation_lng numeric,
    geolocation_city varchar,
    geolocation_state varchar(2)
);
create table customers_dataset(
    customer_id varchar,
    customer_unique_id varchar,
    customer_zip_code_prefix int,
    customer_city varchar,
    customer_state varchar(2)
);
create table sellers_dataset(
    seller_id varchar,
    seller_zip_code_prefix int,
    seller_city varchar,
    seller_state varchar(2)
);
create table products_dataset(
    product_id varchar,
    product_category_name varchar,
    product_name_lenght int,
    product_description_lenght int,
    product_photos_qty int,
    product_weight_g int,
    product_lenght_cm int,
    product_height_cm int,
    product_width_cm int
);
create table orders_dataset(
    order_id varchar,
    customer_id varchar,
    order_status varchar,
    order_purchase_timestamp timestamp,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);
create table order_items_dataset(
    order_id varchar,
    order_item_id int,
    product_id varchar,
    seller_id varchar,
    shipping_limit_date timestamp,
    price numeric,
    freight_value numeric
);
create table payments_dataset(
    order_id varchar,
    payment_sequential int,
    payment_type varchar,
    payment_installments varchar,
    payment_value numeric
);
create table reviews_dataset(
    review_id varchar,
    order_id varchar,
    review_score int,
    review_comment_title varchar,
    review_comment_message varchar,
    review_creation_date timestamp,
    review_answer_timestamp timestamp
);

-- Primary Key
ALTER TABLE customers_dataset ADD CONSTRAINT customers_pkey ADD PRIMARY KEY(customer_id);
ALTER TABLE orders_dataset ADD CONSTRAINT orders_pkey ADD PRIMARY KEY(order_id);
ALTER TABLE products_dataset ADD CONSTRAINT product_pkey ADD PRIMARY KEY(product_id);
ALTER TABLE sellers_dataset ADD CONSTRAINT sellers_pkey ADD PRIMARY KEY(seller_id);

-- Foreign Key
ALTER TABLE order_items_dataset ADD FOREIGN KEY(order_id) REFERENCES orders_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY(product_id) REFERENCES products_dataset;
ALTER TABLE order_items_dataset	ADD FOREIGN KEY(seller_id) REFERENCES sellers_dataset;
ALTER TABLE payments_dataset ADD FOREIGN KEY(order_id) REFERENCES orders_dataset;
ALTER TABLE reviews_dataset ADD FOREIGN KEY(order_id) REFERENCES orders_dataset;
ALTER TABLE orders_dataset ADD FOREIGN KEY(customer_id) REFERENCES customers_dataset;