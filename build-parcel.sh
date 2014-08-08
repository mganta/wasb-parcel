#!/bin/bash
set -e

# validate directory
java -jar ~/trash/cm_ext/validator/target/validator.jar -d HADOOP_WASB-0.0.1.hadoopwasb.p0.1

# create parcel
tar zcvf HADOOP_WASB-0.0.1.hadoopwasb.p0.1-el6.parcel HADOOP_WASB-0.0.1.hadoopwasb.p0.1

# sudo chown root:root HADOOP_WASB-0.0.1.hadoopwasb.p0.1-el6.parcel

# validate parcel
java -jar ~/trash/cm_ext/validator/target/validator.jar -f HADOOP_WASB-0.0.1.hadoopwasb.p0.1-el6.parcel

# create manifest
~/trash/cm_ext/make_manifest/make_manifest.py
