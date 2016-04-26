FROM ubuntu:16.04

MAINTAINER Ryan Martin

USER root


#Update
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
 && apt-get clean


#Some extra stuff that should probably be above:
RUN apt-get install -y --fix-missing cmake\
  curl\
  cernlib

#Build ROOT using CMAKE:
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


#Install Geant4:
RUN mkdir -p /usr/local/geant4/src && mkdir -p /usr/local/geant4/build && mkdir -p /usr/local/geant4/install

WORKDIR /usr/local/geant4/src

RUN wget http://geant4.cern.ch/support/source/geant4.10.01.p02.tar.gz && tar -xvzf geant4.10.01.p02.tar.gz

WORKDIR /usr/local/geant4/build

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/geant4/install -DGEANT4_INSTALL_DATA=ON ../src/geant4.10.01.p02

RUN make && make install




