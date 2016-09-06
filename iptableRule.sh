# !/bin/bash
# Program :
#	设置防火墙规则,面向一般服务器(只提供某些服务给外部访问,内部主机不限制资源)	
# History :
# 2016/09/06		kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# 相关网络参数,如IP等
EXTIF="eth0"		 # 这个是可以连上Public IP的网络接口(exit interface)
INIF="eth1"		 # 这个是对内LAN的网路接口(in interface)

INNET="192.168.100.0/24" # LAN的Network
export EXTIF INIF INNET  # 全局变量

# 保存额外的防火墙配置script的目录以及文件
IptableDir="/usr/local/iptables"
IptableDeny="${IptableDir}/iptables.deny"
IptableAllow="${IptableDir}/iptables.arrow"
IptableHttp="${IptableDir}/iptables.http"


## ------------------ 针对本机防火墙设置 ------------------
# 对LAN开放,对外只开放提供服务的端口
# 防御SYN Flooding以及PING Flooding的DOS攻击
# 分析不合理IP,并记录
# 关闭ICMP重定向 ICMP redirect

# 设置内核提供的一些网络功能
echo "1" > /proc/sys/net/ipv4/tcp_syncookies # 防御SYN Flooding的DOS攻击
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts # 防御Ping Flooding的DOS攻击
for file in /proc/sys/net/ipv4/conf/*  # 分析不合理IP,丢弃数据包并记录其IP
do	
	echo "1" > "${file}/rp_filter"
	echo "1" > "${file}/log_martians"
done
for file in /proc/sys/net/ipv4/conf/* #关闭ICMP重定向(ICMP redirect)
do
	echo "1" > "${file}/accept_source_route"
	echo "1" > "${file}/accept_redirects"
	echo "1" > "${file}/send_redirects"
done

# 清除本机所有规则,并设置预设政策
iptables -F 	# 清除所有已订的规则
iptables -X	# 清除所有自订的chain(可以理解成一组规则的集合)
iptables -Z	# 将所有chain的计数与流量统计归0
# 设置filter表的预设政策(filter表针对数据包访问的限制)
iptables -P INPUT DROP	# 预设将所有进入的数据包都丢弃
iptables -P OUTPUT ACCEPT  # 预设放行所有出去的数据包
iptables -P FORWARD ACCEPT # 可以进行IP/port的变换

# 对于内部测试接口(lo),开放主机
iptables -A INPUT -i lo -j ACCEPT
# 对于由本机发出的数据包的回应,或已经建立连线的数据包放行
iptables -A INPUT -i ${EXTIF} -m state --state RELATED,ESTABLISHED -j ACCEPT

# 不允许外部主机Ping本机
IcmpTypeDeny="8"  
for typeDeny  in ${IcmpTypeDeny}
do
	iptables -A INPUT -i ${EXTIF} -p icmp --icmp-type ${typeDeny} -j REJECT
done

# 开放某些服务的进入
iptables -A INPUT -i ${EXTIF} -p TCP --dport 80 --sport 1024:65534 -j ACCEPT  # WWW
iptables -A INPUT -i ${EXTIF} -p UDP --dport 80 --sport 1024:65534 -j ACCEPT
iptables -A INPUT -i ${EXTIF} -p TCP --dport 443 --sport 1024:65534 -j ACCEPT # https
iptables -A INPUT -i ${EXTIF} -p UDP --dport 443 --sport 1024:65534 -j ACCEPT 
iptables -A INPUT -i ${EXTIF} -p TCP --dport 22 --sport 1024:65534 -j ACCEPT # ssh
iptables -A INPUT -i ${EXTIF} -p UDP --dport 22 --sport 1024:65534 -j ACCEPT
iptables -A INPUT -i ${EXTIF} -p TCP --dport 21 --sport 1024:65534 -j ACCEPT # ftp
iptables -A INPUT -i ${EXTIF} -p TCP --dport 21 --sport 1024:65534 -j ACCEPT # pop3

# 启动额外的防火墙script
[ -f ${IptableDeny} ] && sh ${IptableDeny}
[ -f ${IptableAllow} ] && sh ${IptableAllow}
[ -f ${IptableHttp} ] && sh ${IptableHttp}



## ------------------ 针对LAN设置防火墙 ------------------
# 主要设置防火墙的NAT表
# 让LAN主机能通过本机获取Public IP连接Internet (IP分享器)
# 同时让Internet访问本机80端口的数据包,转交给LAN主机处理

ifconfig ${INIF} >/dev/null   # 是否存在eth1接口,否则不进行下面操作

# 加载一些有关NAT模块至内核中
modules="ip_tables iptable_nat ip_nat_ftp ip_nat_irc ip_conntrace ip_conntrack_ftp ip_conntrack_irc"
for mod in ${modules}
do	
	testmode=$(lsmod | grep "^${mod}" | awk '{print $1}')
	[ ! -z ${testmode} ] && modprobe ${mod}
done

# 清除NAT table 并设置其预设规则
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables -t nat -P PREROUTING ACCEPT # 可以进行修改目标IP/port
iptables -t nat -P POSTROUTING ACCEPT # 可以进行修改来源IP/port
iptables -t nat -P OUTPUT ACCEPT # 发出数据包不限制

# 存在eth1,将主机开放成为路由器,即IP分享器(共享Public IP)
iptables -A INPUT -i ${INIF} -j ACCEPT # 接收LAN的数据包
echo "1" > /proc/sys/net/ipv4/ip_forward # 启用内核功能[数据包转递],即路由器
if [ ! -z "${INNET}" ] ; then
	for innet in ${INNET}
	do
		iptables -t nat -A POSTROUTING -s $innet -o ${EXTIF} -j MASQUERADE  # 来自LAN且要连接Internet的数据包,将其来源IP改成本主机的出口IP
	done
fi

# 对于来自Internet的请求,且要访问本机80端口服务,都转交LAN内主机处理
iptables -t nat -A PREROUTING -p tcp -i ${EXTIF} --dport 80  -j DNAT --to-destination 192.168.1.210:80

# 限制MTU范围
#iptables -A FORWARD -p tcp -m tcp --ctp-flags SYN,RST SYN -m tcpmss --mss 1400:1536 -j TCPMSS --clamp-mss-to-pmtu

# 如果要开机启动iptableRule.sh
# 将iptableRule.sh写入rc.local
