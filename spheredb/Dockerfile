FROM mongo:3.2.6


#Set the bind IP to accept any connection
RUN sed -i 's/bindIp\: 127.0.0.1/bindIp\: 0.0.0.0/' /etc/mongod.conf.orig


#Copy a script to be run once to create a root user:
COPY createrootuser.sh /

