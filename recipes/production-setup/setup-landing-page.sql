-- Before running this script, make sure to replace "<replace-me>" with 
CREATE USER "summn-landing-page-user" WITH
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    LOGIN
    PASSWORD '<replace-me>';

CREATE DATABASE "summn-landing-page" WITH
    OWNER='summn-landing-page-user';
