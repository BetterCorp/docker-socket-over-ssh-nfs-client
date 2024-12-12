#! /bin/sh -e

mkdir -p "$MOUNTPOINT"

if [ "$SERVER" = "" ]; then
echo "docker NFS client with rpcbind ENABLED... if you wish to mount the mountpoint in this container USE THE FOLLOWING SYNTAX instead: \$ docker run -itd --privileged=true --net=host -v vol:/mnt/nfs-1:shared -e SERVER= X.X.X.X -e SHARE=shared_path d3fk/nfs-client" 
exit 1
else
rpc.statd & rpcbind -f &
mount -t "$FSTYPE" -o "$MOUNT_OPTIONS" "$SERVER:$SHARE" "$MOUNTPOINT"
fi
mount | grep nfs

# Execute the command passed to the container
exec "$@"
