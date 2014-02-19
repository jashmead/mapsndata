sql=/tmp/t.sql
(
# for t in maps links controls users viewpoints layers points lists data_sets geographics 
for t in images
do
	echo "CREATE TRIGGER ${t}_trg_link_delete BEFORE DELETE ON $t FOR EACH ROW EXECUTE PROCEDURE link_delete();"
done
) > $sql
psql < $sql
