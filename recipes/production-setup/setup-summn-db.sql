-- Before running this script, make sure to replace "<replace-me>" with 
CREATE USER "summn-rw-user" WITH
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    LOGIN
    PASSWORD '<replace-me>';

CREATE DATABASE "summn" WITH
    OWNER='summn-rw-user';
