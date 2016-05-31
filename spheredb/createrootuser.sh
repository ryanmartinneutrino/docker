#! /bin/bash
#Script to use the localhost execption to create an admin user
#One should immediately log into the database and change the default password
mongo admin --eval "db.createUser({ user: 'root', pwd: 'root', roles: [ { role: 'root', db: 'admin' } ] })"

