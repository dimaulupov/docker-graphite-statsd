#!/usr/bin/env bash

set -ex

if [ "${EFS_FS_ID}" == "" ] ; then
    echo "Set EFS_FS_ID to efs files system id to use and run this container in privileged mode"
    exit 1
fi

REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}'`
mount -t nfs4 -o nfsvers=4.1 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).${EFS_FS_ID}.efs.${REGION}.amazonaws.com:/ /efs

# -n will not overwrite files in /efs
mv -vn /original-opt /efs/opt
mv -vn /original-nginx /efs/nginx
mv -vn /original-log /efs/log

chmod -R a+Xrw /efs/opt /efs/nginx /efs/log
chmod -R +rw /efs/opt /efs/nginx /efs/log

/sbin/my_init
