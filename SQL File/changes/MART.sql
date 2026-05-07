CREATE TABLE mart_sales (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2),
    sale_date TIMESTAMP DEFAULT NOW()
);
