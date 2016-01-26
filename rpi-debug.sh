#!/system/bin/sh

IP=$(getprop rpi.net.ip)
GW=$(getprop rpi.net.gw)

ip link set eth0 up
sleep 2

if [[ $1 = "ipv6" ]]; then
	ip -6 addr add $IP dev eth0 
	ip -6 route add default via $GW
else 
	ip -4 addr add $IP dev eth0 
	ip -4 route add default via $GW
fi