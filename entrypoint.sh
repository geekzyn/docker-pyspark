#!/bin/bash

SPARK_WORKLOAD=$1

if [ "$SPARK_WORKLOAD" == "master" ];
then
  start-master.sh -p 7077 &
  /.venv/bin/jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''
elif [ "$SPARK_WORKLOAD" == "worker" ];
then
  start-worker.sh spark://spark-master:7077
elif [ "$SPARK_WORKLOAD" == "history" ]
then
  start-history-server.sh
fi
