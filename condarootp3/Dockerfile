#Pull ROOT from git and install on top of the python notebook installation
#Need to source thisroot.sh to set PYTHONPATH when this starts

FROM ryanmartinneutrino/conda400

MAINTAINER Ryan Martin

USER root

#Build ROOT:
#Download the latest from git
WORKDIR /usr/local/src/
RUN git clone http://root.cern.ch/git/root.git && mkdir /usr/local/root 

#configure
WORKDIR /usr/local/root
ENV SHELL /bin/bash

RUN /bin/bash -c "source /usr/local/scripts/setup_env.sh && cmake -Dhttp:BOOL=ON \
  -DPYTHON_EXECUTABLE:FILEPATH=/usr/local/conda/bin/python \
  -DPYTHON_INCLUDE_DIR:PATH=/usr/local/conda/include \
  -DPYTHON_LIBRARY:FILEPATH=/usr/local/conda/lib/libpython3.5m.so \
  -Dpython3:BOOL=ON \
  /usr/local/src/root" 

#Build and install
RUN /bin/bash -c "source /usr/local/scripts/setup_env.sh && cmake --build . --target install"

#Apparently required for the ROOT C++ kernel
RUN  /bin/bash -c "source /usr/local/scripts/setup_env.sh &&conda install -c https://conda.anaconda.org/ioos metakernel

#Apparently required for the ROOT C++ kernel
RUN  /bin/bash -c "source /usr/local/scripts/setup_env.sh \
     && conda install --yes pip \
     && pip install metakernel \
     && source activate root \
     && pip install metakernel"

#Copy the ROOT C++ kernel over:
RUN cp -r /usr/local/root/etc/notebook/kernels/root /usr/local/share/jupyter/kernels/.

