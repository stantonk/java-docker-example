FROM 412335208158.dkr.ecr.us-east-1.amazonaws.com/sprout-java8:latest

# drop the jar+config in the container
RUN mkdir /srv/java-docker-example
COPY ./target/java-docker-example.jar /srv/java-docker-example/
COPY ./config.yml /srv/java-docker-example/

# oye...
# https://github.com/docker-library/docs/tree/master/mysql#no-connections-until-mysql-init-completes
# https://github.com/jwilder/dockerize
ENV DOCKERIZE_VERSION v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# wait for mysql to pass a healthcheck before starting the dropwizard service
# it can't handle the database being down when the app starts up
CMD dockerize -wait tcp://db:3306 -timeout 100s /usr/bin/java -jar /srv/java-docker-example/java-docker-example.jar server /srv/java-docker-example/config.yml
