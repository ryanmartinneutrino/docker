#Pull ROOT from git and install on top of the python notebook installation
#Need to source thisroot.sh to set PYTHONPATH when this starts

FROM ryanmartinneutrino/python

MAINTAINER Ryan Martin

USER root

#Build ROOT:
#Download the latest from git
WORKDIR /usr/local/src/
RUN git clone http://root.cern.ch/git/root.git && mkdir /usr/local/root 

#configure
WORKDIR /usr/local/root
RUN cmake -Dhttp:BOOL=ON \
          -Dpython3:BOOL=ON \
    /usr/local/src/root 

#Build and install
RUN cmake --build . --target install

#Copy the ROOT C++ kernel over:
RUN cp -r /usr/local/root/etc/notebook/kernels/root /usr/local/share/jupyter/kernels/.

#Apparently required for the ROOT C++ kernel
RUN pip2 install metakernel
