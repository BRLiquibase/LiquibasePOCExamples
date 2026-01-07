--liquibase formatted sql

--changeset author:001 labels:v1.0 context:prod
--comment: Create users table for storing customer information
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--rollback DROP TABLE users;