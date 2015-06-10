## -*- docker-image-name: "armbuild/scw-app-elk:latest" -*-
FROM armbuild/scw-app-java:latest
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Upgrade packages
RUN apt-get -q update \
  && apt-get --force-yes -y -qq upgrade

RUN cd /tmp \
  && wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.5.2.deb \
  && wget http://download.elastic.co/logstash/logstash/packages/debian/logstash_1.5.0-1_all.deb \
  && wget https://download.elastic.co/kibana/kibana/kibana-4.0.2-linux-x86.tar.gz


RUN cd /tmp \
  && dpkg -i elasticsearch-1.5.2.deb \
  && dpkg -i logstash_1.5.0-1_all.deb

RUN sed -i 's/JDK_DIRS=".*"/JDK_DIRS="\/opt\/java\/jdk1.8.0_33"/' etc/init.d/elasticsearch \
  && sed -i 's/#network.host: .*/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml \
  && sed -i 's/#LS_OPTS=""/LS_OPTS="-w 4"/' /etc/default/logstash \
  && sed -i 's/#LS_HEAP_SIZE="500m"/LS_HEAP_SIZE="1024m"/' /etc/default/logstash \
  && sed -i '/export PATH/a export JAVA_HOME=\/opt\/java\/jdk1.8.0_33' /etc/init.d/logstash

RUN curl -sL https://deb.nodesource.com/setup | sudo bash - \
  && apt-get install nodejs nginx apache2-utils -y -qq

RUN tar -xf /tmp/kibana-4.0.2-linux-x86.tar.gz -C /opt \
  && mv /opt/kibana-4.0.2-linux-x86 /opt/kibana \
  && sed -i 's/host: ".*"/host: "localhost"/' /opt/kibana/config/kibana.yml

RUN apt-get install pwgen libc6-dev -y -qq
ADD ./patches/etc/ /etc/
ADD ./patches/opt/kibana/bin/ /opt/kibana/bin
ADD ./patches/opt/logstash/vendor/jruby/lib/jni/arm-Linux/ /opt/logstash/vendor/jruby/lib/jni/arm-Linux
ADD ./patches/usr/local/bin/ /usr/local/bin/

RUN update-rc.d kibana4_init defaults 95 10 \
  && update-rc.d elasticsearch defaults 95 10 \ 
  && update-rc.d logstash defaults 95 10

RUN chmod 1777 /tmp \
  && addgroup logstash adm

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
