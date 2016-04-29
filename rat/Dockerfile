######################
#Dockerfile to build RAT into a container that one can ssh into.
#Needs a directory called rat/ with all the source code from github to 
#be in the same directory as the Dockerfile (so that we can avoid
#putting ssh keys in the Dockerfile)
#User is root with password root (it's obvious where to change that)
#Start with: docker run -d -P --name rat_docker ryanmartinneutrino/rat:v1
#####################################


#So far (April 2016, did not compile with 16.04)
#Use a base image from Ubuntu 14.04:
FROM ubuntu:14.04.4

MAINTAINER Ryan Martin

USER root

############################################################
#Start by updating the OS and installing a bunch of packages
############################################################
RUN apt-get update
#Install all sort of prequesites:
RUN apt-get install -y --fix-missing\
 cmake \
 git \
 dpkg-dev \
 make \
 g++ \
 gcc \
 binutils \
 libx11-dev \
 libxpm-dev \
 libxft-dev \
 libxext-dev \
 gfortran \
 libssl-dev \
 libglew1.5-dev \
 libftgl-dev \
 libfftw3-dev \
 graphviz-dev \
 libavahi-compat-libdnssd-dev \
 libldap2-dev \
 python-dev \
 python-pip\
 libxml2-dev \
 libkrb5-dev \
 libgsl0-dev \
 libqt4-dev \
 locales \
 wget \
 libffi-dev \
 vim \
 build-essential \
 bzip2 \
 unzip \
 cmake\
 curl\
 cernlib\
 && apt-get clean


#############################################################
#Build ROOT - use version required by RAT (i.e. from 5.X, not 6.X)
#source into /usr/local/src/root
#build and install into /usr/local (ROOT's default)
#############################################################
#Put source into /usr/local/src/root and build in /usr/local/root
#Download from git
RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src/
RUN git clone http://root.cern.ch/git/root.git\
    && cd root\
    && git checkout -b v5-34-36 v5-34-36 \
    && mkdir /usr/local/root

#Configure ROOT for the build
WORKDIR /usr/local/root
RUN cmake -Dhttp:BOOL=ON \
          -Dpython:BOOL=ON \
          -Dminuit2:BOOL=ON \
    /usr/local/src/root

#Build and install
RUN cmake --build . --target install

#######################################################
#Install Geant4 - use version required by RAT (hard coded)
#source in /usr/local/geant4/src
#build in /usr/local/geant4/build
#install in /usr/local/geant4/install
#######################################################
RUN mkdir -p /usr/local/geant4/src && mkdir -p /usr/local/geant4/build && mkdir -p /usr/local/geant4/install
WORKDIR /usr/local/geant4/src
RUN wget http://geant4.cern.ch/support/source/geant4.10.00.p02.tar.gz && tar -xvzf geant4.10.00.p02.tar.gz
WORKDIR /usr/local/geant4/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/geant4/install -DGEANT4_INSTALL_DATA=ON ../src/geant4.10.00.p02
RUN make && make install

#######################################################
#Install RAT, based on a local copy downloaded in the same directory (and called rat)
#source in /usr/local/rat
#######################################################
RUN mkdir -p /usr/local/rat
RUN apt-get install -y --fix-missing scons libcurl3-openssl-dev bzip2 libbz2-dev libbz2-1.0
WORKDIR /usr/local/rat

#Use a local directory copy of rat from the host located in the same dir as the Dockerfile
COPY rat/. /usr/local/rat
RUN /bin/bash -c "source /usr/local/bin/thisroot.sh \
                  && source /usr/local/geant4/install/bin/geant4.sh \ 
                  && ./configure \
                  && source env.sh \
                  && scons "

#######################################################
#Setup the environment
#######################################################

#Create a bash .profile login script that gets executed when we ssh 
RUN echo 'source /usr/local/bin/thisroot.sh' >> ~/.profile \
   && echo 'source /usr/local/geant4/install/bin/geant4.sh' >> ~/.profile \
   && echo 'source /usr/local/rat/env.sh' >> ~/.profile


# Install Tini as the process manager and set as the entry point
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.9.0/tini && \
    echo "faafbfb5b079303691a939a747d7f60591f2143164093727e870b289a44d9872 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini
ENTRYPOINT ["tini", "--"]

#install java to be able to use HepRApp and downloar HepRApp
RUN apt-get install -y --fix-missing default-jre
RUN mkdir -p /root/rat_work
WORKDIR /root/rat_work
RUN wget http://www.slac.stanford.edu/~perl/HepRApp/HepRApp.jar

#Make root's home directory persist
VOLUME /root/

# start an ssh server (based on https://docs.docker.com/engine/examples/running_ssh_service/)
RUN apt-get install -y --fix-missing openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]



