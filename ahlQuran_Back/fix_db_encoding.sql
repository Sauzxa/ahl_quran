-- SQL script to verify and fix PostgreSQL database encoding for Arabic support
-- Run this if you're having issues with Arabic characters

-- 1. Check current database encoding
SELECT 
    datname as database,
    pg_encoding_to_char(encoding) as encoding,
    datcollate as collate,
    datctype as ctype
FROM pg_database 
WHERE datname = current_database();

-- 2. Check current session encoding
SHOW client_encoding;
SHOW server_encoding;

-- 3. Set client encoding to UTF8 for current session
SET client_encoding = 'UTF8';

-- 4. Test Arabic text
-- This should display Arabic correctly
SELECT 'أحمد محمد' as arabic_test;

-- 5. If you need to recreate the database with proper encoding:
-- WARNING: This will delete all data! Only use if absolutely necessary.
-- 
-- First, disconnect all users from the database:
-- SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'ahl_quran_db';
--
-- Then drop and recreate:
-- DROP DATABASE IF EXISTS ahl_quran_db;
-- CREATE DATABASE ahl_quran_db 
--     WITH ENCODING 'UTF8' 
--     LC_COLLATE='en_US.UTF-8' 
--     LC_CTYPE='en_US.UTF-8' 
--     TEMPLATE=template0;

-- 6. Verify string columns support UTF-8
-- All VARCHAR and TEXT columns automatically support UTF-8 when database encoding is UTF-8
SELECT 
    table_name,
    column_name,
    data_type,
    character_maximum_length
FROM information_schema.columns
WHERE table_schema = 'public' 
    AND data_type IN ('character varying', 'text', 'character')
ORDER BY table_name, ordinal_position;
