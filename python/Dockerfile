#Jupyter Notebooks with basic scipy functionality, with python2 and python3 kernels (using Ubuntus python, not conda)
#Run tini as the entry point!

FROM ubuntu:14.04 

MAINTAINER Ryan Martin

USER root

#Install python3
RUN apt-get update && apt-get install -y python3 python3-pip

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
 libmysqlclient-dev \
 libfftw3-dev \
 graphviz-dev \
 libavahi-compat-libdnssd-dev \
 libldap2-dev \
 python3-dev \
 python3-pip\
 python-dev \
 python-pip\
 libxml2-dev \
 libkrb5-dev \
 libgsl0-dev \
 libqt4-dev \ 
 locales \
 wget \
 cfitsio-dev \
 libffi-dev \
 curl \
 node  

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.9.0/tini && \
    echo "faafbfb5b079303691a939a747d7f60591f2143164093727e870b289a44d9872 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini


ENV SHELL /bin/bash


#Install scipy stack
RUN apt-get install -y python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-nose python-sympy

RUN apt-get install -y python3-numpy python3-scipy python3-matplotlib ipython3 ipython3-notebook python3-pandas python3-nose


# Install some dependencies.
RUN pip2 install ipykernel && \
    pip3 install ipykernel && \
    \
    python2 -m ipykernel.kernelspec && \
    python3 -m ipykernel.kernelspec 


RUN pip3 install jupyter 

ENTRYPOINT ["tini", "--"]

