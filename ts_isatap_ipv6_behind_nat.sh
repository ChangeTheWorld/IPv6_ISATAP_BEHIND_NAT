#!/bin/sh

local_v6_interface=wan6
local_v6_link=6in4-wan6
local_lan_interface=br-lan
 
remote_v6="2402:f000:1:1501:200:5efe"
remote_v4="166.111.21.1"

 
#local_wan_v4_addr=$(ip addr show dev $local_v4_interface | grep inet | awk '{print $2}')
old_local_wan_v4_addr=$(uci show network.wan6.ip6addr | grep -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}")
local_wan_v4_addr=$(curl -4 -s https://api.ip.sb/ip)
if [ "echo $old_local_wan_v4_addr"  = "echo $local_wan_v4_addr" ];
then
echo "No change!"
else
echo "Shutdown IPv6 interface"
ifdown $local_v6_interface
sleep 3
echo "Get local wan IP address $local_wan_v4_addr"
local_v6_addr=$remote_v6:$local_wan_v4_addr/64
echo "Set local IPv6 address $local_v6_addr"
uci set network.$local_v6_interface.ip6addr=$local_v6_addr
# uci set network.$local_v6_interface.ipaddr=$local_wan_v4_addr
uci commit network
echo "Reload network."
/etc/init.d/network reload
sleep 3
 
echo "Bring up IPv6 interface"
ifup $local_v6_interface
sleep 3
 
echo "Set up iptables rules"
ip6tables -t nat -A POSTROUTING -o $local_v6_link -j MASQUERADE
ip6tables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A FORWARD -i eth0.2 -j ACCEPT
 
echo "Set up IPv6 route"
ip -6 route del default from 2402:f000:1:1501::/64
ip -6 route add default via $remote_v6:$remote_v4 dev $local_v6_link
fi

echo "Done"
exit 0
