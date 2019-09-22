# Glue Local Development Environment - Docker image builder

GLUE_VERSION = $(shell bash -c "echo -e 'setns x=http://maven.apache.org/POM/4.0.0\ncat /x:project/x:version/text()' | xmllint --shell pom.xml | grep -e '^\d.*' | cut -c1-3")

MAVEN_URL := "https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz"

ifeq ($(GLUE_VERSION),0.9)
SPARK_URL := "https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-0.9/spark-2.2.1-bin-hadoop2.7.tgz"
PYTHON_BIN := "python"
else
SPARK_URL := "https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-1.0/spark-2.4.3-bin-hadoop2.8.tgz"
PYTHON_BIN := "python3"
endif

build-image:
	docker build -t glue-dev-$(GLUE_VERSION):latest --build-arg GLUE_VER=$(GLUE_VERSION) --build-arg SPARK_URL=$(SPARK_URL) --build-arg MAVEN_URL=$(MAVEN_URL) --build-arg PYTHON_BIN=$(PYTHON_BIN) .
	export IMAGE_REPO_NAME=glue-dev-$(GLUE_VERSION);
	export IMAGE_TAG_TIMESTAMP=`date +%Y%m%d_%H%M%S%Z`;

