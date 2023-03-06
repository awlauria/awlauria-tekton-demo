FROM ubuntu:latest
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN apt-get -y update && apt-get install -y
RUN apt-get -y install g++ cmake git
RUN g++ -g -o hello_world hello_world.cpp
CMD ["/app/hello_world"]
