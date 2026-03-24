create database syagro;
create table companies (
    id serial primary key,
    name varchar(255) not null unique,
    legal_name varchar(255) not null,
    city varchar(100) not null,
    rfc varchar(15) not null,
    phone varchar(20) not null
    email varchar(255) not null,
    status boolean not null default true,
    suscription_plan varchar(50) not null,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now()
);