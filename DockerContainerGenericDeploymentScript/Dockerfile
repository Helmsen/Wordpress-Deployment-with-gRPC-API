FROM ubuntu:14.04

MAINTAINER Wilhelm Stephan, Leon Graser, Dominik Bäßler

# Install Java 8
# ---------------
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-get install -y python-software-properties && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean


# Folders
# -------------------------------
RUN mkdir -p /fapra
RUN mkdir -p /srv/fapra/scripts  && \
	mkdir -p /srv/fapra/key  && \
	mkdir -p /srv/salt/restore  && \
	mkdir -p /srv/salt/generic

# Files
# -------------------------------
COPY scenario4.sh /fapra/scenario4.sh
RUN chmod +x /fapra/scenario4.sh
COPY wp-config.php /srv/salt/generic/wp-config.php
COPY apache.sls /srv/salt/generic/apache.sls
COPY wordpress.sls /srv/salt/generic/wordpress.sls
COPY mysql.sls /srv/salt/generic/mysql.sls
COPY key.pem /srv/salt/key/key.pem
COPY DeploymentClient.jar /fapra/DeploymentClient.jar

# Parameters
# -------------------------------
ENV KEY_PAIR_NAME=CHANGE
ENV AWS_ACCESS_KEY_ID=CHANGE
ENV SECURITY_GROUP_NAME=CHANGE
ENV AWS_ACCESS_KEY_SECRET=CHANGE
ENV IP_SERVER=CHANGE
ENV PORT_SERVER=CHANGE

CMD ["/fapra/scenario4.sh"]
