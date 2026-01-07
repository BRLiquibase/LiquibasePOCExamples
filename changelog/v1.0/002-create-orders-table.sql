--liquibase formatted sql

--changeset author:002 labels:v1.0 context:prod
--comment: Create orders table with foreign key to users
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
--rollback DROP TABLE orders;