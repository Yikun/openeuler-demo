FROM openeuler-20.03-lts-sp2:latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN yum install -y python2 java-11-openjdk-devel tar shadow-utils sudo

RUN groupadd openlkadmin
RUN useradd -m -d /home/openlkadmin -s /bin/bash openlkadmin -g openlkadmin
RUN echo "openlkadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /opt/openlookeng && chown openlkadmin:openlkadmin /opt/openlookeng

USER openlkadmin
WORKDIR /home/openlkadmin

RUN curl -L https://download.openlookeng.io/1.3.0/hetu-server-1.3.0.tar.gz | tar zx
RUN ln -s hetu-server-1.3.0/ hetu-server

COPY --chown=openlkadmin:openlkadmin run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /home/openlkadmin/hetu-server
RUN mkdir -p etc etc/catalog
COPY --chown=openlkadmin:openlkadmin ./conf/mysql.properties etc/catalog
COPY --chown=openlkadmin:openlkadmin ./conf/opengauss.properties etc/catalog
COPY --chown=openlkadmin:openlkadmin ./conf/node.properties etc/node.properties
COPY --chown=openlkadmin:openlkadmin ./conf/config.properties etc/config.properties
COPY --chown=openlkadmin:openlkadmin ./conf/jvm.config etc/jvm.config
COPY --chown=openlkadmin:openlkadmin ./conf/log.properties etc/log.properties

RUN echo "node.id=$(cat /proc/sys/kernel/random/uuid)" >> etc/node.properties

ENV TZ Asia/Hong_Kong

ENTRYPOINT ["/run.sh"]