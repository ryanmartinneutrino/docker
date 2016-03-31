#!/bin/bash
set -e

GID=385
GNAME='sno-news'

if getent group $GID > /dev/null; then
  echo "group $GNAME already exists"
else
  groupadd -g $GID $GNAME
fi

if getent passwd $USER_ID > /dev/null ; then
  echo "$USER ($USER_ID) exists"
else
  echo "Creating user $USER ($USER_ID)"
  useradd -u $USER_ID -s $SHELL -g $GID $USER
fi


sudo -E PATH="${CONDA_DIR}/bin:$PATH" -u $USER bash -c 'source /usr/local/scripts/setup_env.sh && source /usr/local/bin/thisroot.sh && jupyterhub-singleuser \
  --port=8888 \
  --ip=0.0.0.0 \
  --user=$JPY_USER \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  $@'
