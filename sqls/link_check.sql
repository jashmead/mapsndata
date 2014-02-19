
select * from links where from_table_name = 'maps' and from_table_id not in (select id from maps);
select * from links where to_table_name = 'maps' and to_table_id not in (select id from maps);
