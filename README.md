HADOOP WASB Parcel
==================

This repository provides a parcel(https://github.com/cloudera/cm_ext) to install the required jars for Azure's Blob ( `wasb` ) bindings for Hadoop, to be used with Cloudera Manager.

# Install Steps
0. Install Prerequisites: `cloudera/cm_ext`
```sh
cd /tmp
git clone https://github.com/cloudera/cm_ext
cd cm_ext/validator
mvn install
```

1. Create parcel:
```sh
cd /tmp
git clone http://github.com/prateek/wasb-parcel
cd wasb-parcel
POINT_VERSION=5 VALIDATOR_DIR=/tmp/cm_ext ./build-parcel.sh
cd build
python -m SimpleHTTPServer 14641
```

2. The commands above create a local directory and webserver to serve this parcel as a repository. Follow these [detailed instructions](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM5/latest/Cloudera-Manager-Installation-Guide/cm5ig_create_local_parcel_repo.html) to add the repository to Cloudera Manager.

3. Install, Activate & Distribute the HADOOP_WASB parcel.

4. Add the following to the `core-site.xml` safety-valve for the HDFS service:
```xml
<property>
  <name>fs.azure.account.key.[STORAGE_ACCOUNT].blob.core.windows.net</name>
  <value>[SECRET_KEY]</value>
</property>
```

*Note* Multiple such entries may be added

5. Deploy Client Configs and Restart the cluster.

6. Example usage:
```sh
# HDFS access for CLI or M/R
$ hdfs dfs -ls wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/

# Create sample directory
$ seq 1 10000 | paste - - - - - - - - -d',' > sample.txt
$ hdfs dfs -mkdir wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/sample-dir
$ hdfs dfs -put sample.txt wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/sample-dir

# Access using Hive
$ hive << EOF
create external table wasb_sample
( a1 int, a2 int, a3 int, a4 int, a5 int, a6 int, a7 int, a8 int )
row format delimited
fields terminated by ','
location 'wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/sample-dir';
EOF
$ hive -e 'select count(*) from wasb_sample'

# Access using Spark
$ spark-shell <<EOF
val textFile = sc.textFile( "wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/sample-dir" )
textFile.count()
EOF
```

# References
This is a simplified distribution mechanism for the great work done by the Azure team: [HADOOP-9629](https://issues.apache.org/jira/browse/HADOOP-9629)
