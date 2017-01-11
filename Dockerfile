FROM ubuntu:16.04

# https://www.digitalocean.com/community/tutorials/how-to-manually-install-oracle-java-on-a-debian-or-ubuntu-vps
RUN mkdir /opt/jdk

COPY ./jdk-8u112-linux-x64.tar.gz /tmp/
RUN tar -zxf /tmp/jdk-8u112-linux-x64.tar.gz -C /opt/jdk
RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_112/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_112/bin/javac 100
RUN java -version
# always clean up after yourself in docker images to keep their size down!
RUN rm /tmp/jdk-8u112-linux-x64.tar.gz

RUN mkdir /srv/java-docker-example
COPY ./target/java-docker-example.jar /srv/java-docker-example/
COPY ./config.yml /srv/java-docker-example/

# oye...
# https://github.com/docker-library/docs/tree/master/mysql#no-connections-until-mysql-init-completes
# https://github.com/jwilder/dockerize
RUN apt-get update && apt-get install -y \
    wget \
&& rm -rf /var/lib/apt/lists/*

ENV DOCKERIZE_VERSION v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# wait for mysql to pass a healthcheck before starting the dropwizard service
# it can't handle the database being down when the app starts up
CMD dockerize -wait tcp://db:3306 -timeout 100s /usr/bin/java -jar /srv/java-docker-example/java-docker-example.jar server /srv/java-docker-example/config.yml
