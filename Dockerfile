FROM ubuntu:16.04

# https://www.digitalocean.com/community/tutorials/how-to-manually-install-oracle-java-on-a-debian-or-ubuntu-vps
RUN mkdir /opt/jdk

COPY ./jdk-8u112-linux-x64.tar.gz /tmp/
RUN tar -zxvf /tmp/jdk-8u112-linux-x64.tar.gz -C /opt/jdk
RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_112/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_112/bin/javac 100
RUN java -version

RUN mkdir /srv/java-docker-example
COPY ./target/java-docker-example.jar /srv/java-docker-example/
CMD /usr/bin/java -jar /srv/java-docker-example/java-docker-example.jar
