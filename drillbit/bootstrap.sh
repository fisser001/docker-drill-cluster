# generate frill-override.conf with new cluster name and zookeeper instances
echo "drill.exec: { cluster-id: \"$CLUSTER_ID\", zk.connect: \"$ZOOKEEPERS\" }" > $DRILL_ROOT/conf/drill-override.conf

# remove enabled features from the excludes list
IFS=','
for x in $ENABLE_EXCLUDES
do
	echo "removing $x from exlude list"
	sed -i "/${x}/d" $DRILL_ROOT/bin/hadoop-excludes.txt
done

# boot drill
$DRILL_ROOT/bin/drillbit.sh run