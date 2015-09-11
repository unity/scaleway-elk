## -*- docker-image-name: "armbuild/scw-app-elk:latest" -*-
FROM armbuild/scw-app-java:latest
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Upgrade packages
RUN apt-get -q update \
  && apt-get --force-yes -y -qq upgrade


ENV ELASTICSEARCH_VERSION 1.7.1
ENV LOGSTASH_VERSION 1.5.4-1
ENV KIBANA_VERSION 4.1.2
RUN cd /tmp \
  && wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.deb \
  && wget -q http://download.elastic.co/logstash/logstash/packages/debian/logstash_${LOGSTASH_VERSION}_all.deb \
  && wget -q https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x86.tar.gz


RUN cd /tmp \
  && dpkg -i elasticsearch-${ELASTICSEARCH_VERSION}.deb \
  && dpkg -i logstash_${LOGSTASH_VERSION}_all.deb


RUN sed -i 's/#network.host: .*/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml \
  && sed -i 's/#LS_OPTS=""/LS_OPTS="-w 4"/' /etc/default/logstash \
  && sed -i 's/#LS_HEAP_SIZE="500m"/LS_HEAP_SIZE="1024m"/' /etc/default/logstash


RUN curl -sL https://deb.nodesource.com/setup | sudo bash - \
  && apt-get install nodejs nginx apache2-utils -y -qq


RUN tar -xf /tmp/kibana-${KIBANA_VERSION}-linux-x86.tar.gz -C /opt \
  && mv /opt/kibana-${KIBANA_VERSION}-linux-x86 /opt/kibana \
  && sed -i 's/host: ".*"/host: "localhost"/' /opt/kibana/config/kibana.yml

RUN apt-get install pwgen libc6-dev -y -qq
ADD ./patches/etc/ /etc/
ADD ./patches/opt/ /opt/
ADD ./patches/usr/ /usr/


RUN update-rc.d kibana4_init defaults 95 10 \
  && update-rc.d elasticsearch defaults 95 10 \
  && update-rc.d logstash defaults 95 10


RUN chmod 1777 /tmp \
  && addgroup logstash adm


RUN mkdir -p /var/run/elasticsearch


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
