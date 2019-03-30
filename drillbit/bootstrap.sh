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


sleep 60
curl -X POST -H "Content-Type: application/json" -d '{"name":"hive", "config": {"type": "hive","enabled": true,"configProps": {"hive.metastore.uris": "thrift://hive-metastore:9083","hive.metastore.sasl.enabled": "false","fs.default.name": "hdfs://namenode"}}}' http://172.22.0.8:8047/storage/hive.json