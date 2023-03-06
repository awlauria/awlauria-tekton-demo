FROM ubuntu:latest
RUN apt-get -y update && apt-get install -y
RUN apt-get -y install g++ cmake git
