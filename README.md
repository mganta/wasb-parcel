HADOOP WASB Parcel
==================

This repository provides a parcel(https://github.com/cloudera/cm_ext) to install the required jars for Azure's Blob ( `wasb` ) bindings for Hadoop, to be used with Cloudera Manager.

# Install Steps
1. Create a local repository to serve this repository. [Detailed Instructions](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM5/latest/Cloudera-Manager-Installation-Guide/cm5ig_create_local_parcel_repo.html)

Follow the steps below to serve the repository files, after which follow the instructions in the link above to add the repository to Cloudera Manager.
```sh
git clone http://github.com/prateek/wasb_parcel
cd wasb_parcel
python -m SimpleHTTPServer 14641
```

2. Install, Activate & Distribute the HADOOP_WASB parcel.

3. Add the following to the `core-site.xml` safety-valve for the HDFS service:
```xml
<property>
  <name>fs.azure.account.key.[STORAGE_ACCOUNT].blob.core.windows.net</name>
  <value>[SECRET_KEY]</value>
</property>
```

*Note* Multiple such entries may be added

4. Deploy Client Configs and Restart the cluster.

5. Example usage:
```sh
# Hdfs access for CLI or M/R
$ hdfs dfs -ls wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/

# Hive table
$ seq 1 10000 | paste - - - - - - - - -d',' > sample.txt
$ hdfs dfs -mkdir wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/hive-sample
$ hdfs dfs -put sample.txt wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/hive-sample
$ hive << EOF
create external table wasb_sample
( a1 int, a2 int, a3 int, a4 int, a5 int, a6 int, a7 int, a8 int )
row format delimited
fields terminated by ','
location 'wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/sample-dir';
EOF
$ hive -e 'select count(*) from wasb_sample'
```

# References
This is a simplified distribution mechanism for the great work done by the Azure team: [HADOOP-9629](https://issues.apache.org/jira/browse/HADOOP-9629)
