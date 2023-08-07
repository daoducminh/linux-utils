#!/usr/bin/env bash

CUR_DIR=$(pwd)

mkdir -p jars
cd jars

JAR_TXT=$(pwd)/spark_s3.txt
wget -c -i JAR_TXT

cd $CUR_DIR

SPARK_VERSION=${1:-3.3.1}

wget -c "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz"

tar -xzf "spark-$SPARK_VERSION-bin-hadoop3.tgz" 

cd "spark-$SPARK_VERSION-bin-hadoop3"

export SPARK_HOME=$(pwd)

rm -rf data/*
rm -rf examples/*

cd jars
cp -f $CUR_DIR/jars/*.jar .

cd $SPARK_HOME
./bin/docker-image-tool.sh -r daoducminh1997 -t $SPARK_VERSION build && \
./bin/docker-image-tool.sh -r daoducminh1997 -t $SPARK_VERSION push && \
cd $CUR_DIR && rm -rf "spark-$SPARK_VERSION-bin-hadoop3" && rm -rf "spark-$SPARK_VERSION-bin-hadoop3.tgz"
