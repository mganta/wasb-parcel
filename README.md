HADOOP WASB Parcel
==================

This repository provides a parcel(https://github.com/cloudera/cm_ext) to install the required jars for Azure's Blob ( `wasb` ) bindings for Hadoop, to be used with Cloudera Manager.

# Install Steps
1. Create a local repository to serve this repository. [Detailed Instructions](http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM5/latest/Cloudera-Manager-Installation-Guide/cm5ig_create_local_parcel_repo.html)

Sample steps for repository creation:
```sh
git clone http://github.com/prateek/wasb_parcel
cd hadoop_wasb
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

4. Example usage:
```sh
# Hdfs access for CLI or M/R
hdfs dfs -ls wasb://[CONTAINER]@[STORAGE_ACCOUNT].blob.core.windows.net/
```

# References
This is a simplified distribution for the great work done by the Azure team: [HADOOP-9629](https://issues.apache.org/jira/browse/HADOOP-9629)
