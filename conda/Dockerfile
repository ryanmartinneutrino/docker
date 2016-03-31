#Jupyter Notebooks with basic scipy functionality, with python2 and python3 kernels (using Ubuntus Anaconda)
#Run tini as the entry point!

FROM ubuntu:14.04 

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
 libmysqlclient-dev \
 libfftw3-dev \
 graphviz-dev \
 libavahi-compat-libdnssd-dev \
 libldap2-dev \
 python3 \
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
 node \
 vim \
 jed \
 emacs \
 build-essential \
 bzip2 \
 unzip \
 libsm6 \
 pandoc \
 texlive-latex-base \
 texlive-latex-extra \
 texlive-fonts-extra \
 texlive-fonts-recommended \
 texlive-generic-recommended \
 locales \
 libxrender1 \ 
 libav-tools \
 && apt-get clean


# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.9.0/tini && \
    echo "faafbfb5b079303691a939a747d7f60591f2143164093727e870b289a44d9872 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini


ENV SHELL /bin/bash

# Install Anaconda
RUN mkdir -p /usr/local/conda
WORKDIR /usr/local/conda
RUN wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-4.0.0-Linux-x86_64.sh
RUN /bin/bash Anaconda3-4.0.0-Linux-x86_64.sh -f -b -p /usr/local/conda 
RUN /usr/local/conda/bin/conda install --quiet --yes conda==4.0.0

#Install scipy packages in python3 (should already have most of them)
RUN /usr/local/conda/bin/conda install --quiet --yes \
    notebook \
    terminado \
    ipywidgets \
    pandas \
    matplotlib \
    scipy \
    seaborn \
    scikit-learn \
    scikit-image \
    sympy \
    cython \
    patsy \
    statsmodels \
    cloudpickle \
    dill \
    numba \
    bokeh \
    h5py \
    && /usr/local/conda/bin/conda clean -tipsy

#Install python2 and packages into its own environment
RUN /usr/local/conda/bin/conda create --quiet --yes -p /usr/local/conda/envs/python2 python=2.7 \
    ipython \
    ipywidgets \
    pandas \
    matplotlib \
    scipy \
    seaborn \
    scikit-learn \
    scikit-image \
    sympy \
    cython \
    patsy \
    statsmodels \
    cloudpickle \
    dill \
    numba \
    bokeh \
    h5py \
    pyzmq \
    && /usr/local/conda/bin/conda clean -tipsy

#Make the python2 kernel
RUN /usr/local/conda/envs/python2/bin/python -m ipykernel install

#Make sure to source this when running the container:
RUN mkdir -p /usr/local/scripts
ADD setup_env.sh /usr/local/scripts/.

ENTRYPOINT ["tini", "--"]

