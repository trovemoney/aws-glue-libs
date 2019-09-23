FROM openjdk:8

LABEL AUTHOR="Subramanya Vajiraya (https://github.com/svajiraya)"
WORKDIR /glue
ARG GLUE_VER
ARG SPARK
ARG MAVEN
ARG PYTHON_BIN

RUN apt-get update && apt-get install awscli zip git tar ${PYTHON_BIN} ${PYTHON_BIN}-pip -y

ADD https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/${MAVEN}-bin.tar.gz /tmp/maven.tar.gz
ADD https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-${GLUE_VER}/${SPARK}.tgz /tmp/spark.tar.gz

RUN tar zxvf /tmp/maven.tar.gz -C ~/ && tar zxvf /tmp/spark.tar.gz -C ~/ && rm -rf /tmp
ENV SPARK_HOME "/root/${SPARK}"
ENV PYSPARK_PYTHON "${PYTHON_BIN}"

ADD . /glue
ENV PATH "$PATH:/root/${MAVEN}/bin:/root/${SPARK}/bin:/glue/bin"

RUN bash /glue/bin/glue-setup.sh
ENTRYPOINT [ "bash" ]