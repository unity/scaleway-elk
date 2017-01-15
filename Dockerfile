## -*- docker-image-name: "scaleway/elk:latest" -*-
FROM scaleway/java:amd64-latest
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/java:armhf-latest       # arch=armv7l
#FROM scaleway/java:arm64-latest       # arch=arm64
#FROM scaleway/java:i386-latest        # arch=i386
#FROM scaleway/java:mips-latest        # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter


# Upgrade packages
RUN apt-get -q update \
  && apt-get --force-yes -y -qq upgrade


ENV ELASTICSEARCH_VERSION=5.1.2 LOGSTASH_VERSION=5.1.2 KIBANA_VERSION=5.1.2
RUN cd /tmp \
  && wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.deb \
  && wget -q https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}.deb \
  && wget -q https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86.tar.gz


RUN cd /tmp \
  && dpkg -i elasticsearch-${ELASTICSEARCH_VERSION}.deb \
  && dpkg -i logstash-${LOGSTASH_VERSION}.deb


RUN sed -i 's/#network.host: .*/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml \
  && sed -i 's/#LS_OPTS=""/LS_OPTS="-w 4"/' /etc/default/logstash \
  && sed -i 's/#LS_HEAP_SIZE="500m"/LS_HEAP_SIZE="1024m"/' /etc/default/logstash


RUN curl -sL https://deb.nodesource.com/setup | sudo bash - \
  && apt-get install nodejs nginx apache2-utils -y -qq


RUN tar -xf /tmp/kibana-${KIBANA_VERSION}-linux-x86.tar.gz -C /opt \
  && mv /opt/kibana-${KIBANA_VERSION}-linux-x86 /opt/kibana \
  && sed -i 's/host: ".*"/host: "localhost"/' /opt/kibana/config/kibana.yml


RUN apt-get install pwgen libc6-dev -y -qq
COPY ./overlay/ /


RUN update-rc.d kibana4_init defaults 95 10 \
  && update-rc.d elasticsearch defaults 95 10 \
  && update-rc.d logstash defaults 95 10


RUN chmod 1777 /tmp \
  && addgroup logstash adm


RUN mkdir -p /var/run/elasticsearch


# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
