update helps set title = name where title is null or title = '';
insert into members (person_id, talk_id, rsvp_status, member_type) values (154, 336, 'yes', 'admin');
select * from members;
alter table members rename to partners\^J;
alter table partners rename column member_type to partner_type;
select * from users;
select * from maps;
create role mapsndata createdb login password 'Dr@g0n13';
create database mapsndata with owner mapsndata\^J;
alter role mapsndata set replication to ON\^J;
alter role mapsndata with option REPLICATION;
alter role mapsndata with replication;
select inet_server_port();
select current_database();
select current_user;
select inet_server_addr();
select * from pg_stat_activity;
create extension hstore;
create extension postgis;
select now();
drop table base_table;
select * from points;
select * from maps;
insert into maps (name, title) values (map3, title3);
insert into maps (name, title) values ('map3', 'title3')\^J;
select * from maps;
select * from points;
insert into points (name, title) values ( 'point1', 'title1');
insert into points (name, title) values ( 'point2', 'title2');
insert into points (name, title) values ( 'point3', 'title3');
insert into links (from_table_id, to_table_id) \^Jselect max(maps.id), max(points.id) from maps, points;
insert into links (from_table_id, to_table_id) \^Jselect max(maps.id), max(points.id) from maps, points;
insert into links (from_table_id, to_table_id) \^Jselect min(maps.id), min(points.id) from maps, points;
select * from links;
select 'maps', (select id from maps order by random() limit 1);
select max(id) from maps;
delete from maps where id = 2829;
select from_table_id, count(*) from links group by 1 order by 2 desc;
select from_table_name, count(*) from links group by 1 order by 2 desc;
select * from links where from_table_name = 'maps'::name;
select * from links where from_table_name != 'maps'::character varying;
delete from links where from_table_name != 'maps'::character varying;
select to_table_name, count(*) from links group by 1 order by 2 desc;
