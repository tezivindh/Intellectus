-- Create test database for isolated testing
-- This runs automatically when PostgreSQL container starts

SELECT 'CREATE DATABASE Intellectus_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'Intellectus_test')\gexec

GRANT ALL PRIVILEGES ON DATABASE Intellectus_test TO Intellectus;
