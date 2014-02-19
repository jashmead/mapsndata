sql=/tmp/faker1.sql
rm -f $sql
for t in `cat tables.lst`
do
	for i in QQ
	do
		name="${t}$i"
		title="${t}$i"
		case $t in
			maps)
				echo "insert into $t (name, title) values ('$name', '$title');" >> $sql
				;;
			users)
				email="$name@mapsndata.com"
				echo "insert into $t (name, title, email) values ('$name', '$title', '$email');" >> $sql
				;;
			links)
				;;
			*) echo "insert into $t (name, title) values ('$name', '$title');" >> $sql
				;;
		esac
		echo "insert into links (from_table_name, from_table_id, to_table_name, to_table_id)" >> $sql
		echo "select 'maps', (select id from maps order by random() limit 1), " >> $sql
		echo "'$t', (select id from $t order by random() limit 1);" >> $sql
	done
done
psql < $sql
