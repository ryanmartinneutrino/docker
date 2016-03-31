#Add the jupyterhub-single user to run this as with dockerspawner from Jupyterhub
#Runs the notebook server as a user from the host, with home directory mounted.
#The systemuser.sh scrip will source thisroot.sh as the system user that  is creates


FROM ryanmartinneutrino/conda4rootp3 

MAINTAINER Ryan Martin

USER root

EXPOSE 8888

ENV SHELL /bin/bash
RUN wget -q https://raw.githubusercontent.com/jupyter/jupyterhub/master/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser
RUN chmod 755 /usr/local/bin/jupyterhub-singleuser

ADD systemuser.sh /srv/singleuser/systemuser.sh

CMD ["sh", "/srv/singleuser/systemuser.sh"]
