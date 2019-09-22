# Glue Local Development Environment - Docker image builder

GLUE_VERSION = $(shell bash -c "echo -e 'setns x=http://maven.apache.org/POM/4.0.0\ncat /x:project/x:version/text()' | xmllint --shell pom.xml | grep -e '^\d.*' | cut -c1-3")

MAVEN := "apache-maven-3.6.0"

ifeq ($(GLUE_VERSION),0.9)
SPARK := "spark-2.2.1-bin-hadoop2.7"
PYTHON_BIN := "python"
else
SPARK := "spark-2.4.3-bin-hadoop2.8"
PYTHON_BIN := "python3"
endif



build-image:
	docker build -t glue-dev-$(GLUE_VERSION):latest --build-arg GLUE_VER=$(GLUE_VERSION) --build-arg SPARK=$(SPARK) --build-arg MAVEN=$(MAVEN) --build-arg PYTHON_BIN=$(PYTHON_BIN) .

