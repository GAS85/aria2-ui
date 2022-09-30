#!/bin/sh

ARIA2_CONFIG=/configuration/aria2.conf

if [ ! -f $ARIA2_CONFIG ]; then
  echo "INFO - Will setup initial default configuration. You can edit it in mounted folder under $ARIA2_CONFIG"
  cp /start/aria2.conf $ARIA2_CONFIG
fi

if [ $RPC_SECRET ]; then
  echo "INFO - Updatating configuration with RPC_SECRET from Docker Variables"
  # Replace Values
  sed -i "s/^.*\brpc-secret=\b.*$/rpc-secret=$RPC_SECRET/" $ARIA2_CONFIG
  # Remove other entries if not uniq
  sed -i '' '2,$s/^rpc-secret.*//' $ARIA2_CONFIG
  # Remove USER and PASSWORD if any
  sed -i "s/^.*\b\(rpc-user=\|rpc-password=\)\b.*$//" $ARIA2_CONFIG
else
  echo "WARN - RPC_SECRET is not set. It is INSECURE to use aria2 wihout any Secret unless you set User/Password"
  if [ $RPC_USER ]; then
    echo "INFO - Updatating configuration with RPC_USER from Docker Variables"
    sed -i "s/^.*\brpc-user=\b.*$/rpc-user=$RPC_USER/" $ARIA2_CONFIG
    # Remove other entries if not uniq
    sed -i '' '2,$s/^rpc-user.*//' $ARIA2_CONFIG
  else
    echo "WARN - RPC_USER is not set. It is INSECURE to use aria2 wihout any Secret or User/Password"
  fi

  if [ $RPC_PASSWORD ]; then
    echo "INFO - Updatating configuration with RPC_PASSWORD from Docker Variables"
    sed -i "s/^.*\brpc-password=\b.*$/rpc-password=$RPC_PASSWORD/" $ARIA2_CONFIG
    # Remove other entries if not uniq
    sed -i '' '2,$s/^rpc-password.*//' $ARIA2_CONFIG
  else
    echo "WARN - RPC_PASSWORD is not set. It is INSECURE to use aria2 wihout any Secret or User/Password"
  fi
fi

if [ ! -e /configuration/aria2.session ]; then
  echo "INFO - Creating of aria2 Session file"
  touch /configuration/aria2.session
fi

if [ ! -e /configuration/dht.dat ]; then
  echo "INFO - Creating of dht file"
  touch /configuration/dht.dat
fi

if [ ! -e /configuration/access.log ]; then
  echo "INFO - Creating of webserer access logs"
  touch /configuration/access.log
fi

if [ ! "$ARIA_WEB_UI" = "webui" ]; then
  if [ ! "$ARIA_WEB_UI" = "ariang" ]; then
    echo "ERROR - You set wrong value for ARIA_WEB_UI, supported are: webui,ariang."
    exit 1
  fi
fi

echo "INFO - Starting Webserver with UI:$ARIA_WEB_UI and aria2"

darkhttpd /$ARIA_WEB_UI --port 8080 --log /configuration/access.log & 
aria2c --conf-path=$ARIA2_CONFIG
