# !/bin/sh
# Program :
#	This program set the environment of the sslocal, for shadowsocks
# History :
# 2016/08/06		kumho		First release
#

# for setting path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin
export PATH

# for setting language family
LANG=C.UTF-8
export LANG

# shadowsocks ports
port_num=4
port_1="sslocal -s ip -p port -k passwd"
port_2="sslocal -s ip -p port -k passwd"
port_3="sslocal -s ip -p port -k passwd"
port_4="sslocal -s id -p port -k passwd"

# for selecting the port
port_sel=$port_1
switchPort() {
	case $1 in
		"1") port_sel=${port_1} ;;
		"2") port_sel=${port_2} ;;
		"3") port_sel=${port_3} ;;
		"4") port_sel=${port_4} ;;
		 * ) echo "the port $1 not exist." && exit 1 ;; 
	esac
	return 0
}

# for receive the parameters of this program
if [ $# -eq 0 ] ; then
	echo "sslcal runing port_1"&&$($port_1)&&exit 0
fi

for param in $@
do
	case $param in
		-p:[0-9]*)
			p_no=$(echo $param | cut -d ":" -f 2)
			switchPort $p_no
			echo "sslocal runing port_${p_no}"&&$($port_sel)&&exit 0
			;;
		  "start")
		  	switchPort 1
			echo "sslocal runing port_1"&&$($port_sel)&&exit 0
			;;
		  "stop" )
			 pid=$(ps -C sslocal |egrep "sslocal"|cut -d " " -f 2 )
			[ -z $pid ] &&echo "sslocal not run" &&exit 0
                         kill -15 $pid
		        ;;
		      * )
			;;
	esac
done

