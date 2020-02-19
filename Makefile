
REPOSITORY=epolyakov/accumulo
VERSION=1.9.3
ZOOKEEPER_VERSION=3.4.14
HADOOP_VERSION=2.9.2
ACCUMULO_VERSION=1.9.3
GEOMESA_VERSION=2.4.0

SUDO=
BUILD_ARGS=--build-arg ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION} \
  --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
  --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} \
  --build-arg GEOMESA_VERSION=${GEOMESA_VERSION}

DOWNLOADS=accumulo-${ACCUMULO_VERSION}-bin.tar.gz \
  zookeeper-${ZOOKEEPER_VERSION}.tar.gz hadoop-${HADOOP_VERSION}.tar.gz \
  geomesa-accumulo_2.11-${GEOMESA_VERSION}-bin.tar.gz

all: ${DOWNLOADS}
	${SUDO} docker build ${BUILD_ARGS} -t ${REPOSITORY}:${VERSION} .

zookeeper-${ZOOKEEPER_VERSION}.tar.gz:
	wget -q -O $@ https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

accumulo-${ACCUMULO_VERSION}-bin.tar.gz:
	wget -q -O $@ https://archive.apache.org/dist/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz

hadoop-${HADOOP_VERSION}.tar.gz:
	wget -q -O $@ https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
	
geomesa-accumulo_2.11-${GEOMESA_VERSION}-bin.tar.gz:
	wget -q -O $@ https://github.com/locationtech/geomesa/releases/download/geomesa_2.11-${GEOMESA_VERSION}/geomesa-accumulo_2.11-${GEOMESA_VERSION}-bin.tar.gz

push:
	${SUDO} docker push ${REPOSITORY}:${VERSION}

# Continuous deployment support
BRANCH=master
FILE=accumulo-version
REPO=git@github.com:cybermaggedon/gaffer-docker

tools: phony
	if [ ! -d tools ]; then \
		git clone git@github.com:trustnetworks/cd-tools tools; \
	fi; \
	(cd tools; git pull)

phony:

bump-version: tools
	tools/bump-version

update-cluster-config: tools
	tools/update-version-file ${BRANCH} ${VERSION} ${FILE} ${REPO}

