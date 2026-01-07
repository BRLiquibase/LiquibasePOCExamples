--liquibase formatted sql

--changeset author:003 labels:v1.1 context:prod
--comment: Add email column to users table
ALTER TABLE users ADD COLUMN email VARCHAR(100);
--rollback ALTER TABLE users DROP COLUMN email;