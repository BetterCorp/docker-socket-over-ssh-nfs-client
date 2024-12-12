FROM alpine:latest
LABEL org.opencontainers.image.authors="betterweb"
LABEL org.opencontainers.image.source="https://github.com/BetterCorp/docker-socket-over-ssh-nfs-client.git"
LABEL org.opencontainers.image.url="https://github.com/BetterCorp/docker-socket-over-ssh-nfs-client"

# USAGE
# $ docker build -t nfs-client .
# $ docker run -it --privileged=true --net=host -v vol:/mnt/nfs-1:shared -e SERVER=X.X.X.X -e SHARE=shared_path nfs-client
#    or detached:
#       $ docker run -itd --privileged=true --net=host -v vol:/mnt/nfs-1:shared -e SERVER=X.X.X.X -e SHARE=shared_path nfs-client
#    or with some more options:
#       $ docker run -itd \
#             --name nfs-vols \
#             --restart=always \
#             --privileged=true \
#             --net=host \
#             -v /mnt/host:/mnt/container \
#             -e SERVER=192.168.0.9 \
#             -e SHARE=movies \
#             -e MOUNT_OPTIONS="nfsvers=3,ro" \
#             -e FSTYPE=nfs \
#             -e MOUNTPOINT=/mnt/host/mnt/nfs-1 \
#                nfs-client

#to enable nfs4 simply switch the FSTYPE to nfs4 and set nfsvers=4 
ENV FSTYPE nfs
ENV MOUNT_OPTIONS nfsvers=3
ENV MOUNTPOINT /mnt/nfs-1

RUN apk upgrade --no-cache && apk add --no-cache nfs-utils envsubst docker-cli openssh-client curl jq \
# https://github.com/rancher/os/issues/641#issuecomment-157006575
    && rm /sbin/halt /sbin/poweroff /sbin/reboot

COPY docker.sh /docker.sh
ADD nfs.sh /usr/local/bin/nfs.sh
RUN chmod +x /docker.sh

ENTRYPOINT ["/usr/local/bin/nfs.sh"]
