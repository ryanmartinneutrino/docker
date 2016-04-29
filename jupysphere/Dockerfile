#This builds conda, ROOT, and is setup to run from dockerspawner to run a jupyternotebook for a specific system user
#Uses tini as the entry point (process manager, like init)

#trusty is the latest version of Ubuntu 14.04 (currently 14.04.4)

FROM ubuntu:trusty

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
COPY setup_env.sh /usr/local/scripts/.

ENTRYPOINT ["tini", "--"]

#Pull ROOT from git and install on top of the python notebook installation

#Build ROOT:
#Download a tagged version from git
WORKDIR /usr/local/src/
RUN git clone http://root.cern.ch/git/root.git \ 
    && cd root\
    && git checkout -b v6-07-06 v6-07-06 \
    && mkdir /usr/local/root
#configure
WORKDIR /usr/local/root
ENV SHELL /bin/bash

RUN /bin/bash -c "source /usr/local/scripts/setup_env.sh && cmake -Dhttp:BOOL=ON \
  -DPYTHON_EXECUTABLE:FILEPATH=/usr/local/conda/envs/python2/bin/python \
  -DPYTHON_INCLUDE_DIR:PATH=/usr/local/conda/envs/python2/include \
  -DPYTHON_LIBRARY:FILEPATH=/usr/local/conda/envs/python2/lib/libpython2.7.so \
 /usr/local/src/root" 

#Build and install
RUN /bin/bash -c "source /usr/local/scripts/setup_env.sh && cmake --build . --target install"

#Apparently required for the ROOT C++ kernel
RUN  /bin/bash -c "source /usr/local/scripts/setup_env.sh \
     && conda install --yes pip \
     && pip install metakernel \
     && source activate root \
     && pip install metakernel \
     && source activate python2 \
     && echo conda envs --list \
     && pip install metakernel" 

#Copy the ROOT C++ kernel over:
RUN cp -r /usr/local/root/etc/notebook/kernels/root /usr/local/share/jupyter/kernels/.

#Add the jupyterhub-single user to run this as with dockerspawner from Jupyterhub
#Runs the notebook server as a user from the host, with home directory mounted.
#The systemuser.sh scrip will source thisroot.sh as the system user that  is creates

EXPOSE 8888

ENV SHELL /bin/bash
RUN wget -q https://raw.githubusercontent.com/jupyter/jupyterhub/master/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser
RUN chmod 755 /usr/local/bin/jupyterhub-singleuser

COPY systemuser.sh /srv/singleuser/systemuser.sh

ENV CONDA_DIR /usr/local/conda

CMD ["sh", "/srv/singleuser/systemuser.sh"]
