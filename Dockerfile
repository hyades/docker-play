FROM centos 

MAINTAINER aayushahuja@gmail.com

RUN yum -y update

RUN yum -y install wget git unzip pwgen ca-certificates java-1.7.0-openjdk java-1.7.0-openjdk-devel

RUN adduser -c "builder" -mr builder

RUN mkdir -p /home/builder/activator && \
    cd /home/builder/activator && \
    wget http://downloads.typesafe.com/typesafe-activator/1.2.12/typesafe-activator-1.2.12.zip && \
    unzip typesafe-activator-1.2.12.zip && \
    cd activator-1.2.12 && \
    export PATH=$PATH:$PWD

ENV PATH /home/builder/activator/activator-1.2.12:$PATH

RUN mkdir -p /home/builder/build && \
    cd /home/builder/build && \
    git clone https://github.com/hyades/docker-play.git

EXPOSE 9000

RUN cd /home/builder/build/docker-play && \
    activator dist

RUN mkdir -p /home/builder/app

RUN cp /home/builder/build/docker-play/target/universal/docker-play-1.0-SNAPSHOT.zip /home/builder/app 
 
RUN cd /home/builder/app && \
    unzip docker-play-1.0-SNAPSHOT.zip
 
CMD /home/builder/app/docker-play-1.0-SNAPSHOT/bin/docker-play -Dhttp.port=9000 -Dlogger.file=/home/builder/build/docker-play/logger.xml