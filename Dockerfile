FROM ubuntu:latest

LABEL maintainer="geekzyn"

ENV OPENJDK_VERSION=17 \
    HADOOP_VERSION=3 \
    SPARK_VERSION=3.5.3 \
    SPARK_MASTER="spark://spark-master:7077" \
    SPARK_MASTER_HOST=spark-master \
    SPARK_MASTER_PORT=7077 \
    PYSPARK_PYTHON=python3

RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    rsync \
    ssh \
    curl \
    python3 \
    python3-venv \
    "openjdk-${OPENJDK_VERSION}-jre-headless" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

RUN python3 -m venv .venv && \
    /.venv/bin/pip install --upgrade pip && \
    /.venv/bin/pip install pyspark==${SPARK_VERSION} pyarrow jupyter ipykernel && \
    /.venv/bin/python -m ipykernel install --user --name=pyspark --display-name "pyspark"

COPY conf/spark-defaults.conf "$SPARK_HOME/conf"
COPY entrypoint.sh ${SPARK_HOME}

RUN chmod u+x ${SPARK_HOME}/sbin/* && \
    chmod u+x ${SPARK_HOME}/bin/* && \
    chmod u+x ${SPARK_HOME}/entrypoint.sh

ENTRYPOINT ["${SPARK_HOME}/entrypoint.sh"]
CMD ["bash"]
