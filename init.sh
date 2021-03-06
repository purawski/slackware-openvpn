#!/bin/sh
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi
for conf in /etc/openvpn/*.conf
do
   /usr/sbin/openvpn --config $conf --daemon
done
sleep infinity
