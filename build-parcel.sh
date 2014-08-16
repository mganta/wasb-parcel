#!/bin/bash
set -e

VALIDATOR_DIR=${VALIDATOR_DIR:-~/trash/cm_ext}
POINT_VERSION=${POINT_VERSION:-5}

BASE_NAME=HADDOP_WASB
SRC_DIR=${PARCEL_SRC:-parcel-src}
BUILD_DIR=${BUILD_DIR:-build}

PARCEL_NAME=$(echo HADOOP_WASB-0.0.${POINT_VERSION}.hadoopwasb.p0.${POINT_VERSION})
SHORT_VERSION=$(echo 0.0.${POINT_VERSION})
FULL_VERSION=$(echo ${SHORT_VERSION}.hadoopwasb.p0.${POINT_VERSION})

# Make Build Directory
if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi

# Make directory
mkdir $BUILD_DIR

# Create Copy
cp -r $SRC_DIR $BUILD_DIR/$PARCEL_NAME

# move into BUILD_DIR
cd $BUILD_DIR

for file in `ls $PARCEL_NAME/meta/**`
do
  sed -i "" "s/<VERSION-FULL>/$FULL_VERSION/g"     $file
  sed -i "" "s/<VERSION-SHORT>/${SHORT_VERSION}/g" $file
  sed -i "" "s/<PARCEL-NAME>/${PARCEL_NAME}/g"     $file
done

# validate directory
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -d $PARCEL_NAME

# http://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
export COPYFILE_DISABLE=true

# create parcel
tar zcvf ${PARCEL_NAME}-el6.parcel ${PARCEL_NAME}

# validate parcel
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -f ${PARCEL_NAME}-el6.parcel

# create manifest
$VALIDATOR_DIR/make_manifest/make_manifest.py
