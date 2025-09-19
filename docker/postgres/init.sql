-- Initialize PostgreSQL database for Dygus
-- This script runs when the PostgreSQL container starts for the first time

-- Create extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Set timezone
SET timezone = 'UTC';

-- Create additional databases if needed
-- CREATE DATABASE dygus_test;

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE dygus_db TO dygus_user;
GRANT ALL PRIVILEGES ON SCHEMA public TO dygus_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO dygus_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO dygus_user;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO dygus_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO dygus_user;
