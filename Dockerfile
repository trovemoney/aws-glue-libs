FROM openjdk:8

LABEL AUTHOR="Subramanya Vajiraya (https://github.com/svajiraya)"
ARG GLUE_VER
ARG SPARK_URL
ARG MAVEN_URL
ARG PYTHON_BIN

RUN apt-get update && apt-get install awscli zip git tar ${PYTHON_BIN} ${PYTHON_BIN}-pip -y

ADD ${MAVEN_URL} /tmp/maven.tar.gz
ADD ${SPARK_URL} /tmp/spark.tar.gz

RUN tar zxvf /tmp/maven.tar.gz -C ~/ && tar zxvf /tmp/spark.tar.gz -C ~/ && rm -rf /tmp/*
RUN echo 'export SPARK_HOME="$(ls -d /root/*spark*)"; export MAVEN_HOME="$(ls -d /root/*maven*)"; export PATH="$PATH:$MAVEN_HOME/bin:$SPARK_HOME/bin:/glue/bin"' >> ~/.bashrc
ENV PYSPARK_PYTHON "${PYTHON_BIN}"

WORKDIR /glue
ADD . /glue

RUN bash -l -c 'bash ~/.profile && bash /glue/bin/glue-setup.sh && wget -O /glue/conf/log4j.properties https://gist.githubusercontent.com/svajiraya/aecb45c038e7bba86429646a68b542bb/raw/0cc6229d3b745a0092be75bbbf9476fa17318004/log4j.properties && pip3 install boto3 pytest'
CMD [ "bash", "-l", "-c", "gluepyspark" ]