Build the Dropwizard Java REST service:

```
mvn clean -U package
```

Build a Java 8 Docker container based off Ubuntu 16.04. Note you'll need to download `jdk-8u112-linux-x64.tar.gz` first
before this will work. Put it in the project root directory.

http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

```
docker build --tag app .
```

Now you have the Dropwizard service in a container, ready to start up
with `docker-compose`. Since the Dropwizard service requires a MySQL
database as it's persistence layer, `docker-compose.yml` sets up
two containers, one running the Dropwizard service's image, and another
to run MySQL.

```
docker-compose up
```

Once that finishes, you now have 2 running containers, one with the Dropwizard REST service and the other with MySQL.

You can confirm the service is up and running by CURLing it:

```
curl -vs "http://localhost:8080/api/tweets"
*   Trying ::1...
* Connected to localhost (::1) port 8080 (#0)
> GET /api/tweets HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.43.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Wed, 11 Jan 2017 04:21:22 GMT
< Content-Type: application/json
< Vary: Accept-Encoding
< Content-Length: 2
<
* Connection #0 to host localhost left intact
[]
```

The idea here is to demonstrate a fully working application environment
that can be as close to Production as possible while:

* minimizing the amount of time to get a working dev environment up and running
* reducing the impedance mismatch between Production/Stage/Local Environments.

There's lots to add in here to further demonstrate the power of this.

I don't necessarily recommend running MySQL (or any persistence) in Docker,
I'm not convinced of the benefits there as of yet. But for services the
arguments are compelling, e.g.:

* combining Docker with Kubernets or Mesos gives you relatively cheap High Availability, both intra and inter Data
Center while making it possible to keep server costs down by treating a set of servers as
one giant resource to stack containers onto.
* Decoupling applications from their environment, making config mgmt less difficult by enabling
developers to manage configs vs. creating a human-level bottleneck and divider between Dev and Ops.

#TODO
1. Make the service actually do something
2. Bootstrap the service's DB schema for MySQL as part of build process
3. Logging/Config Mgmt examples...
4. *start* the service's `Dockerfile` from an already ready to go Java8 image to significantly cut down on initial build time?
