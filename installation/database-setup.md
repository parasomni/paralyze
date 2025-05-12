# database setup 
## log into database 
    
    mariadb -u root -p

## create database 
    
    CREATE DATABASE botNetwork;
    USE botNetwork;

## create table

    CREATE TABLE bots (
        uuid CHAR(36) PRIMARY KEY, 
        ip_address varchar(255), 
        port int unsigned, 
        location VARCHAR(255),
        status varchar(255), 
        last_seen varchar(255), 
        bot_type VARCHAR(255),
        token VARCHAR(255),
        OS VARCHAR(255)
    );