# !/bin/bash
# Program :
#	防火墙开放Wlan接口
# History :
# 2016/09/06		kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG



iptables -A INPUT -i wlan0 -p udp -m udp --dport 67 -j ACCEPT
iptables -A INPUT -i wlan0 -p tcp -m tcp --dport 67 -j ACCEPT
iptables -A INPUT -i wlan0 -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -i wlan0 -p tcp -m tcp --dport 53 -j ACCEPT

iptables -A FORWARD -d 10.42.0.0/24 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 10.42.0.0/24 -i wlan0 -j ACCEPT
iptables -A FORWARD -i wlan0 -o wlan0 -j ACCEPT
iptables  -A FORWARD -o wlan0 -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -i wlan0 -j REJECT --reject-with icmp-port-unreachable

iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P INPUT ACCEPT
iptables -t nat -P OUTPUT ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -A POSTROUTING -s 10.42.0.0/24  ! -d 10.42.0.0/24 -j MASQUERADE
