sql=/tmp/link_check.sql
(
for t in `cat tables.lst`
do
	echo "select * from links where from_table_name = '$t' and from_table_id not in (select id from $t);"
	echo "select * from links where to_table_name = '$t' and to_table_id not in (select id from $t);"
done
) > $sql
psql < $sql

